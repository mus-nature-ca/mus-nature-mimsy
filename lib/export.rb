class Export
  EXCLUSIONS = [
    "CatalogAgent", "CatalogVessel", "Vessel", "VesselAccessory",
    "VesselComponent", "VesselDescription", "VesselMarking",
    "VesselMeasurement", "VesselMultifield", "VesselName",
    "VesselOtherNumber", "VesselStatus", "VesselType"
  ]

  def initialize(dir)
    @dir = dir
  end

  def interleave(a,*args)
    max_length = args.map(&:size).max
    padding = [nil]*[max_length-a.size, 0].max
    (a+padding).zip(*args)
  end

  def migration_templates
    models = ActiveRecord::Base.descendants
    models.delete_if{|m| Export::EXCLUSIONS.include?(m.name)}

    models.each do |model|
      map_cols = model.custom_attribute_names.zip(model.attribute_names).to_h
      yaml = model.custom_attribute_names
                  .map{|an| [an, { 
                    "MIMSY" => [model.table_name.upcase, map_cols[an].upcase].join("."), 
                    "module" => "", 
                    "column" => "", 
                    "instructions" => "" }.symbolize_keys!]}
                  .to_h.symbolize_keys!.to_yaml
      File.open(@dir + "/#{model.name}.yaml", 'w') {|f| f.write yaml }
    end
  end

  def all(processes = 4)
    Dir.mkdir(@dir)
    models = ActiveRecord::Base.descendants
    models.delete_if{|m| EXCLUSIONS.include?(m.name)}
    part = models.length/processes

    model_counts = {}
    Parallel.map(0..4, progress: "Sorting", in_threads: 4) do |i|
      ActiveRecord::Base.connection_pool.with_connection do
        sub = models.slice(models.length/4*i, models.length/4)
        sub.each do |model|
          model_counts[model.name] = model.count
        end
      end
    end

    #remove large models from array & later evenly distribute them among available processes
    large_models = model_counts.sort_by{|_key, value| value}.reverse.first(processes).to_h.keys
    models.delete_if{|m| model_counts[m.name] == 0 || large_models.include?(m.name)}.shuffle!
    part = models.length/processes

    Parallel.map(0..processes, progress: "Exporting", in_processes: processes) do |i|
      sub = models.slice(part*i, part)
      sub << large_models[i].constantize if i < processes
      sub.each do |model|
        CSV.open(@dir + "/#{model.name}.csv", 'w') do |csv|
          if model.to_s == "Medium"
            csv << model.custom_attribute_names.push("locator_linux")
            model.find_each do |row|
              csv << row.custom_attributes.values.push(row.locator_linux)
            end
          elsif model.to_s == "Group"
            csv << model.custom_attribute_names.push("table", "full_title")
            model.find_each do |row|
              csv << row.custom_attributes.values.push(row.table, row.full_title)
            end
          else
            csv << model.custom_attribute_names
            model.find_each do |row|
              csv << row.custom_attributes.values
            end
          end
        end
      end
    end

    zf = ZipFileGenerator.new(@dir, @dir + ".zip")
    zf.write()
    FileUtils.rm_rf(@dir)
  end

  def admin_lists
    Dir.mkdir(@dir)
    lists = List.all_terms
    CSV.open(@dir + "/mimsy_admin_lists.csv", 'w') do |csv|
      csv << lists.keys
      values = lists.values
      interleave(values[0],*values[1..-1]).each{ |i| csv << i }
    end
  end

  def model(m)
    dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
    model = m.constantize
    CSV.open(@dir + "/#{model}-#{dt}.csv", 'w') do |csv|
      if model.to_s == "Medium"
        csv << model.custom_attribute_names.push("locator_linux")
        model.find_each do |row|
          data = row.custom_attributes.values.push(row.locator_linux)
          csv << data
        end
      elsif model.to_s == "Group"
        csv << model.custom_attribute_names.push("table", "full_title")
        model.find_each do |row|
          csv << row.custom_attributes.values.push(row.table, row.full_title)
        end
      else
        csv << model.custom_attribute_names
        model.find_each do |row|
          csv << row.custom_attributes.values
        end
      end
    end
  end

  def lists(processes = 4)
    Dir.mkdir(@dir)

    models = ActiveRecord::Base.descendants
    models.delete_if{|m| EXCLUSIONS.include?(m.name)}
    models.delete_if{|m| m.categorical_columns.empty?}

    model_counts = {}
    Parallel.map(0..4, progress: "Sorting", in_threads: 4) do |i|
      ActiveRecord::Base.connection_pool.with_connection do
        sub = models.slice(models.length/4*i, models.length/4)
        sub.each do |model|
          model_counts[model.name] = model.count
        end
      end
    end

    #remove large models from array & later evenly distribute them among available processes
    large_models = model_counts.sort_by{|_key, value| value}.reverse.first(processes).to_h.keys
    models.delete_if{|m| model_counts[m.name] == 0 || large_models.include?(m.name)}.shuffle!
    part = models.length/processes

    if processes >= models.length
      processes = models.length
    end
    part = models.length/processes

    Parallel.map(0..processes, progress: "Exporting Lists", in_processes: processes) do |i|
      sub = models.slice(part*i, part)
      sub << large_models[i].constantize if i < processes
      sub.each do |model|
        CSV.open(@dir + "/#{model.name}_lists.csv", 'w') do |csv|
          csv << model.categorical_columns
          values = model.categorical_values.values
          if model.categorical_columns.size > 1
            interleave(values[0],*values[1..-1]).each{ |i| csv << i }
          else
            values[0].each{ |i| csv << [i] }
          end
        end
      end
    end
  end

  def fields(processes = 4)
    Dir.mkdir(@dir)

    models = ActiveRecord::Base.descendants
    models.delete_if{|m| EXCLUSIONS.include?(m.name)}
    part = models.length/processes

    mappings_dir = File.join(ENV['PWD'], 'migration_mappings')

    Parallel.map(0..processes, progress: "Exporting Fields", in_processes: processes) do |i|
      sub = models.slice(part*i, part)
      sub.each do |model|
        CSV.open(@dir + "/#{model.name}_fields.csv", 'w') do |csv|
          if File.file?(File.join(mappings_dir, "#{model.name}.yaml"))
            csv << ["field_name", "MIMSY_field_name", "field_type", "field_length", "field_example", "emu_module", "emu_column", "migration_instructions"]
          else
            csv << ["field_name", "MIMSY_field_name", "field_type", "field_length", "field_example"]
          end
          original = model.attribute_names.map{|n| [model.table_name.upcase, n.upcase].join(".")}
          custom = model.custom_attribute_names
          type = model.columns.collect(&:type).map(&:to_s)
          length = model.columns.collect(&:limit)
          sample = model.attribute_names.map{|a| model.limit(5_000).pluck(a).compact.sample rescue nil}
          if File.file?(File.join(mappings_dir, "#{model.name}.yaml"))
            mappings = YAML.load_file(File.join(mappings_dir, "#{model.name}.yaml"))
            emu_module = model.custom_attribute_names.map{|a| mappings[a.to_sym][:module]}
            emu_column = model.custom_attribute_names.map{|a| mappings[a.to_sym][:column]}
            emu_instructions = model.custom_attribute_names.map{|a| mappings[a.to_sym][:instructions]}
            columns = custom.zip(original, type, length, sample, emu_module, emu_column, emu_instructions)
          else
            columns = custom.zip(original, type, length, sample)
          end
          columns.each do |data|
            csv << data
          end
        end
      end
    end

    zf = ZipFileGenerator.new(@dir, @dir + ".zip")
    zf.write()
    FileUtils.rm_rf(@dir)
  end

end