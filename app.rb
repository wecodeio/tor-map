require "cuba"
require "cuba/render"
require "tilt/haml"
require "cuhaml/contrib"
require "haml"
require "json"
require "bigdecimal"

require_relative "config/initializers/dotenv"
require_relative "config/initializers/sequel"

require_relative "use_cases/find_nearby_routers"

require_relative "presenters/router_presenter"

Cuba.use Rack::Static, urls: %w(/images), root: "assets"

Cuba.plugin Cuba::Render
Cuba.plugin Cuhaml::Contrib::ContentFor

Cuba.settings[:google_maps_api_key] = ENV["GOOGLE_MAPS_API_KEY"]

Cuba.define do
  on get do
    on "routers", param("latitude"), param("longitude") do |lat, long|
      latitude, longitude = BigDecimal.new(lat), BigDecimal.new(long)
      routers = FindNearbyRouters.execute(latitude, longitude)
      routers.map! { |router| RouterPresenter.to_h(router) }
      res.write JSON.generate(routers)
    end

    on root do
      res.write view("index")
    end
  end
end
