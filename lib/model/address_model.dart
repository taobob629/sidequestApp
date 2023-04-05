class AddressModel {
  late int id = 0;
  late String firstName = "";
  late String lastName = "";
  late String phone = "";
  late String email = "";
  late String line1 = "";
  late String line2 = "";
  late String postCode = "";
  late String city = "";
  late bool useDefault = false;

  AddressModel();

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? id;
    firstName = json['firstName'] ?? firstName;
    lastName = json['lastName'] ?? lastName;
    email = json['email'] ?? email;
    phone = json['phone'] ?? phone;
    line1 = json['line1'] ?? line1;
    line2 = json['line2'] == null ? "" : json['line2'];
    postCode = json['postCode'] == null ? "" : json['postCode'];
    city = json['city'] ?? "";
    useDefault = json['useDefault'] ?? false;
  }

  AddressModel.fromEdit(Map<String, dynamic> json) {
    id = json['id'] ?? id;
    firstName = json['firstName'] ?? firstName;
    lastName = json['lastName'] ?? lastName;
    email = json['email'] ?? email;
    phone = json['phone'] ?? phone;
    line1 = json['addressDetail'] ?? line1;
    line2 = json['line2'] == null ? "" : json['line2'];
    postCode = json['postCode'] == null ? "" : json['postCode'];
    city = json['city'] ?? "";
    useDefault = json['isDefault'] == 1 ?? false;
  }
}
