
import 'dart:developer';

import 'package:ct484_project/models/hotel.dart';
import 'package:ct484_project/ui/favorite/favoriteManager.dart';
import 'package:ct484_project/ui/hotel/hotelDetail.dart';
import 'package:ct484_project/ui/hotel/hotelsManager.dart';
import 'package:ct484_project/ui/rooms/roomsManager.dart';
import 'package:ct484_project/ui/rooms/roomsPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HotelsPage extends StatefulWidget{
  const HotelsPage(this.city,{Key? key}): super(key:key);
  static const routeName = '/hotels';
  final city;

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  late Future<void> _fetchHotels;
  late Future<void> _fetchFavorite;
  late Future<void> _fetchRooms;
  
  
  @override
  void initState(){
    super.initState();
    
    _fetchHotels = context.read<HotelsManager>().fetchHotels();
    _fetchFavorite = context.read<FavoriteManager>().getListHotel();
    _fetchRooms = context.read<RoomsManager>().fetchRooms();
    // HotelsManager().addHotel(
    //   Hotel(
    //     id: "vinf", 
    //     name: "Vinholidays Fiesta Phú Quốc", 
    //     description: "Nằm ở vị trí trung tâm tại Gành Dầu của Đảo Phú Quốc, chỗ nghỉ này đặt quý khách ở gần các điểm thu hút và tùy chọn ăn uống thú vị. ", 
    //     addrress: "Ganh Dau, Gành Dầu, Đảo Phú Quốc, Việt Nam", 
        
    //     star: 4, 
    //     parking: true, 
    //     elevator: true, 
    //     breakfast: true, 
    //     images: [
    //       "https://pix8.agoda.net/hotelImages/17242876/-1/77f13db2325ef043d92a740cc551e1f8.jpg?ca=19&ce=1&s=1024x768",
    //       "https://pix8.agoda.net/hotelImages/17242876/-1/579ae9b69226bb6b6d21559c84e85cbc.jpg?ca=19&ce=1&s=1024x768",
    //       "https://q-xx.bstatic.com/xdata/images/hotel/max1024x768/268509239.jpg?k=4900badb5ce4b5b67b2dab0110d8e3db32da5a1980a6b92a4aeb74e7714569bc&o="
    //     ], 
    //     city: "phu quoc"
    //     )

    // );
    // HotelsManager().addHotel(
    //   Hotel(
    //     id: "ssh", 
    //     name: "Seashells Hotel & Spa Phú Quốc", 
    //     description: " Nằm ở vị trí chiến lược tại Dương Đông, cho phép quý khách lui tới và gần với các điểm thu hút và tham quan địa phương.", 
    //     addrress: "Vo Thi Sau, Dương Đông, Đảo Phú Quốc", 
        
    //     star: 5, 
    //     parking: true, 
    //     elevator: true, 
    //     breakfast: true, 
    //     images: [
    //       "https://pix8.agoda.net/hotelImages/2430159/-1/147856f2f4b8df2d4dd4a90a1c0841d2.jpg?ce=0&s=1024x768",
    //       "https://pix8.agoda.net/hotelImages/2430159/-1/43d426cc151661a5ec7504d736f8e0ab.jpg?ce=0&s=1024x768",
    //       "https://pix8.agoda.net/hotelImages/2430159/-1/f2e42b36e1c2476e06a134bc86c7ba33.jpg?ce=0&s=1024x768"
    //     ], 
    //     city: "phu quoc"
    //     )

    // );
  }
 
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,),
          onPressed: (){
            Navigator.of(context)
                .pop();
          },),
        backgroundColor:Color.fromARGB(255, 3, 9, 75) ,
        title:  Text("Danh sách khách sạn", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
        ),
        
      ),
      body: FutureBuilder(
        future: _fetchHotels,
        builder: (context, snapshot){
            
          if(snapshot.connectionState == ConnectionState.done){
            return   _listHotels();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      );
     
     
  
  }

  Widget _listHotels() {
  
  //log(_hotels.items[1].title.toString());
   return  Container(
        
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
         child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Danh sách khách sạn  ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold )),
                SizedBox(height: 15,),
                FutureBuilder(
                  future: _fetchRooms,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      return FutureBuilder(
                        future: _fetchFavorite,
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            return Consumer<HotelsManager>(
                              builder: (ctx, _fetchHotels, child) {
                                return Container(
                                  height: 650,
                                  child: ListView.builder(
                                    itemCount: _fetchHotels.itemCount,
                                    itemBuilder: (ctx, i){
                                      return compareIgnoreCase(widget.city, _fetchHotels.items[i].city )? _hotelInfo(_fetchHotels.items[i]): Container();
                                    },
                                  ),
                                );
                              }
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                
              ],
            ),
       );
   
  }

  Widget _hotelInfo(Hotel hotel)  {
 
    bool isFavorite = context.read<FavoriteManager>().isFavorite(hotel.id);
    int min = context.read<RoomsManager>().getMinCost(hotel.id);
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(HotelDetail.routeName, arguments: hotel);
        
      },
      child: AspectRatio(
      
        aspectRatio: 3/2,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.5), 
                spreadRadius: 1, 
                blurRadius: 1, 
                offset: Offset(0, 2), 
              )],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 170,
                height: 300,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 236, 236),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(hotel.images[0])
                  ),
                  boxShadow: [BoxShadow(
                    color: Colors.grey.withOpacity(0.3), 
                    spreadRadius: 1, 
                    blurRadius: 1, 
                    offset: Offset(0, 1), 
                  )],
                )
              ),
              Container(
                padding: EdgeInsets.only(left: 10,top : 10),
                alignment: Alignment.topLeft,
                width: 210,
                height: 270,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Titlle
                    Text(hotel.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75) ),),
                    //Star
                    Container(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotel.star,
                        itemBuilder: (context, index){
                          return Icon(Icons.star, color: Colors.amber,);
                        }),
                    ),
                    
                   
                    //addrress
                    Container(
                      alignment: Alignment.topLeft,
                      
                      height: 70,
                      child: Row(children: [ 
                        Icon(Icons.location_on_rounded),
                        Container(
                          width: 170,
                          child: Text(hotel.addrress))])
                    ),
                    // Price
                    SizedBox(height: 8,),
                    Container(
                      height: 20
                      ,
                      alignment: Alignment.topLeft,
                      child: Text(
                      "Giá: ${formatCurrency(min)} vnđ",
                        style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w500),  
                      )
                      
                    ),
                    // Button
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 0),
                      alignment: Alignment.bottomRight,
                      child: Row(
                        children:<Widget>[ 
                          IconButton(
                            onPressed: ()async {
                              await context.read<FavoriteManager>().updateFavorite(
                               context.read<FavoriteManager>().isFavorite(hotel.id), 
                                hotel.id
                              );
                              setState(() {
                                isFavorite = !isFavorite;
                                log(isFavorite.toString());
                              });
                              
                            }, 
                            icon: isFavorite
                            ? Icon(Icons.favorite_rounded, size: 22, color: Colors.red,)
                            : Icon(Icons.favorite_border_rounded, size: 22, color: Colors.red,),
                          ),
                          SizedBox(width: 5,),
                          ElevatedButton.icon(
                            icon: Icon(Icons.menu, size: 22, color: Color.fromARGB(255, 3, 9, 75),),
                            onPressed: (){
                              Navigator.of(context).pushNamed(RoomsPage.routeName, arguments: hotel);
                            }, 
                            label: Text("Xem phòng", style: TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(255, 3, 9, 75)),),
                          ),
                        ]
                      ),
                    )
                
                  ],
                  
                ),
              ),
            ] ,
          ),
        ),
        
        ),
    );
  }
  
  
 bool compareIgnoreCase(String str1, String str2) {
  return str1.toLowerCase() == str2.toLowerCase();
}
String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###");
  return formatter.format(amount);
  
}
}
