import 'package:nocturnal_flutter_tutorials/src/models/tutorial_page.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_section.dart';

/// A single entry in the flat page list shown by [TutorialBook].
///
/// Each entry is either a [SectionCover] (dedicated title page) or a
/// [ContentPage] (regular tutorial content).
sealed class BookEntry {
  const BookEntry();
}

class SectionCover extends BookEntry {
  final TutorialSection section;
  const SectionCover(this.section);
}

class ContentPage extends BookEntry {
  final TutorialPage page;
  final TutorialSection section;
  const ContentPage(this.page, this.section);
}
