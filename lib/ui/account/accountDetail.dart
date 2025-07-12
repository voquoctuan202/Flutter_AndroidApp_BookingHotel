import 'package:ct484_project/ui/account/accountsManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class AccountDetail extends StatefulWidget{
  
  const AccountDetail({Key? key}): super(key:key);
  static const rootName = "/roomDetail";

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  TextEditingController usernameController =  TextEditingController();
  TextEditingController fullnameController =  TextEditingController();
  TextEditingController phoneController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
   late Future<void> _fetchUser;
   @override
  void initState(){
    super.initState();
    
    _fetchUser = context.read<AccountsManager>().fetchUser();
    
  }
  @override
  Widget build(BuildContext context){
    AccountsManager _user = context.read<AccountsManager>();
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
        title: Text("Thông tin tài khoản", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
        
      ),
      body: FutureBuilder(
        future: _fetchUser,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            usernameController.text = _user.item.username ?? "";
            fullnameController.text = _user.item.fullname ?? "" ;
            phoneController.text = _user.item.phone ?? "";
            emailController.text = _user.item.email ?? "";
            return  Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text("Thông tin",style: TextStyle(color: Color.fromARGB(255, 3, 9, 75), fontWeight: FontWeight.bold, fontSize: 25),),
                  const SizedBox(height: 10),
                  _inputText("Tên đăng nhập", usernameController),
                  const SizedBox(height: 10),
                  _inputText("Tên đầy đủ", fullnameController),
                  const SizedBox(height: 10),
                  _inputText("Số điện thoại", phoneController),
                  const SizedBox(height: 10),
                  _inputText("Email", emailController),
                  const SizedBox(height: 20),
                   _saveAccount()

                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ), 

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

   Widget _saveAccount(){
    AccountsManager _user = context.read<AccountsManager>();
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId =  prefs.getString("userId");
        User user = User(
          id: userId!, 
          username: usernameController.text, 
          fullname: fullnameController.text,
          password: _user.item.password,
          phone: phoneController.text, 
          email: emailController.text
        );
        if(await context.read<AccountsManager>().updateUser(user)){
          final snackBar = SnackBar(content: Text('Thông tin đã được lưu lại'));  
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }else {
          final snackBar = SnackBar(content: Text('Có lỗi xảy ra!!!'));  
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
              "Lưu thông tin",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(width: 8,),
            Icon(
              Icons.save_as_rounded
            ),
          ],
        )
      ),
    );
  }
}