import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  String fontfamily,
  FontStyle fontStyle, [
  Color? color,
]) {
  return TextStyle(
    fontSize: fontSize,
    color: color, // اللون يتم تعيينه فقط إذا تم تمريره
    fontWeight: fontWeight,
    fontFamily: fontfamily,
    fontStyle: fontStyle,
  );
}

// TextStyle getAppTextStyle({
//   required double fontSize,
//   required String fontFamily,
//   FontWeight fontWeight = FontWeightManger.regular,
//   FontStyle fontStyle = FontStyle.normal,
//   Color? color,
// }) {
//   return _getTextStyle(fontSize, fontWeight, fontFamily, fontStyle, color);
// }

TextStyle getRegularStyle({
  double fontSize = FontSize.size12,
  Color? color, // اللون كمعامل اختياري
  required String fontFamily,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManger.regular,
    fontFamily,
    fontStyle ?? FontStyle.normal,
    color,
  );
}

// Medium style
TextStyle getMediumStyle({
  double fontSize = FontSize.size12,
  Color? color, // اللون كمعامل اختياري
  required String fontFamily,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManger.medium,
    fontFamily,
    fontStyle ?? FontStyle.normal,
    color,
  );
}

// Light style
TextStyle getLightStyle({
  double fontSize = FontSize.size12,
  Color? color, // اللون كمعامل اختياري
  required String fontFamily,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManger.light,
    fontFamily,
    fontStyle ?? FontStyle.normal,
    color,
  );
}

// Bold style
TextStyle getBoldStyle({
  double fontSize = FontSize.size12,
  Color? color, // اللون كمعامل اختياري
  required String fontFamily,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManger.bold,
    fontFamily,
    fontStyle ?? FontStyle.normal,
    color,
  );
}

// SemiBold style
TextStyle getSemiBoldStyle({
  double fontSize = FontSize.size12,
  Color? color, // اللون كمعامل اختياري
  required String fontFamily,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManger.semiBold,
    fontFamily,
    fontStyle ?? FontStyle.normal,
    color,
  );
}
