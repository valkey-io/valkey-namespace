# Contributing to valkey-namespace

Thank you for your interest in contributing to valkey-namespace!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR-USERNAME/valkey-namespace.git`
3. Install dependencies: `bundle install`
4. Make sure tests pass: `bundle exec rake spec`

## Development

### Running Tests

```bash
bundle exec rake spec
```

### Adding New Commands

If you need to add support for a new Valkey command:

1. Add the command to the appropriate command table in `lib/valkey/namespace.rb`:
   - `NAMESPACED_COMMANDS` - for commands that operate on keys
   - `TRANSACTION_COMMANDS` - for transaction-related commands
   - `HELPER_COMMANDS` - for utility commands
   - `ADMINISTRATIVE_COMMANDS` - for admin commands (discouraged)

2. Specify how arguments should be namespaced:
   - `:first` - namespace the first argument
   - `:all` - namespace all arguments
   - `:exclude_first` - namespace all but first
   - `:exclude_last` - namespace all but last
   - `:alternate` - namespace every other argument (for key-value pairs)
   - `:scan_style` - for SCAN-like commands
   - `:eval_style` - for EVAL/EVALSHA commands

3. Specify how return values should be processed:
   - `nil` - no processing
   - `:all` - remove namespace from all returned keys
   - `:first` - remove namespace from first element
   - `:second` - remove namespace from second element

4. Add tests in `spec/valkey_spec.rb`

### Code Style

- Follow Ruby community style guidelines
- Keep methods focused and single-purpose
- Add comments for complex logic
- Maintain compatibility with Ruby 2.7+

## Submitting Changes

1. Create a feature branch: `git checkout -b my-feature`
2. Make your changes
3. Add tests for your changes
4. Ensure all tests pass
5. Commit with a clear message: `git commit -m "Add support for COMMAND"`
6. Push to your fork: `git push origin my-feature`
7. Open a Pull Request

## Reporting Issues

When reporting issues, please include:

- Ruby version
- valkey-namespace version
- valkey-glide-ruby version
- Minimal reproduction code
- Expected vs actual behavior

## Questions?

Feel free to open an issue for questions or discussions.
