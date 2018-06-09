class Company
  include Mongoid::Document

  field :name, type: String
  field :website, type: String
  field :reg_id, type: Integer
  field :timings, type: String
  field :established_date, type: Time

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :reg_id

  embeds_many :branches
  validates_associated :branches

  scope :startup, -> () { where(established_date: (8.years.ago.to_date - 1.day..Time.now.to_date + 1.day)) }
  scope :mid_size, -> () { where(established_date: (18.years.ago.to_date - 1.day..9.years.ago.to_date + 1.day)) }
  scope :established, -> () { where(:established_date.lte => 18.years.ago.to_date) }

  def create_or_update_branches(records)
    records.each do |attrs|
      exist_branch = branches.where(name: attrs.with_indifferent_access["name"]).first

      if exist_branch
        exist_branch.update_attributes(attrs)
      else
        branches << Branch.new(attrs)
      end
    end
  end
end
