/**
 * TypeScript definitions mapping to native @PluginMethod methods in GetuiPlugin.java
 */
export interface GetuiPlugin {
  /** 原样返回输入，调试用 */
  echo(options: { value: string }): Promise<{ value: string }>;

  /** 初始化个推 SDK，返回版本与当前 clientId（若已生成） */
  init(): Promise<{ version: string; client_id: string | null }>; 

  /** 获取当前 SDK 版本 */
  getVersion(): Promise<{ version: string }>;

  /** 获取当前设备 clientId */
  getClientId(): Promise<{ client_id: string | null }>;

  /** 设置标签 */
  setTag(options: { tags: string[]; sn?: string }): Promise<{ resultCode: number; resultMessage: string }>;

  /** 打开推送 */
  turnOnPush(): Promise<{ state: boolean }>;

  /** 关闭推送 */
  turnOffPush(): Promise<{ state: boolean }>;

  /** 设定静默时间（单位：小时），begin_hour:0-23, duration: 持续小时 */
  setSilentTime(options: { begin_hour: number; duration: number }): Promise<{ state: boolean }>;

  /** 查询推送是否开启 */
  isPushTurnedOn(): Promise<{ state: boolean }>;

  /** 系统通知权限是否开启 */
  areNotificationsEnabled(): Promise<{ state: boolean }>;

  /** 打开系统通知设置页 */
  openNotification(): Promise<void>;

  /** 设置华为角标 */
  setHwBadgeNum(options: { num: number }): Promise<{ result: boolean }>;

  /** 设置 OPPO 角标 */
  setOPPOBadgeNum(options: { num: number }): Promise<{ result: boolean }>;

  /** 设置 vivo 角标 */
  setVivoAppBadgeNum(options: { num: number }): Promise<{ result: boolean }>;

  /** 添加事件监听（Capacitor 自动注入类型） */
  addListener(eventName: 'onReceiveClientId', listenerFunc: (data: { client_id?: string; online?: boolean }) => void): Promise<PluginListenerHandle>;
  addListener(eventName: 'onReceiveMessageData', listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
  addListener(eventName: 'localNotificationReceived', listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
  addListener(eventName: string, listenerFunc: (data: any) => void): Promise<PluginListenerHandle>;
}

// Re-export the Capacitor listener handle type for convenience
export interface PluginListenerHandle {
  remove: () => Promise<void> | void;
}
