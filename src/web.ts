import { WebPlugin } from '@capacitor/core';
import type { GetuiPlugin } from './definitions';

function notAvailable(method: string): any {
  console.warn(`[GetuiWeb] ${method} is not available in Web environment.`);
  return Promise.reject(`${method} not available on web`);
}

export class GetuiWeb extends WebPlugin implements GetuiPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    return options;
  }
  init() { return Promise.resolve({ version: 'web', client_id: null }); }
  getVersion() { return Promise.resolve({ version: 'web' }); }
  getClientId() { return Promise.resolve({ client_id: null }); }
  setTag() { return notAvailable('setTag'); }
  turnOnPush() { return notAvailable('turnOnPush'); }
  turnOffPush() { return notAvailable('turnOffPush'); }
  setSilentTime() { return notAvailable('setSilentTime'); }
  isPushTurnedOn() { return Promise.resolve({ state: false }); }
  areNotificationsEnabled() { return Promise.resolve({ state: false }); }
  openNotification() { return notAvailable('openNotification'); }
  setHwBadgeNum() { return notAvailable('setHwBadgeNum'); }
  setOPPOBadgeNum() { return notAvailable('setOPPOBadgeNum'); }
  setVivoAppBadgeNum() { return notAvailable('setVivoAppBadgeNum'); }
}
