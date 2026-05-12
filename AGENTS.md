# Codex Agent Rules - GastroCrew Flutter

These rules apply to the whole repository. Follow them before making code changes.

## Project Shape

- This is a Flutter multi-platform app for Android, iOS, Windows, Web, and macOS.
- Implement shared behavior in Dart under `lib/` first.
- Modify `android/`, `ios/`, `windows/`, `web/`, or `macos/` only when Dart or an existing plugin cannot solve the problem.
- Keep platform code minimal and free of business logic.

## Architecture

- Follow the existing clean-ish feature structure:
  - `data/` for Dio remotes, DTO parsing, external API access.
  - `domain/` for models, repository interfaces, errors.
  - `providers/` for state and orchestration.
  - `screens/` and `widgets/` for presentation.
- Do not put business logic in widgets.
- Prefer one meaningful class per file, except tiny private UI helpers.
- Use existing repository/provider patterns before introducing new abstractions.
- Do not add a new state-management library. This repo uses `provider`; keep using it.

## Imports

- Use package imports for project files:
  - `import 'package:gastrobotmanager/...';`
- Avoid relative imports like `../` or `../../`.
- Keep imports grouped and remove unused imports.

## Flutter UI Components

- Keep screens as orchestration layers; move reusable or bulky sections into widgets.
- Extract UI when a widget exceeds roughly 150-200 lines, nesting becomes hard to read, or a section repeats.
- Prefer private widgets in the same file first, then promote to `widgets/` when reused.
- Keep each widget focused on one responsibility.
- Avoid heavy work inside `build()`.
- Use builders for lists and large collections.
- Prefer `const` constructors where possible.

## State And Data Flow

- Keep async loading and mutation logic in providers or domain/data classes.
- Avoid complex logic in `setState`.
- Providers should expose immutable/unmodifiable views for lists.
- Preserve existing behavior for other roles/features when adding role-specific logic.
- When adding API calls, use existing authenticated `Dio` injection patterns from `main.dart`.

## Networking And Errors

- Use `dio` for HTTP.
- Keep endpoint path selection in remotes or a small explicit domain enum/value, not in widgets.
- Parse API responses defensively.
- Do not swallow errors silently.
- Prefer structured exception classes with useful messages; include status codes when behavior depends on `401`, `403`, etc.
- Log only where existing logging patterns support it.

## Approved Dependencies

- Prefer existing dependencies: `provider`, `dio`, `go_router`, `shared_preferences`, `cached_network_image`, `flutter_svg`, `package_info_plus`, `mocktail`.
- Do not add obscure or large dependencies without a clear need.
- Do not introduce Riverpod, BLoC, GetX, or another state-management stack into this repo.

## Testing

- Add unit tests for business logic, providers, remotes, parsing, and error/status handling.
- Add widget tests for complex UI states and interactions.
- Use `flutter_test` and `mocktail`.
- Update existing tests when public method signatures change.
- If full `flutter analyze` or broad `flutter test` is too slow locally, prefer targeted checks:
  - `flutter test --no-pub test/path/to_test.dart`
  - `rg` for stale references
  - `git diff --check`
- Do not run long checks repeatedly if they are known to hang; use targeted validation and report any skipped checks.

## Code Generation

- Do not edit generated files manually.
- If model generation is introduced later, use the project-standard generator command and commit generated output only if the repo already tracks it.
- Current models in this repo are mostly handwritten; match that unless the surrounding feature already uses codegen.

## Localization

- Use `AppLocalizations` for user-facing strings.
- Add strings to ARB files when introducing new UI text.
- Do not hardcode visible production UI text in widgets unless the surrounding code already does so for the same case.

## Performance

- Avoid unnecessary rebuilds by using `context.read` for callbacks and `context.watch` only where the widget must rebuild.
- Keep provider state scoped when shared global state would cause unrelated tabs/screens to overwrite each other.
- Avoid CPU-heavy work on the UI thread; use isolates only for genuinely heavy processing.

## Git And Editing

- Never revert user changes unless explicitly asked.
- Keep edits scoped to the requested behavior.
- Avoid unrelated refactors and metadata churn.
- Use `apply_patch` for manual edits.
- Do not run destructive commands without explicit approval.

## Cursor Rule And Skill Mapping

- `.cursor/rules/project-rules.mdc` is the source rule set this file adapts for Codex.
- Apply `.cursor/skills/flutter-architecture/SKILL.md` guidance when designing or modifying feature structure.
- Apply `.cursor/skills/flutter-ui-components/SKILL.md` guidance when building or refactoring screens/widgets.
- Apply `.cursor/skills/flutter-testing/SKILL.md` guidance when adding or updating tests.
