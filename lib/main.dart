import 'package:chatapp/Screen/AuthScreen.dart';
import 'package:chatapp/Screen/SplashScreen.dart';
import 'package:chatapp/widget/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterchat',
      theme: ThemeData().copyWith(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 63, 17,16)),
           
      ),
      home:ScreenUtilInit(
        child: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(), builder:(ctx,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return SplashScreen();
          }
           if(snapshot.hasData)
        {
          return NavigationScreen();
        }
        
          return AuthSreen();
          }),
      ),
    );    
  }
}

