class AccountAccess

  def self.all
    Account.all
  end

  def self.create(params)
    Account.create(params)
  end

  def self.find_or_create(params)
    Account.find_or_create(params)
  end

  def self.first
    Account.first
  end

  def self.find_from_json(json)
    institution = Institution.where(name: json['institution']).first
    if !institution.nil?
      Account.where(name: json['account'], owner: json['owner'], institution_id: institution[:id]).first
    end
  end

end
