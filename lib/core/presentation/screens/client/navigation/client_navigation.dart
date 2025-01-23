import 'package:flutter/material.dart';
import '../home/client_home_screen.dart';
import '../map/services_map_screen.dart';
import '../requests/client_requests_screen.dart';
import '../profile/client_profile_screen.dart';

class ClientNavigation extends StatefulWidget {
  const ClientNavigation({Key? key}) : super(key: key);

  @override
  State<ClientNavigation> createState() => _ClientNavigationState();
}

class _ClientNavigationState extends State<ClientNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ClientHomeScreen(),
    const MapScreen(),
    ClientRequestsScreen(),
    const ClientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                    (Set<MaterialState> states) {
                  // Always return white color for labels
                  return const TextStyle(
                    color: Colors.white, // Label color is always white
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  );
                },
              ),
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              backgroundColor: Colors.black,
              indicatorColor: Colors.transparent,
              elevation: 0,
              height: 80, // Increased height
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Colors.white, size: 30), // Slightly larger icons
                  selectedIcon: Icon(Icons.home, color: Colors.lightBlue, size: 30),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined, color: Colors.white, size: 30),
                  selectedIcon: Icon(Icons.explore, color: Colors.lightBlue, size: 30),
                  label: 'Explore',
                ),
                NavigationDestination(
                  icon: Icon(Icons.request_page_outlined, color: Colors.white, size: 30),
                  selectedIcon: Icon(Icons.request_page, color: Colors.lightBlue, size: 30),
                  label: 'Requests',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline, color: Colors.white, size: 30),
                  selectedIcon: Icon(Icons.person, color: Colors.lightBlue, size: 30),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}