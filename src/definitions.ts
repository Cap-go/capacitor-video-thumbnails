/**
 * Options for generating a video thumbnail.
 *
 * @since 0.0.1
 */
export interface VideoThumbnailsOptions {
  /**
   * The URI of the video file. Can be a local file path or a remote URL.
   * For local files, use file:// protocol or absolute path.
   * For remote files, use http:// or https:// protocol.
   */
  sourceUri: string;

  /**
   * The time position in milliseconds from which to extract the thumbnail.
   * Defaults to 0 (first frame).
   */
  time?: number;

  /**
   * Quality of the generated image, from 0.0 (lowest) to 1.0 (highest).
   * Defaults to 1.0.
   */
  quality?: number;

  /**
   * HTTP headers to include when fetching remote video URIs.
   * Only applicable for remote URLs.
   */
  headers?: Record<string, string>;
}

/**
 * Result of thumbnail generation.
 *
 * @since 0.0.1
 */
export interface VideoThumbnailsResult {
  /**
   * The local URI path to the generated thumbnail image.
   * This can be used directly in img tags or Image components.
   */
  uri: string;

  /**
   * Width of the generated thumbnail in pixels.
   */
  width: number;

  /**
   * Height of the generated thumbnail in pixels.
   */
  height: number;
}

/**
 * Capacitor Video Thumbnails Plugin interface for generating video thumbnails.
 *
 * @since 0.0.1
 */
export interface CapgoVideoThumbnailsPlugin {
  /**
   * Generate a thumbnail image from a video file at a specific time position.
   *
   * @param options - Options for generating the thumbnail
   * @returns Promise that resolves with the thumbnail result containing uri, width, and height
   * @throws Error if thumbnail generation fails (e.g., invalid video, network error, unsupported format)
   * @since 0.0.1
   * @example
   * ```typescript
   * const result = await CapgoVideoThumbnails.getThumbnail({
   *   sourceUri: 'file:///path/to/video.mp4',
   *   time: 5000,
   *   quality: 0.8
   * });
   * console.log('Thumbnail URI:', result.uri);
   * console.log('Dimensions:', result.width, 'x', result.height);
   * ```
   */
  getThumbnail(options: VideoThumbnailsOptions): Promise<VideoThumbnailsResult>;

  /**
   * Get the native Capacitor plugin version.
   *
   * @returns Promise that resolves with the plugin version
   * @throws Error if getting the version fails
   * @since 0.0.1
   * @example
   * ```typescript
   * const { version } = await CapgoVideoThumbnails.getPluginVersion();
   * console.log('Plugin version:', version);
   * ```
   */
  getPluginVersion(): Promise<{ version: string }>;
}
