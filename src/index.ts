import { registerPlugin } from '@capacitor/core';

import type { GetuiPlugin } from './definitions';

const Getui = registerPlugin<GetuiPlugin>('Getui', {
  web: () => import('./web').then(m => new m.GetuiWeb()),
});

export * from './definitions';
export { Getui };
