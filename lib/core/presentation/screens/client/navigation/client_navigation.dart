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
              icon: Icon(Icons.home_outlined, color: Colors.white, size: 38,),
              selectedIcon: Icon(Icons.home, color: Colors.lightBlue, size: 38,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined, color: Colors.white, size: 38,),
              selectedIcon: Icon(Icons.explore, color: Colors.lightBlue, size: 38,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined, color: Colors.white, size: 38,),
              selectedIcon: Icon(Icons.calendar_today, color: Colors.lightBlue, size: 38,),
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