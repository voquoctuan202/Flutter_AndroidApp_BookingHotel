
import 'package:ct484_project/ui/account/changePassword.dart';
import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'accountDetail.dart';

class AccountPage extends StatefulWidget{
  const AccountPage({Key? key}): super(key:key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        
        backgroundColor:Color.fromARGB(255, 3, 9, 75) ,
        title: const Center(
          child: Text("Tài khoản", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 3, 9, 75) ,
                ),
                SizedBox(width: 10,),
                Text("Tài khoản", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)

              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
            ),
           
            buildAccountOption(context, "Thông tin"),
            buildAccountOption(context, "Đổi mật khẩu"),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  context.read<AuthManager>().logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 3, 9, 75),
                  shape: const StadiumBorder(),
                  primary: Color.fromARGB(255, 228, 226, 226),
                  onPrimary: Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(vertical: 10)
                ) , 
                child:  SizedBox(
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Đăng xuất",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(width: 8,),
                        Icon(
                          Icons.logout_rounded
                        ),
                      ],
                    ),
                  )
                )
              

          ],
        ),
      )

    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title ){
    return GestureDetector(
      onTap: (){
        switch (title){
          case "Thông tin": Navigator.of(context).pushNamed(AccountDetail.rootName ); break;
          case "Đổi mật khẩu": Navigator.of(context).pushNamed(ChangePassword.rootName ); break;
        }
      
      },
      child: Padding(
        padding:EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 0, 0, 0)
              )
            ),
            Icon(Icons.arrow_forward_ios, color: const Color.fromARGB(255, 0, 0, 0),)
          ],

        ),
      ),
    );
  }
}