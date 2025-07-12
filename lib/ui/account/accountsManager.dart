import 'dart:developer';

import 'package:ct484_project/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth_token.dart';
import '../../services/account_service.dart';


class AccountsManager with ChangeNotifier{
  User item = User(id: "", username: "", password: "", phone: "", email: "");

  final AccountService _accountService;
  

  AccountsManager([AuthToken? authToken])
    :_accountService = AccountService(authToken);
  
  set authToken(AuthToken? authToken){
    _accountService.authToken = authToken;
  }

  Future<void> fetchUser() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //String? userId =  prefs.getString("userId");
    
    item = await _accountService.fetchUser();
     
    notifyListeners();
  }



  

  Future<void> addUser(String _email, String _password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =  prefs.getString("userId");
    log(_email);
    log(_password);
    User user = User(id: userId!, username: "", password: _password, phone: "", email: _email);
    final newUser = await _accountService.addUser(user);

    if(newUser != null){
      item = newUser;
      notifyListeners();
    }
  }

  Future<bool> updateUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =  prefs.getString("userId");

    if(userId == user.id){
      if(await _accountService.updateUser(user)){
        item = user;
        notifyListeners();
        return true;
      }
      
    }
    return false;
  }
  bool ChangePassword(String userId,String password){

    if(userId == item.id && password == item.password){
      return true;
      
    }
   
    return false;
  }

 
  

  User getUser() {
    return item;
  }
  
  
}

 