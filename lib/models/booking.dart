class Booking {
    final String id;
    final String idHotel;
    final String idRoom;
    final String idUser;
   
    final String typeRoom;
    final int price;
    final String startDate;
    final String lastDate;
    String status;
    
    Booking({
      required  this.id,
      required this.idHotel,
      required this.idRoom,
      required this.idUser,
      
      required this.typeRoom,
      required this.price,
      required this.startDate,
      required this.lastDate,
      required this.status,
    });

    Booking copyWith({
      String? id,
      String? idHotel,
      String? idRoom,
      String? idUser,
      String? name,
      String? typeRoom,
      int? price,
      String? startDate,
      String? lastDate,
      String? status,
    }){
      return Booking(
        id: id ?? this.id,
        idHotel: idHotel ?? this.idHotel,
        idRoom: idRoom ?? this.idRoom,
        idUser: idUser ?? this.idUser,
        
        typeRoom: typeRoom ?? this.typeRoom,
        price: price ?? this.price,
        startDate: startDate ?? this.startDate,
        lastDate: lastDate ?? this.lastDate,
        status: status ?? this.status,
       
      );

    }
    void setStatus(String status){
      this.status = status;
    }

    Map<String, dynamic> toJson(){
      return {
        'id': id,
        'idHotel': idHotel,
        'idRoom': idRoom,
        'idUser': idUser,
        
        'typeRoom': typeRoom,
        'price': price,
        'startDate': startDate,
        'lastDate': lastDate,
        'status': status,
      };
    }

    static Booking fromJson(Map<String, dynamic> json) {
      return Booking(
        id: json['id'],
        idHotel: json['idHotel'],
        idRoom: json['idRoom'], 
        idUser: json['idUser'], 
       
        typeRoom: json['typeRoom'], 
        price: json['price'], 
        startDate: json['startDate'], 
        lastDate: json['lastDate'],
        status: json['status']
      );
    }
  }