import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class RoundedImageWithShadow extends StatefulWidget {
  final String imageUrl;
  final double ratio;
  final double radius;
  final Color shadowColor;
  final Key? key;
  final Function(Size)? onImageSizeAvailable;
  final String errorWidgetAsset;

  const RoundedImageWithShadow({
    this.key,
    required this.imageUrl,
    this.ratio = 0.64,
    this.radius = 10,
    this.shadowColor = Colors.black,
    this.onImageSizeAvailable,
    this.errorWidgetAsset = 'assets/images/NoCoverArt.png',
  }) : super(key: key);

  @override
  _RoundedImageWithShadowState createState() => _RoundedImageWithShadowState();
}

class _RoundedImageWithShadowState extends State<RoundedImageWithShadow> {
  Size? imageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // The callback will be executed after the widget has finished building.
      if (widget.onImageSizeAvailable != null) {
        widget.onImageSizeAvailable!(imageSize!);
      }
    });
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: AspectRatio(
          aspectRatio: widget.ratio,
          child:
              widget.imageUrl == '' || widget.imageUrl.toLowerCase() == 'asset'
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        // callback to get the image size once rendered
                        // if (widget.onImageSizeAvailable != null) {
                          imageSize = constraints.biggest;
                        //   widget.onImageSizeAvailable!(imageSize!);
                        // }
                        return Image.asset(
                          widget.errorWidgetAsset,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // if (widget.onImageSizeAvailable != null) {
                          imageSize = constraints.biggest;
                          // widget.onImageSizeAvailable!(imageSize!);
                        // }
                        return FancyShimmerImage(
                          width: constraints.biggest.width,
                          imageUrl: widget.imageUrl,
                          boxFit: BoxFit.cover,
                          errorWidget: Image.asset(
                             widget.errorWidgetAsset,
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
