import 'package:flutter/material.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/session_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/auth/data/auth_remote.dart';
import 'features/auth/data/shared_preferences_session_storage.dart';
import 'features/auth/domain/repositories/auth_api.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/services/auth_service.dart';
import 'features/profile/data/profile_remote.dart';
import 'features/profile/domain/repositories/profile_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        Provider<SessionStorage>(
          create: (_) => SharedPreferencesSessionStorage(prefs),
        ),
        Provider<AuthApi>(
          create: (_) => AuthRemote(),
        ),
        Provider<ProfileApi>(
          create: (_) => ProfileRemote(),
        ),
        Provider<AuthService>(
          create: (c) => AuthService(c.read<SessionStorage>(), c.read<AuthApi>()),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (c) => AuthProvider(c.read<AuthService>()),
        ),
      ],
      child: const GastroBotApp(),
    ),
  );
}
