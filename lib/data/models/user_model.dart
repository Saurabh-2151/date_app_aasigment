class UserName {
  final String first;
  final String last;

  UserName({required this.first, required this.last});

  factory UserName.fromJson(Map<String, dynamic> json) => UserName(
        first: json['first'],
        last: json['last'],
      );

  String get fullName => '$first $last';
}

class UserPicture {
  final String large;

  UserPicture({required this.large});

  factory UserPicture.fromJson(Map<String, dynamic> json) => UserPicture(
        large: json['large'],
      );
}

class UserLocation {
  final String city;
  final String country;

  UserLocation({required this.city, required this.country});

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
        city: json['city'],
        country: json['country'],
      );
}

class UserDob {
  final int age;

  UserDob({required this.age});

  factory UserDob.fromJson(Map<String, dynamic> json) => UserDob(
        age: json['age'],
      );
}

class UserModel {
  final String gender;
  final UserName name;
  final UserLocation location;
  final UserPicture picture;
  final UserDob dob;

  UserModel({
    required this.gender,
    required this.name,
    required this.location,
    required this.picture,
    required this.dob,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        gender: json['gender'],
        name: UserName.fromJson(json['name']),
        location: UserLocation.fromJson(json['location']),
        picture: UserPicture.fromJson(json['picture']),
        dob: UserDob.fromJson(json['dob']),
      );
}
