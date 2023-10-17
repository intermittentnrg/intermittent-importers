class Validate
  include SemanticLogger::Loggable

  @@rules = YAML.load_file("validate.yaml").with_indifferent_access
  def self.validate_generation(points)
    areas = {}

    points.select! do |p|
      if p[:country]
        area = areas[p[:country]] ||= Area.find_by(code: p[:country])
      elsif p[:area_id]
        area = areas[p[:area_id]] ||= Area.find(p[:area_id])
      else
        raise p.inspect
      end

      rule = @@rules[area.region][area.code].try(:[], p[:production_type]) || {}
      rule_all = @@rules[area.region]['all'].try(:[], p[:production_type]) || {}

      min = rule[:min] || rule_all[:min]
      max = rule[:max] || rule_all[:max]

      r = (min.nil? && max.nil?) || (min...max).include?(p[:value])
      logger.warn "skipped invalid generation", generation: p unless r

      r
    end

    points
  end

  def self.validate_load(points)
    areas = {}

    points.select! do |p|
      if p[:area_id]
        area = areas[p[:area_id]] ||= Area.find p[:area_id]
      else
        area = areas[p[:country]] ||= Area.find_by(code: p[:country])
      end

      rule = @@rules[area.region][p[:country]].try(:[], :load) || {}
      rule_all = @@rules[area.region]['all'].try(:[], :load) || {}

      min = rule[:min] || rule_all[:min]
      max = rule[:max] || rule_all[:max]

      r = (min.nil? && max.nil?) || (min...max).include?(p[:value])
      logger.warn "skipped invalid load", load: p unless r

      r
    end

    points
  end
  def self.validate_data_cli(args)
    delete = false
    if args.first == '--delete'
      delete = true
      args.shift
    end
    Validate.validate_data(delete, args)
  end

  def self.validate_data(delete=false, filters = [])
    @@rules.each do |region, areas|
      areas.each do |area_code, production_types|
        area = Area.find_by!(region: region, code: area_code, enabled: true) if area_code != 'all'
        production_types.each do |production_type_name, rules|
          next unless filters.empty? || filters.any? do |filter|
            "#{area_code}/#{production_type_name}".include? filter
          end
          #TODO skip if check constraint in place
          if production_type_name == "load"
            query = Load
          else
            production_type = ProductionType.find_by(name: production_type_name)
            raise production_type_name unless production_type
            query = Generation.where(production_type_id: production_type.id)
          end

          if area
            query = query.where(area_id: area.id)
          else
            query = query.joins(:area).where("area.region" => region)
          end

          if rules[:min] || rules[:max]
            query = query.where.not(value: rules[:min]...rules[:max])
            #puts query.to_sql
            query_count = query.count
            if query_count > 0
              puts "#{region} #{area_code}/#{production_type_name} #{query_count} invalid records"
              pp query
              #require 'pry' ; binding.pry
              if delete
                logger.warn "DELETE"
                query.delete_all
              end
            else
              logger.info "#{region} #{area_code}/#{production_type_name} GOOD"
            end
          end
        end
      end
    end
  end

  def self.check_constraints
    gen_check_constraints = Hash[ActiveRecord::Base.connection.check_constraints(:generation_data).map { |c| [c.options[:name], c.expression] }]
    load_check_constraints = Hash[ActiveRecord::Base.connection.check_constraints(:load).map { |c| [c.options[:name], c.expression] }]
    #areas = {}
    #production_types = {}
    @@rules.each do |region, areas|
      areas.each do |area_code, production_types|
        area = Area.find_by!(region: region, code: area_code) if area_code != 'all'
        if area
          area_expression = "area_id = #{area.id}".freeze
        else
          area_ids = Area.where(region:).pluck(:id)
          area_expression = "(area_id = ANY (ARRAY[#{area_ids.join(', ')}]))".freeze
        end

        production_types.each do |production_type_name, rules|
          if production_type_name == "load"
            check_constraints = load_check_constraints
            table = :load
            name = "auto_#{region}_#{area_code}".downcase
            expression = area_expression
          else
            check_constraints = gen_check_constraints
            table = :generation_data
            production_type = ProductionType.where(name: production_type_name).first
            name = "auto_#{region}_#{area_code}_#{production_type_name.gsub(/-/,'_')}".downcase
            expression = "#{area_expression} AND production_type_id = #{production_type.id}"
          end
          if rules[:min]
            rules[:min] = "'#{rules[:min]}'::integer" if rules[:min] < 0
            if rules[:max]
              expression = "NOT (#{expression} AND (value < #{rules[:min]} OR value >= #{rules[:max]}))"
            else
              expression = "NOT (#{expression} AND value < #{rules[:min]})"
            end
          elsif rules[:max]
            expression = "NOT (#{expression} AND value >= #{rules[:max]})"
          end
          ActiveRecord::Base.connection.change_table(table) do |t|
            # TODO use has_check_constraint?
            if check_constraints[name] && expression == check_constraints[name]
              logger.debug("#{table} #{name} GOOD")
              check_constraints.delete(name)
              next
            elsif check_constraints[name] && expression != check_constraints[name]
              #require 'pry' ; binding.pry
              logger.info("remove_check_constraint #{table} #{name} #{check_constraints[name]}")
              t.remove_check_constraint(name: name)
            end
            logger.info("add_check_constraint #{table} #{name} #{expression}")
            t.check_constraint(expression, name: name)
            check_constraints.delete(name)
          end
        end
      end
    end
    logger.warn("Unmanaged generation check constraints: #{gen_check_constraints.keys}")
    pp gen_check_constraints
    logger.warn("Unmanaged load check constraints: #{load_check_constraints.keys}")
    pp load_check_constraints
  end
  def self.has_check_constraint?
  end
end
