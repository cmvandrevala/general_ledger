class ResponseBuilder

  def initialize
    @status_code = 200
    @body = ''
  end

  def set_status_code(code)
    @status_code = code
    self
  end

  def set_body(body)
    @body = body
    self
  end

  def build
    [@status_code, {"Content-Type" => "application/json"}, [@body]]
  end

end
