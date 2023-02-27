# TODO or Die Hard

WIP

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

# Warns you
TodoOrDie["Whaaa Whaaa Whaaa!", warn_by: Time.local(2020, 1, 20)]

# Raises an OverdueTodo error
TodoOrDie["Blammo!", by: Time.local(2020, 1, 20)]
```

## Contributing

Bug reports and sugestions are welcome. Otherwise, at this time, this project is closed for code changes and pull requests. I appreciate your understanding.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## Contributors

- [nogginly](https://github.com/nogginly) - creator and maintainer
