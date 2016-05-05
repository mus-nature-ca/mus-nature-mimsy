class EmuCatalog < Catalog

  def summary
    {
      accessionNo: nil,
      acquisition: acquisition.present? ? acquisition.ref_number : nil,
      collection: collection,
      originalAccessionNo: nil,
      typeStatus: nil,
      taxon: taxa,
      collectors: collectors,
      collectionNo: nil,
      collectionDate: date_collected,
      objectType: nil,
      flagged: flag1,
      incidentalTaxa: nil,
      onExhibit: nil,
      onLoan: nil,
      locality: sites,
      habitat: nil,
      substrate: nil
    }
  end

  def labels
  end

  def features
  end

  def determinations
  end

  def incidentals
  end

  def other_associations
  end

  def management
  end

  def events
  end

  def conditions
  end

  def environmental_recommendations
  end

  def handling_recommendations
  end

  def references
  end

  def collections
  end

  def exchanges
  end

  def requests
  end

  def measurements
  end

  def preparations
  end

  def preparation_histories
  end

  def collection_associations
  end

  def notes
  end

  def biologies
  end

  def taxonomy
  end

  def stratigraphy
  end

  def source
  end

  def related_objects
  end

  def associations
  end

  def publications
  end

  def replications
  end

  def analyses
  end

  def conditions
  end

  def storages
  end

  def displays
  end

  def locations
  end

  def legalities
  end

  def valuations
  end

  def object_events
  end

  def provenance1
  end

  def provenance2
  end

  def text_imageries
  end

  def cultural
  end

  def dwc_paleo
  end

end