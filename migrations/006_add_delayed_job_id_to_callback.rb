class AddDelayedJobIdToCallback < ActiveRecord::Migration

  def self.up
    change_table :callbacks do |table|
      table.references :delayed_job
    end
  end
  
  def self.down
    change_table :callbacks do |table|
      table.remove :delayed_job_id
    end
  end
  
end