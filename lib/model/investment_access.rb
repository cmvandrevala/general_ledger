require_relative './model'

class InvestmentAccess

  def self.all
    Investment.all
  end

  def self.create(params)
    Investment.create(params)
  end

  def self.find_or_create(params)
    Investment.find_or_create(params)
  end

  def self.first
    Investment.first
  end

end
