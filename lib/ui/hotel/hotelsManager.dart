import 'dart:developer';

import 'package:ct484_project/models/hotel.dart';
import 'package:flutter/material.dart';

import '../../models/auth_token.dart';
import '../../services/hotel_service.dart';


class HotelsManager with ChangeNotifier {
  List<Hotel> _items = [
      
    ];

  final HotelService _hotelService;

  HotelsManager([AuthToken? authToken])
    :_hotelService = HotelService(authToken);
  
  set authToken(AuthToken? authToken){
    _hotelService.authToken = authToken;
  }

   Future<void> fetchHotels() async {
    _items = await _hotelService.fetchHotels();
    notifyListeners();
  }




  Future<void> getKeyByID(String id) async {
    final key = await _hotelService.getKeyByID(id);
    log(key.toString());
  }

  Future<void> addHotel(Hotel hotel) async {
    final newHotel = await _hotelService.addHotel(hotel);

    if(newHotel != null){
      _items.add(newHotel);
      notifyListeners();
    }
  }

  Future<void> updateHotel(Hotel hotel) async {
    final index = _items.indexWhere((item) => item.id == hotel.id);
    if(index >= 0){
      if(await _hotelService.updateHotel(hotel)){
        _items[index] = hotel;
        notifyListeners();
      }
      
    }
  }
  Future<void> deleteHotel(String id) async {
    
    final index = _items.indexWhere((item) => item.id == id);
    Hotel? existingHotel = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if(!await _hotelService.deleteHotel(id)){
      _items.insert(index, existingHotel);
      notifyListeners();
    }
      
    
  }

  int get itemCount {
    return _items.length;
  }

  List<Hotel> get items {
    return [..._items];
  }

  String getAddress(String idHotel){
    String addrress = "";
    items.forEach((element) { 
      if(element.id == idHotel){
        addrress = element.addrress;
      }
    });
    return addrress;
  }
  String getName(String idHotel){
    String name = "";
    items.forEach((element) { 
      if(element.id == idHotel){
        name = element.name;
      }
    });
    return name;
  }


  get length => null;
  Hotel? findById(String id){
    try{
        return _items.firstWhere((item) => item.id == id);
    }catch (error){
        return null;
    }
  }

  // void addProduct(Product product) {
  //   _items.add(
  //     product.copyWith(
  //       id: 'p${DateTime.now().toIso8601String()}',
  //     )
  //   );
  //   notifyListeners();
  // }
  // Future<void> updateProduct(Product product) async {
  //   final index = _items.indexWhere((item) => item.id == product.id);
  //   if(index >= 0){
  //     if(await _productsService.updateProduct(product)){
  //       _items[index] = product;
  //       notifyListeners();
  //     }
      
  //   }
  // }
  // Future<void> deleteProduct(String id) async {
    
  //   final index = _items.indexWhere((item) => item.id == id);
  //   Product? existingProduct = _items[index];
  //   _items.removeAt(index);
  //   notifyListeners();

  //   if(!await _productsService.deleteProduct(id)){
  //     _items.insert(index, existingProduct);
  //     notifyListeners();
  //   }
      
    
  // }
 
  // void toggleFavoriteStatus(Product product){
  //   final savedStatus = product.isFavorite;
  //   product.isFavorite = !savedStatus;
  // }
  





}
// Product(
//       id: 'p1',
//       title: 'Red Shirt',
//       description: 'A red shirt - it is pretty red!',
//       price: 29.99,
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//       isFavorite: true,
//     ),
//     Product(
//       id: 'p2',
//       title: 'Trousers',
//       description: 'A nice pair of trousers.',
//       price: 59.99,
//       imageUrl:
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//     ),
//     Product(
//       id: 'p3',
//       title: 'Yellow Scarf',
//       description: 'Warm and cozy - exactly what you need for the winter.',
//       price: 19.99,
//       imageUrl:
//           'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//     ),
//     Product(
//       id: 'p4',
//       title: 'A Pan',
//       description: 'Prepare any meal you want.',
//       price: 49.99,
//       imageUrl:
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//       isFavorite: true,
//     ),