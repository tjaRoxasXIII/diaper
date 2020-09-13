class AddDistributionLimitAndNotesToParter < ActiveRecord::Migration[6.0]
  def change
    add_column :partners, :notes, :text
    add_column :partners, :distribution_limit, :integer, default: 0, null: false
  end
end
