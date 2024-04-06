import 'dart:io';
import 'package:chatapp/widget/userimagepicker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase=FirebaseAuth.instance;
class AuthSreen extends StatefulWidget{

  @override
  State<AuthSreen> createState() => _AuthSreenState();
}

class _AuthSreenState extends State<AuthSreen> {
  final _formKey=GlobalKey<FormState>();
  File? _pickedImageFile;
  var _enteredEmail='';
  var _enterpassword='';
  var _enterdedBio='';
  var _enteredusername='';
 // var _followers='';
  var _isLogin=true;
  var _isAuthenticating=false;
  void _submit() async{
        bool _isValid= _formKey.currentState!.validate();
        if(!_isValid){
         return ;
        }
        if(!_isLogin && _pickedImageFile==null){
          return;
        }
          _formKey.currentState!.save();
          try{
            setState(() {
               _isAuthenticating=true;
            });
           
        if(_isLogin){
            final userCredrentials=
            await _firebase.signInWithEmailAndPassword(email: _enteredEmail, password: _enterpassword);


        }
        else{
             final userCredrentials= 
             await  _firebase.createUserWithEmailAndPassword(email: _enteredEmail, password: _enterpassword);
          
         final storageref= FirebaseStorage.instance.ref().child('user_image').child('${userCredrentials.user!.uid}.jpg');
         await storageref.putFile(_pickedImageFile!);
         final imageurl=await storageref.getDownloadURL();

         FirebaseFirestore.instance.collection('users').doc(userCredrentials.user!.uid).set(
          {
            'username':_enteredusername,
            'uid':userCredrentials.user!.uid,
            'bio':_enterdedBio,
            'email':_enteredEmail,
            'image_url':imageurl,
            'followers':[],
            'following':[]
          }
         );
       }
          }
          on FirebaseAuthException catch(error){
              if(error.code == 'email-already-in-use'){

              }
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? 'authentication failed')));

              setState(() {
                _isAuthenticating=false;
              });
          }
        
        
       
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Container(
                margin:const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
             
              child: Image.asset("assets/logo5.jpg",
              // color: secondaryColor,
            //    height: 64,) ,
              )),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: 
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(!_isLogin)

                      UserImagePicker(onPickImage:(pickedImage){
                        _pickedImageFile=pickedImage;
                      } ,),
                    if(!_isLogin)
                       
                        TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username'
                      ),
                      keyboardType: TextInputType.text,
                      validator:(value){
                        if(value==null || value.trim().isEmpty){
                          return 'Please enter the valid username';
                        }
                      },
                        onSaved: (value){
                          _enteredusername  =value!;
                      },
                    ),
                    const SizedBox(height: 12,),
                    if(!_isLogin)

                     TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter Bio'
                      ),
                      keyboardType: TextInputType.text,
                    
                    //  validator:(value){
                      //  if(value==null || value.trim().isEmpty || !value.contains("@")){
                       //   return 'Please enter a valid email address';
                       // }
                     // },
                        onSaved: (value){
                          _enterdedBio  =value!;
                      },
                    ),
                    
                       if(!_isLogin)
                        const SizedBox(height: 12,),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email adress'
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator:(value){
                        if(value==null || value.trim().isEmpty || !value.contains("@")){
                          return 'Please enter a valid email address';
                        }
                      },
                        onSaved: (value){
                          _enteredEmail  =value!;
                      },
                    ),
                     const SizedBox(height: 12,),
                     TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password'
                      ),
                     obscureText: true,
                     validator:(value){
                        if(value==null || value.trim().length <6){
                          return 'Password must be at least 6 characters long';
                        }
                      },
                      onSaved: (value){
                          _enterpassword  =value!;
                      },
                    ),
                    const SizedBox(height: 12,),
                    if(_isAuthenticating)
                    const CircularProgressIndicator(),
                    if(!_isAuthenticating)
                    ElevatedButton(onPressed: _submit, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child:  Text(_isLogin ?'Login' : 'Signup' )),
                    if(!_isAuthenticating)
                    TextButton(onPressed: (){
                      setState(() {
                        _isLogin = _isLogin ? false:true;
                      });
                    }, 
                    child:Text(_isLogin ?'Create an account' : 'I already have an account')
                     )
                  ],
                )),),
                
              )
            ],
          ),
        ),
      ),
    );
  }
}