# Changelog

All notable changes to this project will be documented in this file.

## [0.0.1] - Initial Release

### Added
- `getThumbnail()` method to generate thumbnails from video files
- Support for local file paths (file://) and remote URLs (http(s)://)
- Custom time position extraction in milliseconds
- Quality control for JPEG compression (0.0 - 1.0)
- HTTP headers support for authenticated video sources
- `getPluginVersion()` method to get native plugin version
- iOS implementation using AVAssetImageGenerator
- Android implementation using MediaMetadataRetriever
- Web implementation using HTML5 Video and Canvas APIs
- Example app with interactive demo
