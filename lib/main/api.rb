$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sequel'
require_relative '../../db/database_connection'
require_relative '../../lib/json/response_builder.rb'
require_relative '../../lib/model/account.rb'

db = DatabaseConnection.new.create

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

  private

  def set_account_open_status(account, status)
    return {} if account.nil?
    account.update(open: status)
    {account: {name: account[:name], owner: account[:owner], open: account[:open]}}
  end

end
