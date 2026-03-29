# Preset: Mobile App

Load khi solution type = Mobile App (React Native, Expo).

## Stack gợi ý

| Use case | Stack |
|---------|-------|
| Cross-platform nhanh | Expo (managed workflow) |
| Native modules cần thiết | React Native CLI hoặc Expo (bare workflow) |
| Simple prototype | Expo Snack |

## Structure

```
src/
├── app/             # Screens (Expo Router file-based routing)
│   ├── (tabs)/      # Tab navigator
│   ├── _layout.tsx  # Root layout
│   └── index.tsx    # Home screen
├── components/      # Reusable UI components
├── hooks/           # Custom hooks
├── services/        # API calls, storage
├── stores/          # State (Zustand)
└── types/           # TypeScript types
```

## Rules

**Layout:**
- Luôn wrap root trong `<SafeAreaProvider>` + `<SafeAreaView>`
- Dùng `KeyboardAvoidingView` cho form screens
- Không hardcode pixel dimensions — dùng `Dimensions` API hoặc `%`

**Platform differences:**
```typescript
import { Platform } from 'react-native'
const styles = StyleSheet.create({
  shadow: Platform.select({
    ios: { shadowColor: '#000', shadowOffset: { width: 0, height: 2 } },
    android: { elevation: 4 },
  })
})
```

**Navigation (Expo Router):**
- File-based routing — tên file = route path
- `router.push()`, `router.replace()`, `router.back()`
- Deep linking tự động từ file structure

**State:**
- Zustand cho global state
- TanStack Query cho server state (API calls)
- AsyncStorage cho persistent local data

**Performance:**
- `FlatList` thay `ScrollView` cho danh sách dài
- `React.memo` + `useCallback` cho list items
- Lazy load heavy screens

## Testing

- Unit test: Jest + React Native Testing Library
- E2E: Detox (native) hoặc Maestro (YAML-based, dễ hơn)
- Manual checklist: test trên cả iOS simulator + Android emulator

## Build & Distribution

```bash
# Development
npx expo start

# Build (Expo EAS)
eas build --platform ios
eas build --platform android

# Submit to store
eas submit --platform ios
eas submit --platform android
```
