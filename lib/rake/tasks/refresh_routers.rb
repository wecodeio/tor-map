require "open-uri"
require "csv"

require File.expand_path("models/router")
require File.expand_path("lib/ip_geocoder")

class RefreshRouters
  def self.execute
    csv_filename = "Tor_query_EXPORT.csv"
    csv_file = File.join(ENV["HOME"], csv_filename)

    unless File.exists?(csv_file) && File.ctime(csv_file) > Time.now - 60*60*24
      File.open(csv_file, "w") do |f|
        f.write(open("http://torstatus.blutmagie.de/query_export.php/#{csv_filename}").read)
      end
    end

    return unless CSV.read(csv_file).length > 1

    Router.dataset.delete

    DB.run "COPY routers (name,country_code,bandwidth,uptime,ip_address,hostname,or_port,dir_port,authority,exit,fast,guard,named,stable,running,valid,v2_dir,platform,hibernating,bad_exit) FROM '#{csv_file}' WITH CSV HEADER NULL 'None';"

    DB.run "VACUUM VERBOSE ANALYZE routers"

    DB.run "UPDATE routers SET platform = SUBSTRING(platform FROM 'on (.+)')"

    Router.exclude(ip_address: nil).where(location: nil).all.each do |router|
      geocoder = IPGeocoder.new(router.ip_address)
      router.update_location(geocoder.latitude, geocoder.longitude) if geocoder.success?
    end

    print "done.\n"
  end
end
