/// One entry in a [DetailedInstructions] list: a headline/description block ([InstructionPoint])
/// or an inline bullet list ([BulletPoints]), interleaved in any order.
sealed class InstructionItem {
  const InstructionItem();
}

/// Every field is optional so a point can be just a headline introducing a following
/// [BulletPoints], or just a closing tip after one — without rendering empty text.
class InstructionPoint extends InstructionItem {
  final String? headline;
  final String? description;
  final String? tip;

  const InstructionPoint({this.headline, this.description, this.tip});
}

/// A single bullet. [label] renders bold ahead of [text] as "label: text"; null is a plain bullet.
class Bullet {
  final String text;
  final String? label;

  const Bullet(this.text, {this.label});
}

sealed class InstructionContent {
  const InstructionContent();
}

class DetailedInstructions extends InstructionContent {
  final List<InstructionItem> points;
  const DetailedInstructions({required this.points});
}

/// Stands alone as page content, and nests inside [DetailedInstructions.points] — hence both
/// the `InstructionContent` base and the `InstructionItem` interface.
class BulletPoints extends InstructionContent implements InstructionItem {
  final List<Bullet> bullets;

  const BulletPoints({required this.bullets});

  /// Plain bullets: `BulletPoints.text(['a', 'b'])`.
  BulletPoints.text(List<String> bullets)
    : bullets = [for (final b in bullets) Bullet(b)];

  /// Bold-label bullets: `{'Green light': 'Optimization has started'}` → "**Green light**: …".
  BulletPoints.labeled(Map<String, String> bullets)
    : bullets = [
        for (final e in bullets.entries) Bullet(e.value, label: e.key),
      ];
}
