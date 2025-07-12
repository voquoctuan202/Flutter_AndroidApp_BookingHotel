import 'package:flutter/material.dart';

import '/../../ui/account/acountPage.dart';
import '/../../ui/booking/bookingPage.dart';
import '/../../ui/favorite/favorivePage.dart';
import 'homePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}): super(key:key);
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage =0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _getPage(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  _bottomNavigationBar(){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 25,
      selectedIconTheme: const IconThemeData (
        color: Color.fromARGB(255, 3, 9, 75),
        opacity: 1.0,
        size: 25,
      ),
      unselectedIconTheme: const IconThemeData (
        color: Color.fromARGB(255, 81, 81, 81),
        opacity: 1.0,
        size: 25
      ),
      items:const [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Yêu thích"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Lịch đã đặt"),
        BottomNavigationBarItem(icon: Icon(Icons.account_box), label: "Tài khoản"),
      ],
      currentIndex: selectedPage,
      onTap: (tap){
        setState(() {
          selectedPage = tap;
        });
      },
    );
      
  }

  _getPage(){
    switch(selectedPage){
      case 0:
        return const HomePage();
      case 1:
        return const FavoritePage();
      case 2:
        return const BookingPage();
      case 3:
        return const AccountPage();
    }
  }
}