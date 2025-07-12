
class Favorite{
  final String id;
  late final List<dynamic> idHotels; 

  Favorite({
    required this.id,
    required this.idHotels,
   
  });


  Favorite copyWith({
    String? id,
    List<dynamic>? idHotels
  }){
    return Favorite(
      id: id ?? this.id, 
      idHotels: idHotels ?? this.idHotels
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'idHotels': idHotels
    };
  }

  static Favorite fromJson(Map<String, dynamic> json){
    List<dynamic> hotels = json['idHotels'] ?? [];
    return Favorite(
      id: json['id'], 
      idHotels: hotels,
    );
  }
}