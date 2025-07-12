import 'dart:developer';

import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/ui/booking/bookingsManager.dart';
import 'package:ct484_project/ui/hotel/hotelsManager.dart';
import 'package:ct484_project/ui/rooms/roomsManager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/booking.dart';
import '../../models/room.dart';
import '../account/accountsManager.dart';
import 'dialog_utils.dart';


class FormBooking extends StatefulWidget{
  
  const FormBooking(this.room,{Key? key}): super(key:key);
  static const rootName = "/formBooking";

  final Room room; 
 

  @override
  State<FormBooking> createState() => _FormBookingState();
}

class _FormBookingState extends State<FormBooking> {

 
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstDate = TextEditingController();
  TextEditingController lastDate = TextEditingController();
  String valueChoose ="Phòng 1 giường 2 người";
  int price =0;
  List listItem =[
    "Phòng 1 giường 2 người",
    "Phòng 2 giường 4 người",
    "Phòng 3 người 6 người",
  ];

  late Future<void> _fetchBookings;
  late Future<void> _fetchUser;
  @override
  void initState(){
    super.initState();
    _fetchBookings = context.read<BookingsManager>().fetchBookings();
    _fetchUser = context.read<AccountsManager>().fetchUser();
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
        title: Text("Đặt phòng", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
        
      ),
      body: Container(
       
        padding: EdgeInsets.all(10),
        
        child: FutureBuilder(
        future: _fetchUser,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return FutureBuilder(
              future: _fetchBookings,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return formBooking();
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
      )

    );
  }

  Widget formBooking(){
    User user = context.read<AccountsManager>().item;
    final String addrress = context.read<HotelsManager>().getAddress(widget.room.idHotel); 
    final String name= context.read<HotelsManager>().getName(widget.room.idHotel); 
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Thông tin đặt phòng",style: TextStyle(color: Color.fromARGB(255, 3, 9, 75), fontWeight: FontWeight.bold, fontSize: 25),),
        Divider(
          height: 15,
          thickness: 1,
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Tên: $name",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500, fontSize: 18))
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Địa chỉ: $addrress",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500, fontSize: 18))
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Số ngày: ${countDaysBetweenDates(firstDate.text, lastDate.text)} ngày ${countDaysBetweenDates(firstDate.text, lastDate.text)==0 ? 0 :countDaysBetweenDates(firstDate.text!, lastDate.text!)- 1} đêm",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500, fontSize: 18))
        ),
        Divider(
          height: 15,
          thickness: 1,
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Họ tên khách: ${user.fullname} ",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500, fontSize: 18))
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Số điện thoại: ${user.phone}",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500, fontSize: 18))
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Email: ${user.email}",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500, fontSize: 18))
        ),
        Divider(
          height: 15,
          thickness: 1,
        ),
         
        const SizedBox(height: 4),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Ngày đi: ",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500, fontSize: 15))
        ),
        const SizedBox(height: 4),
        _datePick("Chọn ngày đi",firstDate, true ),
        const SizedBox(height: 4),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Ngày về: ",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500, fontSize: 15))
        ),
        const SizedBox(height: 4),
        _datePick("Chọn ngày về",lastDate, false ),
        const SizedBox(height: 10),
        Text(
          "Giá: ${formatCurrency(price)} vnđ",
            style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.w500),  
          ),
          const SizedBox(height: 10),
        _booking()

      ],
    );
  }


  Widget _inputText(String title, TextEditingController controller){
    var border = OutlineInputBorder(
    
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0))
    );
    return TextField(  
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
        hintText: title,
        hintStyle: const TextStyle(color: Color.fromARGB(139, 0, 0, 0)),
        enabledBorder: border,
        focusedBorder: border, 
      ),
    );
  }

   Widget _booking() {
    return ElevatedButton(
      onPressed: ()async{
        List<String> listIdRoom = context.read<RoomsManager>().getListIdRoomByType(widget.room.typeRoom, widget.room.idHotel);
        String idRoomPossible = context.read<BookingsManager>().getIdRoomPossible(listIdRoom, widget.room.idHotel, firstDate.text, lastDate.text);
        
        log(idRoomPossible);
        if(idRoomPossible !='null'){
          SharedPreferences prefs =  await SharedPreferences.getInstance() ;
          String? userId = prefs.getString("userId");
          
          Booking booking = Booking(
            id: 'p${DateTime.now().toIso8601String()}',
            idHotel: widget.room.idHotel, 
            idRoom: idRoomPossible, 
            idUser: userId!, 
            typeRoom: widget.room.typeRoom, 
            price: widget.room.price * countDaysBetweenDates(firstDate.text, lastDate.text), 
            startDate: firstDate.text, 
            lastDate: lastDate.text, 
            status: "0"
          );
          
          await BookingsManager().addBooking(booking);
          Navigator.of(context)
          .popUntil((route) => route.isFirst);
        }else{
           final snackBar = SnackBar(content: Text('Phòng đang tạm hết!!!'));  
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        
      
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 3, 9, 75),
        shape: const StadiumBorder(),
        primary: Color.fromARGB(255, 228, 226, 226),
        onPrimary: Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.symmetric(vertical: 10)
      ) , 
      child: const SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Đặt phòng",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(width: 8,),
            Icon(
              Icons.check
            ),
          ],
        )
      ),
    );
  }

   Widget _datePick(String hintText,TextEditingController date,bool checkDate){
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0))
    );
    return TextField(
      controller: date,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w200,),
        enabledBorder: border,
        focusedBorder: border, 
      ),
      readOnly: true,
      onTap: (){
        _selectDay(date, checkDate);
      },
    );
  }

  Future<void> _selectDay(TextEditingController date,bool checkDate) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100)
      );

    // Check _picked was chose
    if(_picked != null){
      String pickedDateStr = DateFormat('dd/MM/yyyy').format(_picked); 
     
      if(checkDate ){
        // This firstdate pick 
        // check fistdate require curentdate or after
        if(lastDate.text != ""){ // Check first date chose
          // Parse string firstDate to type Datetime
            DateTime lastDateStr = DateFormat('dd/MM/yyyy').parseStrict(lastDate.text); 
            if( _picked.isBefore(lastDateStr)){ // check fistdate require after current date
              setState(() {
                date.text = pickedDateStr;
              });
            }else{
              showErrorDialog(context, "Bạn đã nhập ngày không hợp lệ.\nVui lòng nhập lại");
            }

        }else{
          setState(() {
              date.text = pickedDateStr;
              price = countDaysBetweenDates(date.text, lastDate.text ) * widget.room.price;
            });
        }
        
      }else {
        // this last date
        if(firstDate.text != ""){ // Check first date chose
          // Parse string firstDate to type Datetime
            DateTime firstDateStr = DateFormat('dd/MM/yyyy').parseStrict(firstDate.text); 
            if( _picked.isAfter(firstDateStr)){ // check fistdate require after current date
              setState(() {
                date.text = pickedDateStr;
                price = countDaysBetweenDates(firstDate.text, date.text )  * widget.room.price;
              });
            }else{
              showErrorDialog(context, "Bạn đã nhập ngày không hợp lệ.\nVui lòng nhập lại");
            }
        }
        
      } 
    }
  }
   int countDaysBetweenDates(String startDate, String endDate) {
    
    if(startDate=="" || endDate=="" ){
      return 0;
    }
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    DateTime startDateTime = formatter.parse(startDate);
    DateTime endDateTime = formatter.parse(endDate);

    Duration difference = endDateTime.difference(startDateTime);
    return difference.inDays.abs();
}
    String formatCurrency(int amount) {
  final formatter = NumberFormat("#,###");
  return formatter.format(amount);
  }
}