Sequel.migration do
  change do
    add_column :investments, :open, TrueClass, default: true
  end
end
