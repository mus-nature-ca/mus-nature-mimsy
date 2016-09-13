class TaxonParser

  def initialize(relation, output)
    @relation = relation
    @output = output
    @parser = ScientificNameParser.new
    make_csv_header
  end

  def make_csv_header
    CSV.open(@output, 'w') do |csv|
      csv << ["id", "verbatim", "scientific_name", "canonical", "authority", "year", "rank", "hybrid", "hybrid_parent1", "hybrid_parent2"]
    end
  end

  def nested_hash_value(obj,key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r = nested_hash_value(a.last,key) }
      r
    end
  end

  def export
    Parallel.map(@relation.find_in_batches, progress: "#{@relation}Parser") do |group|
      CSV.open(@output, 'a') do |csv|
        group.each do |name|

          id = name.id
          verbatim = name.scientific_name
          authority = name.attribute_present?(:source) ? name.authority : nil
          scientific_name = [name.scientific_name, authority].join(" ").strip
          rank = name.attribute_present?(:level_text) ? name.rank : nil

          canonical = year = hybrid = nil
          hybrid_parents = []

          begin
            parsed = @parser.parse(scientific_name)
          rescue
            parsed = nil
          end

          #skip if we have nothing
          if parsed && parsed[:scientificName][:parsed] && parsed[:scientificName][:details].present?

            hybrid = parsed[:scientificName][:hybrid]
            canonical = parsed[:scientificName][:canonical]

            details = parsed[:scientificName][:details]
            authority = nested_hash_value(details, :authorship) if authority.nil?
            year = nested_hash_value(details, :year)

            if hybrid && name.collection == "Botany"
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
                hybrid_parents << [uninomial, genus, species, infraspecies].join(" ").strip
              end

              if hybrid_parents.size == 1
                canonical = hybrid_parents[0]
                rank = (name.scientific_name[0] == "×") ? "genus" : "species"
                hybrid_parents = [nil,nil]
              end
            end

          end

          csv << [id, verbatim, scientific_name, canonical, authority, year, rank, hybrid] + hybrid_parents
        end

      end
    end

  end

end