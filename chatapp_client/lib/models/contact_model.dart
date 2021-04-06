class ContactModel {
  String name;
  String number;
  String profilePic;
  String id;
  String email;
  String publicKey;
  ContactModel({this.name, this.number, this.id, this.profilePic, this.email, this.publicKey});


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'number': number,
      'email': email,
      'publicKey': publicKey,
      'profile_pic': profilePic,
      };
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    // print("inside model");
    // print(json['name']);
    return ContactModel(
      id: json['_id'],
      name: json['name'],
      number: json['number'],
      email: json['email'],
      publicKey: json['publicKey'],
      profilePic: json['profile_pic'],

    );
  }


}
