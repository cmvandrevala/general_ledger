require "json/transaction_validator"

describe TransactionValidator do

  before(:each) do
    @validator = TransactionValidator.new
  end

  context "validating a transaction before appending it to the general ledger" do

    it "is valid if all of the required fields are present and well-formatted" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be true
    end

    it "is invalid if the json is missing a timestamp" do
      json = {"institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing an institution" do
      json = {"timestamp": "t", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing a description" do
      json = {"timestamp": "t", "institution": "i", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing an owner" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "symbol": "s", "asset_or_liability": "ASSET", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing a symbol" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "asset_or_liability": "ASSET", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing an asset or liability classification" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing a value" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing a classification" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 0}
      expect(@validator.valid?(json)).to be false
    end

    it "is valid if the asset_or_liability field has a value of ASSET" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be true
    end

    it "is valid if the asset_or_liability field has a value of LIABILITY" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "LIABILITY", "value": 0, "classification": "Debt"}
      expect(@validator.valid?(json)).to be true
    end

    it "is invalid if the asset_or_liability field has a random value" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "foobarbazquo", "value": 0, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is valid if value is an integer" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 7890, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be true
    end

    it "is invalid if value is a float" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 78.90, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if value is a string" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": "123", "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "is valid if the asset class is set to Cash Equivalents" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 123, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be true
    end

    it "is valid if the asset class is set to Equities" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 123, "classification": "Equities"}
      expect(@validator.valid?(json)).to be true
    end

    it "is valid if the asset class is set to Fixed Income" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 123, "classification": "Fixed Income"}
      expect(@validator.valid?(json)).to be true
    end

    it "is invalid if the asset class is set to a random value" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 123, "classification": "foobar"}
      expect(@validator.valid?(json)).to be false
    end

    it "has a classification of Debt if it is a liability" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "LIABILITY", "value": 123, "classification": "Debt"}
      expect(@validator.valid?(json)).to be true
    end

    it "cannot have a classification other than Debt if it is a liability" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "LIABILITY", "value": 123, "classification": "Cash Equivalents"}
      expect(@validator.valid?(json)).to be false
    end

    it "cannot have a classification of Debt if it is an asset" do
      json = {"timestamp": "t", "institution": "i", "description": "d", "owner": "o", "symbol": "s", "asset_or_liability": "ASSET", "value": 123, "classification": "Debt"}
      expect(@validator.valid?(json)).to be false
    end

  end
end
