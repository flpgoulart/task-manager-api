class ApiVersionConstraint
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end 

  def matches?(req)
    # vnd = vendor, para indicar que não é aplicado a outros parametros
    # neste caso, ele busca se tiver setado a versão default ou se informar a versão
    @default || req.headers['Accept'].include?("application/vnd.taskmanager.v#{@version}")
  end
end