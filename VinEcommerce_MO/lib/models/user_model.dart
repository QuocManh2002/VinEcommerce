class User{
  String? userId;
  String? imgUrl;
  String? name;
  String? plate;
  String? phone;

  String? getUserId() => this.userId;
  String?getImgUrl() => this.imgUrl;
  String? getName() => this.name;
  String? getPhone() => this.phone;

  User.fromJson(Map<String, dynamic> json):
  name = json['name'],
  imgUrl = json['avatarUrl'],
  phone = json['phone'],
  plate = json['licensePlate'];

}