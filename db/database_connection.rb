require "sequel"
require "yaml"

class DatabaseConnection
  def create
    database_config = YAML.load_file('config.yml')
    sequel_params = database_config["sequel"].reduce({}, :merge)
    Sequel.connect(sequel_params)
  end
end
