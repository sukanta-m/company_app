class Branch
  include Mongoid::Document

  field :name, type: String
  field :line1, type: String
  field :line2, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String
  field :zip, type: String

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :line1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :country
  validates_presence_of :zip

  embedded_in :company, inverse_of: :branches
end
