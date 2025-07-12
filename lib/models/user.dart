
class User{
  final String id;
  final String? username;
  final String? password;
  final String? fullname;
  final String? phone;
  final String? email;

  User({
    required this.id,
    this.username,
    this.password,
    this.fullname,
    this.phone,
    this.email,
  });


  User copyWith({
    String? id,
    String? username,
    String? password,
    String? fullname,
    String? phone,
    String? email,
  }){
    return User(
      id: id ?? this.id, 
      username: username ?? this.username, 
      password: password ?? this.password,
      fullname: fullname?? this.fullname, 
      phone: phone ?? this.phone, 
      email: email ?? this.email
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'username' : username,
      'password' : password,
      'fullname' : fullname,
      'phone'    : phone,
      'email'   : email
    };
  }

  static User fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'], 
      username: json['username'], 
      password: json['password'], 
      fullname: json['fullname'],
      phone: json['phone'], 
      email: json['email']
    );
  }
}