import 'package:flutter/material.dart';

class PopularCategories extends StatelessWidget {
  const PopularCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Category',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: const [
            CategoryCard(
              title: 'Car Driver',
              image: 'lib/assets/images/image1.jpg',
              route: '/comingSoon',
            ),
            CategoryCard(
              title: 'Personal Teacher',
              image: 'lib/assets/images/image2.jpg',
              route: '/comingSoon',
            ),
            CategoryCard(
              title: 'Cleaning Service',
              image: 'lib/assets/images/image3.jpg',
              route: '/comingSoon',
            ),
            CategoryCard(
              title: 'Help Desk',
              image: 'lib/assets/images/promo.jpg',
              route: '/comingSoon',
            ),
          ],
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final String route;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.image,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}