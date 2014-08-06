require Rails.root.join('db', 'support', 'transform_users_into_resellers_migration')

class TransformUsersIntoResellers < ActiveRecord::Migration
  def change
    m = TransformUsersIntoResellersMigration.new
    m.test_names = ["Pieter", "Test Reseller", "Toby", "Vicancy"]
    m.reseller_names = ["AV diensten", "AgriMatch", "Automotive Vacaturebank", "BCFjobs", "BeQuan", "HRMatches", "IT-vacatures.nl", "Job Brokers", "Jobbird", "Madlle", "MrWork", "Njorku", "Reismedia", "Solliciterenmeteenfilmpje.nl", "Staffonly.nl", "Uitzendbureau.nl", "Vonq", "Wannaflex"]
    # others are direct vicancy's clients
    m.run
  end
end
