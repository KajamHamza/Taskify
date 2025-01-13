import 'package:Taskify/core/models/service_model.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/services/firestore_service.dart';
import '../../../../../models/user_model.dart';

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
          stream: FirestoreService().getTopServices(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

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
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(service.images.first ?? ''),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
              color: service.images.first == null ? Colors.grey : null,
            ),
            child: service.images.first == null ? const Icon(Icons.task) : null,
          ),
          const SizedBox(height: 8),
          Text(
            service.title ?? '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            service.category as String? ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(
                ' ${service.rating.toStringAsFixed(1) ?? '0.0'}',
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
    );
  }
}