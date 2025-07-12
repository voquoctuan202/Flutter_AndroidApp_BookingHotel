import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_token.dart';

import '../models/user.dart';
import 'firebase_service.dart';

class AccountService extends FirebaseService {
  AccountService([AuthToken? authToken]) : super(authToken);

  Future<User> fetchUser() async {
    
    User _user = User(id: "", username: "", password: "", phone: "", email: "");
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userId =  prefs.getString("userId");

    try{
      final usersMap = await httpFetch(
        '$databaseUrl/users.json?auth=$token',
      ) as Map<String, dynamic>;
      
     
      usersMap.forEach((userId,user){
        if(_userId == User.fromJson({...user}).id)
        _user =  User.fromJson({...user});
      });
      
      return _user;

    } catch(error){
      print(error);
      return _user;
    }
  }
  Future<String?> getKeyByID(String id) async{
    final usersMap = await httpFetch(
        '$databaseUrl/users.json?auth=$token',
      ) as Map<String, dynamic>;
    
    String? key;
    usersMap.forEach((userId,user){
        User _user = User.fromJson({
              ...user
            });
        if(_user.id == id){
          key = userId;
        }
    });
    return key;
  }

  Future<User?> addUser(User user) async {
    try{
      final newUser = await httpFetch(
        '$databaseUrl/users/.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
         user.toJson()
          
        ),
      ) as Map<String, dynamic>?;

      return user; 
    }catch (error){
      print(error);
      return null;
    }
  }
  Future<bool> updateUser(User user) async {
    String? key = await getKeyByID(user.id);
    try{
      await httpFetch(
        '$databaseUrl/users/$key.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(
         user.toJson()
        ),
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
  Future<bool> deleteUser(String id) async {
    String? key = await getKeyByID(id);
    try{
      await httpFetch(
        '$databaseUrl/users/$key.json?auth=$token',
        method: HttpMethod.delete,
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
}