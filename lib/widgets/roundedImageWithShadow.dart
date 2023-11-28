import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class RoundedImageWithShadow extends StatefulWidget {
  final String imageUrl;
  final double ratio;
  final double radius;
  final Color shadowColor;
  final Function(Size)? onImageSizeAvailable;
  final String errorWidgetAsset;
  final Size? size; // Optional size parameter

  const RoundedImageWithShadow({
    super.key,
    required this.imageUrl,
    this.ratio = 0.64,
    this.radius = 10,
    this.shadowColor = Colors.black,
    this.onImageSizeAvailable,
    this.errorWidgetAsset = 'assets/images/NoCoverArt.png',
    this.size, // Add size to the constructor
  });

  @override
  _RoundedImageWithShadowState createState() => _RoundedImageWithShadowState();
}

class _RoundedImageWithShadowState extends State<RoundedImageWithShadow> {
  Size? imageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onImageSizeAvailable != null) {
        widget.onImageSizeAvailable!(imageSize!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget
          .size?.width, // Use the width from the size parameter if provided
      height: widget
          .size?.height, // Use the height from the size parameter if provided
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: AspectRatio(
          aspectRatio: widget.ratio,
          child: widget.imageUrl == '' ||
                  widget.imageUrl.toLowerCase() == 'asset'
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    imageSize = widget.size ?? constraints.biggest;

                    return Image.asset(
                      widget.errorWidgetAsset,
                      fit: BoxFit.cover,
                      width:
                          imageSize?.width, // Use the width from the imageSize
                      height: imageSize
                          ?.height, // Use the height from the imageSize
                    );
                  },
                )
              : widget.imageUrl.contains('http')
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        imageSize = widget.size ?? constraints.biggest;

                        return FancyShimmerImage(
                          imageUrl: widget.imageUrl,
                          boxFit: BoxFit.cover,
                          errorWidget: Image.asset(
                            widget.errorWidgetAsset,
                            width: imageSize
                                ?.width, // Use the width from the imageSize
                            height: imageSize
                                ?.height, // Use the height from the imageSize
                          ),
                        );
                      },
                    )
                  : Image.file(File(widget.imageUrl), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
