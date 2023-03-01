require "log"

# The alias
alias TodoOrDie = TodoOrDiehard

# The module
module TodoOrDiehard
  # The version
  VERSION = "0.3.0"

  {% if compile_date = system("date +%Y%m%d") %}
    # The date when compiled, as a number in the form `yyyymmdd`
    COMPILE_DATE = {{ compile_date }}
  {% end %}

  # The error
  class OverdueTodo < RuntimeError
  end

  # The checked reminder that a raises an error on or after *by* date specified as a
  # tuple (e.g. `{2019, 10, 30}`) or array (e.g. `[2019, 10, 30]`)
  macro [](message, *, by)
    {% if (by.is_a? TupleLiteral || by.is_a? ArrayLiteral) && by.size == 3 %}
      {% y = by[0] %}
      {% m = by[1] %}
      {% d = by[2] %}
      TodoOrDiehard[{{message}}, y: {{ y }}, m: {{m}}, d: {{d}}]
    {% else %}
      {% raise "Invalid deadline #{by}, must be array or tuple with three integers" %}
    {% end %}
  end

  # The checked reminder that will log a warning on or after *warn_by* date specified as a
  # tuple (e.g. `{2019, 10, 30}`) or array (e.g. `[2019, 10, 30]`)
  macro [](message, *, warn_by)
    {% if (warn_by.is_a? TupleLiteral || warn_by.is_a? ArrayLiteral) && warn_by.size == 3 %}
      {% y = warn_by[0] %}
      {% m = warn_by[1] %}
      {% d = warn_by[2] %}
      TodoOrDiehard[warning: {{message}}, y: {{ y }}, m: {{m}}, d: {{d}}]
    {% else %}
      {% raise "Invalid deadline #{warn_by}, must be array or tuple with three integers" %}
    {% end %}
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
