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

enum RelatedType { plural, neutral, male, female, unknown }

RelatedType parseRelatedWordType(String str) {
  switch (str) {
    case "neutral":
    case "singular":
      return RelatedType.neutral;
    case "male":
      return RelatedType.male;
    case "female":
      return RelatedType.female;
    case "plural":
      return RelatedType.plural;
    default:
      return RelatedType.unknown;
  }
}

String relatedTypeName(RelatedType type) {
  switch (type) {
    case RelatedType.male: return "Male";
    case RelatedType.female: return "Female";
    case RelatedType.neutral: return "Neutral";
    case RelatedType.plural: return "Plural";
    default: return "Unknown";
  }
}

class RelatedWord {
  final RelatedType type;
  final String word;

  const RelatedWord(this.type, this.word);
}

abstract class HasKey {
  String get key;
}

class WordCard implements HasKey {
  final String word;
  final String value;
  final WordType wordType;
  final List<RelatedWord> relatedWords;

  const WordCard(this.word, this.value, this.wordType, this.relatedWords);

  @override
  String toString() {
    return 'WordCard{word: $word, value: $value, wordType: $wordType, relatedWords: $relatedWords}';
  }

  @override
  String get key => word;
}

class VerbFormCard implements HasKey {
  final String word;
  final String translation;
  final Map<String, String> forms;

  const VerbFormCard(this.word, this.translation, this.forms);

  @override
  String toString() {
    return 'VerbFormCard{word: $word, translation: $translation, forms: $forms}';
  }

  @override
  String get key => word;
}

class SentenceCard implements HasKey {
  final String question;
  final String translation;
  final String answer;
  final String answerTranslation;

  const SentenceCard(this.question, this.translation, this.answer, this.answerTranslation);

  @override
  String get key => question;
}
