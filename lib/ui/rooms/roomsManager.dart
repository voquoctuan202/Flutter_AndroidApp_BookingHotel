import 'package:flutter/material.dart';

import '../../models/auth_token.dart';
import '../../models/room.dart';
import '../../services/room_service.dart';


class RoomsManager with ChangeNotifier {
  List<Room> _items = [];
  
  final RoomService _roomService;

  RoomsManager([AuthToken? authToken])
    :_roomService = RoomService(authToken);
  
  set authToken(AuthToken? authToken){
    _roomService.authToken = authToken;
  }

  Future<void> fetchRooms() async {
    _items = await _roomService.fetchRooms();
    notifyListeners();
  }

  Future<void> addRoom(Room room) async {
    final newRoom = await _roomService.addRoom(room);

    if(newRoom != null){
      _items.add(newRoom);
      notifyListeners();
    }
  }

  Future<void> updateHotel(Room room) async {
    final index = _items.indexWhere((item) => item.id == room.id);
    if(index >= 0){
      if(await _roomService.updateRoom(room)){
        _items[index] = room;
        notifyListeners();
      }
      
    }
  }

  int getMinCost(String hotelId){
    int min =10000000000;
    items.forEach((element) {
      if(element.idHotel == hotelId && min>element.price){
        min = element.price;
      }
    });
    return min;

  }
  int getMaxCost(String hotelId){
    int max =0;
    items.forEach((element) {
      if(element.idHotel == hotelId && max<element.price){
        max = element.price;
      }
    });
    return max;

  }
  List<String> getListIdRoomByType(String type, String idHotel){
    List<String> _listRoom = [];
    _items.forEach((element) { 
      if(element.typeRoom == type && element.idHotel == idHotel) _listRoom.add(element.id!);
    });
    return _listRoom;

  }

  Future<void> deleteRoom(String id) async {
    
    final index = _items.indexWhere((item) => item.id == id);
    Room? existingRoom = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if(!await _roomService.deleteRoom(id)){
      _items.insert(index, existingRoom);
      notifyListeners();
    }
      
    
  }
 
  int get itemCount {
    return _items.length;
  }

  List<Room> get items {
    return [..._items];
  }

  String getIdHotel(String idRoom){
    for (var element in _items) { 
      if(idRoom == element.id){
        return element.idHotel;
      }
    }
    return "Không tìm thấy IdHotel";
  }


  get length => null;
  Room? findById(String id){
    try{
        return _items.firstWhere((item) => item.id == id);
    }catch (error){
        return null;
    }
  }
}
