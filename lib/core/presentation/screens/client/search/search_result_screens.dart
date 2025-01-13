import 'package:flutter/material.dart';

import '../../../../models/service_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../widgets/service_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchResultsScreen({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$searchQuery"'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: FirestoreService().searchServiceStream(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No services found'));
          }

          final services = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return ServiceCard(
                service: services[index],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/service-details',
                    arguments: services[index],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}