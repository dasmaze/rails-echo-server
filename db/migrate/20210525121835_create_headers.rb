class CreateHeaders < ActiveRecord::Migration[6.1]
  def change
    create_table :headers do |t|
      t.string :name
      t.string :value
      t.references :endpoint, foreign_key: true

      t.timestamps
    end
  end
end
