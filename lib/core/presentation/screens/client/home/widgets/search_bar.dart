import 'package:flutter/material.dart';

import '../../../../../services/firestore_service.dart';
import '../../search/search_result_screens.dart';


class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: ServiceSearchDelegate(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              'What do you need help with?',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceSearchDelegate extends SearchDelegate<String> {
  final _firestoreService = FirestoreService();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResultsScreen(searchQuery: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox();
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: _firestoreService.searchServices(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        final data = snapshot.data!;
        final mainCategory = data['mainCategory'];
        final otherCategories = data['otherCategories'] as List;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (mainCategory != null) _buildMainCategory(mainCategory),
            const SizedBox(height: 24),
            const Text(
              'Other tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...otherCategories.map((category) => _buildCategoryItem(
              context,
              category['name'] ?? '',
              category['availableCount'] ?? 0,
              category['imageUrl'],
            )),
          ],
        );
      },
    );
  }

  Widget _buildMainCategory(Map<String, dynamic> category) {
    return InkWell(
      onTap: () {
        // Navigate to category services
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                category['imageUrl'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${category['availableCount'] ?? 0} availables',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context,
      String name,
      int availableCount,
      String image,
      ) {
    return ListTile(
      onTap: () {
        close(context, name);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(searchQuery: name ?? ''),
          ),
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(name),
      subtitle: Text('$availableCount availables'),
    );
  }
}