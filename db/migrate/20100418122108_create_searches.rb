class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :checksum, :null => false
      t.text :original, :null => false

      t.timestamps
    end

    add_index :documents, :checksum
  end

  def self.down
    drop_table :documents
  end
end
