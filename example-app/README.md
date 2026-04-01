# Example App for `@capgo/capacitor-video-thumbnails`

This Vite project links directly to the local plugin source so you can generate thumbnails from sample or custom video URLs while developing on web, iOS, and Android.

## Getting started

```bash
bun install
bun run start
```

To test on native shells:

```bash
bunx cap add ios
bunx cap add android
bunx cap sync
```

Use the example UI to generate thumbnails at different timestamps, inspect the returned URI and dimensions, and verify remote video sources behave consistently across platforms.
