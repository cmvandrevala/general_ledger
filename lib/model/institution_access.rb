require_relative './model'

class InstitutionAccess

  def self.all
    Institution.all
  end

  def self.create(params)
    Institution.create(params)
  end

  def self.find_or_create(params)
    Institution.find_or_create(params)
  end

  def self.first
    Institution.first
  end

end
