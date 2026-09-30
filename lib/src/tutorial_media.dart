import 'dart:io';

import 'package:flutter/material.dart';

/// Maps a content media path to where it should load from; null means "use the path as given".
typedef TutorialMediaResolver = Future<String?> Function(String path);

/// Hook letting the client serve tutorial media from downloaded files instead of the bundle.
class TutorialMedia {
  TutorialMedia._();

  /// Set once by the client at startup; left null the package reads bundled assets as before.
  static TutorialMediaResolver? resolver;

  /// Returns the resolved path, falling back to [path] so a failing resolver never blanks a page.
  static Future<String> resolve(String path) async {
    final r = resolver;
    if (r == null) return path;
    try {
      return await r(path) ?? path;
    } catch (_) {
      return path;
    }
  }

  /// Absolute paths are downloaded files; everything else is a bundled asset key.
  static bool isFilePath(String path) => path.startsWith('/');
}

/// Image that resolves its path through [TutorialMedia] before picking Image.file or Image.asset.
class TutorialMediaImage extends StatefulWidget {
  final String path;
  final double? width;
  final BoxFit? fit;
  final Widget Function()? placeholder;

  const TutorialMediaImage({
    super.key,
    required this.path,
    this.width,
    this.fit,
    this.placeholder,
  });

  @override
  State<TutorialMediaImage> createState() => _TutorialMediaImageState();
}

class _TutorialMediaImageState extends State<TutorialMediaImage> {
  late Future<String> _resolved;

  @override
  void initState() {
    super.initState();
    _resolved = TutorialMedia.resolve(widget.path);
  }

  @override
  void didUpdateWidget(covariant TutorialMediaImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _resolved = TutorialMedia.resolve(widget.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolved,
      // Without a resolver the path is final, so the first frame draws the image instead of the placeholder.
      initialData: TutorialMedia.resolver == null ? widget.path : null,
      builder: (context, snapshot) {
        final resolved = snapshot.data;
        if (resolved == null) {
          return widget.placeholder?.call() ?? const SizedBox.shrink();
        }
        Widget onError(BuildContext _, Object __, StackTrace? ___) =>
            widget.placeholder?.call() ?? const SizedBox.shrink();
        if (TutorialMedia.isFilePath(resolved)) {
          return Image.file(
            File(resolved),
            width: widget.width,
            fit: widget.fit,
            errorBuilder: onError,
          );
        }
        return Image.asset(
          resolved,
          width: widget.width,
          fit: widget.fit,
          errorBuilder: onError,
        );
      },
    );
  }
}
