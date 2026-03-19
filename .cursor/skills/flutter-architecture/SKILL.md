---
name: flutter-architecture
description: Implements clean architecture for Flutter apps. Use when designing features, creating new modules, or when the user asks about architecture, layers, or project structure.
---

# Flutter Clean Architecture

Extends project rules: Architecture. Use when designing or implementing features.

## Layers

- **presentation** – UI, widgets, screens. No business logic.
- **domain** – Use cases, entities, repository interfaces.
- **data** – Repositories, data sources, DTOs.

## Rules

- No business logic inside widgets.
- Keep UI, state, and data layers separated.
- One class per file (unless trivial).
- Keep widgets < 200 lines. See `flutter-ui-components` skill for decomposition.

## Structure

```
feature/
├── domain/
│   ├── models/
│   ├── repositories/   # interfaces
│   └── use_cases/
├── data/
│   ├── repositories/
│   └── data_sources/
└── presentation/
    ├── screens/
    ├── widgets/
    └── providers/
```
