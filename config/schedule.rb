set :environment_variable, "RACK_ENV"
set :output, "log/whenever.log"

every 1.day, at: "3:00 am" do
  rake "routers:refresh"
end

every 1.day, at: "3:15 am" do
  rake "routers:set_contact_info"
end
