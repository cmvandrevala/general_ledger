Sequel.migration do
  change do
    add_column :investments, :asset_class, String, default: "None"
  end
end
