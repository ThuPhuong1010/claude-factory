---
name: testing
description: "Testing strategy. Trigger khi viết test hoặc debug test failure."
---

# Testing — Test BEHAVIOR, not IMPLEMENTATION.

## Stack: Vitest + React Testing Library

## Must test per feature
Happy path, error state, empty state, loading state

## Component test: render → userEvent → expect
## Service test: mock API → call → expect result
## Run: npm test -- --related {file} (per task, not full suite)
