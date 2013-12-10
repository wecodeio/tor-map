class RouterPresenter
  def self.to_h(router)
    router.values.select do |k, _|
      %i(name latitude longitude distance bandwidth uptime ip_address hostname or_port dir_port exit fast stable running valid platform)
    end
  end
end

