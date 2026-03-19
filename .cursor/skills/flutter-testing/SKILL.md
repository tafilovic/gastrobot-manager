---
name: flutter-testing
description: Guides unit and widget testing for Flutter. Use when writing tests, adding test coverage, or when the user asks about testing, mocks, or test structure.
---

# Flutter Testing

Extends project rules: Testing. Use when writing or reviewing tests.

## Requirements

- All business logic must have unit tests.
- Test use cases, repositories, and state logic.
- Add widget tests for complex UI states.
- No feature is complete without tests.

## Stack

- `flutter_test`
- `mocktail` or `mockito` for mocks

## What to Test

| Layer      | Test Type   | Focus                          |
|-----------|-------------|---------------------------------|
| Use cases | Unit        | Logic, edge cases               |
| Repos     | Unit        | Data mapping, error handling    |
| Providers | Unit        | State transitions                |
| Widgets   | Widget test | Complex UI, user interactions   |
