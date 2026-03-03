import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/main_shell.dart';

class GastroBotApp extends StatelessWidget {
  const GastroBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GastroBot Manager',
      theme: AppTheme.light,
      home: Consumer<AuthProvider>(
        builder: (_, auth, __) {
          if (auth.isLoggedIn) {
            return const MainShell();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
