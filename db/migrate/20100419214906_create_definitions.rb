class CreateDefinitions < ActiveRecord::Migration
  def self.up
    create_table :definitions do |t|
      t.string :name
      t.text :body
      t.timestamps
    end

    add_index :definitions, :name
  end

  def self.down
    drop_table :definitions
  end
end
