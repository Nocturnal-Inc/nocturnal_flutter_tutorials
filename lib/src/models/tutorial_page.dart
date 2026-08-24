import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/src/models/instruction_point.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_section.dart';

enum ContentType { text, textAndImage, video, portraitVideo, gif, mixed }

sealed class TutorialPageType {
  const TutorialPageType();
}

class GroupPage extends TutorialPageType {
  final TutorialSection section;
  final String subtitle;
  final String? imagePath;

  /// Typed as [LeafPage], not [TutorialPage]: a section cannot contain another
  /// section. The flattener would otherwise need a downcast, and a nested
  /// [GroupPage] crashed it at runtime ("type 'GroupPage' is not a subtype of
  /// type 'LeafPage'"). Narrowing the type makes that structure a compile error.
  final List<LeafPage> children;

  const GroupPage({
    required this.section,
    required this.subtitle,
    required this.children,
    this.imagePath,
  });

  String get title => section.displayName;
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

  /// Whether the video starts playing as soon as the page appears.
  ///
  /// Defaults to true — tutorial clips play on arrival rather than waiting for
  /// a tap.
  final bool autoPlay;

  /// Whether the video repeats when it reaches the end.
  ///
  /// Defaults to true — tutorial clips are short, so looping keeps the step
  /// demonstrated for as long as the page is open.
  final bool looping;

  /// Whether this page's video plays with sound. Defaults to false — tutorial
  /// videos are silent unless the clip carries narration worth hearing.
  ///
  /// Audio pages still autoplay and loop, so the soundtrack repeats for as long
  /// as the page is open.
  final bool enableAudio;

  /// Whether rotating the device to landscape expands this page's video to
  /// fullscreen, and rotating back to portrait returns to the page.
  ///
  /// Defaults to false — pages stay portrait-locked unless they opt in. The
  /// consuming app must also permit landscape natively (Android manifest /
  /// iOS Info.plist), otherwise the OS vetoes the rotation.
  final bool allowFullScreenLandscape;

  /// Whether the video shows playback controls — play/pause, a scrub bar and
  /// remaining time — which auto-hide after a few seconds of no interaction.
  ///
  /// Defaults to **true**. Unlike [enableAudio] and [allowFullScreenLandscape]
  /// this one is opt-OUT: set it false for a page whose video should play
  /// uninterrupted.
  final bool showVideoControls;

  const LeafPage({
    required this.title,
    required this.instructionContent,
    required this.contentType,
    this.imagePath,
    this.videoUrl,
    this.gifPath,
    this.placeholderIcon,
    this.autoPlay = true,
    this.looping = true,
    this.isScrollable = false,
    this.footerText,
    this.enableAudio = false,
    this.allowFullScreenLandscape = false,
    this.showVideoControls = true,
  });
}

class TutorialPage {
  final TutorialPageType type;
  const TutorialPage(this.type);
}
