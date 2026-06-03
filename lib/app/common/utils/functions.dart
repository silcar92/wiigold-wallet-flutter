import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildAssetImage(
  String url, {
  double height = 25,
  double width = 25,
  bool isNetwork = true,
}) {
  if (url.isEmpty) {
    return SizedBox(
      width: width,
      height: height,
      child: Icon(Icons.image_not_supported, size: 20, color: Colors.grey[400]),
    );
  }

  return isNetwork
      ? SvgPicture.network(
          url,
          height: height,
          width: width,
          fit: BoxFit.contain,
          placeholderBuilder: (BuildContext context) => SizedBox(
            width: width,
            height: height,
            child: const CircularProgressIndicator(strokeWidth: 2.0),
          ),
          errorBuilder: (context, error, stackTrace) {
            return SizedBox(
              width: width,
              height: height,
              child: Icon(
                Icons.error_outline,
                size: 20,
                color: Colors.grey[400],
              ),
            );
          },
        )
      : SvgPicture.asset(
          url,
          height: height,
          width: width,
          fit: BoxFit.contain,
          placeholderBuilder: (BuildContext context) => SizedBox(
            width: width,
            height: height,
            child: const CircularProgressIndicator(strokeWidth: 2.0),
          ),
          errorBuilder: (context, error, stackTrace) {
            return SizedBox(
              width: width,
              height: height,
              child: Icon(
                Icons.error_outline,
                size: 20,
                color: Colors.grey[400],
              ),
            );
          },
        );
}
