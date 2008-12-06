class AddErrorMessageToCallback < ActiveRecord::Migration

  def self.up
    change_table :callbacks do |table|
      table.text :error_message
    end
  end
  
  def self.down
    change_table :callbacks do |table|
      table.remove :error_message
    end
  end
  
end