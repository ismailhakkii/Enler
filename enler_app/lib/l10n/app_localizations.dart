import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Enler'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşını Ne Kadar Tanıyorsun?'**
  String get appTagline;

  /// No description provided for @commonContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get commonContinue;

  /// No description provided for @commonCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get commonEdit;

  /// No description provided for @commonShare.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get commonShare;

  /// No description provided for @commonLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get commonRetry;

  /// No description provided for @commonOr.
  ///
  /// In tr, this message translates to:
  /// **'veya'**
  String get commonOr;

  /// No description provided for @commonDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get commonDone;

  /// No description provided for @commonNext.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get commonBack;

  /// No description provided for @commonClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get commonClose;

  /// No description provided for @commonSearch.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get commonSearch;

  /// No description provided for @commonYes.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get commonNo;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Enler\'e Hoş Geldin!'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Profilini oluştur, arkadaşların seni ne kadar tanıyor görsün!'**
  String get authWelcomeSubtitle;

  /// No description provided for @authSignInWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Giriş Yap'**
  String get authSignInWithGoogle;

  /// No description provided for @authSignInWithApple.
  ///
  /// In tr, this message translates to:
  /// **'Apple ile Giriş Yap'**
  String get authSignInWithApple;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir Olarak Devam Et'**
  String get authContinueAsGuest;

  /// No description provided for @authSignOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get authSignOut;

  /// No description provided for @authSignOutConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapmak istediğine emin misin?'**
  String get authSignOutConfirm;

  /// No description provided for @profileCreateTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profilini Oluştur'**
  String get profileCreateTitle;

  /// No description provided for @profileUsername.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı Adı'**
  String get profileUsername;

  /// No description provided for @profileUsernameHint.
  ///
  /// In tr, this message translates to:
  /// **'ornek_kullanici'**
  String get profileUsernameHint;

  /// No description provided for @profileUsernameError.
  ///
  /// In tr, this message translates to:
  /// **'3-20 karakter, küçük harf ve rakam'**
  String get profileUsernameError;

  /// No description provided for @profileDisplayName.
  ///
  /// In tr, this message translates to:
  /// **'Görünen Ad'**
  String get profileDisplayName;

  /// No description provided for @profileDisplayNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Ahmet Yılmaz'**
  String get profileDisplayNameHint;

  /// No description provided for @profileSelectEmoji.
  ///
  /// In tr, this message translates to:
  /// **'Emoji Avatarını Seç'**
  String get profileSelectEmoji;

  /// No description provided for @profileEditProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profili Düzenle'**
  String get profileEditProfile;

  /// No description provided for @profileMyProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profilim'**
  String get profileMyProfile;

  /// No description provided for @profileShareLink.
  ///
  /// In tr, this message translates to:
  /// **'Link\'ini Paylaş!'**
  String get profileShareLink;

  /// No description provided for @profileTotalPlays.
  ///
  /// In tr, this message translates to:
  /// **'{count} kişi çözdü'**
  String profileTotalPlays(int count);

  /// No description provided for @profileQuestionCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} soru'**
  String profileQuestionCount(int count);

  /// No description provided for @questionAddTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sorularını Ekle'**
  String get questionAddTitle;

  /// No description provided for @questionAddSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşların bu soruları cevaplayacak'**
  String get questionAddSubtitle;

  /// No description provided for @questionSelectCategory.
  ///
  /// In tr, this message translates to:
  /// **'Kategori Seç'**
  String get questionSelectCategory;

  /// No description provided for @questionYourAnswer.
  ///
  /// In tr, this message translates to:
  /// **'Senin Cevabın'**
  String get questionYourAnswer;

  /// No description provided for @questionYourAnswerHint.
  ///
  /// In tr, this message translates to:
  /// **'Doğru cevabı yaz'**
  String get questionYourAnswerHint;

  /// No description provided for @questionWrongAnswers.
  ///
  /// In tr, this message translates to:
  /// **'Yanlış Şıklar'**
  String get questionWrongAnswers;

  /// No description provided for @questionGenerateWithAI.
  ///
  /// In tr, this message translates to:
  /// **'AI ile Üret'**
  String get questionGenerateWithAI;

  /// No description provided for @questionMinQuestions.
  ///
  /// In tr, this message translates to:
  /// **'En az 5 soru ekle'**
  String get questionMinQuestions;

  /// No description provided for @questionMaxQuestions.
  ///
  /// In tr, this message translates to:
  /// **'En fazla 10 soru ekleyebilirsin'**
  String get questionMaxQuestions;

  /// No description provided for @questionSaved.
  ///
  /// In tr, this message translates to:
  /// **'Soru kaydedildi!'**
  String get questionSaved;

  /// No description provided for @questionDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Soru silindi'**
  String get questionDeleted;

  /// No description provided for @categoryFavoriteColor.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin renk?'**
  String get categoryFavoriteColor;

  /// No description provided for @categoryFavoriteFood.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin yemek?'**
  String get categoryFavoriteFood;

  /// No description provided for @categoryFavoriteMovie.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin film?'**
  String get categoryFavoriteMovie;

  /// No description provided for @categoryFavoriteMusic.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin müzik?'**
  String get categoryFavoriteMusic;

  /// No description provided for @categoryFavoriteHobby.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin hobi?'**
  String get categoryFavoriteHobby;

  /// No description provided for @categoryFavoritePlace.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin yer?'**
  String get categoryFavoritePlace;

  /// No description provided for @categoryFavoriteBook.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin kitap?'**
  String get categoryFavoriteBook;

  /// No description provided for @categoryFavoriteAnimal.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin hayvan?'**
  String get categoryFavoriteAnimal;

  /// No description provided for @categoryFavoriteSport.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin spor?'**
  String get categoryFavoriteSport;

  /// No description provided for @categoryFavoriteSeason.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin mevsim?'**
  String get categoryFavoriteSeason;

  /// No description provided for @categoryPersonality.
  ///
  /// In tr, this message translates to:
  /// **'Kişilik'**
  String get categoryPersonality;

  /// No description provided for @categoryDream.
  ///
  /// In tr, this message translates to:
  /// **'Hayal'**
  String get categoryDream;

  /// No description provided for @categoryMemory.
  ///
  /// In tr, this message translates to:
  /// **'Anı'**
  String get categoryMemory;

  /// No description provided for @categoryPreference.
  ///
  /// In tr, this message translates to:
  /// **'Tercih'**
  String get categoryPreference;

  /// No description provided for @categoryCustom.
  ///
  /// In tr, this message translates to:
  /// **'Özel Soru'**
  String get categoryCustom;

  /// No description provided for @quizStartTitle.
  ///
  /// In tr, this message translates to:
  /// **'{name} — Quiz'**
  String quizStartTitle(String name);

  /// No description provided for @quizEnterName.
  ///
  /// In tr, this message translates to:
  /// **'Adını Gir'**
  String get quizEnterName;

  /// No description provided for @quizEnterNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Adın'**
  String get quizEnterNameHint;

  /// No description provided for @quizStartButton.
  ///
  /// In tr, this message translates to:
  /// **'Quizi Başlat!'**
  String get quizStartButton;

  /// No description provided for @quizQuestionOf.
  ///
  /// In tr, this message translates to:
  /// **'{current}/{total}'**
  String quizQuestionOf(int current, int total);

  /// No description provided for @resultTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç'**
  String get resultTitle;

  /// No description provided for @resultPercentage.
  ///
  /// In tr, this message translates to:
  /// **'%{percentage}'**
  String resultPercentage(int percentage);

  /// No description provided for @resultBetterThan.
  ///
  /// In tr, this message translates to:
  /// **'Senden daha iyi bilen: {count} kişi var 😏'**
  String resultBetterThan(int count);

  /// No description provided for @resultShareStory.
  ///
  /// In tr, this message translates to:
  /// **'Story\'de Paylaş'**
  String get resultShareStory;

  /// No description provided for @resultCreateYours.
  ///
  /// In tr, this message translates to:
  /// **'Sen de Oluştur!'**
  String get resultCreateYours;

  /// No description provided for @resultPlayAgain.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Çöz'**
  String get resultPlayAgain;

  /// No description provided for @badgeStranger.
  ///
  /// In tr, this message translates to:
  /// **'Yabancı'**
  String get badgeStranger;

  /// No description provided for @badgeStrangerSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Hiç tanımıyor musun ya? 😅'**
  String get badgeStrangerSlogan;

  /// No description provided for @badgeAcquaintance.
  ///
  /// In tr, this message translates to:
  /// **'Tanıdık'**
  String get badgeAcquaintance;

  /// No description provided for @badgeAcquaintanceSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Geliştirmeye açık bir arkadaşlık 😄'**
  String get badgeAcquaintanceSlogan;

  /// No description provided for @badgeFriend.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaş'**
  String get badgeFriend;

  /// No description provided for @badgeFriendSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Fena değil, ama daha iyisini yapabilirsin 💪'**
  String get badgeFriendSlogan;

  /// No description provided for @badgeCloseFriend.
  ///
  /// In tr, this message translates to:
  /// **'Yakın Dost'**
  String get badgeCloseFriend;

  /// No description provided for @badgeCloseFriendSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Ciddi ciddi tanıyorsun, saygılar 🙌'**
  String get badgeCloseFriendSlogan;

  /// No description provided for @badgeBestFriend.
  ///
  /// In tr, this message translates to:
  /// **'Kanka'**
  String get badgeBestFriend;

  /// No description provided for @badgeBestFriendSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Neredeyse kankasın, biraz daha stalkla 👀'**
  String get badgeBestFriendSlogan;

  /// No description provided for @badgeSoulmate.
  ///
  /// In tr, this message translates to:
  /// **'Stalker'**
  String get badgeSoulmate;

  /// No description provided for @badgeSoulmateSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Resmen stalker, ödülü hakkediyorsun 🕵️'**
  String get badgeSoulmateSlogan;

  /// No description provided for @leaderboardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get leaderboardTitle;

  /// No description provided for @leaderboardEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kimse çözmemiş'**
  String get leaderboardEmpty;

  /// No description provided for @leaderboardYourRank.
  ///
  /// In tr, this message translates to:
  /// **'Senin Sıran'**
  String get leaderboardYourRank;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get settingsAccount;

  /// No description provided for @settingsNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get settingsNotifications;

  /// No description provided for @settingsPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Şartları'**
  String get settingsTerms;

  /// No description provided for @settingsVersion.
  ///
  /// In tr, this message translates to:
  /// **'Versiyon {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı Sil'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Hesabını silmek istediğine emin misin? Bu işlem geri alınamaz.'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navHome;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profilim'**
  String get navProfile;

  /// No description provided for @navLeaderboard.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get navLeaderboard;

  /// No description provided for @shareMessage.
  ///
  /// In tr, this message translates to:
  /// **'{name} beni ne kadar tanıyor bak! 🤔 Sen de dene: {url}'**
  String shareMessage(String name, String url);

  /// No description provided for @errorNoInternet.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı bulunamadı'**
  String get errorNoInternet;

  /// No description provided for @errorTimeout.
  ///
  /// In tr, this message translates to:
  /// **'İstek zaman aşımına uğradı'**
  String get errorTimeout;

  /// No description provided for @errorUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen bir hata oluştu'**
  String get errorUnknown;

  /// No description provided for @errorUsernameAlreadyTaken.
  ///
  /// In tr, this message translates to:
  /// **'Bu kullanıcı adı zaten alınmış'**
  String get errorUsernameAlreadyTaken;

  /// No description provided for @errorProfileNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Profil bulunamadı'**
  String get errorProfileNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
