class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :string do |t|
      t.decimal :total_price, null: false
      t.string :shipping_address, null: false
      t.string :status, null: false
      t.string :stripe_payment_intent
      t.string :stripe_charge_id
      t.string :stripe_refund_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
