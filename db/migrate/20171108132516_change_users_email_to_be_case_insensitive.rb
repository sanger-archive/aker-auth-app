class ChangeUsersEmailToBeCaseInsensitive < ActiveRecord::Migration[5.1]
  def up
    enable_extension 'citext'
    change_column :users, :email, :citext

    # Remove the default value
    change_column_default(:users, :email, nil)
    User.all do |u|
      if u.sanitise_email
        u.save!
      end
    end
  end

  def down
    change_column :users, :email, :string
    change_column_default(:users, :email, '')
  end
end
