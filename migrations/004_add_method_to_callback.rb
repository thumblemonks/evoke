class AddMethodToCallback < ActiveRecord::Migration

  def self.up
    change_table :callbacks do |table|
      table.string :method, :limit => 10
    end
  end
  
  def self.down
    change_table :callbacks do |table|
      table.remove :method
    end
  end
  
end