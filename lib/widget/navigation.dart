
import 'package:chatapp/Screen/post_screenn.dart';
import 'package:chatapp/Screen/profilescreenn.dart';
import 'package:chatapp/Screen/reelscreen.dart';
import 'package:chatapp/Screen/searchscreen.dart';
import 'package:chatapp/responsive/mobilescreenlayout.dart';
import 'package:chatapp/responsive/responsive_layout_screen.dart';
import 'package:chatapp/responsive/webscreenlayout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget{
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}
int _currentIndex=0;
class _NavigationScreenState extends State<NavigationScreen> {
  late PageController pageController;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  void initState() {
    
    super.initState();
    pageController=PageController();
  }

  @override
  void dispose() {
   
    super.dispose();
    pageController.dispose();
  }
  onChanged(int page){
    setState(() {
      _currentIndex=page;
    });
  }

  navigationTapped(int page){
    pageController.jumpToPage(page);
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: navigationTapped,
          items:const [
            BottomNavigationBarItem(icon:Icon(Icons.home),label: ''),
            BottomNavigationBarItem(icon:Icon(Icons.search),label: ''),
            BottomNavigationBarItem(icon:Icon(Icons.video_call_sharp),label: ''),
            BottomNavigationBarItem(icon:Icon(Icons.camera),label: ''),
            BottomNavigationBarItem(icon:Icon(Icons.person),label: ''),
          ]),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onChanged,
        children: [
          ResponsiveLayoutScreen(mobilescreenlayout:MobileScreenLayout() ,webscreenlayout:WebScreenLayout() ),
          SearchScreen(),
          AddPostScreen(),
          ReelsScreen(),
          ProfileScreenn(uid:_auth.currentUser!.uid),
          
        ],
      ),
    );
  }
}