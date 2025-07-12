import 'package:ct484_project/models/hotel.dart';
import 'package:ct484_project/models/room.dart';
import 'package:ct484_project/ui/account/accountDetail.dart';
import 'package:ct484_project/ui/account/accountsManager.dart';
import 'package:ct484_project/ui/account/changePassword.dart';
import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:ct484_project/ui/auth/auth_screen.dart';
import 'package:ct484_project/ui/booking/bookingsManager.dart';
import 'package:ct484_project/ui/favorite/favoriteManager.dart';
import 'package:ct484_project/ui/hotel/hotelDetail.dart';
import 'package:ct484_project/ui/hotel/hotelsManager.dart';
import 'package:ct484_project/ui/hotel/hotelsPage.dart';
import 'package:ct484_project/ui/rooms/roomsManager.dart';
import 'package:ct484_project/ui/rooms/roomsPage.dart';
import 'package:ct484_project/ui/shared/fromBooking.dart';
import 'package:ct484_project/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../ui/home/homeScreen.dart';
import 'ui/rooms/roomDetail.dart';


Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 3, 9, 75),
      secondary: Colors.deepOrange,
      background: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    return MultiProvider(
      providers:[
         ChangeNotifierProvider(
          create: (ctx) => AuthManager()),
        ChangeNotifierProvider(
          create: (ctx) => HotelsManager()),
        ChangeNotifierProvider(
          create: (ctx) => RoomsManager()),
        ChangeNotifierProvider(
          create: (ctx) => BookingsManager()),
        ChangeNotifierProvider(
          create: (ctx) => AccountsManager()),
           ChangeNotifierProvider(
          create: (ctx) => FavoriteManager()),
        
      ],
      child: Consumer<AuthManager>(
        builder: (context, authManager, child){
          return MaterialApp(
            theme: ThemeData(
              colorScheme: colorScheme,
            ),
            home: authManager.isAuth ? HomeScreen() : FutureBuilder(
              future: authManager.tryAutoLogin(), 
              builder: (context,snapshot){
                return snapshot.connectionState == ConnectionState.waiting ? const SplashScreen() : const AuthScreen();
              },
            ),
            routes: {
               
                HomeScreen.routeName : (ctx) => SafeArea(child: HomeScreen())
            },
            onGenerateRoute: (settings){
              
              if(settings.name == HomeScreen.routeName){
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child: HomeScreen(),
                    );
                  },
                );
              }
              if(settings.name == RoomsPage.routeName){
                Hotel hotel = settings.arguments as Hotel ;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child: RoomsPage(hotel),
                    );
                  },
                );
              }
              if(settings.name == HotelsPage.routeName){
                String city = settings.arguments as String;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child: HotelsPage(city),
                    );
                  },
                );
              }
              if(settings.name == RoomsDetail.routeName){
                Room room = settings.arguments as Room;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child: RoomsDetail(room),
                    );
                  },
                );
              }
              if(settings.name == HotelDetail.routeName){
                Hotel hotel = settings.arguments as Hotel;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child: HotelDetail(hotel),
                    );
                  },
                );
              }
              if(settings.name == AccountDetail.rootName){
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child: AccountDetail(),
                    );
                  },
                );
              }
              if(settings.name == ChangePassword.rootName){
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child:  ChangePassword(),
                    );
                  },
                );
              }
              if(settings.name == FormBooking.rootName){
                Room room = settings.arguments as Room;
                
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child:  FormBooking(room),
                    );
                  },
                );
              }
            }, 
          );
        },
      
      ),
    
    ) ;
    
    // MaterialApp(
    //   theme: ThemeData(
    //     colorScheme: colorScheme,
    //   ),
    //   home: HomeScreen(),
    //   routes: {
    //       LoginScreen.routeName: (ctx) =>  SafeArea(child: LoginScreen()),
    //       RegisterScreen.routeName : (ctx) => SafeArea(child: RegisterScreen()),
    //       HomeScreen.routeName : (ctx) => SafeArea(child: HomeScreen())
    //     },
    //   onGenerateRoute: (settings){
    //     if(settings.name == LoginScreen.routeName){
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child: LoginScreen(),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == RegisterScreen.routeName){
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child: LoginScreen(),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == HomeScreen.routeName){
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child: HomeScreen(),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == RoomsPage.routeName){
    //       Hotel hotel = settings.arguments as Hotel ;
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child: RoomsPage(hotel),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == HotelsPage.routeName){
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child: HotelsPage(),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == RoomsDetail.routeName){
    //       Room room = settings.arguments as Room;
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child: RoomsDetail(room),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == HotelDetail.routeName){
    //       Hotel hotel = settings.arguments as Hotel;
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child: HotelDetail(hotel),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == AccountDetail.rootName){
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child: AccountDetail(),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == ChangePassword.rootName){
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child:  ChangePassword(),
    //             );
    //           },
    //         );
    //     }
    //     if(settings.name == FormBooking.rootName){
    //       Room room = settings.arguments as Room;
          
    //       return MaterialPageRoute(
    //           settings: settings,
    //           builder: (ctx) {
    //             return SafeArea(
    //               child:  FormBooking(room),
    //             );
    //           },
    //         );
    //     }
    //   }, 
    // );
  }
}




