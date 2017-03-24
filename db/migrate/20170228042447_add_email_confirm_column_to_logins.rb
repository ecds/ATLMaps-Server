class AddEmailConfirmColumnToLogins < ActiveRecord::Migration[5.0]
  def change
    add_column :logins, :email_confirmed, :boolean, default: false
    add_column :logins, :confirm_token, :string
  end
end
