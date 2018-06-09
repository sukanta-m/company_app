require 'rails_helper'

RSpec.describe Company, type: :model do
  it { is_expected.to be_mongoid_document }

  context "field matching" do
    it { is_expected.to have_field(:name).of_type(String) }
    it { is_expected.to have_field(:website).of_type(String) }
    it { is_expected.to have_field(:reg_id).of_type(Integer) }
    it { is_expected.to have_field(:timings).of_type(String) }
    it { is_expected.to have_field(:established_date).of_type(Time) }
  end

  it { is_expected.to embed_many :branches }

  context "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_numericality_of(:reg_id) }
  end

  context "scopes" do
    let!(:statup_company1) { FactoryBot.create(:company, name: 'startup Company 1', established_date: Time.now.to_date) }
    let!(:statup_company2) { FactoryBot.create(:company, name: 'startup Company 2', established_date: 8.years.ago.to_date) }
    let!(:mid_size_company1) { FactoryBot.create(:company, name: 'Midsize Company 1', established_date: 9.years.ago.to_date) }
    let!(:mid_size_company2) { FactoryBot.create(:company, name: 'Midsize Company 2', established_date: 18.years.ago.to_date) }
    let!(:established_company1) { FactoryBot.create(:company, name: 'Established Company 1', established_date: 19.years.ago.to_date) }
    let!(:established_company2) { FactoryBot.create(:company, name: 'Established Company 2', established_date: 30.years.ago.to_date) }

    describe ".startup" do
      it "should return statup comapnies" do
        expect(Company.startup.to_a).to match_array([statup_company1, statup_company2])
      end
    end

    describe ".mid_size" do
      it "should return mid_size comapnies" do
        expect(Company.mid_size.to_a).to match_array([mid_size_company1, mid_size_company2])
      end
    end

    describe ".established" do
      it "should return established comapnies" do
        expect(Company.established.to_a).to match_array([established_company1, established_company2])
      end
    end
  end

  describe ".create_or_update_branches" do
    let(:branch_attributes) {
      {
        name: 'branch 1',
        line1: "Apt #14, Suite #22",
        line2: "ABC Street, BCDTown",
        city: "XYCity",
        state: "Foo",
        country: "Bar",
        zip: "0102"
      }
    }
    let!(:company1) { FactoryBot.create(:company, name: "company1") }

    it "should create new branch" do
      expect(company1.branches.count).to eq 0
      company1.create_or_update_branches([branch_attributes])
      expect(company1.reload.branches.count).to eq 1
    end

    it "should update matching branch" do
      company1.branches << Branch.new(branch_attributes)
      company1.create_or_update_branches([branch_attributes.merge(line1: "update line1")])
      expect(company1.reload.branches.first.line1).to eq "update line1"
    end
  end
end
