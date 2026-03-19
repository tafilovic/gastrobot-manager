---
name: flutter-ui-components
description: Guides Flutter UI design toward small, focused, reusable components. Use when building screens, creating widgets, refactoring UI, or when the user mentions fat widgets, large components, or component decomposition.
---

# Flutter UI Component Design

Extends project rules: Architecture. Provides detailed UI component guidance.

## Core Principle

Prefer small, focused UI components. Do not create fat/big widgets; split into smaller, reusable components when possible.

## When to Extract

Extract a widget when:
- A widget exceeds ~150–200 lines
- A logical section repeats or could be reused
- Nesting depth exceeds 3–4 levels
- A `build()` method has multiple distinct visual blocks

## How to Split

1. **Identify logical units** – Header, list item, card, form section, etc.
2. **Extract to private widget** – `_SectionHeader`, `_ListItemCard` in same file first
3. **Promote to shared** – Move to `widgets/` when reused across screens
4. **Keep single responsibility** – Each widget does one thing

## Structure

```
feature/
├── screens/
│   └── example_screen.dart    # Orchestrates layout, delegates to widgets
└── widgets/
    ├── example_header.dart
    ├── example_list_item.dart
    └── example_card.dart
```

## Anti-Patterns

- **Fat screen** – 300+ lines with inline build logic
- **Deep nesting** – `Column` > `Row` > `Container` > `Padding` > `Column` > …
- **Inline complex UI** – Multi-section forms or lists built entirely in one widget

## Quick Checklist

- [ ] Each widget under ~200 lines
- [ ] No more than 3–4 nesting levels
- [ ] Reusable pieces extracted to `widgets/`
- [ ] One clear responsibility per widget
