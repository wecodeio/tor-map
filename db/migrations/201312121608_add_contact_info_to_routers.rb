Sequel.migration do
  change do
    alter_table :routers do
      add_column :contact_info, String, text: true
    end
  end
end
