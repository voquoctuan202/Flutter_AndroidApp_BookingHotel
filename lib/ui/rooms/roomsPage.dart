import 'package:ct484_project/models/hotel.dart';
import 'package:ct484_project/ui/rooms/roomDetail.dart';
import 'package:ct484_project/ui/rooms/roomsManager.dart';
import 'package:ct484_project/ui/shared/fromBooking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/room.dart';

class RoomsPage extends StatefulWidget{
  const RoomsPage(this.hotel,{Key? key}): super(key:key);
  final Hotel hotel;
  static const routeName = '/rooms';

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
   late Future<void> _fetchRooms;
  @override
  void initState(){
    super.initState();
    _fetchRooms = context.read<RoomsManager>().fetchRooms();
    // RoomsManager().addRoom(
    //   Room(
    //     id: 'tsr12',
    //     idHotel: 'ts',
    //     typeRoom: '1',
    //     description: '1 giường đôi lớn & 1 giường sofa -Diện tích phòng: 50 m² - Không hút thuốc - Bếp nhỏ - Bồn tắm/vòi sen riêng - Wifi miễn phí',
       
    //     price: 883326,
    //     images:[
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/dfabc71d991d4f7d22fdfed1f7391a52.jpg?ce=0&s=1024x768",
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/ad42b229bc222612ba5a9efd0e96407e.jpg?ce=0&s=1024x768",
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/c5d29636bbec961fe6751ae19183a25c.jpg?ce=0&s=1024x768"
    //     ]
    //   ),
    // );
    // RoomsManager().addRoom(
    //    Room(
    //     id: 'tsr13',
    //     idHotel: 'ts',
    //     typeRoom: '1',
    //     description: '1 giường đôi lớn & 1 giường sofa -Diện tích phòng: 50 m² - Không hút thuốc - Bếp nhỏ - Bồn tắm/vòi sen riêng - Wifi miễn phí',
       
    //     price: 883326,
    //     images:[
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/dfabc71d991d4f7d22fdfed1f7391a52.jpg?ce=0&s=1024x768",
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/ad42b229bc222612ba5a9efd0e96407e.jpg?ce=0&s=1024x768",
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/c5d29636bbec961fe6751ae19183a25c.jpg?ce=0&s=1024x768"
    //     ]
    //   ),
    // );
    //     RoomsManager().addRoom(
    //    Room(
    //     id: 'tsr14',
    //     idHotel: 'ts',
    //     typeRoom: '1',
    //     description: '1 giường đôi lớn & 1 giường sofa -Diện tích phòng: 50 m² - Không hút thuốc - Bếp nhỏ - Bồn tắm/vòi sen riêng - Wifi miễn phí',
       
    //     price: 883326,
    //     images:[
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/dfabc71d991d4f7d22fdfed1f7391a52.jpg?ce=0&s=1024x768",
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/ad42b229bc222612ba5a9efd0e96407e.jpg?ce=0&s=1024x768",
    //         "https://pix8.agoda.net/hotelImages/33941483/695464520/c5d29636bbec961fe6751ae19183a25c.jpg?ce=0&s=1024x768"
    //     ]
    //   ),
    // );
    // RoomsManager().addRoom(
    //   Room(
    //     id: 'sshr2',
    //     idHotel: 'ssh',
    //     typeRoom: '2',
    //     description: '2 giường đôi tiêu chuẩn -Diện tích phòng: 33 m² - Phòng tắm vòi sen & bồn tắm - Wifi miễn phí',
       
    //     price: 2291000,
    //     images:[
    //         "https://pix8.agoda.net/hotelImages/2430159/-1/f4f61416c0b33749a2359317ea16c41b.jpg?ce=0&s=1024x768",
    //         "https://pix8.agoda.net/hotelImages/2430159/-1/ea4967029112803650aed61028ac328b.jpg?ce=0&s=1024x768",
    //         "https://q-xx.bstatic.com/xdata/images/hotel/max1024x768/365535026.jpg?k=929e2ebe6aab44e5f7c348e9b2eb9a95d473da915b7caf9b89fdd61f610ff503&o="
    //     ]
    //   )
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
        title: Text("Danh sách phòng", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
       
      ),
      body: FutureBuilder(
        future: _fetchRooms,
        builder: (context, snapshot){
          
          if(snapshot.connectionState == ConnectionState.done){
            return _listRooms();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ), 
     
     
    );
  }

  Widget _listRooms(){
 
 
   return Container(
    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
     child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Danh sách phòng ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold )),
            SizedBox(height: 15,),
            Container(
            height: 650,
            child: ListView(
             children: [
              _roomInfo("1"),
              _roomInfo("2"),
              _roomInfo("3"),
              
             ],
            ),
          )
             
          ],
        ),
   );
  }

  Widget _roomInfo(String type){
    Room? room = getRoomType(type,widget.hotel.id);
   
    return (room!= null && room.idHotel == widget.hotel.id ) ?
    GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(RoomsDetail.routeName, arguments: room);
      },
      child: AspectRatio(
      
        aspectRatio: 4/3.7,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 130,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 236, 236),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(room.images[0])
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
                width: double.infinity,
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Titlle

                    room.typeRoom == "1" ? Text("Phòng 2 người", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75) ),): Container(),
                    room.typeRoom == "2" ? Text("Phòng 4 người", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75) ),): Container(),
                    room.typeRoom == "3" ? Text("Phòng 6 người", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75) ),): Container(),
                    
                    // Description
                    Container(
                      alignment: Alignment.topLeft,
                      height: 70,
                      child: Text(room.description)
                    ),
                    // Price
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Giá: ${formatCurrency(room.price)} vnđ",
                        style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),  
                      )
                      
                    ),
                    // Button
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 5),
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.check, size: 22, color: Color.fromARGB(255, 3, 9, 75),),
                        onPressed: (){
                          Navigator.of(context).pushNamed(FormBooking.rootName, arguments: room);
                        }, 
                        label: Text("Đặt Phòng", style: TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(255, 3, 9, 75)),),
                      ),
                    )
                
                  ],
                  
                ),
              ),
            ] ,
          ),
        ),
        
        ),
    ) : Container();
  }

  Room? getRoomType(String type, String idHotel){
    RoomsManager _rooms = context.read<RoomsManager>();
    switch(type){
      case '1':{
        for(var room in _rooms.items){
          if(room.typeRoom == '1' && idHotel == room.idHotel){
            return room;
          }
        }
      }
      case '2': {
        for(var room in _rooms.items){
          if(room.typeRoom == '2' && idHotel == room.idHotel){
            return room;
          }
        }

      }
      case '3':{
        for(var room in _rooms.items){
          if(room.typeRoom == '3' && idHotel == room.idHotel){
            return room;
          }
        }
      }
      
    }
    return null;
  }
  String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###");
  return formatter.format(amount);
  }
}