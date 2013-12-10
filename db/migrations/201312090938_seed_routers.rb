Sequel.migration do
  up do
    run "COPY routers (name,country_code,bandwidth,uptime,ip_address,hostname,or_port,dir_port,authority,exit,fast,guard,named,stable,running,valid,v2_dir,platform,hibernating,bad_exit) FROM '#{File.join(Dir.pwd, "data/Tor_query_EXPORT.csv")}' WITH CSV HEADER NULL 'None';"
  end

  down do
    run "DELETE FROM routers"
  end
end
