# Idea Variants

Dùng `/variants` để test nhiều approach cho cùng ý tưởng trước khi commit vào 1 hướng.

## Cách dùng

```
> /variants
```

Claude sẽ đọc `context/input.md`, đề xuất 2-3 approaches khác nhau, so sánh ưu/nhược, bạn chọn 1 rồi chạy `/analyze` tiếp.

## Cấu trúc

```
variants/
├── README.md              # File này
├── current.md             # Variant đang được chọn
├── variant-a/
│   ├── approach.md        # Mô tả approach + user flow
│   ├── pros-cons.md       # Ưu/nhược điểm + rủi ro
│   ├── techstack.md       # Stack nếu khác default
│   ├── effort.md          # Estimate S/M/L + timeline
│   └── prototype/         # Code prototype nhỏ (optional)
├── variant-b/
│   └── ...
└── comparison.md          # Bảng so sánh tất cả variants
```

## Scope Variants

Ngoài approach khác nhau, còn có thể test scope khác nhau:

- `mvp-lean/` — Ít feature nhất, ship nhanh nhất (3-5 features core)
- `mvp-standard/` — Balanced (7-10 features)
- `mvp-full/` — Đầy đủ (15+ features)
