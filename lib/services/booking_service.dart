import 'dart:convert';
import 'dart:developer';

import '../models/auth_token.dart';
import '../models/booking.dart';
import 'firebase_service.dart';

class BookingService extends FirebaseService {
  BookingService([AuthToken? authToken]) : super(authToken);

  Future<List<Booking>> fetchBookings() async {
    final List<Booking> bookings = [];
    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // log(prefs.getString("userId")?? "rỗng");
   
    try{
      final bookingsMap = await httpFetch(
        '$databaseUrl/bookings.json?auth=$token',
      ) as Map<String, dynamic>;
       
     
      bookingsMap.forEach((bookungId,booking){
          
          bookings.add(
            Booking.fromJson({
              ...booking
            }) 

           
      );
          
      });
      
      return bookings;

    } catch(error){
      print(error);
      return bookings;
    }
  }
  Future<List<Booking>> fetchBookingsByID(String userId) async {
    final List<Booking> bookings = [];
    
    try{
      final bookingsMap = await httpFetch(
        '$databaseUrl/bookings.json?auth=$token',
      ) as Map<String, dynamic>;
       
     
      bookingsMap.forEach((bookungId,booking){
        if(userId == Booking.fromJson({...booking}).idUser )
          bookings.add(
            Booking.fromJson({
              ...booking
            }) 
           
      );
          
      });
      
      return bookings;

    } catch(error){
      print(error);
      return bookings;
    }
  }

  Future<String?> getKeyByID(String id) async{
    final bookingsMap = await httpFetch(
        '$databaseUrl/bookings.json?auth=$token',
      ) as Map<String, dynamic>;
    
    String? key;
    bookingsMap.forEach((bookingId,booking){
        Booking _booking = Booking.fromJson({
              ...booking
            });
        if(_booking.id == id){
          key = bookingId;
        }
    });
    return key;
  }
  Future<Booking?> addBooking(Booking booking) async {
    try{
      final newBooking = await httpFetch(
        '$databaseUrl/bookings.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
         booking.toJson()
          ..addAll({
            
          }),
        ),
      );
      return booking; 
    }catch (error){
      print(error);
      return null;
    }
  }
  Future<bool> updateBooking(Booking booking) async {
    String? key = await getKeyByID(booking.id!);
    log(booking.status);
    try{
      await httpFetch(
        '$databaseUrl/bookings/$key.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(
         booking.toJson()
        ),
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
  Future<bool> deleteBooking(String id) async {
    String? key = await getKeyByID(id);
    try{
      await httpFetch(
        '$databaseUrl/bookings/$key.json?auth=$token',
        method: HttpMethod.delete,
      );

      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
  
}