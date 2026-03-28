---
name: search
description: "Full-text & vector search. Trigger khi cần tìm kiếm nội dung, search-as-you-type, RAG vector search."
---

# Search

## Lựa chọn
| Option | Dùng khi | Hosting |
|--------|---------|---------|
| PostgreSQL `tsvector` | Simple FTS, đã có Postgres | Self |
| Typesense | Typo-tolerant, search UX tốt | Self / Cloud |
| Algolia | Production SaaS, zero-ops | Cloud (cost) |
| pgvector | Vector/semantic search, RAG | Self (Postgres) |

## PostgreSQL Full-text (zero dependency)
```ts
// Prisma raw query
const results = await prisma.$queryRaw`
  SELECT id, title, ts_rank(search_vector, query) AS rank
  FROM posts, plainto_tsquery('vietnamese', ${term}) query
  WHERE search_vector @@ query
  ORDER BY rank DESC
  LIMIT 20
`

// Migration: thêm search vector column
ALTER TABLE posts ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (to_tsvector('simple', coalesce(title,'') || ' ' || coalesce(content,''))) STORED;
CREATE INDEX posts_search_idx ON posts USING GIN(search_vector);
```

## Typesense (typo-tolerant, đề xuất cho production)
```bash
npm install typesense
```
```ts
// lib/typesense.ts
import Typesense from 'typesense'
export const typesense = new Typesense.Client({
  nodes: [{ host: process.env.TYPESENSE_HOST!, port: 443, protocol: 'https' }],
  apiKey: process.env.TYPESENSE_API_KEY!,
})

// Index document
await typesense.collections('posts').documents().upsert({ id, title, content, createdAt })

// Search
const results = await typesense.collections('posts').documents().search({
  q: query,
  query_by: 'title,content',
  per_page: 10,
})
```

## pgvector (semantic/AI search)
```bash
npm install @pinecone-database/doc-splitter  # hoặc dùng pgvector
```
```sql
-- Enable extension
CREATE EXTENSION IF NOT EXISTS vector;
ALTER TABLE documents ADD COLUMN embedding vector(1536);
CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops);

-- Query nearest neighbors
SELECT id, title, 1 - (embedding <=> $1) AS similarity
FROM documents
ORDER BY embedding <=> $1
LIMIT 10;
```

## Rules
- Debounce search input: 300ms trước khi trigger
- Highlight matched terms trong results (Typesense có built-in `highlight`)
- Paginate kết quả — không trả về all matches
