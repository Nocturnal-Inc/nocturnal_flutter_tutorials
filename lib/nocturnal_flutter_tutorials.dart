/// Tutorial Book
///
/// A reusable, content-agnostic tutorial engine: an optional welcome screen
/// followed by a swipeable book of section covers and content pages.
///
/// The client owns the content. Build a `List<TutorialPage>` from [GroupPage]
/// and [LeafPage] and hand it to [TutorialBook] — this package ships no
/// copy and no assets of its own.
library;

// Data model — the blueprint clients build their tutorials from.
export 'package:nocturnal_flutter_tutorials/src/models/tutorial_section.dart';
export 'package:nocturnal_flutter_tutorials/src/models/tutorial_page.dart';
export 'package:nocturnal_flutter_tutorials/src/models/instruction_point.dart';

// The engine.
export 'package:nocturnal_flutter_tutorials/src/widgets/tutorial_book.dart';

// Reusable primitives.
export 'package:nocturnal_flutter_tutorials/src/widgets/amoeba_background.dart';
export 'package:nocturnal_flutter_tutorials/src/widgets/video_player_widget.dart';

// Default theme (still Nocturnal-branded; parameterized in a later phase).
export 'package:nocturnal_flutter_tutorials/src/theme/tutorials_theme.dart';
