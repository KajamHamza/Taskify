import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/models/user_model.dart';
import 'core/presentation/screens/auth/auth_screen.dart';
import 'core/presentation/screens/client/navigation/client_navigation.dart';
import 'core/presentation/screens/onboarding/onboarding_screen.dart';
import 'core/presentation/screens/onboarding/splash_screen.dart';
import 'core/presentation/screens/provider/navigation/provider_navigation.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/route_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: '',
        authDomain: '',
        projectId: '',
        storageBucket: '',
        messagingSenderId: '',
        appId: '',
        measurementId: '',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiceHub',
      theme: AppTheme.lightTheme,
      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (authSnapshot.hasData) {
            return StreamBuilder<UserModel>(
              stream: FirestoreService().getUserStream(authSnapshot.data!.uid),
              builder: (context, userSnapshot) {

                if (userSnapshot.hasData) {
                  return userSnapshot.data!.userType == UserType.serviceProvider
                      ? const ProviderNavigation()
                      : const ClientNavigation();
                }

                return const AuthScreen();
              },
            );
          }

          return const AuthScreen();
        },
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}