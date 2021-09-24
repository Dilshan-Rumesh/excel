class UserModel {
  String firstName;
  String lastName;
  String email;
  String password;

  UserModel({this.firstName, this.lastName, this.email, this.password});

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      firstName: "${json['firstName']}",
      lastName: "${json['lastName']}",
      email: "${json['email']}",
      password: "${json['password']}",
    );
  }

  Map toJson() => {
        "firstName": firstName,
        "lastName": this.lastName,
        "email": this.email,
        "password": this.password,
      };
}
