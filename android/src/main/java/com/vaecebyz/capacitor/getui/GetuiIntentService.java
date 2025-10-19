package com.vaecebyz.capacitor.getui;

import android.content.Context;

import com.getcapacitor.JSObject;
import com.igexin.sdk.GTIntentService;
import com.igexin.sdk.message.GTCmdMessage;
import com.igexin.sdk.message.GTNotificationMessage;
import com.igexin.sdk.message.GTTransmitMessage;
import com.getcapacitor.Logger;
import org.json.JSONException;

public class GetuiIntentService extends GTIntentService {

  @Override
  public void onReceiveServicePid(Context context, int pid) {
  }

  // 处理透传消息
  @Override
  public void onReceiveMessageData(Context context, GTTransmitMessage msg) {
    byte[] payload = msg.getPayload();
    JSObject data = new JSObject();
    data.put("appid", msg.getAppid());
    data.put("taskid", msg.getTaskId());
    data.put("messageid", msg.getMessageId());
    data.put("pkg", msg.getPkgName());
    data.put("cid", msg.getClientId());
    if (payload != null) {
      String string = new String(payload);
      try {
        data.put("payload", new JSObject(string));
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }
    GetuiPlugin.triggerListeners("onReceiveMessageData", data, true);
  }

  // 接收 cid
  @Override
  public void onReceiveClientId(Context context, String clientid) {
    JSObject data = new JSObject();
    data.put("client_id", clientid);
    GetuiPlugin.triggerListeners("onReceiveClientId", data, true);
  }

  // cid 离线上线通知
  @Override
  public void onReceiveOnlineState(Context context, boolean online) {
    JSObject data = new JSObject();
    data.put("online", online);
    GetuiPlugin.triggerListeners("onReceiveClientId", data, true);
  }

  // 各种事件处理回执
  @Override
  public void onReceiveCommandResult(Context context, GTCmdMessage cmdMessage) {
  }

  // 通知到达，只有个推通道下发的通知会回调此方法
  @Override
  public void onNotificationMessageArrived(Context context, GTNotificationMessage msg) {
  }

  // 通知点击，只有个推通道下发的通知会回调此方法
  @Override
  public void onNotificationMessageClicked(Context context, GTNotificationMessage msg) {
  }
}
