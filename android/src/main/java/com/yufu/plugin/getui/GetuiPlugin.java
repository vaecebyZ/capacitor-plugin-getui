package com.yufu.plugin.getui;

import android.annotation.SuppressLint;
import android.content.Context;
import com.getcapacitor.Bridge;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginHandle;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.igexin.sdk.PushConsts;
import com.igexin.sdk.PushManager;
import com.igexin.sdk.Tag;

import org.json.JSONException;

@CapacitorPlugin(name = "Getui")
public class GetuiPlugin extends Plugin {

  public static Bridge staticBridge = null;
  private final Getui implementation = new Getui();
  @SuppressLint("StaticFieldLeak")
  public static Context staticContext;
  private static PushManager pushManager = PushManager.getInstance();
  private String clientId = null;

  @Override
  public void load() {
    super.load();
    staticBridge = this.bridge;
    staticContext = getActivity();
    pushManager = PushManager.getInstance();
  }

  @PluginMethod
  public void echo(PluginCall call) {
    String value = call.getString("value");
    JSObject ret = new JSObject();
    ret.put("value", implementation.echo(value));
    call.resolve(ret);
  }

  /**
   * 初始化SDK
   */
  @PluginMethod
  public void init(PluginCall call) {
    JSObject ret = new JSObject();
    pushManager.initialize(staticContext);
    ret.put("version", pushManager.getVersion(staticContext));
    ret.put("client_id", getClientId());
    call.resolve(ret);
  }

  /**
   * 获取当前 SDK 版本号
   */
  @PluginMethod
  public void getVersion(PluginCall call) {
    JSObject ret = new JSObject();
    ret.put("version", pushManager.getVersion(staticContext));
    call.resolve(ret);
  }

  /**
   * 获取当前用户的clientId
   */
  @PluginMethod
  public void getClientId(PluginCall call) {
    JSObject ret = new JSObject();
    ret.put("client_id", getClientId());
    call.resolve(ret);
  }

  /**
   * 为当前用户设置一组标签，后续推送可以指定标签名进行定向推送。
   */
  @PluginMethod
  public void setTag(PluginCall call) {
    if (clientId == null) {
      call.reject("clientId is empty");
      return;
    }
    String sn = call.getString("sn", "sn");
    JSArray tags = call.getArray("tags");
    int length = tags.length();

    Tag[] tagParam = new Tag[length];
    for (int i = 0; i < length; i++) {
      String tag = "";
      try {
        tag = tags.getString(i);
      } catch (JSONException ignored) {

      }
      if (!tag.equals("")) {
        Tag t = new Tag();
        // name 字段只支持：中文、英文字母（大小写）、数字、除英文逗号以外的其他特殊符号
        t.setName(tag);
        tagParam[i] = t;
      }
    }
    int resultCode = pushManager.setTag(staticContext, tagParam, sn);
    String resultMessage = "设置标签失败,未知异常";
    switch (resultCode) {
      case PushConsts.SETTAG_SUCCESS:
        resultMessage = "设置标签成功";
        break;
      case PushConsts.SETTAG_ERROR_COUNT:
        resultMessage = "设置标签失败, tag数量过大, 最大不能超过200个";
        break;
      case PushConsts.SETTAG_ERROR_FREQUENCY:
        resultMessage = "设置标签失败, 频率过快, 两次间隔应大于1s";
        break;
      case PushConsts.SETTAG_ERROR_REPEAT:
        resultMessage = "设置标签失败, 标签重复";
        break;
      case PushConsts.SETTAG_ERROR_UNBIND:
        resultMessage = "设置标签失败, 服务未初始化成功";
        break;
      case PushConsts.SETTAG_ERROR_EXCEPTION:
        resultMessage = "设置标签失败, 未知异常";
        break;
      case PushConsts.SETTAG_ERROR_NULL:
        resultMessage = "设置标签失败, tag 为空";
        break;
      case PushConsts.SETTAG_NOTONLINE:
        resultMessage = "还未登陆成功";
        break;
      case PushConsts.SETTAG_IN_BLACKLIST:
        resultMessage = "该应用已经在黑名单中,请联系售后支持!";
        break;
      case PushConsts.SETTAG_NUM_EXCEED:
        resultMessage = "已存 tag 超过限制";
        break;
      default:
        break;
    }

    JSObject ret = new JSObject();
    ret.put("resultCode", resultCode);
    ret.put("resultMessage", resultMessage);
    call.resolve(ret);
  }

  /**
   * 开启Push推送, 默认是开启状态, 关闭状态则收不到推送。turnOnPush 默认打开
   */
  @PluginMethod
  public void turnOnPush(PluginCall call) {
    pushManager.turnOnPush(staticContext);
    JSObject ret = new JSObject();
    ret.put("state", isPushTurnedOn());
    call.resolve(ret);
  }

  /**
   * 关闭Push推送, 关闭后则无法收到推送消息
   */
  @PluginMethod
  public void turnOffPush(PluginCall call) {
    pushManager.turnOffPush(staticContext);
    JSObject ret = new JSObject();
    ret.put("state", isPushTurnedOn());
    call.resolve(ret);
  }

  /**
   * 设置静默时间，静默期间SDK将不再联网
   */
  @PluginMethod
  public void setSilentTime(PluginCall call) {
    Integer beginHour = call.getInt("begin_hour", 0);
    // Bug fix: duration 应该读取 duration 参数而不是 begin_hour
    Integer duration = call.getInt("duration", 0);
    assert (beginHour != null && duration != null);
    pushManager.setSilentTime(staticContext, beginHour, duration);
    JSObject ret = new JSObject();
    ret.put("state", isPushTurnedOn());
    call.resolve(ret);
  }

  /**
   * 获取 SDK 服务状态
   * true：当前推送已打开；false：当前推送已关闭
   */
  @PluginMethod
  public void isPushTurnedOn(PluginCall call) {
    JSObject ret = new JSObject();
    ret.put("state", isPushTurnedOn());
    call.resolve(ret);
  }

  /**
   * 检测用户设备是否开启通知权限
   * 返回true，表示用户设备正常开启通知权限，推送通知在设备上可以正常到达、展示；返回false，表示用户设备未开启通知权限
   */
  @PluginMethod
  public void areNotificationsEnabled(PluginCall call) {
    boolean state = pushManager.areNotificationsEnabled(staticContext);
    JSObject ret = new JSObject();
    ret.put("state", state);
    call.resolve(ret);
  }

  /**
   * 开启通知权限
   * 调用方法，将跳转到系统开启通知功能页面，引导用户开启通知权限
   */
  @PluginMethod
  public void openNotification(PluginCall call) {
    pushManager.openNotification(staticContext);
  }

  /**
   * 设置华为设备上的应用角标
   * num: 角标数量
   */
  @PluginMethod
  public void setHwBadgeNum(PluginCall call) {
    Integer num = call.getInt("num", 1);
    assert (num != null);
    boolean result = pushManager.setHwBadgeNum(staticContext, num);
    JSObject ret = new JSObject();
    ret.put("result", result);
    call.resolve(ret);
  }

  /**
   * 设置Oppo角标。需要oppo官方设置白名单
   * num: 角标数量
   */
  @PluginMethod
  public void setOPPOBadgeNum(PluginCall call) {
    Integer num = call.getInt("num", 1);
    assert (num != null);
    boolean result = pushManager.setOPPOBadgeNum(staticContext, num);
    JSObject ret = new JSObject();
    ret.put("result", result);
    call.resolve(ret);
  }

  /**
   * 设置vivo设备上的角标数
   * num: 角标数量
   */
  @PluginMethod
  public void setVivoAppBadgeNum(PluginCall call) {
    Integer num = call.getInt("num", 1);
    assert (num != null);
    boolean result = pushManager.setVivoAppBadgeNum(staticContext, num);
    JSObject ret = new JSObject();
    ret.put("result", result);
    call.resolve(ret);
  }

  public static GetuiPlugin getInstance() {
    if (staticBridge != null && staticBridge.getWebView() != null) {
      PluginHandle handle = staticBridge.getPlugin("Getui");
      if (handle == null) {
        return null;
      }
      return (GetuiPlugin) handle.getInstance();
    }
    return null;
  }

  public static void fireReceived(JSObject notification) {
    GetuiPlugin getuiPlugin = GetuiPlugin.getInstance();
    if (getuiPlugin != null) {
      getuiPlugin.notifyListeners("localNotificationReceived", notification, true);
    }
  }

  public static void triggerListeners(String eventName, JSObject data, boolean retainUntilConsumed) {
    GetuiPlugin getuiPlugin = GetuiPlugin.getInstance();
    if (getuiPlugin != null) {
      getuiPlugin.notifyListeners(eventName, data, retainUntilConsumed);
    }
  }

  public static void triggerListeners(String eventName, JSObject data) {
    triggerListeners(eventName, data, false);
  }

  public String getClientId() {
    clientId = pushManager.getClientid(staticContext);
    return clientId;
  }

  public Boolean isPushTurnedOn() {
    return pushManager.isPushTurnedOn(staticContext);
  }

}
