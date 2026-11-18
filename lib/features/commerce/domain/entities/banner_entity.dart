import 'package:flutter/material.dart';

class BannerEntity {
  String image;
  String title;
  String categoryName;
  Alignment alignment;
  Color buttonBackGroundColor;
  Color buttonForGroundColor;

  BannerEntity(
    this.image,
    this.title,
    this.categoryName,
    this.alignment,
    this.buttonBackGroundColor,
    this.buttonForGroundColor,
  );
}
