 // import 'dart:ffi';



class Room {
    final String? id;
    final String idHotel;
    final String description;
    final String typeRoom;
   
    final int price;
    final List<dynamic> images;
   

    Room({
      this.id,
      required this.idHotel,
      required this.description,
      
      required this.typeRoom,
      required this.price,
      required this.images,
     
    });

    

    Room copyWith({
      String? id,
      String? idHotel,
      String? description,
      String? typeRoom,
     
      int? price,
      List<String>? images,
      
    }){
      return Room(
        id: id ?? this.id,
        idHotel: idHotel ?? this.idHotel, 
        description: description ?? this.description, 
       
        typeRoom: typeRoom ?? this.typeRoom,
        price: price ?? this.price, 
        images: images ?? this.images,
        
      );

    }

    Map<String, dynamic> toJson(){
      return {
        'id': id,
        'idHotel': idHotel,
        'description': description,
        
        'typeRoom': typeRoom,
        'price': price,
        'images': images,
      };
    }

    static Room fromJson(Map<String, dynamic> json) {
      List<dynamic> images = json['images'];
      return Room(
        id: json['id'],
        idHotel: json['idHotel'], 
        description: json['description'], 
        
        typeRoom: json['typeRoom'],
        price: json['price'], 
        images: images
      );
    }
  }