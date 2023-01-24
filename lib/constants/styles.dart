import 'dart:ui';
import 'package:flutter/material.dart';

import 'colors.dart';


class StyleConstant {
  static TextStyle active_text = TextStyle(
    color: ColorConstant.Volonterka_theme_color,
    fontSize: 18,
    fontFamily: 'SF Pro Text',
    fontWeight: FontWeight.w400,
  );

  static TextStyle bold_header = TextStyle(
      color: ColorConstant.Black_volonterka,
      fontFamily: 'SF Pro Text',
      fontSize: 20,
      fontWeight: FontWeight.bold
  );

  static TextStyle bold = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: ColorConstant.Black_volonterka,
  );

  static TextStyle thin = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: ColorConstant.help_text,
  );

  static TextStyle bold_help = TextStyle(
    color: ColorConstant.help_text,
    fontSize: 18,
    fontFamily: 'SF Pro Text',
    fontWeight: FontWeight.w600,
  );

  static TextStyle bold_main = TextStyle(
    color: ColorConstant.Black_volonterka,
    fontSize: 18,
    fontFamily: 'SF Pro Text',
    fontWeight: FontWeight.w600,
  );

  static TextStyle thin_main = TextStyle(
    color: ColorConstant.Black_volonterka,
    fontSize: 18,
    fontFamily: 'SF Pro Text',
    fontWeight: FontWeight.w400,
  );

  static TextStyle norm_main = TextStyle(
    color: ColorConstant.Black_volonterka,
    fontSize: 17,
    fontFamily: 'SF Pro Text',
    fontWeight: FontWeight.w500,
  );

  static TextStyle thin_help = TextStyle(
    color: ColorConstant.help_text,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    fontFamily: 'SF Pro Text',
  );
}
