require "json/response_builder"

describe ResponseBuilder do

  before(:each) do
    @builder = ResponseBuilder.new
  end

  it "returns a default Rack response" do
    headers = {"Content-Type" => 'application/json'}
    expect(@builder.build).to eq [200, headers, ['']]
  end

  it "sets the status code of the Rack response" do
    @builder.set_status_code(404)
    headers = {"Content-Type" => 'application/json'}
    expect(@builder.build).to eq [404, headers, ['']]
  end

  it "sets the body of the Rack response" do
    @builder.set_body('This is my HTTP body!')
    headers = {"Content-Type" => 'application/json'}
    expect(@builder.build).to eq [200, headers, ['This is my HTTP body!']]
  end

  it "sets both a status code and a body" do
    @builder.set_status_code(300).set_body('body')
    headers = {"Content-Type" => 'application/json'}
    expect(@builder.build).to eq [300, headers, ['body']]
  end

end
