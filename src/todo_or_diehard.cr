require "log"

# The alias
alias TodoOrDie = TodoOrDiehard

# The module
module TodoOrDiehard
  # The version
  VERSION = "0.2.0"

  {% if compile_date = system("date +%Y%m%d") %}
    # The date when compiled, as a number in the form `yyyymmdd`
    COMPILE_DATE = {{ compile_date }}
  {% end %}

  # The error
  class OverdueTodo < RuntimeError
  end

  # The check that raises an error when overdue
  # (i.e. current date is >= *y*/*m*/*d*).
  macro [](message, *, y, m, d)
    # Check and report at compile time
    {% deadline_date = y * 10000 + m * 100 + d %}
    {% if COMPILE_DATE >= deadline_date %}
      # Raise compile error
      {% pp "\nIn #{__FILE__}:#{__LINE__}".id %}
      {% raise "TODO is overdue: #{message.id}".id %}
    {% else %}
      # Print info at compile time
      {% pp "\nIn #{__FILE__}:#{__LINE__}".id %}
      {% pp "    Info: TODO due #{deadline_date}: #{message.id}".id %}
    {% end %}
    TodoOrDiehard.yippee_ki_yay({{message}}, by: Time.local({{y}}, {{m}}, {{d}}), warn: false)
  end

  # The check that warns when overdue
  # (i.e. current date is >= *y*/*m*/*d*).
  macro [](*, warning, y, m, d)
    {% deadline_date = y * 10000 + m * 100 + d %}
    {% if COMPILE_DATE >= deadline_date %}
      {% pp "\nIn #{__FILE__}:#{__LINE__}".id %}
      {% pp "    Warning: TODO due #{deadline_date}: Overdue: #{warning.id}".id %}
    {% else %}
      # Print info at compile time
      {% pp "\nIn #{__FILE__}:#{__LINE__}".id %}
      {% pp "    Info: TODO due #{deadline_date}: #{message.id}".id %}
    {% end %}
    TodoOrDiehard.yippee_ki_yay({{warning}}, by: Time.local({{y}}, {{m}}, {{d}}), warn: true)
  end

  # :nodoc:
  def self.yippee_ki_yay(message, *, by : Time, warn = false)
    now = Time.local
    deadline = by
    if now >= deadline
      log_message = "TODO due #{by.to_s("%F")}: Overdue: #{message}"
      case warn
      when false
        Log.error { log_message } # in case error is captured
        raise TodoOrDie::OverdueTodo.new(message)
      else
        Log.warn { log_message } # if warn
      end
    end
  end
end
