$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sequel'

require_relative '../../lib/json/response_builder.rb'
require_relative '../../lib/json/snapshot_validator.rb'
require_relative '../../lib/model/model.rb'

class Api

  def open_account(json)
    account = Account.find_from_json(json)
    body = set_account_open_status(account, true)
    ResponseBuilder.new.set_body(body.to_json).build
  end

  def close_account(json)
    account = Account.find_from_json(json)
    body = set_account_open_status(account, false)
    ResponseBuilder.new.set_body(body.to_json).build
  end

  def append_snapshot(json)
    if SnapshotValidator.new.valid?(json)
      institution = Institution.find_or_create(name: json['institution'])
      account = Account.find_or_create(name: json['account'], owner: json['owner'], institution_id: institution[:id])
      investment = Investment.find_or_create(name: json['investment'], asset: json['asset'], account_id: account[:id])
      Snapshot.create(timestamp: json['timestamp'], value: json['value'], investment_id: investment[:id])
      ResponseBuilder.new.set_body({status: 'Successfully appended the snapshot'}.to_json).build
    else
      ResponseBuilder.new.set_body({status: 'The JSON is invalid'}.to_json).build
    end
  end

  private

  def set_account_open_status(account, status)
    return {} if account.nil?
    account.update(open: status)
    {account: {name: account[:name], owner: account[:owner], open: account[:open]}}
  end

end
