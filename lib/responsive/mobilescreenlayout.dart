import 'package:chatapp/widget/postwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //String username="";
  // @override
  // void initState() {
  //  getUsername();
  //  super.initState();
  // }
  // void getUsername() async{
  //  DocumentSnapshot snap= await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

//setState(() {
  //username=(snap.data()as Map <String,dynamic>)['username'];
//});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: SizedBox(
            width: double.infinity,
            height: 60,
            child: Image.asset('assets/Insta_logo.png',
                height: 50, width: double.infinity),
          ),
          // leading:  Image.asset('assets/camera.png',height: 10,width:10),

          actions: [
            const Icon(Icons.favorite_border_outlined,
                color: Colors.black, size: 25),
            const SizedBox(width: 10),
            Image.asset(
              'assets/send.png',
              height: 20,
              width: 30,
            ),
          ],
          backgroundColor: const Color(0xffFAFAFA),
        ),
        body: CustomScrollView(
          slivers: [
            StreamBuilder(
                stream: _firebaseFirestore
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return PostWidget(snapshot.data!.docs[index].data());
                    },
                    childCount:
                        snapshot.data == null ? 0 : snapshot.data!.docs.length,
                  ));
                })
          ],
        ));
    // Center(child: Text('$username'),),);
  }
}
