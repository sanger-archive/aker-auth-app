class Session < ApplicationRecord
  def self.sweep(time = 5.days)
    Session.where("created_at < ?", time.ago.to_s(:db)).delete_all
    Rails.logger.info("Old sessions purged")
  end
end
