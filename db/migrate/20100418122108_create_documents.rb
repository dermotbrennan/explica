class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :checksum, :null => false
      t.text :original, :null => false
      t.boolean :is_public, :null => false, :default => false

      t.timestamps
    end

    add_index :documents, :checksum
    add_index :documents, :is_public
    add_index :documents, :created_at
  end

  def self.down
    drop_table :documents
  end
end
