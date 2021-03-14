class ChatContactModel {
  String name;
  String number;
  String recentMessage;
  int notificationCount;
  String recentMessageTime;

  ChatContactModel({this.name, this.number, this.recentMessage, this.notificationCount, this.recentMessageTime});


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'recentMessage': recentMessage,
      'notificationCount': notificationCount,
      'recentMessageTime': recentMessageTime
      };
  }
}
