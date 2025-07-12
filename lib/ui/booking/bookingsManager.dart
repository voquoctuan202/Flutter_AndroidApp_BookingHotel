

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth_token.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';

class BookingsManager with ChangeNotifier{
  List<Booking> _items = [
    //  Booking(
    //     id: "1",
    //     idRoom: "r1",
    //     idUser: "456",
    //     typeRoom: "Phòng 1 giường 2 người",
    //     price: 400000,
    //     startDate: "28/05/2024",
    //     lastDate: "29/05/2024",
    //     status: "1"
    //   ),
    //   Booking(
    //     id: "1",
    //     idRoom: "r2",
    //     idUser: "123",
    //     typeRoom: "Phòng 1 giường 2 người",
    //     price: 400000,
    //     startDate: "28/05/2024",
    //     lastDate: "29/05/2024",
    //     status: "2"
    //   ),
    //   Booking(
    //     id: "1",
    //     idRoom: "r3",
    //     idUser: "u1",
    //     typeRoom: "Phòng 1 giường 2 người",
    //     price: 400000,
    //     startDate: "28/05/2024",
    //     lastDate: "29/05/2024",
    //     status: "3"
    //   )
    ];

  final BookingService _bookingService;

  BookingsManager([AuthToken? authToken])
    :_bookingService = BookingService(authToken);
  
  set authToken(AuthToken? authToken){
    _bookingService.authToken = authToken;
  }

   Future<void> fetchBookings() async {
    _items = await _bookingService.fetchBookings();
    notifyListeners();
  }
   Future<void> fetchBookingsByID() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance() ;
    String? userId = prefs.getString("userId");
    
    _items = await _bookingService.fetchBookingsByID(userId!);
    await loadAfterBooking();
    notifyListeners();
  }

  Future<void> addBooking(Booking booking) async {
    final newBooking = await _bookingService.addBooking(booking);

    if(newBooking != null){
      _items.add(newBooking);
      notifyListeners();
    }
  }

  Future<void> updateBooking(Booking booking) async {
    final index = _items.indexWhere((item) => item.id == booking.id);
    if(index >= 0){
      if(await _bookingService.updateBooking(booking)){
        _items[index] = booking;
        notifyListeners();
      }
      
    }
  }
  Future<void> deleteBooking(String id) async {
    await _bookingService.deleteBooking(id);
  }
  
  Future<void> loadAfterBooking() async{
    DateTime now = DateTime.now();
    
    _items.forEach((element) async { 
      DateTime date = DateFormat('dd/MM/yyyy').parse(element.lastDate);
      if(now == date || now.isAfter(date)){
        await SetAfterBooking(element);
      }
    });
  }
  
  int get itemCount {
    return _items.length;
  }

  List<Booking> get items {
    return [..._items];
  }

  String getIdRoomPossible(List<String> listIdRoom,String idHotel,String start, String end){
    for (var idRoom in listIdRoom) { 
      bool check = true;
      
      _items.forEach((booking) { 
        log("$idRoom - ${booking.idRoom}");
        if(idHotel==booking.idHotel && idRoom == booking.idRoom && !CheckDayPossible(start,end, booking.startDate, booking.lastDate)){
          check = false;
        }
      });
      if(check) {
        return idRoom;
      }
    }
    
    return "null";
  }

  bool CheckDayPossible(String start1,String end1,String start2, String end2){
    bool check= false;
    DateTime start = parseDateString(start1);
    DateTime end = parseDateString(end1);
    DateTime startB = parseDateString(start2);
    DateTime endB = parseDateString(end2);

    bool condition1 = (start.isAfter(endB) || start == endB) ; 
    bool condition2 = (end.isBefore(startB) || end == startB);
    if(condition1 || condition2){
      check = true;
    }
    return check;
  }
 
  Future<void> cancelBooking(Booking booking)async{
    booking.status = "2";
    log("run cancel ${booking.id}");
    await _bookingService.updateBooking(booking);
  }
  Future<void> SetAfterBooking(Booking booking)async{
    booking.status = "1";
   
    await _bookingService.updateBooking(booking);
  }
  DateTime parseDateString(String dateString) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.parse(dateString);
  }

  get length => null;
  Booking? findById(String id){
    try{
        return _items.firstWhere((item) => item.id == id);
    }catch (error){
        return null;
    }
  }
}
 