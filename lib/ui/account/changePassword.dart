import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/ui/account/accountsManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget{
  
  const ChangePassword({Key? key}): super(key:key);
  static const rootName = "/changePassword";

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldpassController = TextEditingController();
  TextEditingController newpassController = TextEditingController();
  TextEditingController renewpassController = TextEditingController();
  late Future<void> _fetchUser;
    @override
    void initState(){
      super.initState();
      
      _fetchUser = context.read<AccountsManager>().fetchUser();
    
    }
  @override
  Widget build(BuildContext context){

    //AccountsManager _user = context.read<AccountsManager>();
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
        title: Text("Đổi mật khẩu", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
        
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: _fetchUser,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return  Column(
                  children: [
                    Text("Đổi mật khẩu",style: TextStyle(color: Color.fromARGB(255, 3, 9, 75), fontWeight: FontWeight.bold, fontSize: 25),),
                    const SizedBox(height: 10),
                    _inputText("Mật khẩu cũ", oldpassController),
                    const SizedBox(height: 10),
                    _inputText("Mật khẩu mới", newpassController),
                    const SizedBox(height: 10),
                    _inputText("Xác nhận mật khẩu mới", renewpassController),
                  const SizedBox(height: 20),
                    _saveAccount()

                  ],
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
      obscureText: true,
      
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
          username: _user.item.username, 
          fullname: _user.item.fullname,
          phone: _user.item.phone, 
          email: _user.item.email,
          password: newpassController.text
        );
        if(newpassController.text == renewpassController.text 
        && context.read<AccountsManager>().ChangePassword(userId,oldpassController.text)){
          await context.read<AccountsManager>().updateUser(user);
          final snackBar = SnackBar(content: Text('Đã đổi mật khẩu'));  
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }else {
          final snackBar = SnackBar(content: Text('Có lỗi xảy ra'));  
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