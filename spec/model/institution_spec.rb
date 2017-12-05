require "database_cleaner"
require "model/institution"

DatabaseCleaner.strategy = :transaction

describe Institution do

  it "creates a new institution" do
    DatabaseCleaner.cleaning do
      Institution.create(name: "Charles Schwab and Co.")
      expect(Institution.all.length).to eq 1
    end
  end

  it "creates two new institutions" do
    DatabaseCleaner.cleaning do
      Institution.create(name: "Charles Schwab and Co.")
      Institution.create(name: "JP Morgan and Chase")
      expect(Institution.all.length).to eq 2
    end
  end

  it "sets the name of the institution" do
    DatabaseCleaner.cleaning do
      Institution.create(name: "US Bank")
      institution = Institution.all.first
      expect(institution[:name]).to eq "US Bank"
    end
  end

  it "enforces uniqueness of the name of the institution" do
    DatabaseCleaner.cleaning do
      expect{ 2.times do Institution.create(name: "US Bank") end }.to raise_error Sequel::UniqueConstraintViolation
    end
  end

  it "enforces a non-nil name for the institution" do
    DatabaseCleaner.cleaning do
      expect{ Institution.create(name: nil) }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it "sets the created_at timestamp" do
    DatabaseCleaner.cleaning do
      Institution.create(name: "US Bank")
      institution = Institution.all.first
      expect(institution[:created_at]).not_to be_nil
    end
  end

  it "sets the updated_at timestamp at creation" do
    DatabaseCleaner.cleaning do
      Institution.create(name: "US Bank")
      institution = Institution.all.first
      expect(institution[:updated_at]).not_to be_nil
    end
  end

  it "sets the id of the institution" do
    DatabaseCleaner.cleaning do
      Institution.create(name: "US Bank")
      institution = Institution.all.first
      expect(institution[:id]).not_to be_nil
    end
  end

end
