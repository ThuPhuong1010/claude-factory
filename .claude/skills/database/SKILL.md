---
name: database
description: "Database design patterns. Trigger khi tạo schema, models."
---

# Database Design

## Naming: snake_case
Tables: plural (users). Columns: snake_case (first_name).
FK: {singular}_id. Boolean: is_active.

## Must-have columns
Every table: id (UUID), created_at, updated_at
Deletable: deleted_at (soft delete)

## Indexes
Every FK. Frequent WHERE columns. Unique constraints.
