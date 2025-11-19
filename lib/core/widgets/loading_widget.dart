import 'package:flutter/material.dart';
import '../resources/colors.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;
  final double? size;
  final double? strokeWidth;

  const LoadingWidget({super.key, this.color, this.size, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 40,
        height: size ?? 40,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
          strokeWidth: strokeWidth ?? 3,
        ),
      ),
    );
  }
}
