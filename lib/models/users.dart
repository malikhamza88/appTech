import 'dart:convert';

const mockUsers = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'near.huscarl@gmail.com': 'subscribe to pewdiepie',
  '@.com': '.',
};

// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.status,
    this.data,
  });

  String status;
  Data data;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.userName,
    this.email,
    this.name,
    this.photo,
    this.designationsId,
    this.userId,
    this.lastLogin,
    this.onlineTime,
    this.loggedin,
    this.userType,
    this.userFlag,
    this.direction,
    this.token,
  });

  String userName;
  String email;
  String name;
  String photo;
  String designationsId;
  String userId;
  DateTime lastLogin;
  int onlineTime;
  bool loggedin;
  String userType;
  int userFlag;
  String direction;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userName: json["user_name"],
        email: json["email"],
        name: json["name"],
        photo: json["photo"],
        designationsId: json["designations_id"],
        userId: json["user_id"],
        lastLogin: DateTime.parse(json["last_login"]),
        onlineTime: json["online_time"],
        loggedin: json["loggedin"],
        userType: json["user_type"],
        userFlag: json["user_flag"],
        direction: json["direction"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "email": email,
        "name": name,
        "photo": photo,
        "designations_id": designationsId,
        "user_id": userId,
        "last_login": lastLogin.toIso8601String(),
        "online_time": onlineTime,
        "loggedin": loggedin,
        "user_type": userType,
        "user_flag": userFlag,
        "direction": direction,
        "token": token,
      };
}
