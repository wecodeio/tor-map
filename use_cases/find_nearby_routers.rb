require_relative "../models/router"

class FindNearbyRouters
  DISTANCE = 400_000

  class << self
    def execute(latitude, longitude)
      Router.within(DISTANCE, latitude, longitude).include_location.
        ordered_by_proximity(latitude, longitude).all
    end
  end
end
