class FamilyDatum < ActiveRecord::Base
  #-- Rev. 12/08/2013 to add has_many
  belongs_to :family_start_points
  has_many :family_affinities
  has_many :family_aliases
  has_many :family_documents
end
