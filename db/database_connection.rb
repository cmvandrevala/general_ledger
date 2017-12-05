require 'sequel'
require 'yaml'

class DatabaseConnection

  def create(environment = 'test')
    @@db ||= Sequel.connect(params(environment))
  end

  private

  def params(environment)
    database_config = YAML.load_file('config.yml')
    database_config[environment].reduce({}, :merge)
  end
end
