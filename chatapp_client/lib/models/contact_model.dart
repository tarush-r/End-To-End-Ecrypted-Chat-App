class ContactModel {
  String name;
  String number;

  ContactModel({this.name, this.number});


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number
      };
  }
}
