import 'package:flutter/material.dart';

class CafeMarker extends StatelessWidget {
  const CafeMarker({
    super.key,
    required this.id,
    required this.globalKey,
    required this.title,
    required this.rating,
    required this.isSelected,
  });

  final String id;
  final GlobalKey globalKey;
  final String title;
  final double rating;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final baseWidth = 120.0 * (isSelected ? 1.5 : 1);
    final markerSize = Size(baseWidth, baseWidth);
    final iconSize = 40.0 * (isSelected ? 1.5 : 1);
    final radius = iconSize * 1.2;

    final textWidth = markerSize.width * 1.9;

    final fontSize = 32.0 * (isSelected ? 1.1 : 1);

    const fontColor = Colors.black;
    const fontBorderColor = Colors.white;
    return RepaintBoundary(
      key: globalKey,
      child: SizedBox(
        width: textWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: radius,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_cafe,
                        color: Colors.white,
                        size: iconSize,
                      ),
                      Flexible(
                        child: Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            height: 1.2,
                            color: Colors.white,
                            fontSize: fontSize * 0.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: textWidth,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: fontColor,
                  fontSize: fontSize,
                  height: 1.3,
                  shadows: const [
                    Shadow(
                      offset: Offset(-1.5, -1.5),
                      color: fontBorderColor,
                    ),
                    Shadow(
                      offset: Offset(1.5, -1.5),
                      color: fontBorderColor,
                    ),
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      color: fontBorderColor,
                    ),
                    Shadow(
                      offset: Offset(-1.5, 1.5),
                      color: fontBorderColor,
                    ),
                  ],
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
