# frozen_string_literal: true

class Validate
  include SemanticLogger::Loggable

  def self.validate_generation(points, rules)
    return points unless rules

    logger.benchmark_info('validate generation') do
      points.select! do |p|
        area_code = area_for(p[:country])&.code

        rule = rules.dig(area_code, p[:production_type]) || {}
        rule_all = rules.dig('all', p[:production_type]) || {}

        min = rule[:min] || rule_all[:min]
        max = rule[:max] || rule_all[:max]

        valid = if min && max
                  (min...max).include?(p[:value])
                elsif min
                  p[:value] >= min
                elsif max
                  p[:value] < max
                else
                  true
                end

        logger.warn 'skipped invalid value', area: area_code, type: p[:production_type], value: p[:value] unless valid
        valid
      end
    end
    points
  end

  def self.validate_load(points, rules)
    return points unless rules

    logger.benchmark_info('validate load') do
      points.select! do |p|
        area_code = area_for(p[:country])&.code

        rule = rules[area_code] || {}
        rule_all = rules['all'] || {}

        min = rule[:min] || rule_all[:min]
        max = rule[:max] || rule_all[:max]

        valid = if min && max
                  (min...max).include?(p[:value])
                elsif min
                  p[:value] >= min
                elsif max
                  p[:value] < max
                else
                  true
                end

        logger.warn 'skipped invalid load', area: area_code, value: p[:value] unless valid
        valid
      end
    end
    points
  end

  def self.check_db_gen(rules, source, delete:, filter:)
    rules.each do |area_code, area_rules|
      next if area_code == 'all'

      area = Area.where(source:, code: area_code, enabled: true)

      area_rules.each do |production_type_name, r|
        next unless r[:min] || r[:max]
        next unless filter.empty? || filter.any? { |f| "#{source}/#{area_code}/#{production_type_name}".include?(f) }

        production_type = ProductionType.find_by!(name: production_type_name)
        apt_ids = production_type.areas_production_type.where(area:).pluck(:id)
        query = Generation.where(areas_production_type_id: apt_ids)

        query = query.where.not(value: r[:min]...r[:max])
        count = query.count

        if count > 0
          puts "#{source} #{area_code}/#{production_type_name}: #{count} invalid records"
          query.delete_all if delete
        end
      end
    end
  end

  def self.check_db_load(rules, source, delete:, filter:)
    rules.each do |area_code, r|
      next if area_code == 'all'
      next unless r[:min] || r[:max]
      next unless filter.empty? || filter.any? { |f| "#{source}/#{area_code}/load".include?(f) }

      area = Area.where(source:, code: area_code, enabled: true)
      query = Load.where(area:)

      query = query.where.not(value: r[:min]...r[:max])
      count = query.count

      if count > 0
        puts "#{source} #{area_code}/load: #{count} invalid records"
        query.delete_all if delete
      end
    end
  end

  def self.area_for(internal_id)
    @areas ||= {}
    @areas[internal_id] ||= Area.find_by(internal_id:)
  end
end
