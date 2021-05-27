class AddIndexToEndpoints < ActiveRecord::Migration[6.1]
  def change
    add_index :endpoints, [:path, :verb], unique: true
  end
end
