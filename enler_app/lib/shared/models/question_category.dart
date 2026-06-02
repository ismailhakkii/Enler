/// Represents a question category that users can choose from
/// when adding questions to their profile.
///
/// Each category has a machine-readable [key], a Turkish display
/// label [labelTr], and an [emoji] for visual identification.
class QuestionCategory {
  const QuestionCategory({
    required this.key,
    required this.labelTr,
    required this.emoji,
  });

  /// Machine-readable unique key (stored in the database).
  final String key;

  /// Turkish display label for the UI.
  final String labelTr;

  /// Emoji icon representing the category.
  final String emoji;

  /// All available question categories.
  static const List<QuestionCategory> all = [
    QuestionCategory(
      key: 'favorite_food',
      labelTr: 'En Sevdiği Yemek',
      emoji: '🍕',
    ),
    QuestionCategory(
      key: 'favorite_movie',
      labelTr: 'En Sevdiği Film',
      emoji: '🎬',
    ),
    QuestionCategory(
      key: 'favorite_music',
      labelTr: 'En Sevdiği Müzik',
      emoji: '🎵',
    ),
    QuestionCategory(
      key: 'favorite_color',
      labelTr: 'En Sevdiği Renk',
      emoji: '🎨',
    ),
    QuestionCategory(
      key: 'favorite_place',
      labelTr: 'En Sevdiği Yer',
      emoji: '🌍',
    ),
    QuestionCategory(
      key: 'favorite_hobby',
      labelTr: 'En Sevdiği Hobi',
      emoji: '⚽',
    ),
    QuestionCategory(
      key: 'favorite_book',
      labelTr: 'En Sevdiği Kitap',
      emoji: '📚',
    ),
    QuestionCategory(
      key: 'favorite_series',
      labelTr: 'En Sevdiği Dizi',
      emoji: '📺',
    ),
    QuestionCategory(
      key: 'favorite_season',
      labelTr: 'En Sevdiği Mevsim',
      emoji: '🌸',
    ),
    QuestionCategory(
      key: 'favorite_animal',
      labelTr: 'En Sevdiği Hayvan',
      emoji: '🐱',
    ),
    QuestionCategory(
      key: 'dream_job',
      labelTr: 'Hayalindeki Meslek',
      emoji: '💼',
    ),
    QuestionCategory(
      key: 'biggest_fear',
      labelTr: 'En Büyük Korkusu',
      emoji: '😱',
    ),
    QuestionCategory(
      key: 'superpower',
      labelTr: 'İstediği Süper Güç',
      emoji: '🦸',
    ),
    QuestionCategory(
      key: 'travel_destination',
      labelTr: 'Gitmek İstediği Ülke',
      emoji: '✈️',
    ),
    QuestionCategory(
      key: 'life_motto',
      labelTr: 'Hayat Mottosu',
      emoji: '💡',
    ),
  ];

  /// Finds a [QuestionCategory] by its unique [key].
  ///
  /// Returns `null` if no category matches.
  static QuestionCategory? fromKey(String key) {
    for (final category in all) {
      if (category.key == key) return category;
    }
    return null;
  }

  @override
  String toString() => 'QuestionCategory($key)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionCategory &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}
