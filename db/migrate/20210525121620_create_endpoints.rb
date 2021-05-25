class CreateEndpoints < ActiveRecord::Migration[6.1]
  def change
    create_table :endpoints do |t|
      t.string :verb
      t.string :path
      t.integer :response_code
      t.text :response_body

      t.timestamps
    end
  end
end
