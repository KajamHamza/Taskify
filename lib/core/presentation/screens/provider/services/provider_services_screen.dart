import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../../core/models/service_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/firestore_service.dart';
import '../setup/add_service_screen.dart';
import '../setup/edit_service_screen.dart';
import 'widgets/service_list_item.dart';


class ProviderServicesScreen extends StatelessWidget {
  const ProviderServicesScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddServiceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: AuthService().currentUser?.uid != null
            ? FirestoreService().getServices(providerId: AuthService().currentUser!.uid)
            : Stream.empty(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final services = snapshot.data!;

          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No services yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddServiceScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Service'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return ServiceListItem(
                service: services[index],
                onEdit: () {
                  // Navigate to edit service screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditServiceScreen(
                        service: services[index],
                      ),
                    ),
                  );

                },
                onToggleActive: () {
                  // Toggle service active status
                  final service = services[index];
                  final updatedService = service.copyWith(isActive: !service.isActive);
                  FirestoreService().updateService(updatedService);
                },
              );
            },
          );
        },
      ),
    );
  }
}
