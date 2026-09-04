# AI tools

Small, practical tools for working with AI coding agents.

## Skills

### `prune-tests`

Audits a test suite for tests that protect implementation details, incidental copy, or presentation instead of behavior. It gives every suspect test a `DELETE`, `REWRITE`, or `KEEP` disposition and requires evidence for anything it preserves.

The skill works with agents that support the open `SKILL.md` format.

To install it manually, copy [`skills/prune-tests`](skills/prune-tests) into your agent's skills directory.

## License

[MIT](LICENSE)
