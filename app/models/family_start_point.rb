class FamilyStartPoint < ActiveRecord::Base
  #-- Rev. 12/08/2013 to add has_many
  has_many :family_data
end
