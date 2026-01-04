# @capgo/capacitor-video-thumbnails
 <a href="https://capgo.app/"><img src='https://raw.githubusercontent.com/Cap-go/capgo/main/assets/capgo_banner.png' alt='Capgo - Instant updates for capacitor'/></a>

<div align="center">
  <h2><a href="https://capgo.app/?ref=plugin_video_thumbnails"> ➡️ Get Instant updates for your App with Capgo</a></h2>
  <h2><a href="https://capgo.app/consulting/?ref=plugin_video_thumbnails"> Missing a feature? We'll build the plugin for you 💪</a></h2>
</div>

Generate video thumbnails from local or remote video files.

## Why Capacitor Video Thumbnails?

Extract thumbnail images from videos at specific time positions:

- **Local & Remote Videos** - Works with both file:// paths and http(s):// URLs
- **Custom Time Position** - Extract frame at any millisecond timestamp
- **Quality Control** - Adjustable JPEG compression quality
- **HTTP Headers Support** - Custom headers for authenticated video sources
- **Cross-platform** - Consistent API across iOS, Android, and Web

Perfect for video galleries, media players, video editors, and any app that needs video preview images.

## Documentation

The most complete doc is available here: https://capgo.app/docs/plugins/video-thumbnails/

## Install

```bash
npm install @capgo/capacitor-video-thumbnails
npx cap sync
```

## Requirements

- iOS: iOS 15.0+
- Android: API 24+ (Android 7.0+)
- Web: Modern browsers with HTML5 video support

## API

<docgen-index>

* [`getThumbnail(...)`](#getthumbnail)
* [`getPluginVersion()`](#getpluginversion)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

Capacitor Video Thumbnails Plugin interface for generating video thumbnails.

### getThumbnail(...)

```typescript
getThumbnail(options: VideoThumbnailsOptions) => Promise<VideoThumbnailsResult>
```

Generate a thumbnail image from a video file at a specific time position.

| Param         | Type                                                                      | Description                            |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------- |
| **`options`** | <code><a href="#videothumbnailsoptions">VideoThumbnailsOptions</a></code> | - Options for generating the thumbnail |

**Returns:** <code>Promise&lt;<a href="#videothumbnailsresult">VideoThumbnailsResult</a>&gt;</code>

**Since:** 8.0.0

--------------------


### getPluginVersion()

```typescript
getPluginVersion() => Promise<{ version: string; }>
```

Get the native Capacitor plugin version.

**Returns:** <code>Promise&lt;{ version: string; }&gt;</code>

**Since:** 8.0.0

--------------------


### Interfaces


#### VideoThumbnailsResult

Result of thumbnail generation.

| Prop         | Type                | Description                                                                                                     |
| ------------ | ------------------- | --------------------------------------------------------------------------------------------------------------- |
| **`uri`**    | <code>string</code> | The local URI path to the generated thumbnail image. This can be used directly in img tags or Image components. |
| **`width`**  | <code>number</code> | Width of the generated thumbnail in pixels.                                                                     |
| **`height`** | <code>number</code> | Height of the generated thumbnail in pixels.                                                                    |


#### VideoThumbnailsOptions

Options for generating a video thumbnail.

| Prop            | Type                                                            | Description                                                                                                                                                                      |
| --------------- | --------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`sourceUri`** | <code>string</code>                                             | The URI of the video file. Can be a local file path or a remote URL. For local files, use file:// protocol or absolute path. For remote files, use http:// or https:// protocol. |
| **`time`**      | <code>number</code>                                             | The time position in milliseconds from which to extract the thumbnail. Defaults to 0 (first frame).                                                                              |
| **`quality`**   | <code>number</code>                                             | Quality of the generated image, from 0.0 (lowest) to 1.0 (highest). Defaults to 1.0.                                                                                             |
| **`headers`**   | <code><a href="#record">Record</a>&lt;string, string&gt;</code> | HTTP headers to include when fetching remote video URIs. Only applicable for remote URLs.                                                                                        |


### Type Aliases


#### Record

Construct a type with a set of properties K of type T

<code>{ [P in K]: T; }</code>

</docgen-api>
