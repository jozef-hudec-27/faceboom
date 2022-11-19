class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  scope :latest, -> { where('created_at > ?', Time.now - 7.days) }

  default_scope { order('created_at desc') }

  def time_since
    seconds_since = (Time.now - created_at).to_i

    if seconds_since < 60
      return "#{seconds_since} seconds"
    end

    minutes = seconds_since / 60
    hours = minutes / 60

    if hours >= 24
      days = hours / 24
      return "#{days} day" + (days > 1 ? 's' : '')
    end

    minutes %= 60
    result = ''
    result += ("#{hours} hour" + (hours > 1 ? 's' : '')) if hours.positive?
    result += (" #{minutes} minute" + (minutes > 1 ? 's' : '')) if minutes.positive?
  end
end
