import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'app_text.dart';

class CustomBotton extends StatelessWidget {
  final double? height, width, borderRadius, fontSize, spacing;
  final Color? backgroundColor, iconColor, textColor, borderColor;
  final String? imagePath, label;
  final FontWeight? fontWeight;
  final BoxBorder? border;
  final double? imageheight;
  final double? imageWidth;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;

  const CustomBotton(
      {super.key,
      this.height,
      this.width,
      this.borderRadius,
      this.backgroundColor,
      this.imagePath,
      this.iconColor,
      this.label,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.borderColor,
      this.border,
      this.padding,
      this.onTap,
      this.spacing,
      this.imageheight,
      this.imageWidth});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        height: height ?? 52,
        width: width ?? 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          border: border ??
              Border.all(
                color: borderColor ?? Colors.transparent,
                width: 1,
              ),
          color: backgroundColor ?? AppColors.green,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null && imagePath!.isNotEmpty)
              SvgPicture.asset(
                height: imageheight,
                width: imageWidth,
                imagePath!,
                color: iconColor,
              ),
            SizedBox(
              width: spacing,
            ),
            AppText(
              textAlign: TextAlign.center,
              text: label ?? "",
              textColor: textColor ?? Colors.white,
              fontWeight: fontWeight ?? FontWeight.w400,
              fontSize: fontSize ?? 15,
            ),
          ],
        ),
      ),
    );
  }
}
