require 'rails_helper'

RSpec.describe DistanceController, type: :controller do
  let(:map) { create(:map) }
  let!(:routeA_B) { create(:distance, origin: 'A', destiny: 'B', distance: 10, map: map) }
  let!(:routeB_D) { create(:distance, origin: 'B', destiny: 'D', distance: 15, map: map) }
  let!(:routeA_C) { create(:distance, origin: 'A', destiny: 'C', distance: 20, map: map) }
  let!(:routeC_D) { create(:distance, origin: 'C', destiny: 'D', distance: 30, map: map) }

  describe 'GET #index' do
    before do
      @origin = 'A'
      @destiny = 'D'
      @map = map.name
      @cost = 5
    end

    context 'with correct params' do
      it 'return shortest path' do
        get :index, params: { map: @map,
                              origin: @origin,
                              destiny: @destiny,
                              cost: @cost }

        expected_body = { 'path' => routeA_B.origin + routeB_D.origin + @destiny,
                          'distance' => routeA_B.distance + routeB_D.distance,
                          'cost' => (routeA_B.distance + routeB_D.distance) * @cost }

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body).to eql expected_body
      end
    end

    context 'with incorrect params' do
      it 'return Not Path Found' do
        get :index, params: { map: @map,
                              origin: 'D',
                              destiny: 'A',
                              cost: @cost }

        expected_body = { 'error' => 'NO PATH FOUND', 'source' => ['D', 'A'] }

        expect(response).to have_http_status(:forbidden)
        body = JSON.parse(response.body)
        expect(body).to eql(expected_body)
      end
    end

    context 'with incorrect params' do
      it 'return Record Not Found' do
        get :index, params: { map: 'some_map',
                              origin: @origin,
                              destiny: @destiny,
                              cost: @cost }

        expected_body = { 'error' => 'NOT FOUND', 'source' => 'some_map' }

        expect(response).to have_http_status(:not_found)
        body = JSON.parse(response.body)
        expect(body).to eql(expected_body)
      end

      it 'return Record Not Found' do
        get :index, params: { map: @map,
                              origin: 'some_origin',
                              destiny: @destiny,
                              cost: @cost }

        expected_body = { 'error' => 'NOT FOUND', 'source' => 'some_origin' }

        expect(response).to have_http_status(:not_found)
        body = JSON.parse(response.body)
        expect(body).to eql(expected_body)
      end

      it 'return Record Not Found' do
        get :index, params: { map: @map,
                              origin: @origin,
                              destiny: 'some_destiny',
                              cost: @cost }

        expected_body = { 'error' => 'NOT FOUND', 'source' => 'some_destiny' }

        expect(response).to have_http_status(:not_found)
        body = JSON.parse(response.body)
        expect(body).to eql(expected_body)
      end
    end
  end

  describe 'PUT #update' do
    context 'when map doesnt exist' do
      it 'create a map and return route created' do
        params = { map: 'new_map',
                   origin: 'A',
                   destiny: 'B',
                   distance: 20 }
        put :update, params: params

        expected_body = { 'origin' => params[:origin],
                          'destiny' => params[:destiny],
                          'distance' => params[:distance] }

        expect(response).to have_http_status(:created)

        body = JSON.parse(response.body)
        expect(body.except('id', 'map_id', 'created_at', 'updated_at')).to eql expected_body
      end
    end

    context 'when route doesnt exist on map' do
      it 'create route and return created' do
        params = { map: map.name,
                   origin: 'E',
                   destiny: 'F',
                   distance: 20 }
        put :update, params: params

        expected_body = { 'origin' => params[:origin],
                          'destiny' => params[:destiny],
                          'distance' => params[:distance],
                          'map_id' => map.id }

        expect(response).to have_http_status(:created)

        body = JSON.parse(response.body)
        expect(body.except('id', 'created_at', 'updated_at')).to eql expected_body
      end
    end

    context 'when route exist on map' do
      it 'update route and return' do
        params = { map: map.name,
                   origin: routeA_B.origin,
                   destiny: routeA_B.destiny,
                   distance: 20 }
        put :update, params: params

        expected_body = { 'origin' => params[:origin],
                          'destiny' => params[:destiny],
                          'distance' => params[:distance],
                          'map_id' => map.id }

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body.except('id', 'created_at', 'updated_at')).to eql expected_body
      end
    end
  end
end
