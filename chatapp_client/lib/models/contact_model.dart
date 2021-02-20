class ContactModel {
  String name;
  String number;

  ContactModel(name, number){
    this.name = name;
    this.number = number;
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number
      };
  }
}
