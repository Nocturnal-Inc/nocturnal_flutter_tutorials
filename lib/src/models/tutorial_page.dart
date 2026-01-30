import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/src/models/instruction_point.dart';

enum ContentType { text, textAndImage, video, portraitVideo, gif, mixed }

class TutorialPage {
  final String title;
  final List<InstructionPoint> instructionPoints;
  final ContentType contentType;
  final String? imagePath;
  final String? videoUrl;
  final String? gifPath;
  final IconData? placeholderIcon;
  final bool isScrollable;

  const TutorialPage({
    required this.title,
    required this.instructionPoints,
    required this.contentType,
    this.imagePath,
    this.videoUrl,
    this.gifPath,
    this.placeholderIcon,
    this.isScrollable = false,
  });
}
