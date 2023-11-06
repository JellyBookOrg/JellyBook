import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class RoundedImageWithShadow extends StatefulWidget {
  final String imageUrl;
  final double ratio;
  final double radius;
  final Color shadowColor;
  final Function(Size)? onImageSizeAvailable;
  final String errorWidgetAsset;

  const RoundedImageWithShadow({
    super.key,
    required this.imageUrl,
    this.ratio = 0.64,
    this.radius = 10,
    this.shadowColor = Colors.black,
    this.onImageSizeAvailable,
    this.errorWidgetAsset = 'assets/images/NoCoverArt.png',
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
            offset: const Offset(0, 3),
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
                        imageSize = constraints.biggest;

                        return Image.asset(
                          widget.errorWidgetAsset,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        imageSize = constraints.biggest;

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
