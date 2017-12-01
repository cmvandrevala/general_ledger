class TransactionValidator
  CLASSIFICATIONS_FOR_ASSETS = ['Cash Equivalents', 'Equities', 'Fixed Income']
  CLASSIFICATIONS_FOR_LIABILITIES = ['Debt']
  REQUIRED_FIELDS = [:asset_or_liability, :classification, :description, :institution, :owner, :symbol, :timestamp, :value]

  def valid?(json)
    (REQUIRED_FIELDS - json.keys).empty? &&
      valid_asset_or_liability(json) &&
      valid_classification(json) &&
      valid_value(json)
  end

  private

  def valid_asset_or_liability(json)
    ['ASSET', 'LIABILITY'].include? json[:asset_or_liability]
  end

  def valid_classification(json)
    valid_classification_for_liability(json) || valid_classification_for_asset(json)
  end

  def valid_classification_for_liability(json)
    json[:asset_or_liability] == 'LIABILITY' && CLASSIFICATIONS_FOR_LIABILITIES.include?(json[:classification])
  end

  def valid_classification_for_asset(json)
    json[:asset_or_liability] == 'ASSET' && CLASSIFICATIONS_FOR_ASSETS.include?(json[:classification])
  end

  def valid_value(json)
    json[:value].is_a? Integer
  end

end
