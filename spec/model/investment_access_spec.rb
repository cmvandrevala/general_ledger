require 'database_cleaner'
require 'model/investment_access'

DatabaseCleaner.strategy = :transaction

describe InvestmentAccess do

  context "#update_frequency" do

    it 'changes the update frequency of an investment when a frequency already exists' do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'institution')
        account = Account.create(name: 'account', owner: 'owner', institution_id: institution[:id])
        investment = Investment.create(name: 'investment', asset: true, account_id: account[:id], update_frequency: 7)
        json = {'institution' => 'institution', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'asset' => true, 'frequency' => 5}
        actual_response = InvestmentAccess.update_frequency(json)
        expected_response = {status: 'Successfully changed the update frequency'}
        investment = Investment.first
        expect(investment.update_frequency).to eq 5
        expect(actual_response).to eq expected_response
      end
    end

    it 'changes the update frequency of an investment when a frequency does not exist' do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'institution')
        account = Account.create(name: 'account', owner: 'owner', institution_id: institution[:id])
        investment = Investment.create(name: 'investment', asset: true, account_id: account[:id])
        json = {'institution' => 'institution', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'asset' => true, 'frequency' => 12}
        actual_response = InvestmentAccess.update_frequency(json)
        expected_response = {status: 'Successfully changed the update frequency'}
        investment = Investment.first
        expect(investment.update_frequency).to eq 12
        expect(actual_response).to eq expected_response
      end
    end

    it 'returns a failure message when an institution is not found' do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'institution')
        account = Account.create(name: 'account', owner: 'owner', institution_id: institution[:id])
        investment = Investment.create(name: 'investment', asset: true, account_id: account[:id])
        json = {'institution' => 'does not exist', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'asset' => true, 'frequency' => 12}
        actual_response = InvestmentAccess.update_frequency(json)
        expected_response = {status: 'Could not find an institution of "does not exist"'}
        expect(actual_response).to eq expected_response
      end
    end

    it 'returns a failure message when an account is not found' do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'institution')
        account = Account.create(name: 'account', owner: 'owner', institution_id: institution[:id])
        investment = Investment.create(name: 'investment', asset: true, account_id: account[:id])
        json = {'institution' => 'institution', 'account' => 'non-existent', 'owner' => 'owner', 'investment' => 'investment', 'asset' => true, 'frequency' => 12}
        actual_response = InvestmentAccess.update_frequency(json)
        expected_response = {status: 'Could not find an account of "non-existent"'}
        expect(actual_response).to eq expected_response
      end
    end

    it 'returns a failure message when an investment is not found' do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'institution')
        account = Account.create(name: 'account', owner: 'owner', institution_id: institution[:id])
        investment = Investment.create(name: 'investment', asset: true, account_id: account[:id])
        json = {'institution' => 'institution', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'asset' => false, 'frequency' => 12}
        actual_response = InvestmentAccess.update_frequency(json)
        expected_response = {status: 'Could not find an investment of "investment"'}
        expect(actual_response).to eq expected_response
      end
    end

  end

end
