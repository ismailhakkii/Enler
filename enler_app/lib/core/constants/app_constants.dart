/// Application-wide constants.
///
/// Keep runtime configuration in [Env] and visual constants in the
/// theme layer. This class holds product / business constants only.
sealed class AppConstants {
  static const appName = 'Enler';
  static const appTagline = 'Arkadaşını Ne Kadar Tanıyorsun?';
  static const domain = 'enlerapp.com';
  static const maxQuestions = 10;
  static const minQuestions = 5;
  static const quizTimeoutSeconds = 15;
  static const bundleId = 'com.codebros.enler';
  static const publisher = 'CodeBros';
}
