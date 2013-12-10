require "geoip"

class IPGeocoder
  class << self
    attr_reader :db

    def bootstrap
      tmp_dir = ENV["HOME"]
      tmp_dir += "/tmp" unless File.writable?(tmp_dir)
      dat_filename = "GeoLiteCity.dat"
      dat_file = File.join(tmp_dir, dat_filename)
      unless File.exists?(dat_file) && File.ctime(dat_file) > Time.now - 60*60*24
        %x(wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz --directory-prefix=#{tmp_dir} && gunzip #{tmp_dir}/GeoLiteCity.dat.gz)
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
