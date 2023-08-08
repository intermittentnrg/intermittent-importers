class Validate
  include SemanticLogger::Loggable

  @@rules = YAML.load_file("validate.yaml").with_indifferent_access
  def self.validate_generation(points)
    areas = {}

    points.select! do |p|
      area = areas[p[:area_id]] ||= Area.where(code: p[:country]).first

      rule = @@rules[area.region][p[:country]].try(:[], p[:production_type]) || {}
      rule_all = @@rules[area.region]['all'].try(:[], p[:production_type]) || {}

      min = rule[:min] || rule_all[:min]
      max = rule[:max] || rule_all[:max]

      r = max.nil? || (min..max).include?(p[:value])
      logger.warn "skipped invalid generation", generation: p unless r

      r
    end

    points
  end

  def self.validate_load(points)
    areas = {}

    points.select! do |p|
      area = areas[p[:area_id]] ||= Area.where(code: p[:country]).first

      rule = @@rules[area.region][p[:country]].try(:[], :load) || {}
      rule_all = @@rules[area.region]['all'].try(:[], :load) || {}

      min = rule[:min] || rule_all[:min]
      max = rule[:max] || rule_all[:max]

      r = max.nil? || (min..max).include?(p[:value])
      logger.warn "skipped invalid load", load: p unless r

      r
    end

    points
  end

  def self.validate_db(delete=false)
    @@rules.each do |region, areas|
      areas.each do |area_code, production_types|
        area = Area.where(region: region, code: area_code).first if area_code != 'all'
        production_types.each do |production_type_name, rules|
          if production_type_name == "load"
            query = Load
            if area
              query = query.where(area_id: area.id) if area
            else
              query = query.joins(:area).where("area.region" => region)
            end

            if rules[:max]
              query = query.where.not(value: rules[:min]..rules[:max])
              query_count = query.count
              if query_count > 0
                puts "#{region} #{area_code}/#{production_type_name} #{query_count} invalid records"
                pp query
                #require 'pry' ; binding.pry
              end
              query.delete_all if delete
            end
          else
            production_type = ProductionType.where(name: production_type_name).first
            query = Generation.where(production_type_id: production_type.id)
            if area
              query = query.where(area_id: area.id)
            else
              query = query.joins(:area).where("area.region" => region)
            end

            if rules[:max]
              query = query.where.not(value: rules[:min]..rules[:max])
              query_count = query.count
              if query_count > 0
                puts "#{region} #{area_code}/#{production_type_name} #{query_count} invalid records"
                pp query
                #require 'pry' ; binding.pry
              end
              query.delete_all if delete
            end
          end
        end
      end
    end
  end
end
