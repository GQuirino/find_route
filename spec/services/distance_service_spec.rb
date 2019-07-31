require 'rails_helper'

RSpec.describe DistanceService do
  let!(:map) { create(:map) }
  before do
    create(:distance, origin: 'A', destiny: 'B', distance: 10, map: map)
    create(:distance, origin: 'B', destiny: 'D', distance: 15, map: map)
    create(:distance, origin: 'A', destiny: 'C', distance: 20, map: map)
    create(:distance, origin: 'C', destiny: 'D', distance: 30, map: map)
  end

  describe '.calc_cost' do
    it { expect(DistanceService.calc_cost(5, 5)).to eql 25 }
  end

  describe '.shortest_path' do
    expected_return = { path: 'ABD', distance: 25 }
    it do
      expect(DistanceService.shortest_path(map.name, 'A', 'D')).to eql expected_return
    end
  end
end
