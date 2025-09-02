import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// Menu login
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get login;

  /// Menu register
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get register;

  /// Email
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email;

  /// Silakan masukkan email Anda.
  ///
  /// In id, this message translates to:
  /// **'Silakan masukkan email Anda.'**
  String get pleaseEnterYourEmail;

  /// Kata Sandi
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get password;

  /// Silakan masukkan kata sandi Anda.
  ///
  /// In id, this message translates to:
  /// **'Silakan masukkan kata sandi Anda.'**
  String get pleaseEnterYourPassword;

  /// Login berhasil
  ///
  /// In id, this message translates to:
  /// **'Login berhasil'**
  String get loginSuccess;

  /// Nama
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get name;

  /// Silakan masukkan nama Anda.
  ///
  /// In id, this message translates to:
  /// **'Silakan masukkan nama Anda.'**
  String get pleaseEnterYourName;

  /// Daftar berhasil
  ///
  /// In id, this message translates to:
  /// **'Daftar berhasil'**
  String get registerSuccess;

  /// Cerita
  ///
  /// In id, this message translates to:
  /// **'Cerita'**
  String get story;

  /// Memuat...
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get loading;

  /// Terjadi kesalahan
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan'**
  String get error;

  /// Tambah Cerita
  ///
  /// In id, this message translates to:
  /// **'Tambah Cerita'**
  String get addStory;

  /// Galeri
  ///
  /// In id, this message translates to:
  /// **'Galeri'**
  String get gallery;

  /// Kamera
  ///
  /// In id, this message translates to:
  /// **'Kamera'**
  String get camera;

  /// Deskripsi
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get description;

  /// Cerita ditambahkan
  ///
  /// In id, this message translates to:
  /// **'Cerita ditambahkan'**
  String get storyAdded;

  /// Gambar harus dipilih
  ///
  /// In id, this message translates to:
  /// **'Gambar harus dipilih'**
  String get imageMustBeSelected;

  /// Gambar harus kurang dari 1MB
  ///
  /// In id, this message translates to:
  /// **'Gambar harus kurang dari 1MB'**
  String get imageMustBeLessThan1Mb;

  /// Deskripsi harus diisi
  ///
  /// In id, this message translates to:
  /// **'Deskripsi harus diisi'**
  String get descriptionMustBeFilled;

  /// Keluar
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
