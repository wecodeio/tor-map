Sequel.migration do
  up do
    run "UPDATE routers SET platform = SUBSTRING(platform FROM 'on (.+)')"
  end

  down do
  end
end
