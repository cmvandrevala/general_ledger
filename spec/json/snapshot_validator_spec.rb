require "json/snapshot_validator"

describe SnapshotValidator do

  before(:each) do
    @validator = SnapshotValidator.new
  end

  context "validating a transaction before appending it to the general ledger" do

    it "is valid if all of the required fields are present and well-formatted" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be true
    end

    it "is invalid if the json is missing an institution" do
      json = {'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing an account" do
      json = {'institution' => 'US Bank', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing an owner" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing an investment" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'asset' => true, 'value' => 1012, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing an asset or liability classification" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'value' => 1012, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing a value" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if the json is missing a timestamp" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012}
      expect(@validator.valid?(json)).to be false
    end

    it "is valid if value is an integer" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be true
    end

    it "is invalid if value is a float" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 10.12, 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be false
    end

    it "is invalid if value is a string" do
      json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => '1000', 'timestamp' => '2013-01-21'}
      expect(@validator.valid?(json)).to be false
    end

  end
end
