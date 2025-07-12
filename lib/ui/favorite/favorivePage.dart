
import 'package:ct484_project/ui/favorite/favoriteManager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../rooms/roomsManager.dart';
import '/../../models/hotel.dart';
import '/../../ui/hotel/hotelDetail.dart';
import '/../../ui/rooms/roomsPage.dart';

class FavoritePage extends StatefulWidget{
  const FavoritePage({Key? key}): super(key:key);
 

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<void> _fetchFavorite;
  @override
  void initState(){
    super.initState();
    _fetchFavorite = context.read<FavoriteManager>().getListHotel();
    
    
    
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        
        backgroundColor:Color.fromARGB(255, 3, 9, 75) ,
        title: const Center(
          child: Text("Yêu thích", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold, fontSize: 20),),
        ),
      ),
      body: FutureBuilder(
        future: _fetchFavorite,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return  _listHotels();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ), 
     
    );
  }

  Widget  _listHotels(){
 
  //log(_hotels.items[1].title.toString());
   return Container(
    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
     child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Danh sách yêu thích", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold )),
            SizedBox(height: 15,),
            Consumer<FavoriteManager>(
              builder: (ctx, _fetchFavorite, child) {
                return Container(
                  height: 630,
                  child: ListView.builder(
                    itemCount: _fetchFavorite.itemCount,
                    itemBuilder: (ctx, i){
                      return _hotelInfo(_fetchFavorite.items[i]);
                    },
                  ),
                );
              }
            )
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
  String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###");
  return formatter.format(amount);
  
}
}
