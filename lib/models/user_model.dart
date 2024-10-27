class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phone;
  final String dob;
  final String gender;
  final String password;
  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.dob,
    required this.gender,
  });

  toJson() {
    return {
      "Name": fullName,
      "Email": email,
      "Phone": phone,
      "Gender": gender,
      "DateOfBirth": dob,
      "Password": password,
    };
  }
}
