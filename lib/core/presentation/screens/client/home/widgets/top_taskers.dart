import 'package:Taskify/core/models/service_model.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/services/firestore_service.dart';
import '../../../../../models/user_model.dart';
import 'dart:developer';

import '../../service_details/service_details_screen.dart';

class TopTaskers extends StatelessWidget {
  const TopTaskers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Top Tasks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Text(
              'Experts lead you through topics.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<ServiceModel>>(
          stream: FirestoreService().getTopRatedServicesStream(),
          builder: (context, snapshot) {
            // Debug: Print the connection state
            log('Stream Connection State: ${snapshot.connectionState}');

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
              // Debug: Print if no data is found
              log('No data found in the stream');
              return const Center(child: Text('No top services available'));
            }

            // Debug: Print the number of services fetched
            log('Fetched ${snapshot.data!.length} services');

            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final service = snapshot.data![index];
                  return TaskerCard(service: service);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class TaskerCard extends StatelessWidget {
  final ServiceModel service;

  const TaskerCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(service: service),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(service.images.isNotEmpty ? service.images.first : 'https://via.placeholder.com/100'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              service.category.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(
                  '${service.rating ?? 0.0}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  ' (${service.reviewCount ?? 0} reviews)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}