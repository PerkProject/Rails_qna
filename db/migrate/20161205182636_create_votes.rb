class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user
      t.references :votable, polymorphic: true, index: true
      t.timestamps
    end
    add_index :votes, [:votable_id, :votable_type, :user_id], unique: true
  end
end
