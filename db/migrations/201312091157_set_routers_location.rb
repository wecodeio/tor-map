require File.expand_path("lib/ip_geocoder")

class Router < Sequel::Model
  def update_location(latitude, longitude)
    update(location: Sequel.lit("ST_GeographyFromText('SRID=4326; POINT(? ?)')", longitude, latitude))
  end
end

Sequel.migration do
  up do
    Router.exclude(ip_address: nil).where(location: nil).all.each do |router|
      geocoder = IPGeocoder.new(router.ip_address)
      router.update_location(geocoder.latitude, geocoder.longitude) if geocoder.success?
    end
  end

  down do
    run "update routers set location = nil"
  end
end
