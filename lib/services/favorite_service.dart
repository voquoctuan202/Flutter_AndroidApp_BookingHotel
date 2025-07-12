
import 'dart:convert';
import 'dart:developer';

import 'package:ct484_project/models/hotel.dart';

import '../../models/favorite.dart';
import '../models/auth_token.dart';
import 'firebase_service.dart';


class FavoriteService extends FirebaseService {
  FavoriteService([AuthToken? authToken]) : super(authToken);

  Future<Favorite> fetchFavorites(String userId) async {
   Favorite _favorite  = Favorite(id: "", idHotels: []);
    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // log(prefs.getString("userId")?? "rỗng");
   
    try{
      final favoritesMap = await httpFetch(
        '$databaseUrl/favorites.json?auth=$token',
      ) ;
      favoritesMap.forEach((favoriteId,favorite){
          _favorite = Favorite.fromJson({...favorite}
          );
      });
      
      // log(_favorite.idHotels.toString());
      return _favorite;

    } catch(error){
      print(error);
      return _favorite;
    }
  }

  Future<String?> getKeyByID(String id) async{
    final favoritesMap = await httpFetch(
        '$databaseUrl/favorites.json?auth=$token',
      ) as Map<String, dynamic>;
    
    String? key;
    favoritesMap.forEach((favoriteId,favorite){
        Favorite _favorite = Favorite.fromJson({
              ...favorite
            });
        if(_favorite.id == id){
          key = favoriteId;
        }
    });
    return key;
  }
  
  Future<List<Hotel>> getListHotel(String userId, List<Hotel> _allHotel) async{
    
    List<Hotel> _listHotel = [];
    List<dynamic> _listHotelId = [];
    
   
    try{
      final favoritesMap = await httpFetch(
        '$databaseUrl/favorites/.json?auth=$token',
      ) ;

      favoritesMap.forEach((favoriteId,favorite){
        if(userId == Favorite.fromJson({...favorite}).id)
          _listHotelId = Favorite.fromJson({...favorite}).idHotels;
      });
      
     _listHotelId.forEach((e) { 
        _allHotel.forEach((element) { 
          element.id == e ? _listHotel.add(element): log("");
        });

        
     });
      
      return _listHotel;

    } catch(error){
      print(error);
      return _listHotel;
    }
    

  }

  Future<Favorite?> addFavorite(Favorite favorite) async {
    try{
      final newfavorite = await httpFetch(
        '$databaseUrl/favorites/.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
         favorite.toJson()
          
        ),
      );

      return favorite; 
    }catch (error){
      print(error);
      return null;
    }
  }
  Future<bool> updateFavorite(userId, isFavorite, idHotel) async {
    String? k = await getKeyByID(userId);
    
    Favorite favorite = Favorite(id: "", idHotels: []);
    List<dynamic> _listHotelId = [];
    try{
      final favoritesMap = await httpFetch(
        '$databaseUrl/favorites/.json?auth=$token',
      ) ;
      favoritesMap.forEach((favoriteId,favorite){
        
        if( userId == Favorite.fromJson({...favorite}).id ){
           _listHotelId = Favorite.fromJson({...favorite}).idHotels;
        }
         
      });
    
    } catch(error){
      print(error);
    }
    

   if(isFavorite){
    
      int key=0, i=0;
      _listHotelId.forEach((element) async { 
        if(element == idHotel){
          key=i;
        }
        i++;
      });
      
      _listHotelId.removeAt(key);
      favorite = Favorite(id: userId, idHotels: _listHotelId);
     
    }else{
      
      log(_listHotelId.toString());
      _listHotelId.add(idHotel);
     
      favorite = Favorite(id: userId, idHotels: _listHotelId);
      
    }
    
    try{
      await httpFetch(
        '$databaseUrl/favorites/$k.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(
         favorite.toJson()
        ),
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
  
}