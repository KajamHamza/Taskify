import 'package:flutter/material.dart';
import '../services/provider_services_screen.dart';
import '../requests/provider_requests_screen.dart';
import '../statistics/provider_statistics_screen.dart';
import '../profile/provider_profile_screen.dart';

class ProviderNavigation extends StatefulWidget {
  const ProviderNavigation({Key? key}) : super(key: key);

  @override
  State<ProviderNavigation> createState() => _ProviderNavigationState();
}

class _ProviderNavigationState extends State<ProviderNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProviderServicesScreen(),
    ProviderStatisticsScreen(),
    ProviderRequestsScreen(),
    ProviderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          /*indicatorShape: CircleBorder(
            side: BorderSide(color: Colors.lightBlue, width:),
          ),*/
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.add_outlined, color: Colors.white, size: 38,),
              selectedIcon: Icon(Icons.add, color: Colors.lightBlue, size: 38,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.query_stats_outlined, color: Colors.white, size: 38,),
              selectedIcon: Icon(Icons.query_stats, color: Colors.lightBlue, size: 38,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined, color: Colors.white, size: 38,),
              selectedIcon: Icon(Icons.history_outlined, color: Colors.lightBlue, size: 38,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white, size: 38,),
              selectedIcon: Icon(Icons.person, color: Colors.lightBlue, size: 38,),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}