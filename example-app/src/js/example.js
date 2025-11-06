import { Getui } from '@vaecebyz/capacitor-getui';

window.testEcho = () => {
  const inputValue = document.getElementById('echoInput').value;

  console.log(inputValue);
  Getui.echo();
  Getui.initSdk();
  console.log('Getui SDK started');

  // 监听CID事件
  window.Capacitor.Plugins.Getui.addListener('onClientId', (data) => {
    console.log('Getui ClientId:', data.clientId);
  });

  // 主动获取CID
  try {
    const { clientId } =  Getui.getClientId();
    console.log('CID:', clientId);
  } catch (err) {
    console.warn('ClientId not ready yet');
  }
};
