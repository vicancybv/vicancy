module Retryable
  def try_n_times(times, name=nil)
    try = 0
    begin
      return yield
    rescue => e
      try += 1
      if (try < times)
        Rollbar.report_message("#{name || 'Try'} failed: #{e.message} (#{e.class.to_s})", 'warning')
        sleep try unless Rails.env.test?
        retry
      else
        raise
      end
    end
  end
end