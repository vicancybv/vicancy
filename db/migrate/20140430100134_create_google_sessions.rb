class CreateGoogleSessions < ActiveRecord::Migration
  def change
    create_table :google_sessions do |t|
      t.string :access_token
      t.datetime :expires_at
      t.string :refresh_token

      t.timestamps
    end
  end
end
