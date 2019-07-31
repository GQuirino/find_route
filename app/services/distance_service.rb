module DistanceService
  def shortest_path(params)
    PathService.set_map_id(params[:map])

    all_pairs_until_destiny = PathService
                              .all_pairs_until_destiny(
                                params[:origin],
                                params[:destiny]
                              )
    all_paths = PathService
                .mount_all_paths(
                  all_pairs_until_destiny,
                  params[:origin],
                  params[:destiny]
                )

    all_paths.min_by { |path| path[:distance] }
  end

  def calc_cost(distance, cost_per_km)
    distance * cost_per_km
  end

  def create_or_update(params)
    map = Map.find_or_initialize_by(name: params[:map])
    map.save if map.id.nil?

    distance = Distance.find_or_initialize_by(map_id: map.id,
                                              origin: params[:origin],
                                              destiny: params[:destiny])
    distance.distance = params[:distance]
    status = distance.id.nil? ? :created : :ok
    distance.save

    { distance: distance, status_code: status }
  end

  module_function :shortest_path, :calc_cost, :create_or_update
end
