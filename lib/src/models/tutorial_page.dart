import 'package:flutter/material.dart';

enum ContentType { text, textAndImage, video, gif, mixed }

class TutorialPage {
  final String title;
  final String description;
  final ContentType contentType;
  final String? imagePath;
  final String? videoUrl;
  final String? gifPath;
  final List<String>? bulletPoints;
  final IconData? placeholderIcon;

  const TutorialPage({
    required this.title,
    required this.description,
    required this.contentType,
    this.imagePath,
    this.videoUrl,
    this.gifPath,
    this.bulletPoints,
    this.placeholderIcon,
  });
}
