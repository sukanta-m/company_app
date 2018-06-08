class Company
  include Mongoid::Document

  field :name, type: String
  field :website, type: String
  field :reg_id, type: Integer
  field :timings, type: Time
  field :established_date, type: Time

  validates_presence_of :name

  embeds_many :branches

  scope :startup, -> () { where(established_date: (8.years.ago..Time.now)) }
  scope :mid_size, -> () { where(established_date: (18.years.ago..9.years.ago)) }
  scope :established, -> () { where(:established_date.lte => 18.years.ago) }
end
