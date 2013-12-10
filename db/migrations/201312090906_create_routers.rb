Sequel.migration do
  up do
    create_table :routers do
      String :name, text: true, null: false
      String :country_code, size: 3, null: false
      Integer :bandwidth, null: false, default: 0
      Integer :uptime, null: false, default: 0
      column :ip_address, "inet", null: false
      String :hostname, text: true, null: false
      Integer :or_port, null: false
      Integer :dir_port
      FalseClass :authority, null: false, default: false
      FalseClass :exit, null: false, default: false
      FalseClass :fast, null: false, default: false
      FalseClass :guard, null: false, default: false
      FalseClass :named, null: false, default: false
      FalseClass :stable, null: false, default: false
      FalseClass :running, null: false, default: false
      FalseClass :valid, null: false, default: false
      FalseClass :v2_dir, null: false, default: false
      String :platform, text: true
      FalseClass :hibernating, null: false, default: false
      FalseClass :bad_exit, null: false, default: false

      primary_key :id, Integer
    end
  end

  down do
    drop_table :routers
  end
end
