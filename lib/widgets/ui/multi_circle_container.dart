import 'package:flutter/material.dart';

class MultiCircleContainer extends StatelessWidget {
  const MultiCircleContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const largestSize = 400.0;
    const spacement = 150.0;
    // const scaleSecondCircle = largestSize - (largestSize / spacement) * 100;
    const scaleSecondCircle = largestSize - spacement;
    print('Scale: $scaleSecondCircle');
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: largestSize,
            height: largestSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Container(
            width: largestSize - spacement,
            height: largestSize - spacement,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Container(
            width: largestSize - (spacement + 50),
            height: largestSize - (spacement + 50),
            child: FittedBox(fit: BoxFit.scaleDown, child: child),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }
}
