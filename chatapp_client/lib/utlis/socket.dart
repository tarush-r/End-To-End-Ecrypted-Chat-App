import 'package:socket_io_client/socket_io_client.dart' as client;

class Socket {
  static const _url = 'http://10.0.2.2:3000/';

  static client.Socket _socket;

  static _initialize() {
    if (_socket != null) return;

    _socket = client.io(
      _url,
      <String, dynamic>{
        'transports': ['websocket']
      },
    );
    _socket.on('connection', (_) => print('Connected'));
    _socket.connect();
  }

  static emit(String event, {dynamic arguments}) {
    _initialize(); // Ensure it's initialized
    _socket.emit(event, arguments ?? {});
  }

  static subscribe(String event, Function function) {
    _initialize(); // Ensure it's initialized
    _socket.on(event, function);
  }

  static unsubscribe(String event, Function function) {
    _initialize(); // Ensure it's initialized
    _socket.off(event, function);
  }
}
