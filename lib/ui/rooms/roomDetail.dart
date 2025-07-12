import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/room.dart';
import '../shared/fromBooking.dart';

class RoomsDetail extends StatefulWidget{
  const RoomsDetail(this.room,{Key? key}): super(key:key);
  static const routeName = '/room-detail';

  final Room room;
  
  @override
  State<RoomsDetail> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsDetail> {
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
        title: Text("Thông tin phòng", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
        
       
      ),
      body: _roomDetail()
     
    );
  }

  Widget _roomDetail(){
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
                NetworkImage(widget.room.images[0]),
                NetworkImage(widget.room.images[1]),
                NetworkImage(widget.room.images[2]),
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
                widget.room.typeRoom == "1" ? Text("Phòng 2 người", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75) ),): Container(),
                widget.room.typeRoom == "2" ? Text("Phòng 4 người", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75) ),): Container(),
                widget.room.typeRoom == "3" ? Text("Phòng 6 người", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75) ),): Container(),
                    
              ],
            ),
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
                 Text(widget.room.description),
              ],
            ),
            
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
                 Text("Giá: ${formatCurrency(widget.room.price)} vnđ",style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500)),
              ],
            ),
            
          ),
          
          ElevatedButton.icon(
            icon: Icon(Icons.check, size: 22, color: Color.fromARGB(255, 3, 9, 75),),
            onPressed: (){

             Navigator.of(context).pushNamed(FormBooking.rootName, arguments: widget.room);
            }, 
            label: Text("Đặt Phòng", style: TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(255, 3, 9, 75)),),
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