module PathService
  def set_map_id(map)
    @map_id = Map.select(:id).find_by(name: map)
    raise ActiveRecord::RecordNotFound, map if @map_id.nil?
  end

  def mount_all_paths(all_pairs_until_destiny, origin, destiny)
    paths = [{ path: origin, distance: 0 }]
    paths.each do |path_distance|
      next_routes = all_pairs_until_destiny.select { |route| route.origin == path_distance[:path].last }

      next_routes.each do |route|
        path = path_distance[:path]
        distance = path_distance[:distance]
        distance += route.distance.to_i
        path += route.destiny
        paths.push(path: path, distance: distance)
      end
    end
    paths.select { |path_distance| path_distance[:path].last == destiny }
  end

  def all_pairs_until_destiny(origin, destiny, possible_routes = [])
    all_routes = all_routes_started_with(origin)

    if last_route?(all_routes, origin, destiny)
      possible_routes.push(all_routes)
      return possible_routes.flatten
    end

    all_routes.each do |route|
      possible_routes.push(route)
      all_pairs_until_destiny(route.destiny, destiny, possible_routes)
    end

    possible_routes.flatten
  end

  def self.last_route?(all_routes, origin, destiny)
    last_route = all_routes.where(origin: origin, destiny: destiny)
    last_route.present?
  end

  def self.all_routes_started_with(origin)
    Distance.select(:id, :origin, :destiny, :distance).where(origin: origin, map_id: @map_id)
  end

  module_function :set_map_id, :mount_all_paths, :all_pairs_until_destiny
end
