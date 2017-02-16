class AuthorityLink < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vw_authority_links

  # specify primary key name
  self.primary_key = :authlinkkey

  def self.has_link?(id)
    self.where("key1 = ? OR key2 = ?", id, id).exists?
  end

end