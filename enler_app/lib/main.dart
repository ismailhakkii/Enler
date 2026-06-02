import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/env/env.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

// TODO(l10n): Import generated localizations after `flutter gen-l10n`
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialise Supabase
  await SupabaseService.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  // Allow Google Fonts runtime fetching (cached after first load)
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(
    const ProviderScope(
      child: EnlerApp(),
    ),
  );
}

/// Root widget for the Enler application.
///
/// Sets up Material 3 theme, router, and localisation delegates.
class EnlerApp extends ConsumerWidget {
  const EnlerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Enler',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      localizationsDelegates: const [
        // TODO(l10n): Uncomment after running `flutter gen-l10n`
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
      ],
      locale: const Locale('tr'),
    );
  }
}
