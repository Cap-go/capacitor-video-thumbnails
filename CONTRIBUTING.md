# Contributing to @capgo/capacitor-video-thumbnails

Thank you for your interest in contributing!

## Development Setup

1. Clone the repository
2. Install dependencies: `bun install`
3. Build the plugin: `bun run build`

## Running the Example App

1. Navigate to example-app: `cd example-app`
2. Install dependencies: `bun install`
3. Build: `bun run build`
4. Add platforms: `npx cap add ios` or `npx cap add android`
5. Open in IDE: `npx cap open ios` or `npx cap open android`

## Code Style

- TypeScript: Uses ESLint with `@ionic/eslint-config`
- Swift: Uses SwiftLint with `@ionic/swiftlint-config`
- Java: Uses Prettier with `prettier-plugin-java`

Run linting: `bun run lint`
Fix formatting: `bun run fmt`

## Testing

- Verify iOS: `bun run verify:ios`
- Verify Android: `bun run verify:android`
- Verify Web: `bun run verify:web`

## Pull Requests

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

## License

By contributing, you agree that your contributions will be licensed under the MPL-2.0 License.
