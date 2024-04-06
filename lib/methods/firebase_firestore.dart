

import 'package:chatapp/model/usermodel.dart';
import 'package:chatapp/model/usermod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestor{
 final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
 Future<Usermodel> getuser() async{
  try{
    final user=await _firebaseFirestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    final snapuser=user.data();
    return Usermodel(snapuser!['bio'],snapuser['email'] ,snapuser['username'] , snapuser['image_url']);
  }
  on FirebaseException catch(e){
    throw Exception(e.message.toString());
  }
 }

 Future<Usermod> getuse(String uid) async{
  try{
    final user=await _firebaseFirestore.collection('users').doc(uid).get();
    final snapuser=user.data();
    return Usermod(snapuser!['bio'],snapuser['email'] ,snapuser['username'] , snapuser['image_url'], snapuser['uid']
 // snapuser['followers'],snapuser['following']
    
    );
   // return Usermodel(snapuser!['bio'],snapuser['email'] ,snapuser['username'] , snapuser['image_url']);
  }
  on FirebaseException catch(e){
    throw Exception(e.message.toString());
  }
 }
  Future<bool>CreatePost  ({
   required String postImage,
    required String caption,  }) async {
    var uid=Uuid().v4();
    DateTime data=new DateTime.now();
    Usermodel user=await getuser();
    await  _firebaseFirestore.collection('posts').doc(uid).set({
      'postImage':postImage,
      'username':user.username,
      'profileImage':user.profile,
      'caption':caption,
      'uid':FirebaseAuth.instance.currentUser!.uid,
      'postId':uid,
      'like':[],
      'time':data,

    });
    return true;
 }

  Future<bool>Comments  ({
   required String comment,
    required String type, 
    required String uidd }) async {
    var uid=Uuid().v4();
    
    Usermodel user=await getuser();
    await  _firebaseFirestore.collection(type).doc(uidd).collection('comments').doc(uid).set({
      'comment':comment,
      'username':user.username,
      'profileImage':user.profile,
      'CommentUid':uid,
    });
    return true;
 }

 Future<String> like({
    required List like,
    required String type, 
    required String uid,
    required String postId
 }) async {
  String res='some error';
    try {
  if(like.contains(uid)){
    _firebaseFirestore.collection(type).doc(postId).update({'like':FieldValue.arrayRemove([uid])});
  }
  
  else{
     _firebaseFirestore.collection(type).doc(postId).update({'like':FieldValue.arrayUnion([uid])});
  }
  res="success";
} on Exception catch (e) {
  // TODO
  res=e.toString();
}
    return res;
 }

Future<void> deletePost(String postId) async{
  try{
    await _firebaseFirestore.collection('posts').doc(postId).delete();
  }
  catch(err){
    print(err.toString());
  }
}

Future<void> followUser({
  required String uid,
  required String followId

})async{
   try{
    DocumentSnapshot snap=await _firebaseFirestore.collection('users').doc(uid).get();
    List following =(snap.data()! as dynamic)['following'];

    if(following.contains(followId)){
      await _firebaseFirestore.collection('users').doc(followId).update({'followers':FieldValue.arrayRemove([uid])});
       await _firebaseFirestore.collection('users').doc(uid).update({'following':FieldValue.arrayRemove([uid])});
    }else{

       await _firebaseFirestore.collection('users').doc(followId).update({'followers':FieldValue.arrayUnion([uid])});
       await _firebaseFirestore.collection('users').doc(uid).update({'following':FieldValue.arrayUnion([uid])});

    }
   
   }catch(e){
     print(e.toString());
   }
}
}