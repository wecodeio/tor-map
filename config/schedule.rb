set :environment_variable, "RACK_ENV"
set :output, "log/whenever.log"

# job_type :rake,"cd :path && RACK_ENV=:environment bundle exec rake :task --silent :output"

every :day do
  rake "routers:refresh"
end
