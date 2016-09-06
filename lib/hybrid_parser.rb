class HybridParser

  def initialize(relation, output)
    @relation = relation
    @output = output
    make_csv_header
  end

  def make_csv_header
    CSV.open(@output, 'w') do |csv|
      csv << ["taxon_id", "verbatim", "authority", "canonical", "rank", "parent1", "parent2", "parent3"]
    end
  end

  def export
    parser = ScientificNameParser.new
    Parallel.map(@relation.in_groups_of(25, false), progress: "HybridExport", in_processes: 8) do |group|
      CSV.open(@output, 'a') do |csv|
        group.each do |name|
          parsed = parser.parse(name.scientific_name)
          details = parsed[:scientificName][:details]
          next if !details.present?
          canonical = rank = nil
          parents = []
          details.each do |d|
            uninomial = d[:uninomial].present? ? d[:uninomial][:string] : nil
            genus = d[:genus].present? ? d[:genus][:string] : nil
            species = d[:species].present? ? d[:species][:string] : nil
            infraspecies = nil
            if d[:infraspecies].present?
              infraspecies = d[:infraspecies].map{|i| [i[:rank], i[:string]].join(" ").strip }.join(" ").strip
            end
            if /^[A-Z]\.$/.match(genus) && details.size > 1
              genus = details[0][:uninomial].present? ? details[0][:uninomial][:string] : details[0][:genus][:string]
            end
            parents << [uninomial, genus, species, infraspecies].join(" ").strip
          end
          if parents.size == 1
            canonical = parents[0]
            rank = (name.scientific_name[0] == "×") ? "genus" : "species"
            parents = [nil,nil,nil]
          end
          if parents.size == 2
            parents << nil
          end
          authority = name.attribute_present?("authority") ? name.authority : nil
          csv << [name.id, name.scientific_name, authority, canonical, rank] + parents
        end
      end
    end
  end

end