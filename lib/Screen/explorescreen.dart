import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExploreScreen extends StatefulWidget {
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final search = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SearchBox(),
          //   StreamBuilder(stream: _firebaseFirestore.collection('posts').snapshots(),
          // builder: (context,snapshot){
          // if(!snapshot.hasData){
          //  return const  SliverToBoxAdapter(child: Center(
          // child: CircularProgressIndicator(),
          //       ),);
          //     }
          //   return SliverGrid(delegate: SliverChildBuilderDelegate((context, index) {
          //     return Container(
          //     decoration: const BoxDecoration(
          //     color: Colors.grey,
          // ),
          //            );
          //      }),
          //     gridDelegate: SliverQuiltedGridDelegate(
          //    crossAxisCount: 3,
          //  mainAxisSpacing: 3,
          //       crossAxisSpacing: 3,
          //     pattern: const [
          //       QuiltedGridTile(2, 1),
          //     QuiltedGridTile(1, 1),
          //   QuiltedGridTile(2, 2),
          // QuiltedGridTile(1, 1),
          //                  QuiltedGridTile(1, 1),
          //           ]));
          //
          //   })
        ],
      )),
    );
  }

  SliverToBoxAdapter SearchBox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          width: double.infinity,
          height: 36.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: Colors.grey.shade200,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: TextField(
                    controller: search,
                    decoration: const InputDecoration(
                      hintText: 'Search User',
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
