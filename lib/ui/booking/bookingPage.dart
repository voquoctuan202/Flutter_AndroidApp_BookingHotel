import 'package:ct484_project/models/booking.dart';
import 'package:ct484_project/ui/booking/bookingsManager.dart';
import 'package:ct484_project/ui/hotel/hotelsManager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../account/accountsManager.dart';

class BookingPage extends StatefulWidget{
  const BookingPage({Key? key}): super(key:key);
  static const routeName = '/bookings';

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
   late Future<void> _fetchBookings;
   late Future<void> _fetchUser;
  @override
  void initState(){
    super.initState();
    _fetchBookings = context.read<BookingsManager>().fetchBookingsByID();
    _fetchUser = context.read<AccountsManager>().fetchUser();
   
  }


  List<String> titles = [
    "Đã đặt",
    "Đã qua",
    "Đã hủy"
  ];
  int value =0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        
        
        backgroundColor:Color.fromARGB(255, 3, 9, 75) ,
        title: const Center(
          child: Text("Lịch đã đặt", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
        ),
      ),
      body: FutureBuilder(
        future: _fetchBookings,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return  FutureBuilder(
              future: _fetchUser,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return  _listBookings();
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
     
    );
  }

  Widget _listBookings(){
 
   return Container(
    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
     child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(titles[value], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold )),
                 PopupMenuButton(
                  icon: Icon(Icons.menu, color: Color.fromARGB(255, 3, 9, 75)),
                  itemBuilder: (context) =>[
                    const PopupMenuItem(
              
                      value: 0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            
                            
                            Icon(
                              Icons.access_time_filled_rounded
                            ),
                            SizedBox(width: 8,),
                            Text(
                              "Đang hoạt động",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                    ),
                    const PopupMenuItem(
                      
                      value: 1,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.timer_off
                            ),
                            SizedBox(width: 8,),
                            Text(
                              "Đã qua",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            
                           
                            Icon(
                              Icons.timer_off_outlined
                            ),
                             SizedBox(width: 8,),
                            Text(
                              "Đã hủy",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                    ),
                    
                  ],
                  onSelected: ( (int newValue) {
                    value = newValue;
                    setState(() {
                      
                    });
                  }),
                ),
              ],
            ),
           
            SizedBox(height: 5,),
            Consumer<BookingsManager>(
              builder: (ctx, _fetchBookings, child) {
                return Container(
                  height: 630,
                  child: ListView.builder(
                    itemCount: _fetchBookings.itemCount,
                    itemBuilder: (ctx, i){
                      return _bookingInfo(_fetchBookings.items[i]);
                    },
                  ),
                );
              }
            ),
            
            
            
          ],
        ),
   );
  }

  Widget _bookingInfo(Booking booking){
    
    return (booking.status == (value).toString()) ? 
      GestureDetector(
      onTap: (){
        //Navigator.of(context).pushNamed(RoomsPage.routeName);
      },
      child: AspectRatio(

        aspectRatio: 3/2.5,
        child: Container(
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
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
           
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    context.read<HotelsManager>().getName(booking.idHotel), 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color:Color.fromARGB(255, 3, 9, 75)), 
                    textAlign: TextAlign.left,)
                ),
                SizedBox(height: 5,),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Tên người đặt: ${context.read<AccountsManager>().getUser().fullname}", 
                    style: TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.w600, color:Color.fromARGB(255, 0, 0, 0)
                    )
                  )
                ),
                SizedBox(height: 5,),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Số điện thoại: ${context.read<AccountsManager>().getUser().phone}", 
                    style:const  TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.w600, color:Color.fromARGB(255, 0, 0, 0)
                    )
                  )
                ),
                SizedBox(height: 5,),
                 Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Email: ${context.read<AccountsManager>().getUser().email}", 
                    style:const  TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.w600, color:Color.fromARGB(255, 0, 0, 0)
                    )
                  )
                ),
                SizedBox(height: 5,),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Mã phòng: ${booking.idRoom}", 
                    style:const  TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.w600, color:Color.fromARGB(255, 0, 0, 0)
                    )
                  )
                ),
                SizedBox(height: 5,),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Ngày checkin: ${booking.startDate}", 
                    style: const TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.w600, 
                      color:Color.fromARGB(255, 0, 0, 0)), 
                  )
                ),
                SizedBox(height: 5,),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Ngày checkout: ${booking.lastDate}", 
                    style: const TextStyle(fontSize: 17, 
                    fontWeight: FontWeight.w600, 
                    color:Color.fromARGB(255, 0, 0, 0)), 
                  )
                ),
                SizedBox(height: 5,),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Giá tiền: ${formatCurrency(booking.price)} vnđ", 
                    style: const TextStyle(fontSize: 17, 
                    fontWeight: FontWeight.w600, 
                    color:Color.fromARGB(255, 0, 0, 0)), 
                  )
                ),
                SizedBox(height: 5,),
                (value==0) ?
                Container(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.highlight_remove_rounded, size: 22, color: Color.fromARGB(255, 141, 0, 0),),
                    onPressed: ()async{
                      // bool? check =await showConfirmDialog(context, "Bạn có muốn hủy lịch này?") ;
                      // if(check!){
                      //   await context.read<BookingsManager>().cancelBooking(booking);
                      //   setState(() {
                      //     _fetchBookings = context.read<BookingsManager>().fetchBookingsByID();
                      //   });
                      // }
                      await context.read<BookingsManager>().cancelBooking(booking);
                        setState(() {
                          _fetchBookings = context.read<BookingsManager>().fetchBookingsByID();
                        });
                     
                     
                    }, 
                    label: const Text("Hủy ", style: TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(255, 141, 0, 0)),),
                  ),
                ) 
                : 
                Container(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.highlight_remove_rounded, size: 22, color: Color.fromARGB(255, 141, 0, 0),),
                    onPressed: ()async{
                      await context.read<BookingsManager>().deleteBooking(booking.id);
                      setState(() {
                         _fetchBookings = context.read<BookingsManager>().fetchBookingsByID();
                      });
                     
                    }, 
                    label: const Text("Xóa ", style: TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(255, 141, 0, 0)),),
                  ),
                ),

                
              ]),
          ),
        ),
        
        ),
    )
    : Container();
  }
    String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###");
  return formatter.format(amount);
  }

 

}
