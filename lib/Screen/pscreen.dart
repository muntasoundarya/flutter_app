

import 'package:chatapp/widget/postwidget.dart';
import 'package:flutter/material.dart';

class Pscreen extends StatelessWidget{
  final snapshot;
  Pscreen(this.snapshot,{super.key});
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: PostWidget(snapshot)),
     );
  }
}