class Schedule < ActiveRecord::Base
  belongs_to :user

  before_save :ensure_user_id

  validates :date, presence: true, allow_blank: false

  # Sets the +user_id+ to that which has not been the support
  # hero enough.

  def set_user_id
    User.stats.limit(2).each do |user|
      self.user_id = user['id']

      # prevents us from setting back to the same user
      if self.changes['user_id'][0] != self.changes['user_id'][0]
        break
      end
    end
  end

  private

  def ensure_user_id
    set_user_id if self.user_id.blank?
  end
end
