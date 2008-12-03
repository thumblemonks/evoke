class AddGuidToCallback < ActiveRecord::Migration

  def self.up
    change_table :callbacks do |table|
      table.string :guid
    end
  end
  
  def self.down
    change_table :callbacks do |table|
      table.remove :guid
    end
  end
  
end