class RenameMethodToHttpmethod < ActiveRecord::Migration

  def self.up
    change_table :callbacks do |table|
      table.rename :method, :http_method
    end
  end
  
  def self.down
    change_table :callbacks do |table|
      table.rename :http_method, :method
    end
  end
  
end