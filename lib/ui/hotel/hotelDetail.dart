import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:ct484_project/models/hotel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../rooms/roomsManager.dart';
import '../rooms/roomsPage.dart';

class HotelDetail extends StatefulWidget{
  const HotelDetail(this.hotel,{Key? key}): super(key:key);
  static const routeName = '/hotel-detail';

  final Hotel hotel;
  
  @override
  State<HotelDetail> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<HotelDetail> {
  
  late Future<void> _fetchRooms;
  @override
  void initState(){
    super.initState();
  
    _fetchRooms = context.read<RoomsManager>().fetchRooms();
    
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
        title: Text("Thông tin khách sạn", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
        
       
      ),
      body: FutureBuilder(
        future: _fetchRooms,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
              return _hotelDetail();
            }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      )
     
    );
  }

  Widget _hotelDetail(){
    int min = context.read<RoomsManager>().getMinCost(widget.hotel.id);
    int max = context.read<RoomsManager>().getMaxCost(widget.hotel.id);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: AnotherCarousel(
              dotBgColor: const Color.fromARGB(0, 0, 0, 0),
              dotSize: 5,
              indicatorBgPadding: 5.0,
              images: [
                NetworkImage(widget.hotel.images[0]),
                NetworkImage(widget.hotel.images[1]),
                NetworkImage(widget.hotel.images[2]),
              ],
            ) ,
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Color.fromARGB(255, 3, 9, 75),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.hotel.name,style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75)),textAlign: TextAlign.left,),
                Container(
                      alignment: Alignment.topLeft,
                      
                      height: 50,
                      child: Row(children: [ 
                        Icon(Icons.location_on_rounded),
                        Container(
                          width: 330,
                          child: Text(widget.hotel.addrress, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),))])
                    ),
              ],
            ),
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Color.fromARGB(255, 3, 9, 75),
          ),
          Container(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.hotel.star,
              itemBuilder: (context, index){
                return Icon(Icons.star, color: Colors.amber,);
              }),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Text(widget.hotel.description),
              ],
            ),
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Color.fromARGB(255, 3, 9, 75),
          ),
          widget.hotel.parking? Container(
            alignment: Alignment.topLeft,
            height: 40,
            child: Row(children: [ 
              Icon(Icons.local_parking_rounded),
              Container(
                width: 330,
                child: Text("Có chỗ đậu xe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),))])
          ) : Container(),
          widget.hotel.elevator? Container(
            alignment: Alignment.topLeft,
            height: 40,
            child: Row(children: [ 
              Icon(Icons.expand),
              Container(
                width: 330,
                child: Text("Có thang máy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),))])
          ) : Container(),
         
          widget.hotel.breakfast? Container(
            alignment: Alignment.topLeft,
            height: 40,
            child: Row(children: [ 
              Icon(Icons.local_restaurant),
              Container(
                width: 330,
                child: Text("Miễn phí ăn sáng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),))])
          ) : Container(),
           Divider(
            height: 15,
            thickness: 1,
            color: Color.fromARGB(255, 3, 9, 75),
          ),
          Container(
              alignment: Alignment.topLeft,
              child: Text(
              "Giá: ${formatCurrency(min)} - ${formatCurrency(max)} vnđ",
                style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w500),  
              )
              
            ),
          SizedBox(height: 15,),
          ElevatedButton.icon(
            icon: Icon(Icons.menu, size: 22, color: Color.fromARGB(255, 3, 9, 75),),
            onPressed: (){
               Navigator.of(context).pushNamed(RoomsPage.routeName, arguments:widget.hotel);
            }, 
            label: Text("Chọn Phòng", style: TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(255, 3, 9, 75)),),
          ),


        ],
      ),
    );
  }
String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###");
  return formatter.format(amount);
  
}
  

}
