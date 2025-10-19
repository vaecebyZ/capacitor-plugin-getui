# Changelog

All notable changes to this project will be documented in this file.

## 0.1.0 - 2025-10-19
### Added
- Exposed full Android Getui native methods to TypeScript (`init`, `getVersion`, `getClientId`, `setTag`, `turnOnPush`, `turnOffPush`, `setSilentTime`, `isPushTurnedOn`, `areNotificationsEnabled`, `openNotification`, `setHwBadgeNum`, `setOPPOBadgeNum`, `setVivoAppBadgeNum`).
- Added web stubs for all new methods (return defaults or reject) to prevent runtime errors in browser.

### Fixed
- `setSilentTime` duration parameter bug (`duration` previously read from `begin_hour`).

### Notes
- This is a minor (feature) release: no breaking changes to existing `echo` API.
- Next: add iOS Getui SDK integration & docs.

## 0.0.14 - 2025-10-19
- Previous version before expanding APIs (only `echo`).
