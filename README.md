# @vaecebyz/capacitor-getui

个推

## Install

```bash
npm install @vaecebyz/capacitor-getui
npx cap sync
```

> 本包基于原 `capacitor-plugin-getui` 演进，原作者已不再维护；现由 `vaecebyZ` 继续维护。保留原 MIT 许可归属。

## API

<docgen-index>

* [`echo(...)`](#echo)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => any
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>any</code>

--------------------

</docgen-api>

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
