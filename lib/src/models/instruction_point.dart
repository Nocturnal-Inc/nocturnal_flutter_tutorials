class InstructionPoint {
  final String headline;
  final String description;
  final String? tip;

  const InstructionPoint({required this.headline, required this.description, this.tip});
}

sealed class InstructionContent {
  const InstructionContent();
}

class DetailedInstructions extends InstructionContent {
  final List<InstructionPoint> points;
  const DetailedInstructions({required this.points});
}

class BulletPoints extends InstructionContent {
  final List<String> bullets;
  const BulletPoints({required this.bullets});
}
