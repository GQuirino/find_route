require 'rails_helper'

RSpec.describe PathService do
  let(:map) { create(:map) }
  let!(:routeA_B) { create(:distance, origin: 'A', destiny: 'B', distance: 10, map: map) }
  let!(:routeB_D) { create(:distance, origin: 'B', destiny: 'D', distance: 15, map: map) }
  let!(:routeA_C) { create(:distance, origin: 'A', destiny: 'C', distance: 20, map: map) }
  let!(:routeC_D) { create(:distance, origin: 'C', destiny: 'D', distance: 30, map: map) }

  before do
    @origin = 'A'
    @destiny = 'D'
    PathService.set_map_id(map.name)
  end

  describe '.set_map_id' do
    it do
      expect { PathService.set_map_id('some_name') }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.all_pairs_until_destiny' do
    it do
      expected_result = [
        routeA_B.as_json.except('created_at', 'updated_at', 'map_id'),
        routeB_D.as_json.except('created_at', 'updated_at', 'map_id'),
        routeA_C.as_json.except('created_at', 'updated_at', 'map_id'),
        routeC_D.as_json.except('created_at', 'updated_at', 'map_id')
      ]
      result = PathService.all_pairs_until_destiny(@origin, @destiny).as_json
      expect(result).to match_array expected_result
    end
  end

  describe '.mount_all_paths' do
    it do
      expected_result = [
        {
          path: routeA_B.origin + routeB_D.origin + @destiny,
          distance: routeA_B.distance + routeB_D.distance
        },
        {
          path: routeA_C.origin + routeC_D.origin + @destiny,
          distance: routeA_C.distance + routeC_D.distance
        }
      ]
      all_pairs_until_destiny = PathService.all_pairs_until_destiny(@origin, @destiny)
      result = PathService.mount_all_paths(all_pairs_until_destiny, @origin, @destiny)
      expect(result).to match_array expected_result
    end
  end
end
