require 'sequel'
require_relative '../../lib/json/response_builder.rb'

class Api

  def initialize(snapshots)
    @snapshots = snapshots
  end

  def append_snapshot(json)
    body = @snapshots.create_snapshot_with_structure(json)
    ResponseBuilder.new.set_body(body.to_json).build
  end

  def get_all_open_snapshots
    body = @snapshots.get_all_open_snapshots
    ResponseBuilder.new.set_body(body.to_json).build
  end

end
