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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add margin for floating effect
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 10, // Shadow blur
              offset: const Offset(0, 4), // Shadow position
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30), // Clip the child with rounded corners
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
              backgroundColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              elevation: 0,
              height: 80, // Adjusted height
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.add_outlined, color: Colors.white, size: 30), // Adjusted icon size
                  selectedIcon: Icon(Icons.add, color: Colors.lightBlue, size: 30),
                  label: 'Services',
                ),
                NavigationDestination(
                  icon: Icon(Icons.query_stats_outlined, color: Colors.white, size: 30),
                  selectedIcon: Icon(Icons.query_stats, color: Colors.lightBlue, size: 30),
                  label: 'Statistics',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_outlined, color: Colors.white, size: 30),
                  selectedIcon: Icon(Icons.history_outlined, color: Colors.lightBlue, size: 30),
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
