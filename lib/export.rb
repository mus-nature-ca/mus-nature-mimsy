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

    model_counts = {}
    Parallel.map(0..4, progress: "Counting", in_threads: 4) do |i|
      ActiveRecord::Base.connection_pool.with_connection do
        sub = models.slice(models.length/4*i, models.length/4)
        sub.each do |model|
          model_counts[model.name] = model.count
        end
      end
    end

    small_model_names = model_counts.map{|m| m[0] if m[1] <= 50_000 && m[1] > 0}.compact
    part = small_model_names.count/processes

    puts  "Exporting #{small_model_names.count} small models...".green

    Parallel.map(0..processes, progress: "Exporting small models", in_processes: processes) do |i|
      sub = small_model_names.slice(part*i, part)
      sub.each do |model|
        file_name = "/#{model}.csv"
        CSV.open(File.join(@dir, file_name), 'w') do |csv|
          if model == "Group"
            csv << model.constantize.custom_attribute_names.push("table", "full_title")
            model.constantize.find_each do |row|
              csv << row.custom_attributes.values.push(row.table, row.full_title)
            end
          else
            csv << model.constantize.custom_attribute_names
            model.constantize.find_each do |row|
              csv << row.custom_attributes.values
            end
          end
        end
      end
    end

    models.delete_if{|m| model_counts[m.name] == 0 || small_model_names.include?(m.name)}

    puts "Exporting #{models.count} large models...".green

    Parallel.map(models.map(&:name), progress: "Exporting large models", in_processes: processes) do |model|
      file_name = "/#{model}.csv"
      mc = model.constantize
      CSV.open(File.join(@dir, file_name), 'w') do |csv|
        if model == "Medium"
          csv << mc.custom_attribute_names.push("locator_linux")
        elsif model == "Taxon" || model == "TaxonVariation"
          csv << mc.custom_attribute_names.push("parsed")
        else
          csv << mc.custom_attribute_names
        end
        mc.find_each do |row|
          if model == "Medium"
            csv << row.custom_attributes.values.push(row.locator_linux)
          elsif model == "Taxon" || model == "TaxonVariation"
            csv << row.custom_attributes.values.push(row.parsed.deep_stringify_keys)
          else
            csv << row.custom_attributes.values
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
    model = m.constantize
    dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
    file_name = "#{model}-#{dt}.csv"

    CSV.open(File.join(@dir, file_name), 'w') do |csv|
      if model.to_s == "Medium"
        csv << model.custom_attribute_names.push("locator_linux")
      elsif model.to_s == "Group"
        csv << model.custom_attribute_names.push("table", "full_title")
      elsif model.to_s == "Taxon" || model.to_s == "TaxonVariation"
        csv << model.custom_attribute_names.push("parsed")
      else
        csv << model.custom_attribute_names
      end
      model.find_each do |row|
        if model.to_s == "Medium"
          csv << row.custom_attributes.values.push(row.locator_linux)
        elsif model.to_s == "Group"
          csv << row.custom_attributes.values.push(row.table, row.full_title)
        elsif model.to_s == "Taxon" || model.to_s == "TaxonVariation"
          csv << row.custom_attributes.values.push(row.parsed.deep_stringify_keys)
        else
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
    catalogs(cats.flatten.join(","), name)
  end

  def collection(name = "")
    cats = Catalog.where(collection: name).pluck(:catalog_number).flatten.join(",")
    catalogs(cats, name)
  end

  def catalogs(catalogs = "", name = "catalog_export")
    CSV.open(@dir + "/#{name}.csv", 'w') do |csv|
      csv << [
        "CATALOGUE.ID_NUMBER",
        "OTHER_NUMBERS.OTHER_NUMBER",
        "CATALOGUE.ITEM_NAME",
        "ITEMS_TAXONOMY.TAXONOMY",
        "ITEMS_TAXONOMY.ATTRIBUTOR",
        "ITEMS_TAXONOMY.ATTRIB_DATE",
        "ITEMS_TAXONOMY.AFFILIATION",
        "ITEMS_TAXONOMY.BROADER_TEXT",
        "all_dets",
        "all_annotations",
        "CATALOGUE.ITEM_COUNT",
        "CATALOGUE.SEX",
        "CATALOGUE.STAGE",
        "coll_num",
        "CATALOGUE.COLLECTOR",
        "CATALOGUE.PLACE_COLLECTED",
        "CATALOGUE.DATE_COLLECTED",
        "CATALOGUE.MATERIALS",
        "CATALOGUE.DESCRIPTION",
        "CATALOGUE.CREDIT_LINE",
        "CATALOGUE.HOME_LOCATION",
        "CATALOGUE_MULTIFIELDS",
        "CATALOGUE.CREATED_BY",
        "CATALOGUE.CREATE_DATE",
        "SITES.SITE_ID",
        "SITES.SITE_NAME",
        "SITES.SITE_CLASS",
        "SITES.SITE_TYPE",
        "SITES.SITE_DATE",
        "SITES.LOCATION",
        "SITES.LOCATION_ACCURACY",
        "SITES.DESCRIPTION",
        "SITES.ELEVATION",
        "SITES.DECIMAL_IS_PRIMARY",
        "SITES.START_LATITUDE",
        "SITES.START_LONGITUDE",
        "SITES.START_LATITUDE_DEC",
        "SITES.START_LONGITUDE_DEC",
        "SITES.END_LATITUDE",
        "SITES.END_LONGITUDE",
        "SITES.END_LATITUDE_DEC",
        "SITES.END_LONGITUDE_DEC",
        "SITES.UTM_START",
        "SITES.UTM_END",
        "SITES.RECOMMENDATIONS",
        "SITES.COORD_UNCERTAINTY",
        "SITES.COORD_UNCERTAINTY_VERB",
        "SITES.UNCERTAINTY_UNIT",
        "SITES.GEODETIC_DATUM",
        "SITES.GEOREF_SOURCE",
        "SITES.GEOREF_STATUS",
        "SITES.NOTE",
        "SITES.VEGETATION",
        "SITES.RESEARCH_ACTIVITY",
        "SITES.ARCHAEOLOGICAL_STATUS",
        "SITES.REGISTER_STATUS",
        "SITES.CREATED_BY",
        "SITES.CREATE_DATE"
      ]

      csv << [
        "id_number",
        "other_number",
        "label_name",
        "taxon_link",
        "ident",
        "id_date",
        "type_status",
        "higher_taxa",
        "all_dets",
        "all_annotations",
        "count",
        "sex",
        "stage",
        "coll_num",
        "collector",
        "place_collected",
        "date_collected",
        "spec_nature",
        "description",
        "acq_number",
        "home_loc",
        "descriptor:term",
        "catalog_created_by",
        "catalog_create_date",
        "site_id",
        "site_name",
        "environment",
        "site_type",
        "site_date",
        "site_location",
        "location_accuracy",
        "site_desc",
        "altitude",
        "decimal_is_primary",
        "lat_start",
        "long_start",
        "lat_dec_start",
        "long_dec_start",
        "lat_end",
        "long_end",
        "lat_dec_end",
        "long_dec_end",
        "utm_start",
        "utm_end",
        "site_notes",
        "coord_uncertainty",
        "coord_uncertainty_verb",
        "uncertainty_unit",
        "geodetic_datum",
        "georef_source",
        "georef_status",
        "site_note",
        "vegetation",
        "research_activity",
        "expedition",
        "vessel_name",
        "site_created_by",
        "site_create_date"
      ]
    end

    catalogs = catalogs.split(",").map(&:strip)

    Parallel.map(catalogs.in_groups_of(20, false), progress: "Catalogs", in_processes: processes) do |group|
      CSV.open(@dir + "/#{name}.csv", 'a') do |csv|
        group.each do |id|
          catalog = Catalog.find_by_catalog_number(id)
          id_number = catalog.catalog_number
          other_number = catalog.other_numbers.where(type: "stamped CMN accession number").first.other_number rescue nil
          label_name = catalog.scientific_name
          ct = catalog.catalog_taxa
          ct_first = ct.first
          taxon_link = ct_first.scientific_name rescue nil
          ident = ct_first.identified_by rescue nil
          id_date = ct_first.date_identified.to_s rescue nil
          type_status = ct_first.type_status rescue nil
          higher_taxa = ct_first.higher_taxonomy rescue nil
          all_dets = ct.map{|d| "#{d.scientific_name} % #{d.identified_by} % #{d.date_identified}" }.join(" | ")
          all_annotations = catalog.names.map{|n| "#{n.scientific_name} % #{n.attributor} % #{n.attribution_date}" }.join(" | ")
          count = catalog.item_count.to_s
          sex = catalog.sex
          stage = catalog.stage
          coll_num = catalog.other_numbers.map{|other| other.other_number if other.on_type.include?("collector no./field no.")}.compact.join(" | ") rescue nil
          collector = catalog.collector
          place_collected = catalog.place_collected
          date_collected = catalog.date_collected.to_s
          spec_nature = catalog.specimen_nature
          description = catalog.description
          acq_number = catalog.acquisition_number.to_s
          catalog_create_date = catalog.create_date
          catalog_created_by = catalog.created_by
          st = catalog.sites.first
          site_id = st.site_id rescue nil
          site_name = st.site_name rescue nil
          site_class = st.site_class rescue nil
          site_type = st.site_type rescue nil
          site_date = st.site_date rescue nil
          site_location = st.location rescue nil
          location_accuracy = st.location_accuracy rescue nil
          site_desc = st.description rescue nil
          altitude = st.elevation.to_s rescue nil
          decimal_is_primary = st.decimal_is_primary rescue nil
          lat_start = st.start_latitude rescue nil
          long_start = st.start_longitude rescue nil
          lat_dec_start = st.start_latitude_dec.present? ? st.start_latitude_dec.to_f : nil rescue nil
          long_dec_start = st.start_longitude_dec.present? ? st.start_longitude_dec.to_f : nil rescue nil
          lat_end = st.end_latitude rescue nil
          long_end = st.end_longitude rescue nil
          lat_dec_end = st.end_latitude_dec.present? ? st.end_latitude_dec.to_f : nil rescue nil
          long_dec_end = st.end_longitude_dec.present? ? st.end_longitude_dec.to_f : nil rescue nil
          utm_start = st.utm_start rescue nil
          utm_end = st.utm_end rescue nil
          site_notes = st.recommendations rescue nil
          coord_uncertain = st.coord_uncertainty rescue nil
          coord_uncertain_verb = st.coord_uncertainty_verb rescue nil
          uncertain_unit = st.uncertainty_unit rescue nil
          geodetic_datum = st.geodetic_datum rescue nil
          georef_source = st.georef_source rescue nil
          georef_status = st.georef_status rescue nil
          site_note = st.note rescue nil
          vegetation = st.vegetation rescue nil
          research_activity = st.research_activity rescue nil
          home_loc = catalog.home_location
          multifields = catalog.multifields.map{|m| [m.descriptor,m.term].join(" : ")  }.join(" | ")
          expedition = st.archaeological_status rescue nil
          vessel_name = st.register_status rescue nil
          site_created_by = st.created_by rescue nil
          site_create_date = st.create_date rescue nil

          csv << [
            id_number,
            other_number,
            label_name,
            taxon_link,
            ident,
            id_date,
            type_status,
            higher_taxa,
            all_dets,
            all_annotations,
            count,
            sex,
            stage,
            coll_num,
            collector,
            place_collected,
            date_collected,
            spec_nature,
            description,
            acq_number,
            home_loc,
            multifields,
            catalog_created_by,
            catalog_create_date,
            site_id,
            site_name,
            site_class,
            site_type,
            site_date,
            site_location,
            location_accuracy,
            site_desc,
            altitude,
            decimal_is_primary,
            lat_start,
            long_start,
            lat_dec_start,
            long_dec_start,
            lat_end,
            long_end,
            lat_dec_end,
            long_dec_end,
            utm_start,
            utm_end,
            site_notes,
            coord_uncertain,
            coord_uncertain_verb,
            uncertain_unit,
            geodetic_datum,
            georef_source,
            georef_status,
            site_note,
            vegetation,
            research_activity,
            expedition,
            vessel_name,
            site_created_by,
            site_create_date,
            multifields
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
