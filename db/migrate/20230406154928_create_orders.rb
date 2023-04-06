class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :order_date_time
      t.decimal :full_price
      t.string :shipping_address
      t.string :status
      t.string :stripe_charge_id
      t.string :stripe_refund_id
      t.string :stripe_application_id

      t.timestamps
    end
  end
end
