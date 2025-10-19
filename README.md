# @vaecebyz/capacitor-getui

个推

## Install

```bash
npm install @vaecebyz/capacitor-getui
npx cap sync
```

> 本包基于原 `capacitor-plugin-getui` 演进，原作者已不再维护；现由 `vaecebyZ` 继续维护。保留原 MIT 许可归属。

## 快速使用（JS/TS）

```ts
import { Getui } from '@vaecebyz/capacitor-getui';

async function bootstrap() {
	await Getui.init();
	const { client_id } = await Getui.getClientId();
	console.log('CID', client_id);
	Getui.addListener('onReceiveMessageData', d => console.log('透传', d));
}
```

## 可用方法

| 方法 | 说明 |
| ---- | ---- |
| `echo({ value })` | 调试回显 |
| `init()` | 初始化 SDK，返回版本与 clientId |
| `getVersion()` | 获取 SDK 版本 |
| `getClientId()` | 获取 clientId |
| `setTag({ tags, sn? })` | 设置标签 |
| `turnOnPush()` / `turnOffPush()` | 开/关推送 |
| `setSilentTime({ begin_hour, duration })` | 设置静默时段（小时） |
| `isPushTurnedOn()` | 推送是否开启 |
| `areNotificationsEnabled()` | 系统通知权限是否开启 |
| `openNotification()` | 打开系统通知设置页 |
| `setHwBadgeNum({ num })` | 华为角标 |
| `setOPPOBadgeNum({ num })` | OPPO 角标 |
| `setVivoAppBadgeNum({ num })` | vivo 角标 |

## 事件

| 事件名 | 说明 | 数据示例 |
| ------ | ---- | -------- |
| `onReceiveClientId` | 获取/更新 CID 或在线状态 | `{ client_id?: string, online?: boolean }` |
| `onReceiveMessageData` | 透传消息 | `{ appid, cid, taskid, messageid, payload? }` |
| `localNotificationReceived` | 预留通知到达（扩展用） | 自定义 |

## Web 环境
Web 上方法多数返回默认值或直接 reject，不会抛出未定义。请使用 `Capacitor.isNativePlatform()` 判定。

## Changelog
详见 [CHANGELOG.md](./CHANGELOG.md)

## Troubleshooting

### Android Gradle wrapper zip error

If you see an error like:

```
Could not unzip .../gradle-7.0-all.zip
Reason: zip END header not found
java.util.zip.ZipException: zip END header not found
```

It usually means the cached Gradle distribution zip is corrupted (often due to an interrupted download). Fix it by deleting the broken folder and re-running the build so Gradle re-downloads a fresh copy:

```bash
rm -rf "$HOME/.gradle/wrapper/dists/gradle-7.0-all"*
cd android && ./gradlew --refresh-dependencies tasks && cd ..
```

Or use the provided npm script (after we add it):

```bash
npm run clean:gradle && npm run verify:android
```

### 当前使用的版本

本插件仓库现已固定：

```
Gradle Wrapper: 6.7.1
Android Gradle Plugin: 4.1.3 (在 `android/build.gradle` 中)
JDK: 11 (sdkman 对应 `java=11.0.28-amzn`)
```

这一组合是 AGP 4.1.x 官方支持范围（Gradle ≤6.8.x，JDK 8~11）。避免使用 JDK 17+ 或 Gradle 7+ 以免出现 `Unsupported class file major version`。

如果后续需要升级：

1. 升级到 AGP 7.x 及以上 → 需要 Gradle 7.x 且至少 JDK 11。
2. 继续保持 AGP 4.1.x → 保持 Gradle 6.x（推荐 ≤6.8.3）与 JDK 8~11。

修改 Gradle 版本只需编辑 `android/gradle/wrapper/gradle-wrapper.properties`，然后重新运行 `./gradlew --version` 验证。

### Clearing Gradle caches fully

If problems persist:

```bash
rm -rf "$HOME/.gradle/caches" "$HOME/.gradle/wrapper/dists" && cd android && ./gradlew build && cd ..
```

This forces complete redownload of dependencies.
