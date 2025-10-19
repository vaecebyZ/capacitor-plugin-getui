import { WebPlugin } from '@capacitor/core';

import type { GetuiPlugin } from './definitions';

export class GetuiWeb extends WebPlugin implements GetuiPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
