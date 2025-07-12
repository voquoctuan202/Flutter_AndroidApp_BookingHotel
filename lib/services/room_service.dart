import 'dart:convert';
import 'dart:developer';


import '../models/auth_token.dart';
import '../models/room.dart';
import 'firebase_service.dart';

class RoomService extends FirebaseService {
  RoomService([AuthToken? authToken]) : super(authToken);

  Future<List<Room>> fetchRooms() async {
    final List<Room> rooms = [];
  
    try{
      final roomsMap = await httpFetch(
        '$databaseUrl/rooms.json?auth=$token',
      ) as Map<String, dynamic>;
      
      roomsMap.forEach((roomId,room){
          rooms.add(
            Room.fromJson({
              ...room
            })
           
      );
          
      });
      log(rooms.toString());
      return rooms;

    } catch(error){
      print(error);
      return rooms;
    }
  }

  Future<String?> getKeyByID(String id) async{
    final roomsMap = await httpFetch(
        '$databaseUrl/rooms.json?auth=$token',
      ) as Map<String, dynamic>;
    
    String? key;
    roomsMap.forEach((roomId,room){
        Room _room = Room.fromJson({
              ...room
            });
        if(_room.id == id){
          key = roomId;
        }
    });
    return key;
  }

  Future<Room?> addRoom(Room room) async {
    try{
      final newRoom = await httpFetch(
        '$databaseUrl/rooms.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
         room.toJson()
          ..addAll({
          }),
        ),
      ) as Map<String, dynamic>?;
      return room; 
    }catch (error){
      print(error);
      return null;
    }
  }
  Future<bool> updateRoom(Room room) async {
    String? key = await getKeyByID(room.id!);
    try{
      await httpFetch(
        '$databaseUrl/rooms/$key.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(
         room.toJson()
        ),
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }

  Future<bool> deleteRoom(String id) async {
    String? key = await getKeyByID(id);
    try{
      await httpFetch(
        '$databaseUrl/rooms/$key.json?auth=$token',
        method: HttpMethod.delete,
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
  Future<int> getMinCost(String hotelId)async{
    final List<Room> rooms = [];
  
    try{
      final roomsMap = await httpFetch(
        '$databaseUrl/rooms.json?auth=$token',
      ) as Map<String, dynamic>;
      
      roomsMap.forEach((roomId,room){
        if(hotelId == Room.fromJson({...room}).idHotel) {
          rooms.add(
            Room.fromJson({...room})
        ); 
        }
            
      });
      log(rooms.toString());
    } catch(error){
      print(error);
    }

    int min =0;
    rooms.forEach((element) { 
      if(min <= element.price) min = element.price;
    });
    return min;

  }
}