Sequel.migration do
  change do
    add_column :investments, :update_frequency, Integer, default: 7
  end
end
