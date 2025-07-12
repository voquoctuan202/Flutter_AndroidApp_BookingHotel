import 'dart:convert';

import '../models/auth_token.dart';
import '../models/hotel.dart';
import 'firebase_service.dart';

class HotelService extends FirebaseService {
  HotelService([AuthToken? authToken]) : super(authToken);

  Future<List<Hotel>> fetchHotels() async {
    final List<Hotel> hotels = [];
    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // log(prefs.getString("userId")?? "rỗng");
    try{
      final hotelsMap = await httpFetch(
        '$databaseUrl/hotels.json?auth=$token',
      ) as Map<String, dynamic>;
      
     
      hotelsMap.forEach((hotelId,hotel){
          hotels.add(
            Hotel.fromJson({
              ...hotel
            })
           
      );
          
      });
     
      return hotels;

    } catch(error){
      print(error);
      return hotels;
    }
  }
  Future<String?> getKeyByID(String id) async{
    final hotelsMap = await httpFetch(
        '$databaseUrl/hotels.json?auth=$token',
      ) as Map<String, dynamic>;
    
    String? key;
    hotelsMap.forEach((hotelId,hotel){
        Hotel _hotel = Hotel.fromJson({
              ...hotel
            });
        if(_hotel.id == id){
          key = hotelId;
        }
    });
    return key;
  }

  Future<Hotel?> addHotel(Hotel hotel) async {
    try{
      final newHotel = await httpFetch(
        '$databaseUrl/hotels/.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
         hotel.toJson()
          
        ),
      ) as Map<String, dynamic>?;

      return hotel; 
    }catch (error){
      print(error);
      return null;
    }
  }
  Future<bool> updateHotel(Hotel hotel) async {
    String? key = await getKeyByID(hotel.id);
    try{
      await httpFetch(
        '$databaseUrl/hotels/$key.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(
         hotel.toJson()
        ),
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
  Future<bool> deleteHotel(String id) async {
    String? key = await getKeyByID(id);
    try{
      await httpFetch(
        '$databaseUrl/hotels/$key.json?auth=$token',
        method: HttpMethod.delete,
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
}