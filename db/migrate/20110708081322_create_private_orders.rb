class CreatePrivateOrders < ActiveRecord::Migration
  def self.up
    create_table :private_orders do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :private_orders
  end
end
