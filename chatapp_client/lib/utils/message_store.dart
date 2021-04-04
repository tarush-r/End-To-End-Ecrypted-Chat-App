import './socket.dart';
import 'package:mobx/mobx.dart';

part 'message_store.g.dart';

class MessageStore = _MessageStore with _$MessageStore;

abstract class _MessageStore with Store {
  @observable
  String message;

  _MessageStore() {
    Socket.subscribe("message", _receivedMessage);
  }

  @action
  void test() => Socket.emit('test_connection');

  void _receivedMessage(dynamic message) => this.message = message;

  dispose() => Socket.unsubscribe('message', _receivedMessage);
}
