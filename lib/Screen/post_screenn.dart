
import 'dart:typed_data';
import 'package:chatapp/methods/firebase_firestore.dart';
import 'package:chatapp/methods/storagemethod.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget{
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List ? _file;
  final TextEditingController _descriptioncontroller=TextEditingController();
  _selectImage(BuildContext context) async{
    return showDialog(context: context, builder: (context){
           return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take Picture."),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file=await pickImage(ImageSource.camera);
                  setState(() {
                    _file=file;
                  });
                },
              ),
               SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose From The Device"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file=await pickImage(ImageSource.gallery);
                  setState(() {
                    _file=file;
                  });
                },
              ),

               SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: ()  {
                  Navigator.of(context).pop();
                 
                },
              )
            ],
           );
    });


  }
  @override
  Widget build(BuildContext context) {
   return _file==null?
    Center(
   child: IconButton(icon: const  Icon(Icons.upload),
   onPressed:(){
    _selectImage(context);
   }
    )
    ):
    Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.black),
   //   leading: IconButton(onPressed:   ()  {
     //             Navigator.of(context).pop(); 
     //           }, icon:const Icon(Icons.arrow_back)),
       elevation: 0,
       title:const Text('New Post',
       style: TextStyle(color: Colors.black),),
       centerTitle: false,
       actions: [
        TextButton(onPressed: (){}, child: GestureDetector(
         onTap: () async {
            String posturl=await StorageMethod().uploadImageToStorage('post',_file!);
            await Firebase_Firestor().CreatePost(postImage: posturl, caption: _descriptioncontroller.text);
            Navigator.of(context).pop();
         },
          child: const Text('Post',style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          
          ),),
        ))
       ],
    ),
    body:  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
          child: Container(
            width: 65.w,
            height: 65.h,
            decoration: BoxDecoration(color: Colors.amber,
            image:DecorationImage(image: MemoryImage(_file!),
                fit: BoxFit.cover,
              )  
           )
          ),
        ),
SizedBox(width: 10.w,),
          SizedBox(width: 200.w,height: 60.h,
          child: TextField(
          controller: _descriptioncontroller,
          decoration: const InputDecoration(
            hintText: 'Write a Caption..',
            border: InputBorder.none,
          ),
          maxLines: 8,
),
        

          )    
      
        ],)
      

      ],
    ),
   
   );
  }
}