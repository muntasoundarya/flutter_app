import 'package:chatapp/Screen/pscreen.dart';
import 'package:chatapp/methods/firebase_firestore.dart';
import 'package:chatapp/model/usermod.dart';
import 'package:chatapp/model/usermodel.dart';
import 'package:chatapp/utils/cachedimage.dart';
import 'package:chatapp/widget/postwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreenn extends StatefulWidget {
  final String uid;

  ProfileScreenn({super.key, required this.uid});
  @override
  State<ProfileScreenn> createState() => _ProfileScreennState();
}

class _ProfileScreennState extends State<ProfileScreenn> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FutureBuilder(
                  future: Firebase_Firestor().getuse(widget.uid),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return head(snapshot.data!);
                  })),
            ),
            StreamBuilder(
                stream: _firebaseFirestore
                    .collection('posts')
                    .where('uid', isEqualTo: widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  var snapLength = snapshot.data!.docs.length;
                  return SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var snap = snapshot.data!.docs[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Pscreen(snap.data())));
                            },
                            child: CachedImage(snap['postImage']));
                      }, childCount: snapLength),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4));
                })
          ],
        )),
      ),
    );
  }

  Widget head(Usermod user) {
    var isfollowing=false;
    return Container(
      padding: EdgeInsets.only(bottom: 5.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                child: ClipOval(
                  child: SizedBox(
                    width: 80.w,
                    height: 80.h,
                    child: CachedImage(user.profile),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 35.w,
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(
                        width: 53.w,
                      ),
                      Text(
                        '0',
                        // user.followers.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(
                        width: 53.w,
                      ),
                      Text(
                        //  user.following.length.toString(),
                        '0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 13.03,
                        ),
                      ),
                      SizedBox(
                        width: 35.w,
                      ),
                      Text('Followers',
                          style: TextStyle(
                            fontSize: 13.03,
                          )),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text('Following',
                          style: TextStyle(
                            fontSize: 13.03,
                          )),
                    ],
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  user.bio,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: user.uid == _auth.currentUser!.uid
                ? GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Text('Sign Out'),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      await Firebase_Firestor().followUser(
                          uid: _auth.currentUser!.uid, followId: user.uid);

                          
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 30.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.grey),
                        ),
                        child:
                          isfollowing==false?
                            const Text('Follow')
                      :const  Text('Unfollow',
                     
                      ),
                         
                        ),
                  ),
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: double.infinity,
            height: 30.h,
            child: const TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [
                  Icon(Icons.grid_on),
                  Icon(Icons.video_collection),
                  Icon(Icons.person),
                ]),
          ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }
}
