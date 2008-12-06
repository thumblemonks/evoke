class CreateCallbacks < ActiveRecord::Migration

  def self.up
    create_table :callbacks do |t|
      t.text :url, :null => false
      t.datetime :callback_at, :null => false
      t.text :data
      t.boolean :called_back
      t.timestamps
    end
  end
  
  def self.down
    drop_table :callbacks
  end
  
end