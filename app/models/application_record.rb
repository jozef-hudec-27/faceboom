class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def time_since(args = {})
    short = args[:short]
    approx = args[:approx]
    separator = approx ? '' : ' '

    sec = short ? 's' : 'seconds'
    min = short ? 'm' : 'minute'
    hou = short ? 'h' : 'hour'
    day = short ? 'd' : 'day'

    seconds_since = (Time.now - created_at).to_i

    if seconds_since < 60
      return  "#{seconds_since}#{separator}#{sec}"
    end

    minutes = seconds_since / 60

    if minutes < 60 && approx
      return "#{minutes}#{min}"
    end

    hours = minutes / 60

    return "#{hours}#{hou}" if hours < 24 && approx

    if hours >= 24
      days = hours / 24
      return "#{days}#{day}" if approx

      return "#{days}#{separator}#{day}" + (days > 1 && !approx ? 's' : '')
    end

    minutes %= 60
    result = ''
    result += ("#{hours} #{hou}" + (hours > 1 ? 's' : '')) if hours.positive?
    result += (" #{minutes} #{min}" + (minutes > 1 ? 's' : '')) if minutes.positive?
  end
end
