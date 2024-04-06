

import 'package:chatapp/Screen/profilescreenn.dart';
import 'package:chatapp/utils/cachedimage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class  SearchScreen extends StatefulWidget{
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController search=TextEditingController();
  bool isShow=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    search.dispose();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration:const  InputDecoration(
            labelText: "Search for a User",
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShow=true;
            });
          },
        ),
      ),
      body:isShow? FutureBuilder(future: FirebaseFirestore.instance.collection('users')
      .where('username' ,isGreaterThanOrEqualTo: search.text).get(), 
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator(),);
        }

        return ListView.builder(
          itemCount: (snapshot.data! as dynamic).docs.length,
          itemBuilder: (context,index){
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                  ProfileScreenn(uid: (snapshot.data! as dynamic).docs[index]['uid']))),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['image_url']),
                    ),
                    title: Text((snapshot.data! as dynamic).docs[index]['username']),
                  ),
                );
          });
      })
      : const Text('Posts'));
      
      //FutureBuilder(future: 
     // FirebaseFirestore.instance.collection('posts').get(),
      // builder: (context,snapshot){
       // if(!snapshot.hasData){
         // return const  Center(
        //    child: CircularProgressIndicator(),
        //  );
      //  }  
  }
}