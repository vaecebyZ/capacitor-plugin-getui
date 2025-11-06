import Foundation
import Capacitor
import GTCommonSDK
import GTExtensionSDK
import GTSDK
import UserNotifications
import UIKit

@objc(GetuiPlugin)
public class GetuiPlugin: CAPPlugin, CAPBridgedPlugin, GeTuiSdkDelegate, UNUserNotificationCenterDelegate {
    public let identifier = "GetuiPlugin"
    public let jsName = "Getui"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "init", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getVersion", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getClientId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setTag", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "turnOnPush", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "turnOffPush", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setSilentTime", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "isPushTurnedOn", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "areNotificationsEnabled", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "openNotification", returnType: CAPPluginReturnPromise)
    ]
    
    private var clientId: String?
    private var appId: String?
    private var appKey: String?
    private var appSecret: String?

    public override func load() {
        super.load()
        self.appId = getConfigValue("iosAppId") as? String
        self.appKey = getConfigValue("iosAppKey") as? String
        self.appSecret = getConfigValue("iosAppSecret") as? String
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(self,
            selector: #selector(onClientIdReceived(_:)),
            name: Notification.Name("GetuiDidRegisterClient"),
            object: nil
        )
    }

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve(["value": value])
    }

    @objc func `init`(_ call: CAPPluginCall) {
        guard let appId = appId, let appKey = appKey, let appSecret = appSecret else {
            call.reject("缺少 iOS Getui 配置")
            return
        }
        GeTuiSdk.start(withAppId: appId, appKey: appKey, appSecret: appSecret, delegate: self, launchingOptions: nil)
        GeTuiSdk.registerRemoteNotification([.alert, .sound, .badge])
        let version = GeTuiSdk.version()
        let cid = GeTuiSdk.clientId()
        call.resolve(["version": version, "client_id": cid ?? NSNull()])
    }

    @objc func getVersion(_ call: CAPPluginCall) {
        call.resolve(["version": GeTuiSdk.version()])
    }

    @objc func getClientId(_ call: CAPPluginCall) {
        call.resolve(["client_id": GeTuiSdk.clientId() ?? NSNull()])
    }

    @objc func setTag(_ call: CAPPluginCall) {
        var tagsArray: [String] = []
        if let tags = call.getArray("tags") {
            for t in tags {
                if let s = t as? String { tagsArray.append(s) }
            }
        }
        if tagsArray.isEmpty {
            call.reject("tags 参数无效")
            return
        }
        let sn = call.getString("sn") ?? UUID().uuidString
        let submitted = GeTuiSdk.setTags(tagsArray)
        let submittedWithSn = GeTuiSdk.setTags(tagsArray, andSequenceNum: sn)
        if submitted || submittedWithSn {
            call.resolve(["resultCode": 0, "resultMessage": "设置标签成功"])
        } else {
            call.reject("设置标签请求失败")
        }
    }

    @objc func turnOnPush(_ call: CAPPluginCall) {
        GeTuiSdk.setPushModeForOff(false)
        call.resolve(["state": true])
    }

    @objc func turnOffPush(_ call: CAPPluginCall) {
        GeTuiSdk.setPushModeForOff(true)
        call.resolve(["state": false])
    }

    @objc func setSilentTime(_ call: CAPPluginCall) {
        let beginHour = call.getInt("begin_hour", 0) ?? 0
        let duration = call.getInt("duration", 0) ?? 0
        if duration > 0 {
            GeTuiSdk.setPushModeForOff(true)
            UserDefaults.standard.setValue(["begin_hour": beginHour, "duration": duration], forKey: "GetuiSilentTime")
            call.resolve(["state": true])
        } else {
            GeTuiSdk.setPushModeForOff(false)
            UserDefaults.standard.removeObject(forKey: "GetuiSilentTime")
            call.resolve(["state": true])
        }
    }

    @objc func isPushTurnedOn(_ call: CAPPluginCall) {
        let isOn: Bool = (GeTuiSdk.status() == .started)
        call.resolve(["state": isOn])
    }

    @objc func areNotificationsEnabled(_ call: CAPPluginCall) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                call.resolve(["state": settings.authorizationStatus == .authorized])
            }
        }
    }

    @objc func openNotification(_ call: CAPPluginCall) {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        call.resolve()
    }

    public func geTuiSdkDidRegisterClient(_ clientId: String) {
        notifyListeners("onReceiveClientId", data: ["client_id": clientId])
    }

    public func geTuiSdkDidOccurError(_ error: NSError) {
        notifyListeners("onError", data: ["error": error.localizedDescription])
    }

    public func geTuiSdkDidReceiveSlience(_ userInfo: [AnyHashable : Any],
                                          fromGetui: Bool,
                                          offLine: Bool,
                                          appId: String?,
                                          taskId: String?,
                                          msgId: String?,
                                          fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)?) {
        notifyListeners("onReceiveMessageData", data: userInfo as? [String: Any] ?? [:])
        completionHandler?(.noData)
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let data = notification.request.content.userInfo as? [String: Any] ?? [:]
        notifyListeners("localNotificationReceived", data: data)
        completionHandler([.alert, .sound, .badge])
    }

    @objc private func onClientIdReceived(_ notification: Notification) {
        if let cid = notification.userInfo?["clientId"] as? String {
            clientId = cid
            notifyListeners("onReceiveClientId", data: ["client_id": cid])
        }
    }
}
