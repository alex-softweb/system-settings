module T
  extend self

  FILE_PATH = 'log/trace.log'

  def l(*args)
    log_time
    colorize { inspected_and_joined(args) }
  end

  def y(data)
    puts data.to_yaml
  end

  def d
    require 'debugger'; debugger
  end

  def x(data)
    abort data.inspect
  end

  def purge_emails
    Delayed::Job.destroy_all
  end

  def cv(url)
    uuid = url.slice(/\/((\w+-)+\w+)/, 1)
    Conversation.find_by_uuid(uuid)
  end

  def tb(pattern = nil)
    list = ActiveRecord::Base.connection.tables

    if pattern
      list.grep Regexp.new(pattern)
    else
      list
    end
  end

  def m(object)
    object.methods - Object.methods
  end

private

  def inspected_and_joined(array)
    logger.info(array.map(&:inspect).join(' - '))
  end

  def logger
    @logger ||= Logger.new(FILE_PATH)
  end

  def colorize
    random_color
    yield
    reset_color
  end

  def random_color
    logger.info "\033[0;32m"
  end

  def log_time
    logger.info "\033[0;30;46m#{ Time.now.strftime('%H:%M:%S') }"
  end

  def reset_color
    logger.info "\033[0m"
  end
end
