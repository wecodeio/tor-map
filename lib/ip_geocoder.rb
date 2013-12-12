require "geoip"

class IPGeocoder
  class << self
    attr_reader :db

    def bootstrap
      home_dir = ENV["HOME"]
      dat_file = File.join(home_dir, "GeoLiteCity.dat")
      unless File.exists?(dat_file) && File.ctime(dat_file) > Time.now - 60*60*24
        %x(wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz --directory-prefix=#{home_dir} && gunzip --force #{home_dir}/GeoLiteCity.dat.gz)
      end

      @db = GeoIP::City.new(dat_file, :filesystem)
    end
  end
  bootstrap

  def initialize(ip_address)
    @ip_address = ip_address
  end

  def latitude
    @latitude ||= result[:latitude]
  end

  def longitude
    @longitude ||= result[:longitude]
  end

  def success?
    latitude && longitude
  end

private

  def result
    @result ||= self.class.db.look_up(@ip_address) || {}
  end
end
