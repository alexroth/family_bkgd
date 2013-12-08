class FamilyAffinity < ActiveRecord::Base
  #-- Rev. 12/08/2013 to add has_many
  belongs_to :family_data
end
