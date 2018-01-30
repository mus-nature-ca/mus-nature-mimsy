require "rails_erd/diagram/graphviz"

class Export
  EXCLUSIONS = [
    "CatalogAgent", "CatalogVessel", "Vessel", "VesselAccessory",
    "VesselComponent", "VesselDescription", "VesselMarking",
    "VesselMeasurement", "VesselMultifield", "VesselName",
    "VesselOtherNumber", "VesselStatus", "VesselType",
    "ActivityLink", "AuthorityLink"
  ]

  def initialize(dir)
    @dir = dir
  end

  def processes=(processes)
    @processes = processes
  end

  def processes
    @processes || 4
  end

  def interleave(a,*args)
    max_length = args.map(&:size).max
    padding = [nil]*[max_length-a.size, 0].max
    (a+padding).zip(*args)
  end

  def migration_templates
    Dir.mkdir(@dir)
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

  def schema_diagram
    RailsERD::Domain::Attribute.class_eval do
      def name
        @model.custom_attribute_mappings[column.name] || column.name
      end
    end
    config = {
      filename: @dir,
      filetype: "dot",
      title: "Canadian Museum of Nature :: MIMSY XG",
      attributes: ['primary_keys', 'foreign_keys', 'content', 'timestamps'],
      direct: true,
      exclude: EXCLUSIONS.join(",")
    }
    RailsERD::Diagram::Graphviz.create(config)
  end

  def all
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

  def lists
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

  def group(name = "")
    group = Group.find_by_name(name)
    catalog_ids = group.members.pluck(:table_key)
    cats = []
    catalog_ids.in_groups_of(40, false) do |ids|
      cats << Catalog.where(id: ids).pluck(:catalog_number)
    end
    catalogs(cats.flatten.join(","))
  end

  def catalogs(catalogs = "")
    CSV.open(@dir + "/catalog_exports.csv", 'w') do |csv|
      csv << [
        "id_number",
        "label_name",
        "taxon_link",
        "ident",
        "id_date",
        "type_status",
        "higher_taxa",
        "all_dets",
        "count",
        "sex",
        "coll_num",
        "collector",
        "place_collected",
        "date_collected",
        "spec_nature",
        "description",
        "acq_number",
        "site_desc",
        "altitude",
        "lat",
        "long",
        "site_notes",
        "home_loc"
      ]
    end

    catalogs = catalogs.split(",").map(&:strip)

    Parallel.map(catalogs.in_groups_of(20, false), progress: "Catalogs", in_processes: processes) do |group|
      CSV.open(@dir + "/catalog_exports.csv", 'a') do |csv|
        group.each do |id|
          catalog = Catalog.find_by_catalog_number(id)
          id_number = catalog.catalog_number
          label_name = catalog.scientific_name
          ct = catalog.catalog_taxa
          ct_first = ct.first
          taxon_link = ct_first.scientific_name rescue nil
          ident = ct_first.identified_by rescue nil
          id_date = ct_first.date_identified.to_s rescue nil
          type_status = ct_first.type_status rescue nil
          higher_taxa = ct_first.higher_taxonomy rescue nil
          all_dets = ct.map{|d| "#{d.scientific_name} % #{d.identified_by} % #{d.date_identified}" }.join(" | ")
          count = catalog.item_count.to_s
          sex = catalog.sex
          coll_num = catalog.other_numbers.map{|other| other.other_number if other.on_type == "collector no./field no."}.first.to_s rescue nil
          collector = catalog.collector
          place_collected = catalog.place_collected
          date_collected = catalog.date_collected.to_s
          spec_nature = catalog.specimen_nature
          description = catalog.description
          acq_number = catalog.acquisition_number.to_s
          st = catalog.sites.first
          site_desc = st.description rescue nil
          altitude = st.elevation.to_s rescue nil
          lat = st.start_latitude_dec.to_f rescue nil
          long = st.start_longitude_dec.to_f rescue nil
          #p_s = st.decimal_is_primary? ? "P" : "S" rescue nil
          site_notes = st.recommendations rescue nil
          home_loc = catalog.home_location

          csv << [
            id_number,
            label_name,
            taxon_link,
            ident,
            id_date,
            type_status,
            higher_taxa,
            all_dets,
            count,
            sex,
            coll_num,
            collector,
            place_collected,
            date_collected,
            spec_nature,
            description,
            acq_number,
            site_desc,
            altitude,
            lat,
            long,
            site_notes,
            home_loc
          ]

        end
      end
    end

  end

  def fields
    Dir.mkdir(@dir)

    models = ActiveRecord::Base.descendants
    models.delete_if{|m| EXCLUSIONS.include?(m.name)}
    part = models.length/processes

    mappings_dir = File.join(ENV['PWD'], 'migration_mappings', 'original')

    Parallel.map(0..processes, progress: "Exporting Fields", in_processes: processes) do |i|
      sub = models.slice(part*i, part)
      sub.each do |model|
        CSV.open(@dir + "/#{model.name}_fields.csv", 'w') do |csv|
          if File.file?(File.join(mappings_dir, "#{model.name}.yaml"))
            csv << ["model", "field_name", "MIMSY_field_name", "field_type", "field_length", "field_example", "emu_module", "emu_column", "migration_instructions"]
          else
            csv << ["model", "field_name", "MIMSY_field_name", "field_type", "field_length", "field_example"]
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
            csv << [model.name] + data
          end
        end
      end
    end

    CSV.open(@dir + '/mapping-document.csv','w') do |csv|
      if Dir[mappings_dir].empty?
        hs = ["model", "field_name", "MIMSY_field_name", "field_type", "field_length", "field_example"]
      else
        hs = ["model", "field_name", "MIMSY_field_name", "field_type", "field_length", "field_example", "emu_module", "emu_column", "migration_instructions"]
      end
      csv << hs
      Dir.glob(@dir + '/*.csv') do |file|
        next if File.basename(file) == "mapping-document.csv"
        CSV.foreach(file, headers: true) {|row| csv << row.values_at(*hs) }
      end
    end

    zf = ZipFileGenerator.new(@dir, @dir + ".zip")
    zf.write()
    FileUtils.rm_rf(@dir)
  end

end