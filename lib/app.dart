import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/l10n/locale_provider.dart';
import 'package:gastrobotmanager/core/theme/app_theme.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/auth/screens/login_screen.dart';
import 'package:gastrobotmanager/features/home/screens/main_shell.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

class GastroBotApp extends StatelessWidget {
  const GastroBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return MaterialApp(
          title: 'GastroBot Manager',
          theme: AppTheme.light,
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Consumer<AuthProvider>(
            builder: (_, auth, __) {
              if (auth.isRestoring) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (auth.isLoggedIn) {
                return const MainShell();
              }
              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
