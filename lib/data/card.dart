enum WordType { male, female, neutral, plural, unknown }

WordType parseWordType(String str) {
  switch (str) {
    case "male": return WordType.male;
    case "female": return WordType.female;
    case "neutral": return WordType.neutral;
    case "plural": return WordType.plural;
    default: return WordType.unknown;
  }
}


class WordCard {
  String word;
  String value;
  WordType wordType;

  WordCard(this.word, this.value, this.wordType);
}

