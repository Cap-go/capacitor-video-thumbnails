import { registerPlugin } from '@capacitor/core';

import type { CapgoVideoThumbnailsPlugin } from './definitions';

const CapgoVideoThumbnails = registerPlugin<CapgoVideoThumbnailsPlugin>('CapgoVideoThumbnails', {
  web: () => import('./web').then((m) => new m.CapgoVideoThumbnailsWeb()),
});

export * from './definitions';
export { CapgoVideoThumbnails };
