require 'sequel'
require_relative '../../lib/json/response_builder.rb'

class Api

  def initialize(investments, snapshots)
    @investments = investments
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

  def update_frequency(json)
    body = @investments.update_frequency(json)
    ResponseBuilder.new.set_body(body.to_json).build
  end

  def update_open_date(json)
    body = @investments.update_open_date(json)
    ResponseBuilder.new.set_body(body.to_json).build
  end

end
