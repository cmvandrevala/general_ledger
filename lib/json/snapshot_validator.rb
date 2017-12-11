class SnapshotValidator
  REQUIRED_FIELDS = ['institution', 'account', 'owner', 'investment', 'asset', 'timestamp', 'value']

  def valid?(json)
    (REQUIRED_FIELDS - json.keys).empty? && valid_value(json)
  end

  private

  def valid_value(json)
    json['value'].is_a? Integer
  end

end
