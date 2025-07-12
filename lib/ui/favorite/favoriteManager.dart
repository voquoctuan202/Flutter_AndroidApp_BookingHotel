import 'dart:developer';


import 'package:ct484_project/models/hotel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth_token.dart';
import '../../models/favorite.dart';
import '../../services/favorite_service.dart';
import '../../services/hotel_service.dart';


class FavoriteManager with ChangeNotifier {
  Favorite _item= Favorite(id: "", idHotels: []) ;
  List<Hotel> _items = [];

  final FavoriteService _favoriteService;
  

  FavoriteManager([AuthToken? authToken])
    :_favoriteService = FavoriteService(authToken);
  
  set authToken(AuthToken? authToken){
    _favoriteService.authToken = authToken;
  }

   Future<void> fetchFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =  prefs.getString("userId");
    
    _item = await _favoriteService.fetchFavorites(userId!);
     
    notifyListeners();
  }

  Future<void> getListHotel() async {
    List<Hotel> _allHotel = [];
    
    _allHotel = await HotelService().fetchHotels();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =  prefs.getString("userId");

    _items = await _favoriteService.getListHotel(userId!,_allHotel);
    
    notifyListeners();
  }


  Future<void> getKeyByID(String id) async {
    final key = await _favoriteService.getKeyByID(id);
   
  }

  Future<void> addFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =  prefs.getString("userId");

    Favorite favorite = Favorite(id: userId! , idHotels: []);
    final newFavorite = await _favoriteService.addFavorite(favorite);

    if(newFavorite != null){
      _item = newFavorite;
      notifyListeners();
    }
  }

  Future<void> updateFavorite(bool isFavorite, String idHotel) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =  prefs.getString("userId");
    
    if(await _favoriteService.updateFavorite(userId, isFavorite, idHotel)){
      if(isFavorite){
        int key=-1, i=0;
        _items.forEach((element) {
          if(element.id == idHotel){
            key =i;
          }
          i++;
        });
        if(key!=-1) _items.removeAt(key);
      }else{
        List<Hotel> _allHotel = [];
        _allHotel = await HotelService().fetchHotels();
        
        _allHotel.forEach((element) { 
          if(element.id == idHotel){
           _items.add(element);
          }
        });
        
      }
      
      notifyListeners();
    }
    
    
  }


  int get itemCount {
    return _items.length;
  }

  List<Hotel> get items {
    return [..._items];
  }
  
  bool isFavorite(String idHotel) {
    
    bool isFavorite = false;
     _items.forEach((e) { 
       
        if(e.id == idHotel) { 
          isFavorite = true;
        }  
      });
   
    return isFavorite;
  }
 



  

 




}
