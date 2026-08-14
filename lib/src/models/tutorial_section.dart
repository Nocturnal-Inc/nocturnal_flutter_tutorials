/// Identity for a group of tutorial pages, rendered as a section cover.
///
/// Deliberately an open value type rather than an enum: sections are *content*,
/// so the client defines its own. Declare them as constants next to your page
/// list, e.g.:
///
/// ```dart
/// const powering = TutorialSection(id: 'powering_on', displayName: 'Powering On');
/// ```
///
/// [id] is the stable key used for filtering (so display copy can change
/// without breaking callers); [displayName] is what the cover shows.
class TutorialSection {
  final String id;
  final String displayName;

  const TutorialSection({required this.id, required this.displayName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is TutorialSection && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TutorialSection($id)';
}
