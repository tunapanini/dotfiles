# Global Claude Code Guidelines

## Development Server Management

- **Always run development servers in background**: Use `is_background: true` for `npm run dev`, `pnpm dev`, or `yarn dev` commands
- **Don't wait for server startup**: Continue with other tasks while server is starting
- **Port conflict resolution**: When starting a server and encountering port conflicts with 2 or more existing servers, kill port 3000 and try run server with that port again.

## Package Manager Selection

- **Check package.json first**: Always refer to the project's `package.json` file to determine which package manager to use
- **Priority order**:
  1. Check for `packageManager` field in package.json
  2. Look for lock files (pnpm-lock.yaml, yarn.lock, package-lock.json)
  3. Default to npm if no clear indication

## Documentation Standards

- **Technical decisions documentation**: When making technical choices or feature changes, create documentation in `docs/` directory
- **Document categorization**: Organize documents by category for better maintainability

### Documentation Categories

- **`docs/architecture/`**: System architecture decisions, design patterns, and structural changes
- **`docs/features/`**: New feature implementations, user-facing changes, and functionality additions
- **`docs/technical/`**: Technical decisions, library choices, performance optimizations, and refactoring
- **`docs/migrations/`**: Database migrations, dependency updates, and breaking changes
- **`docs/api/`**: API changes, endpoint modifications, and integration updates
- **`docs/security/`**: Security-related changes, vulnerability fixes, and authentication updates

### Documentation Template

```markdown
# [Title of Change]

## Overview

Brief description of the change and its purpose.

## Context

Why this change was necessary and what problem it solves.

## Technical Details

- Specific implementation details
- Code changes and patterns used
- Configuration updates

## Impact

- What this change affects
- Breaking changes (if any)
- Migration steps (if needed)

## Alternatives Considered

Other approaches that were evaluated and why they weren't chosen.

## Related Issues

Links to related issues, PRs, or discussions.

## Date

When this decision was made and documented.
```

## Best Practices

- **Use appropriate package manager**: Stick to the project's chosen package manager consistently
- **Background execution**: Run long-running processes in background to maintain workflow efficiency
- **Context awareness**: Adapt to each project's specific setup and requirements
- **Documentation first**: Create documentation before or alongside code changes
- **Categorize properly**: Use appropriate category folders for better organization

Always plan & respond in Korean.

- Always respond in Korean.
