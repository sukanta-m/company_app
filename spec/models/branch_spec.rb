require 'rails_helper'

RSpec.describe Branch, type: :model do
  it { is_expected.to be_mongoid_document }

  context "field matching" do
    it { is_expected.to have_field(:name).of_type(String) }
    it { is_expected.to have_field(:line1).of_type(String) }
    it { is_expected.to have_field(:line2).of_type(String) }
    it { is_expected.to have_field(:city).of_type(String) }
    it { is_expected.to have_field(:state).of_type(String) }
    it { is_expected.to have_field(:country).of_type(String) }
    it { is_expected.to have_field(:zip).of_type(String) }
  end

  it { is_expected.to be_embedded_in :company }

  context "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:line1) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:zip) }
  end
end
