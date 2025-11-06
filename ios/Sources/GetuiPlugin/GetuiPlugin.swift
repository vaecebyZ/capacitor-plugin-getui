import Foundation
import Capacitor
import GTCommonSDK
import GTExtensionSDK
import GTSDK
import UserNotifications

@objc(GetuiPlugin)
public class GetuiPlugin: CAPPlugin, CAPBridgedPlugin, GeTuiSdkDelegate, UNUserNotificationCenterDelegate {
    public let identifier = "GetuiPlugin"
    public let jsName = "Getui"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "initSdk", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getClientId", returnType: CAPPluginReturnPromise)
    ]
    
    private var clientId: String?
    private var appId: String?
    private var appKey: String?
    private var appSecret: String?

    // MARK: - 生命周期
    public override func load() {
        super.load()
        self.appId = getConfigValue("iosAppId") as? String
        self.appKey = getConfigValue("iosAppKey") as? String
        self.appSecret = getConfigValue("iosAppSecret") as? String
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onClientIdReceived(_:)),
            name: Notification.Name("GetuiDidRegisterClient"),
            object: nil
        )
    }
    
    // MARK: - 插件方法
    @objc func initSdk(_ call: CAPPluginCall) {
        guard let appId = self.appId,
            let appKey = self.appKey,
            let appSecret = self.appSecret else {
            call.reject("iOS 个推配置缺失，请在 capacitor.config.json 中配置 Getui.iosAppId / iosAppKey / iosAppSecret")
            return
        }
        
        print("[GetuiPlugin] 初始化个推 SDK: \(appId)")
        
        GeTuiSdk.start(
            withAppId: appId,
            appKey: appKey,
            appSecret: appSecret,
            delegate: self,
            launchingOptions: nil
        )
        
        // 注册通知
        GeTuiSdk.registerRemoteNotification([.alert, .sound, .badge])
        UNUserNotificationCenter.current().delegate = self
        
        call.resolve(["status": "started"])
    }
    
    @objc func getClientId(_ call: CAPPluginCall) {
        if let cid = clientId {
            call.resolve(["clientId": cid])
        } else {
            call.reject("ClientId not available yet")
        }
    }
    
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve(["value": value])
    }
    
    // MARK: - 个推回调
    public func geTuiSdkDidRegisterClient(_ clientId: String) {
        print("[Getui] Register ClientID: \(clientId)")
        self.clientId = clientId
        notifyListeners("onClientId", data: ["clientId": clientId])
    }
    
    public func geTuiSdkDidOccurError(_ error: Error) {
        print("[Getui] Error: \(error.localizedDescription)")
    }
    
    public func geTuiSdkDidReceiveSlience(
        _ userInfo: [AnyHashable : Any],
        fromGetui: Bool,
        offLine: Bool,
        appId: String?,
        taskId: String?,
        msgId: String?,
        fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil
    ) {
        print("[Getui] Silent Message: \(userInfo)")
        completionHandler?(.noData)
    }
    
    // MARK: - 通知展示回调
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .sound, .alert])
    }
    
    // MARK: - ClientId通知监听
    @objc private func onClientIdReceived(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let cid = userInfo["clientId"] as? String {
            clientId = cid
            notifyListeners("onClientId", data: ["clientId": cid])
        }
    }
}
