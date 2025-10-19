# @vaecebyz/capacitor-getui

getui

## Install

```bash
npm install @vaecebyz/capacitor-getui
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`init()`](#init)
* [`getVersion()`](#getversion)
* [`getClientId()`](#getclientid)
* [`setTag(...)`](#settag)
* [`turnOnPush()`](#turnonpush)
* [`turnOffPush()`](#turnoffpush)
* [`setSilentTime(...)`](#setsilenttime)
* [`isPushTurnedOn()`](#ispushturnedon)
* [`areNotificationsEnabled()`](#arenotificationsenabled)
* [`openNotification()`](#opennotification)
* [`setHwBadgeNum(...)`](#sethwbadgenum)
* [`setOPPOBadgeNum(...)`](#setoppobadgenum)
* [`setVivoAppBadgeNum(...)`](#setvivoappbadgenum)
* [`addListener('onReceiveClientId', ...)`](#addlisteneronreceiveclientid-)
* [`addListener('onReceiveMessageData', ...)`](#addlisteneronreceivemessagedata-)
* [`addListener('localNotificationReceived', ...)`](#addlistenerlocalnotificationreceived-)
* [`addListener(string, ...)`](#addlistenerstring-)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

TypeScript definitions mapping to native @PluginMethod methods in GetuiPlugin.java

### echo(...)

```typescript
echo(options: { value: string; }) => any
```

原样返回输入，调试用

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>any</code>

--------------------


### init()

```typescript
init() => any
```

初始化个推 SDK，返回版本与当前 clientId（若已生成）

**Returns:** <code>any</code>

--------------------


### getVersion()

```typescript
getVersion() => any
```

获取当前 SDK 版本

**Returns:** <code>any</code>

--------------------


### getClientId()

```typescript
getClientId() => any
```

获取当前设备 clientId

**Returns:** <code>any</code>

--------------------


### setTag(...)

```typescript
setTag(options: { tags: string[]; sn?: string; }) => any
```

设置标签

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ tags: {}; sn?: string; }</code> |

**Returns:** <code>any</code>

--------------------


### turnOnPush()

```typescript
turnOnPush() => any
```

打开推送

**Returns:** <code>any</code>

--------------------


### turnOffPush()

```typescript
turnOffPush() => any
```

关闭推送

**Returns:** <code>any</code>

--------------------


### setSilentTime(...)

```typescript
setSilentTime(options: { begin_hour: number; duration: number; }) => any
```

设定静默时间（单位：小时），begin_hour:0-23, duration: 持续小时

| Param         | Type                                                   |
| ------------- | ------------------------------------------------------ |
| **`options`** | <code>{ begin_hour: number; duration: number; }</code> |

**Returns:** <code>any</code>

--------------------


### isPushTurnedOn()

```typescript
isPushTurnedOn() => any
```

查询推送是否开启

**Returns:** <code>any</code>

--------------------


### areNotificationsEnabled()

```typescript
areNotificationsEnabled() => any
```

系统通知权限是否开启

**Returns:** <code>any</code>

--------------------


### openNotification()

```typescript
openNotification() => any
```

打开系统通知设置页

**Returns:** <code>any</code>

--------------------


### setHwBadgeNum(...)

```typescript
setHwBadgeNum(options: { num: number; }) => any
```

设置华为角标

| Param         | Type                          |
| ------------- | ----------------------------- |
| **`options`** | <code>{ num: number; }</code> |

**Returns:** <code>any</code>

--------------------


### setOPPOBadgeNum(...)

```typescript
setOPPOBadgeNum(options: { num: number; }) => any
```

设置 OPPO 角标

| Param         | Type                          |
| ------------- | ----------------------------- |
| **`options`** | <code>{ num: number; }</code> |

**Returns:** <code>any</code>

--------------------


### setVivoAppBadgeNum(...)

```typescript
setVivoAppBadgeNum(options: { num: number; }) => any
```

设置 vivo 角标

| Param         | Type                          |
| ------------- | ----------------------------- |
| **`options`** | <code>{ num: number; }</code> |

**Returns:** <code>any</code>

--------------------


### addListener('onReceiveClientId', ...)

```typescript
addListener(eventName: 'onReceiveClientId', listenerFunc: (data: { client_id?: string; online?: boolean; }) => void) => any
```

添加事件监听（Capacitor 自动注入类型）

| Param              | Type                                                                      |
| ------------------ | ------------------------------------------------------------------------- |
| **`eventName`**    | <code>'onReceiveClientId'</code>                                          |
| **`listenerFunc`** | <code>(data: { client_id?: string; online?: boolean; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener('onReceiveMessageData', ...)

```typescript
addListener(eventName: 'onReceiveMessageData', listenerFunc: (data: any) => void) => any
```

| Param              | Type                                |
| ------------------ | ----------------------------------- |
| **`eventName`**    | <code>'onReceiveMessageData'</code> |
| **`listenerFunc`** | <code>(data: any) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener('localNotificationReceived', ...)

```typescript
addListener(eventName: 'localNotificationReceived', listenerFunc: (data: any) => void) => any
```

| Param              | Type                                     |
| ------------------ | ---------------------------------------- |
| **`eventName`**    | <code>'localNotificationReceived'</code> |
| **`listenerFunc`** | <code>(data: any) =&gt; void</code>      |

**Returns:** <code>any</code>

--------------------


### addListener(string, ...)

```typescript
addListener(eventName: string, listenerFunc: (data: any) => void) => any
```

| Param              | Type                                |
| ------------------ | ----------------------------------- |
| **`eventName`**    | <code>string</code>                 |
| **`listenerFunc`** | <code>(data: any) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### Interfaces


#### PluginListenerHandle

| Prop         | Type                      |
| ------------ | ------------------------- |
| **`remove`** | <code>() =&gt; any</code> |

</docgen-api>
