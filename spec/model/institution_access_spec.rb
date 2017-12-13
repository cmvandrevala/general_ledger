require 'database_cleaner'
require 'model/institution_access'

DatabaseCleaner.strategy = :transaction

describe InstitutionAccess do

  it 'creates a new institution' do
    DatabaseCleaner.cleaning do
      InstitutionAccess.create(name: 'Charles Schwab and Co.')
      expect(InstitutionAccess.all.length).to eq 1
    end
  end

  it 'creates two new institutions' do
    DatabaseCleaner.cleaning do
      InstitutionAccess.create(name: 'Charles Schwab and Co.')
      InstitutionAccess.create(name: 'JP Morgan and Chase')
      expect(InstitutionAccess.all.length).to eq 2
    end
  end

  it 'sets the name of the institution' do
    DatabaseCleaner.cleaning do
      InstitutionAccess.create(name: 'US Bank')
      institution = InstitutionAccess.first
      expect(institution[:name]).to eq 'US Bank'
    end
  end

  it 'enforces uniqueness of the name of the institution' do
    DatabaseCleaner.cleaning do
      expect{ 2.times do InstitutionAccess.create(name: 'US Bank') end }.to raise_error Sequel::UniqueConstraintViolation
    end
  end

  it 'enforces a non-nil name for the institution' do
    DatabaseCleaner.cleaning do
      expect{ InstitutionAccess.create(name: nil) }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the created_at timestamp' do
    DatabaseCleaner.cleaning do
      InstitutionAccess.create(name: 'US Bank')
      institution = InstitutionAccess.first
      expect(institution[:created_at]).not_to be_nil
    end
  end

  it 'sets the updated_at timestamp at creation' do
    DatabaseCleaner.cleaning do
      InstitutionAccess.create(name: 'US Bank')
      institution = InstitutionAccess.first
      expect(institution[:updated_at]).not_to be_nil
    end
  end

  it 'sets the id of the institution' do
    DatabaseCleaner.cleaning do
      InstitutionAccess.create(name: 'US Bank')
      institution = InstitutionAccess.first
      expect(institution[:id]).not_to be_nil
    end
  end

end
