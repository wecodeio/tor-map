set :stage, :production

server 'tor-map.crasch.com.ar', user: 'cristian', roles: %w{app db}

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
set :ssh_options, { forward_agent: true }

set :linked_dirs, %w{tmp/puma log }

fetch(:default_env).merge!(rack_env: :production)
