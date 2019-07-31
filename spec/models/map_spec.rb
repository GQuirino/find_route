require 'rails_helper'

RSpec.describe Map, type: :model do
  it { is_expected.to accept_nested_attributes_for(:distances) }
  it { is_expected.to have_many(:distances) }
  it { is_expected.to validate_presence_of(:name) }
end
