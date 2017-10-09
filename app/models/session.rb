class Session < ApplicationRecord
  def self.sweep(time = 1.second)
    Session.where("created_at < '#{time.ago.to_s(:db)}'").delete_all
    Rails.logger.warn("Old sessions purged")
  end


end
