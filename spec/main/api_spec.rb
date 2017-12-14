require 'main/api'

class MockSnapshots
  def self.create_snapshot_with_structure(json)
    {status: 'Successfully appended the snapshot'}
  end

  def self.get_all_open_snapshots
    { snapshots: [ { data: 'snapshot data goes here' } ] }
  end
end

describe 'GeneralLedger' do

  before(:each) do
    @api = Api.new(MockSnapshots)
  end

  context "#append_snapshot" do

    it "returns a successful response with the status provided by the snapshots model" do
      response = @api.append_snapshot({})
      expect(response).to eq [200, {"Content-Type"=>"application/json"}, [MockSnapshots.create_snapshot_with_structure({}).to_json]]
    end

  end

  context '#get_all_open_snapshots' do

    it "returns a successful response with the status provided by the snapshots model" do
      response = @api.get_all_open_snapshots
      expect(response).to eq [200, {"Content-Type"=>"application/json"}, [MockSnapshots.get_all_open_snapshots.to_json]]
    end

  end

end
