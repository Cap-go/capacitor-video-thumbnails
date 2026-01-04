import { WebPlugin } from '@capacitor/core';

import type { CapgoVideoThumbnailsPlugin, VideoThumbnailsOptions, VideoThumbnailsResult } from './definitions';

export class CapgoVideoThumbnailsWeb extends WebPlugin implements CapgoVideoThumbnailsPlugin {
  async getThumbnail(options: VideoThumbnailsOptions): Promise<VideoThumbnailsResult> {
    const { sourceUri, time = 0, quality = 1.0 } = options;

    return new Promise((resolve, reject) => {
      const video = document.createElement('video');
      video.crossOrigin = 'anonymous';
      video.preload = 'metadata';

      video.onloadedmetadata = () => {
        // Seek to the specified time (convert ms to seconds)
        video.currentTime = time / 1000;
      };

      video.onseeked = () => {
        try {
          const canvas = document.createElement('canvas');
          canvas.width = video.videoWidth;
          canvas.height = video.videoHeight;

          const ctx = canvas.getContext('2d');
          if (!ctx) {
            reject(new Error('Failed to get canvas context'));
            return;
          }

          ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

          const dataUrl = canvas.toDataURL('image/jpeg', quality);

          resolve({
            uri: dataUrl,
            width: canvas.width,
            height: canvas.height,
          });
        } catch (error) {
          reject(new Error(`Failed to extract frame: ${error instanceof Error ? error.message : String(error)}`));
        }
      };

      video.onerror = () => {
        reject(new Error(`Failed to load video from ${sourceUri}`));
      };

      video.src = sourceUri;
      video.load();
    });
  }

  async getPluginVersion(): Promise<{ version: string }> {
    return { version: 'web' };
  }
}
