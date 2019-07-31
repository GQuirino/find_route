require 'rails_helper'

RSpec.describe Distance, type: :model do
  it { is_expected.to belong_to(:map) }
  it { is_expected.to validate_presence_of(:origin) }
  it { is_expected.to validate_presence_of(:destiny) }
end
