require "open-uri"
require "json"

class IPGeocoder
  def initialize(ip_address)
    @ip_address = ip_address
  end

  def latitude
    @latitude ||= response["latitude"]
  end

  def longitude
    @longitude ||= response["longitude"]
  end

  def success?
    latitude && longitude
  end

private

  # {"ip":"186.22.185.197","country_code":"AR","country_name":"Argentina","region_code":"07",
  #  "region_name":"Distrito Federal","city":"Buenos Aires","zipcode":"",
  #  "latitude":-34.5875,"longitude":-58.6725,"metro_code":"","areacode":""}
  def response
    @response ||= begin
                    JSON.parse(open("http://freegeoip.net/json/#{@ip_address}").read)
                  rescue OpenURI::HTTPError
                    {}
                  end
  end
end
