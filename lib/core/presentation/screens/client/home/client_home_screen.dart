import 'package:flutter/material.dart';
import 'widgets/greeting_header.dart';
import 'widgets/search_bar.dart' as costum;
import 'widgets/popular_categories.dart';
import 'widgets/promo_card.dart';
import 'widgets/top_taskers.dart';
import '../navigation/client_navigation.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            GreetingHeader(),
            SizedBox(height: 24),
            costum.SearchBar(),
            SizedBox(height: 32),
            PopularCategories(),
            SizedBox(height: 32),
            PromoCard(),
            SizedBox(height: 32),
            TopTaskers(),
            ClientNavigation(),
          ],
        ),
      ),
    );
  }
}