


class Hotel{

  final String id;
  final String name;
  final String description;
  final String addrress;
  
  final int star;
  final bool parking;
  final bool elevator;
  final bool breakfast;
  final List<dynamic> images;
  final String city;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.addrress,
   
    required this.star,
    required this.parking,
    required this.elevator,
    required this.breakfast,
    required this.images,
    required this.city,
   
  });

  Hotel copyWith({
    String? id,
    String? name,
    String? addrress,
    String? description,
  
    int? star,
    bool? parking,
    bool? elevator,
    bool? breakfast,
    String? city,
    List<String>? images,
   
  }){
    return Hotel(
      id: id ?? this.id, 
      name: name ?? this.name, 
      addrress: addrress ?? this.addrress, 
      description: description ?? this.description, 
     
      star: star ?? this.star,
      parking: parking ?? this.parking,
      elevator: elevator?? this.elevator,
      breakfast: breakfast ?? this.breakfast,
      city: city ?? this.city, 
      images: images ?? this.images,
     
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name, 
      'description': description, 
      'addrress': addrress, 
     
      'star': star,
      'parking': parking,
      'elevator': elevator,
      'breakfast': breakfast,
      'city': city, 
      'images': images
      
    };
  }

  static Hotel fromJson(Map<String, dynamic> json){
    List<dynamic> images = json['images'];
    return Hotel(
      id: json['id'], 
      name: json['name'], 
      description: json['description'], 
      addrress: json['addrress'], 
      
      star: json['star'], 
      parking: json['parking'], 
      elevator: json['elevator'], 
      breakfast: json['breakfast'], 
      city: json['city'], 
      images: images
    );
  }


}