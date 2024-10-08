import 'package:Lets_Change/providers/user_provider.dart';
import 'package:Lets_Change/screens/login_screen.dart';
import 'package:Lets_Change/utils/colour.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'responsive/mobile_screen_layout.dart';
import 'responsive/responsive_screen_layout.dart';
import 'responsive/web_screen_layout.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){
     await Firebase.initializeApp(
       options: const FirebaseOptions(
           apiKey: 'AIzaSyB0B7hHXXjCGtlDZ24NX8gjdhSjPY9rC2g',
           appId: '1:103900823975:web:4997d1b8e21dea4db7b682',
           messagingSenderId: '103900823975',
           projectId: 'instagram-clone-35eb4',
           storageBucket: 'instagram-clone-35eb4.appspot.com'
       ),
     );
  }else{
    await Firebase.initializeApp();
 }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Let's Change",
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: primaryColor,
        ),

       // home:  const ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(), webScreenLayout: WebScreenLayout()),

        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
             if (snapshot.connectionState == ConnectionState.active){
               // Checking if the snapshot has any data or not
               if (snapshot.hasData){

                 // if snapshot has data which means user is logged in then we
                 // check the width of screen and accordingly display the screen layout or not
                 return const ResponsiveLayout(
                     mobileScreenLayout: MobileScreenLayout(),
                     webScreenLayout: WebScreenLayout()
                 );
               }else if (snapshot.hasError){
                 return Center(
                   child:Text('${snapshot.error}'),
                 );
               }
             }
             if (snapshot.connectionState == ConnectionState.waiting){
               return const Center(
                 child: CircularProgressIndicator(
                   color: primaryColor,
                 ),
               );
             }
             return const LoginScreen();
          }
        ),

      ),
    );
  }
}
