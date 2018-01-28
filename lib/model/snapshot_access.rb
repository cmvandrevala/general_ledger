require_relative './model'
require_relative '../../lib/json/snapshot_validator.rb'

class SnapshotAccess

  def self.create_snapshot_with_structure(json)
    if SnapshotValidator.new.valid?(json)
      institution = Institution.find_or_create(name: json['institution'])
      account = Account.find_or_create(name: json['account'], owner: json['owner'], institution_id: institution[:id])
      investment = Investment.find_or_create(name: json['investment'], asset: json['asset'], account_id: account[:id])
      Snapshot.create(timestamp: json['timestamp'], value: json['value'], investment_id: investment[:id])
      {status: 'Successfully appended the snapshot'}
    else
      {status: 'Failed to append the snapshot'}
    end
  end

  def self.get_all_open_snapshots
    output = []
    Snapshot.all.each do |snapshot|
      investment = snapshot.investment
      account = investment.account
      institution = account.institution
      hash = {institution: institution[:name], account: account[:name], owner: account[:owner], investment: investment[:name], asset: investment[:asset], asset_class: investment[:asset_class], value: snapshot[:value], timestamp: snapshot[:timestamp], update_frequency: investment[:update_frequency]}
      output << hash if account[:open] && investment[:open]
    end
    body = {snapshots: output}
  end

end
