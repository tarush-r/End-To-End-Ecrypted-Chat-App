class ChatModel {
  String to;
  String from;
  String message;
  DateTime time;
  bool seen;

  ChatModel({this.to, this.from, this.message, this.time, this.seen});


  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'number': from,
      'message': message,
      'time': time,
      'seen': seen
      };
  }
}