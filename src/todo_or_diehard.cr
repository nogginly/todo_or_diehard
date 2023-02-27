require "log"

# The alias
alias TodoOrDie = TodoOrDiehard

# The module
module TodoOrDiehard
  VERSION = "0.1.0"

  # The error
  class OverdueTodo < RuntimeError
  end

  # The check that dies
  macro [](message, *, by)
    TodoOrDiehard.todo_or_die({{message}}, by: {{by}}, warn: false)
  end

  # The check that warns
  macro [](message, *, warn_by)
    TodoOrDiehard.todo_or_die({{message}}, by: {{warn_by}}, warn: true)
  end

  # :nodoc:
  def self.todo_or_die(message, *, by : Time, warn = false)
    now = Time.utc
    deadline = by.to_utc
    if now >= deadline
      case warn
      when false then raise TodoOrDie::OverdueTodo.new(message)
      else
        Log.warn { "TodoOrDie: Overdue! #{message}" } # if warn
      end
    end
  end
end
