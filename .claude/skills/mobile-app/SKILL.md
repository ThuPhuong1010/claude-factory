---
name: mobile-app
description: "Mobile app iOS/Android với React Native + Expo. Trigger khi solution cần chạy trên điện thoại."
---

# Mobile App — React Native + Expo

## Stack
- **Expo** (managed workflow) — fastest setup, no native code
- **React Native** — cross-platform iOS + Android
- **TypeScript** — required
- **NativeWind** — Tailwind cho React Native (hoặc StyleSheet)
- **Zustand** — state management
- **TanStack Query** — server state

## Quick Start
```bash
npx create-expo-app@latest MyApp --template blank-typescript
cd MyApp
npx expo start
```

## Project Structure
```
app/
├── (tabs)/          # Tab navigation
├── _layout.tsx      # Root layout
└── +not-found.tsx
components/
hooks/
lib/
stores/
```

## Navigation (Expo Router)
```tsx
// app/(tabs)/_layout.tsx
import { Tabs } from 'expo-router';

export default function TabLayout() {
  return (
    <Tabs>
      <Tabs.Screen name="index" options={{ title: 'Home' }} />
      <Tabs.Screen name="profile" options={{ title: 'Profile' }} />
    </Tabs>
  );
}

// Navigate
import { router } from 'expo-router';
router.push('/profile');
router.push({ pathname: '/detail/[id]', params: { id: '123' } });
```

## Common Components
```tsx
import { View, Text, ScrollView, FlatList, Pressable, TextInput } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

// List với performance tốt
<FlatList
  data={items}
  keyExtractor={(item) => item.id}
  renderItem={({ item }) => <ItemCard item={item} />}
  ListEmptyComponent={<Text>Không có dữ liệu</Text>}
/>
```

## Storage
```bash
npx expo install @react-native-async-storage/async-storage
npx expo install expo-secure-store  # cho sensitive data
```

## Common Permissions
```bash
npx expo install expo-camera expo-location expo-notifications
```

## Build & Deploy
```bash
npx eas build --platform android --profile preview  # APK test
npx eas build --platform all                         # Store build
npx eas submit                                        # Submit to stores
```

## Testing
- Unit: Jest + @testing-library/react-native
- E2E: Maestro (simpler) hoặc Detox
- Manual: Expo Go app trên điện thoại

## Khi nào dùng React Native vs Web App?
- React Native: cần camera, GPS, push notification, offline-first, native UX
- Web App: content-heavy, SEO needed, không cần native features
