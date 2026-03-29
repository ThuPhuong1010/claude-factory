---
name: database
description: "Database design patterns. Trigger khi tạo schema, models, chọn DB type, thiết kế quan hệ."
---

# Database Design

## Khi nào cần đọc skill này
- Thiết kế schema cho feature mới
- Chọn loại database phù hợp
- Tạo relations, indexes
- Cần migration strategy

---

## Phân tích — Chọn DB Type

| Tình huống | DB | Lý do |
|-----------|-----|-------|
| Structured data, complex relations | PostgreSQL | ACID, joins, full SQL |
| Simple key-value, session, cache | Redis | In-memory, cực nhanh |
| Flexible schema, prototype | MongoDB | Schemaless, json native |
| Search, full-text | Elasticsearch | Inverted index, scoring |
| File metadata + CDN | PostgreSQL + S3 | Tách binary khỏi DB |
| Time-series metrics | TimescaleDB / InfluxDB | Optimized cho append |

**Default choice:** PostgreSQL cho mọi web app — versatile, battle-tested.

**Tự hỏi trước khi thiết kế:**
```
Dữ liệu có cấu trúc cố định không?       → Structured: SQL, Flexible: NoSQL
Cần join phức tạp không?                 → Nhiều join: SQL
Read/write ratio là bao nhiêu?           → Read-heavy: thêm read replica
Data có expire không?                    → Có TTL: Redis/cache layer
Scale dự kiến? (10K vs 10M records)     → Ảnh hưởng index strategy
```

---

## Design — Schema Structure

**Chuẩn naming:**
- Tables: `snake_case`, plural (`users`, `order_items`)
- Columns: `snake_case` (`first_name`, `created_at`)
- FK: `{singular_table}_id` (`user_id`, `order_id`)
- Boolean: `is_` prefix (`is_active`, `is_deleted`)
- Enum columns: `status`, `type`, `role`

**Mandatory columns mọi table:**
```sql
id          UUID DEFAULT gen_random_uuid() PRIMARY KEY
created_at  TIMESTAMPTZ DEFAULT NOW() NOT NULL
updated_at  TIMESTAMPTZ DEFAULT NOW() NOT NULL
-- Nếu cần soft delete:
deleted_at  TIMESTAMPTZ NULL
```

**Relation design:**
```
1-to-many:    FK trên bảng "many" (posts.user_id → users.id)
many-to-many: Junction table (user_roles: user_id + role_id)
1-to-1:       FK + UNIQUE constraint, hoặc embed JSON column
```

---

## Design — Index Strategy

```
Luôn index:
  - Mọi FK column (user_id, order_id)
  - Columns thường xuất hiện trong WHERE (email, status, slug)
  - UNIQUE constraints (email, username)

Thêm khi cần:
  - Composite index nếu query thường dùng 2+ columns cùng lúc
  - Partial index: WHERE is_deleted = false (bỏ qua soft-deleted rows)
  - Full-text index: tsvector nếu cần search

Không cần:
  - Index trên boolean có cardinality thấp (is_active trên bảng 99% active)
  - Index trên columns ít khi filter
```

---

## Implementation Rules

- Dùng ORM (Prisma / Drizzle) — không raw SQL trừ khi ORM không hỗ trợ được.
- Mọi schema change = migration file riêng. Không edit migration cũ.
- Không xóa column thật — dùng soft delete (`deleted_at`) trước.
- Không store secret/password raw. Chỉ store hash (bcrypt).
- Không store file binary trong DB. Dùng S3/CDN + lưu URL.

---

## Common Mistakes

| Sai | Đúng |
|-----|------|
| Table tên singular (user) | Plural (users) |
| Không có `updated_at` | Luôn có `created_at` + `updated_at` |
| Index tất cả columns | Index có chọn lọc theo query pattern |
| Hard delete mọi thứ | Soft delete cho dữ liệu có giá trị audit |
| Store file trong DB | Lưu URL, file lên S3/CDN |
| Edit migration cũ | Tạo migration mới để thay đổi |
