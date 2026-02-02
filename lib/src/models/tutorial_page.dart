import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/src/models/instruction_point.dart';
import 'package:nocturnal_flutter_tutorials/src/models/section_type.dart';

enum ContentType { text, textAndImage, video, portraitVideo, gif, mixed }

sealed class TutorialPageType {
  const TutorialPageType();
}

class GroupPage extends TutorialPageType {
  final SectionType sectionType;
  final String subtitle;
  final String? imagePath;
  final List<TutorialPage> children;

  const GroupPage({
    required this.sectionType,
    required this.subtitle,
    required this.children,
    this.imagePath,
  });

  String get title => sectionType.displayName;
}

class LeafPage extends TutorialPageType {
  final String title;
  final InstructionContent instructionContent;
  final ContentType contentType;
  final String? imagePath;
  final String? videoUrl;
  final String? gifPath;
  final IconData? placeholderIcon;
  final bool isScrollable;
  final String? footerText;

  const LeafPage({
    required this.title,
    required this.instructionContent,
    required this.contentType,
    this.imagePath,
    this.videoUrl,
    this.gifPath,
    this.placeholderIcon,
    this.isScrollable = false,
    this.footerText,
  });
}

class TutorialPage {
  final TutorialPageType type;
  const TutorialPage(this.type);
}
