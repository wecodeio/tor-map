Sequel.migration do
  up do
    run "ALTER TABLE routers ADD COLUMN location GEOGRAPHY(POINT, 4326)"
    run "CREATE INDEX routers_location_idx ON routers USING GIST (location)"
  end

  down do
    alter_table :routers do
      drop_column :location
    end
  end
end
