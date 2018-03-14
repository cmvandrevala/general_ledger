require_relative './model'

class InvestmentAccess

  def self.update_frequency(json)
    institution = Institution.find(name: json['institution'])
    return {status: "Could not find an institution of \"#{json['institution']}\""} if institution.nil?
    account = Account.find(name: json['account'], owner: json['owner'], institution_id: institution[:id])
    return {status: "Could not find an account of \"#{json['account']}\""} if account.nil?
    investment = Investment.find(name: json['investment'], asset: json['asset'], account_id: account[:id])
    return {status: "Could not find an investment of \"#{json['investment']}\""} if investment.nil?
    investment.update(update_frequency: json['frequency'])
    {status: 'Successfully changed the update frequency'}
  end

end
