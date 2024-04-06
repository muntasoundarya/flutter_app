import 'package:chatapp/Screen/comment.dart';
import 'package:chatapp/methods/firebase_firestore.dart';
import 'package:chatapp/utils/cachedimage.dart';
import 'package:chatapp/widget/like_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostWidget extends StatefulWidget {
  final snapshot;
  const PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  bool isAnimating = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String user = '';

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!.uid;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                  child: SizedBox(
                width: 35.w,
                height: 35.h,
                child: CachedImage(widget.snapshot['profileImage']),
              )),
              title: Text(
                widget.snapshot['username'],
                style: TextStyle(fontSize: 13.sp),
              ),
              subtitle: Text(
                'location',
                style: TextStyle(fontSize: 11.sp),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            Firebase_Firestor().like(
                like: widget.snapshot['like'],
                type: 'posts',
                uid: user,
                postId: widget.snapshot['postId']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            Container(
              width: 375.w,
              height: 375.w,
              child: CachedImage(widget.snapshot['postImage']),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isAnimating ? 1 : 0,
              child: LikeAnimation(
                child: Icon(
                  Icons.favorite,
                  size: 100.w,
                  color: Colors.red,
                ),
                isAnimated: isAnimating,
                duration: const Duration(milliseconds: 400),
                smallLike: false,
                onEnd: () {
                  setState(() {
                    isAnimating = false;
                  });
                },
              ),
            )
          ]),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 14.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 14.w,
                  ),
                  LikeAnimation(
                    isAnimated: widget.snapshot['like'].contains(user),
                    child: IconButton(
                        icon: Icon(
                          widget.snapshot['like'].contains(user)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.snapshot['like'].contains(user)
                              ? Colors.red
                              : Colors.black,
                          size: 24.w,
                        ),
                        onPressed: () {
                          Firebase_Firestor().like(
                              like: widget.snapshot['like'],
                              type: 'posts',
                              uid: user,
                              postId: widget.snapshot['postId']);
                        }),
                  ),
                  SizedBox(width: 17.w),
                  GestureDetector(
                      onTap: () {
                        showBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: ((context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: DraggableScrollableSheet(
                                    minChildSize: 0.3,
                                    maxChildSize: 1,
                                    initialChildSize: 1,
                                    builder: (context, ScrollController) {
                                      return Comment(
                                          widget.snapshot['postId'], 'posts');
                                    }),
                              );
                            }));
                      },
                      child: Image.asset('assets/comment.png', height: 18.h)),
                  SizedBox(width: 17.w),
                  Image.asset('assets/send.png', height: 18.h),
                  const Spacer(),
                  Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: GestureDetector(
                        onTap:(){
                          Firebase_Firestor().deletePost(widget.snapshot['postId']);
                        } ,
                        child:const Icon(Icons.delete),
                        // Image.asset('assets/save.png', height: 20.h)
                        )),
                ],
              ),
           //   Padding(
               // padding: EdgeInsets.only(
                 // left: 19.w,
                 // top: 13.5.h,
                 // bottom: 5.h,
               // ),
             
             //  padding: EdgeInsets.only(left: 15.w),
              //  child:
               //  Padding( 
                //  padding:  EdgeInsets.only(left: 15.w),
                 // child:
                   Text(
                    widget.snapshot['like'].length.toString(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              //  ),
        //      ),
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot['username'] + ' ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.snapshot['caption'],
                      style: TextStyle(
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            //  Padding(padding: EdgeInsets.only(left: 15.w,top: 20.h,bottom: 8.h),
              //  child: Text(formatDate(snapshot['time'], [yyyy, '-', mm, '-', dd] ),
                // style: TextStyle(fontSize: 11.sp,color: Colors.grey),),)
            ],
          ),
        )
      ],
    );
  }
}
