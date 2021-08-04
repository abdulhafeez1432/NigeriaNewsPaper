import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final BoxShape boxShape;
  final BoxFit boxFit;

  const CustomCachedNetworkImage({
    Key key,
    @required this.imageUrl,
    this.boxShape,
    this.boxFit,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      color: Colors.white,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          shape: boxShape ?? BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit ?? BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.05),
              BlendMode.darken,
            ),
          ),
        ),
      ),
      placeholder: (BuildContext context, String url) => Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          color: Colors.grey[200],
        ),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.error,
        color: Colors.grey,
      ),
    );
  }
}
