import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  String imageurl;
  CachedImage(this.imageurl, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageurl,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, progress) {
        return Container(
          child: CircularProgressIndicator(
            value: progress.progress,
            color: Colors.black,
          ),
        );
      },
      errorWidget: (context, url, error) => Container(
        color: Colors.amber,
      ),
    );
  }
}
