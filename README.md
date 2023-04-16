# TODO or Die Hard

![TODO or Die Hard!](assets/todo_or_diehard.png)

`TodoOrDiehard` provides macros for Crystal that implement compile-time and runtime checked reminders.

> Inspired by [todo_or_die](https://github.com/searls/todo_or_die) for Ruby.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     todo_or_diehard:
       github: nogginly/todo_or_diehard
   ```

2. Run `shards install`

## Usage

```crystal
require "todo_or_diehard"

# Warning only, does not raise an exception or compile-time error
TodoOrDie["Whaaa Whaaa Whaaa!", warn_by: {2020, 1, 20}]

# Raises an OverdueTodo error
TodoOrDie["Blammo!", by: [2020, 2, 28]]
```

### Warning only

```crystal
TodoOrDie["Whaaa Whaaa Whaaa!", warn_by: {2020, 1, 20}]
# or
TodoOrDie[warning: "Whaaa Whaaa Whaaa!", y: 2020, m: 1, d: 20]
```

* If overdue
  * logs a warning
  * does not raise a compile time error or a run-time error
* Otherwise
  * logs an `Info` at compile-time


### Die hard (if overdue)

```crystal
TodoOrDie["Blammo!", by: [2020, 2, 28]]
# or
TodoOrDie["Blammo!", y: 2020, m: 2, d: 28]
```

* If overdue
  * raises a compile time error when building
  * raises a run-time error when run after deadline
* Otherwise
  * logs an `Info` at compile-time

## Q&A

**Why can't I use `Time` to set the deadline?**

The standard library is not available at compile-time, and for this to work with macros we can't use `Time`. As a side benefit, this made the API simpler by asking for year, month, date arguments.

## Contributing

Bug reports and sugestions are welcome. Otherwise, at this time, this project is closed for code changes and pull requests. I appreciate your understanding.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://www.contributor-covenant.org/version/1/4/code-of-conduct/).

## Contributors

* [nogginly](https://github.com/nogginly) - creator and maintainer
