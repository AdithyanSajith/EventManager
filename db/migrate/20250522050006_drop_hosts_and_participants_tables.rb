class DropHostsAndParticipantsTables < ActiveRecord::Migration[7.2]
  def change
    # Remove foreign keys that depend on hosts
    remove_foreign_key :managed_events, :hosts if foreign_key_exists?(:managed_events, :hosts)
    remove_foreign_key :venues, :hosts if foreign_key_exists?(:venues, :hosts)

    # Now drop the hosts and participants tables
    drop_table :hosts, if_exists: true
    drop_table :participants, if_exists: true
  end
end
