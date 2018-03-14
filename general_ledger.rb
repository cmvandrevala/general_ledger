require 'sinatra/base'
require_relative 'lib/main/api'
require_relative 'lib/model/investment_access'
require_relative 'lib/model/snapshot_access'

class GeneralLedger < Sinatra::Base

  before do
    @api = Api.new(InvestmentAccess, SnapshotAccess)
    begin
      request.body.rewind
      @request_payload = JSON.parse request.body.read
    rescue
    end
  end

  get '/' do
    @api.get_all_open_snapshots
  end

  post '/append_snapshot' do
    @api.append_snapshot(@request_payload)
  end

  post '/update_frequency' do
    @api.update_frequency(@request_payload)
  end

  post '/update_open_date' do
    @api.update_open_date(@request_payload)
  end

  run! if app_file == $0
end
