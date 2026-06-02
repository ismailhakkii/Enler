// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Enler';

  @override
  String get appTagline => 'Arkadaşını Ne Kadar Tanıyorsun?';

  @override
  String get commonContinue => 'Devam Et';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonShare => 'Paylaş';

  @override
  String get commonLoading => 'Yükleniyor...';

  @override
  String get commonError => 'Bir hata oluştu';

  @override
  String get commonRetry => 'Tekrar Dene';

  @override
  String get commonOr => 'veya';

  @override
  String get commonDone => 'Tamam';

  @override
  String get commonNext => 'İleri';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonSearch => 'Ara';

  @override
  String get commonYes => 'Evet';

  @override
  String get commonNo => 'Hayır';

  @override
  String get authWelcomeTitle => 'Enler\'e Hoş Geldin!';

  @override
  String get authWelcomeSubtitle =>
      'Profilini oluştur, arkadaşların seni ne kadar tanıyor görsün!';

  @override
  String get authSignInWithGoogle => 'Google ile Giriş Yap';

  @override
  String get authSignInWithApple => 'Apple ile Giriş Yap';

  @override
  String get authContinueAsGuest => 'Misafir Olarak Devam Et';

  @override
  String get authSignOut => 'Çıkış Yap';

  @override
  String get authSignOutConfirm => 'Çıkış yapmak istediğine emin misin?';

  @override
  String get profileCreateTitle => 'Profilini Oluştur';

  @override
  String get profileUsername => 'Kullanıcı Adı';

  @override
  String get profileUsernameHint => 'ornek_kullanici';

  @override
  String get profileUsernameError => '3-20 karakter, küçük harf ve rakam';

  @override
  String get profileDisplayName => 'Görünen Ad';

  @override
  String get profileDisplayNameHint => 'Ahmet Yılmaz';

  @override
  String get profileSelectEmoji => 'Emoji Avatarını Seç';

  @override
  String get profileEditProfile => 'Profili Düzenle';

  @override
  String get profileMyProfile => 'Profilim';

  @override
  String get profileShareLink => 'Link\'ini Paylaş!';

  @override
  String profileTotalPlays(int count) {
    return '$count kişi çözdü';
  }

  @override
  String profileQuestionCount(int count) {
    return '$count soru';
  }

  @override
  String get questionAddTitle => 'Sorularını Ekle';

  @override
  String get questionAddSubtitle => 'Arkadaşların bu soruları cevaplayacak';

  @override
  String get questionSelectCategory => 'Kategori Seç';

  @override
  String get questionYourAnswer => 'Senin Cevabın';

  @override
  String get questionYourAnswerHint => 'Doğru cevabı yaz';

  @override
  String get questionWrongAnswers => 'Yanlış Şıklar';

  @override
  String get questionGenerateWithAI => 'AI ile Üret';

  @override
  String get questionMinQuestions => 'En az 5 soru ekle';

  @override
  String get questionMaxQuestions => 'En fazla 10 soru ekleyebilirsin';

  @override
  String get questionSaved => 'Soru kaydedildi!';

  @override
  String get questionDeleted => 'Soru silindi';

  @override
  String get categoryFavoriteColor => 'En sevdiğin renk?';

  @override
  String get categoryFavoriteFood => 'En sevdiğin yemek?';

  @override
  String get categoryFavoriteMovie => 'En sevdiğin film?';

  @override
  String get categoryFavoriteMusic => 'En sevdiğin müzik?';

  @override
  String get categoryFavoriteHobby => 'En sevdiğin hobi?';

  @override
  String get categoryFavoritePlace => 'En sevdiğin yer?';

  @override
  String get categoryFavoriteBook => 'En sevdiğin kitap?';

  @override
  String get categoryFavoriteAnimal => 'En sevdiğin hayvan?';

  @override
  String get categoryFavoriteSport => 'En sevdiğin spor?';

  @override
  String get categoryFavoriteSeason => 'En sevdiğin mevsim?';

  @override
  String get categoryPersonality => 'Kişilik';

  @override
  String get categoryDream => 'Hayal';

  @override
  String get categoryMemory => 'Anı';

  @override
  String get categoryPreference => 'Tercih';

  @override
  String get categoryCustom => 'Özel Soru';

  @override
  String quizStartTitle(String name) {
    return '$name — Quiz';
  }

  @override
  String get quizEnterName => 'Adını Gir';

  @override
  String get quizEnterNameHint => 'Adın';

  @override
  String get quizStartButton => 'Quizi Başlat!';

  @override
  String quizQuestionOf(int current, int total) {
    return '$current/$total';
  }

  @override
  String get resultTitle => 'Sonuç';

  @override
  String resultPercentage(int percentage) {
    return '%$percentage';
  }

  @override
  String resultBetterThan(int count) {
    return 'Senden daha iyi bilen: $count kişi var 😏';
  }

  @override
  String get resultShareStory => 'Story\'de Paylaş';

  @override
  String get resultCreateYours => 'Sen de Oluştur!';

  @override
  String get resultPlayAgain => 'Tekrar Çöz';

  @override
  String get badgeStranger => 'Yabancı';

  @override
  String get badgeStrangerSlogan => 'Hiç tanımıyor musun ya? 😅';

  @override
  String get badgeAcquaintance => 'Tanıdık';

  @override
  String get badgeAcquaintanceSlogan => 'Geliştirmeye açık bir arkadaşlık 😄';

  @override
  String get badgeFriend => 'Arkadaş';

  @override
  String get badgeFriendSlogan =>
      'Fena değil, ama daha iyisini yapabilirsin 💪';

  @override
  String get badgeCloseFriend => 'Yakın Dost';

  @override
  String get badgeCloseFriendSlogan => 'Ciddi ciddi tanıyorsun, saygılar 🙌';

  @override
  String get badgeBestFriend => 'Kanka';

  @override
  String get badgeBestFriendSlogan =>
      'Neredeyse kankasın, biraz daha stalkla 👀';

  @override
  String get badgeSoulmate => 'Stalker';

  @override
  String get badgeSoulmateSlogan => 'Resmen stalker, ödülü hakkediyorsun 🕵️';

  @override
  String get leaderboardTitle => 'Sıralama';

  @override
  String get leaderboardEmpty => 'Henüz kimse çözmemiş';

  @override
  String get leaderboardYourRank => 'Senin Sıran';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsAccount => 'Hesap';

  @override
  String get settingsNotifications => 'Bildirimler';

  @override
  String get settingsPrivacy => 'Gizlilik Politikası';

  @override
  String get settingsTerms => 'Kullanım Şartları';

  @override
  String settingsVersion(String version) {
    return 'Versiyon $version';
  }

  @override
  String get settingsDeleteAccount => 'Hesabı Sil';

  @override
  String get settingsDeleteAccountConfirm =>
      'Hesabını silmek istediğine emin misin? Bu işlem geri alınamaz.';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navProfile => 'Profilim';

  @override
  String get navLeaderboard => 'Sıralama';

  @override
  String shareMessage(String name, String url) {
    return '$name beni ne kadar tanıyor bak! 🤔 Sen de dene: $url';
  }

  @override
  String get errorNoInternet => 'İnternet bağlantısı bulunamadı';

  @override
  String get errorTimeout => 'İstek zaman aşımına uğradı';

  @override
  String get errorUnknown => 'Bilinmeyen bir hata oluştu';

  @override
  String get errorUsernameAlreadyTaken => 'Bu kullanıcı adı zaten alınmış';

  @override
  String get errorProfileNotFound => 'Profil bulunamadı';
}
