Sequel.migration do
  up do
    alter_table(:investments) do
      add_column :term, String
      add_constraint(:term_value) { {term: ['short', 'medium', 'long']} }
    end
  end

  down do
    alter_table(:investments) do
      drop_constraint(:term_value)
      drop_column :term
    end
  end
end
