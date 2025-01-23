import 'package:Taskify/core/presentation/screens/chat/chat_list_screen.dart';
import 'package:Taskify/core/presentation/screens/chat/chat_screen.dart';
import 'package:Taskify/core/presentation/screens/client/requests/client_requests_screen.dart';
import 'package:Taskify/core/presentation/screens/notifications/notifications_screen.dart';
import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../presentation/screens/client/Coming_soon_page.dart';
import '../presentation/screens/client/home/client_home_screen.dart';
import '../presentation/screens/client/map/services_map_screen.dart';
import '../presentation/screens/client/profile/edit_profile_screen.dart';
import '../presentation/screens/client/service_details/service_details_screen.dart';
import '../presentation/screens/onboarding/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/auth/auth_screen.dart';
import '../presentation/screens/provider/services/provider_services_screen.dart';
import '../presentation/screens/provider/setup/add_service_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/setup':
        return MaterialPageRoute(builder: (_) => const AddServiceScreen());
      case '/client/home':
        return MaterialPageRoute(builder: (_) => const ClientHomeScreen());
      case '/provider/home':
        return MaterialPageRoute(builder: (_) => const ProviderServicesScreen());
      case '/client/map':
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case '/client/requests':
        return MaterialPageRoute(builder: (_) => ClientRequestsScreen());
      case '/service-details':
        return MaterialPageRoute(builder: (_) => ServiceDetailsScreen( service: settings.arguments as ServiceModel));
      case '/editProfile':
        return MaterialPageRoute(builder: (_) => EditProfilePage(user: settings.arguments as UserModel));
      case '/comingSoon':
        return MaterialPageRoute(builder: (_) => const ComingSoonPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}