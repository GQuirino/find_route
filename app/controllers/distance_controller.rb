class DistanceController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found

  def index
    shortest_path = DistanceService.shortest_path(distance_params)

    if shortest_path.nil?
      render_no_path_error(distance_params[:origin], distance_params[:destiny])
    else
      shortest_path[:cost] = DistanceService.calc_cost(shortest_path[:distance], distance_params[:cost].to_i)
      render json: shortest_path, status: :ok
    end
  end

  def update
    resp = DistanceService.create_or_update(create_distance_params)
    render json: resp[:distance], status: resp[:status_code]
  end

  private

  def render_resource_not_found(exception)
    render json: {
      error: 'NOT FOUND',
      source: exception
    }, status: :not_found
  end

  def render_no_path_error(origin, destiny)
    render json: {
      error: 'NO PATH FOUND',
      source: [origin, destiny]
    }, status: :forbidden
  end

  def distance_params
    {
      origin: params.require(:origin),
      destiny: params.require(:destiny),
      map: params.require(:map),
      cost: params.require(:cost)
    }
  end

  def create_distance_params
    {
      origin: params.require(:origin),
      destiny: params.require(:destiny),
      distance: params.require(:distance),
      map: params.require(:map)
    }
  end
end
