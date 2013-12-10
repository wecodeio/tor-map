Sequel.migration do
  no_transaction

  up do
    run "VACUUM VERBOSE ANALYZE routers"
  end

  down do
  end
end
