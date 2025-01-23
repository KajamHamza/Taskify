import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/service_request_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';
import 'widgets/pie_chart_widget.dart';
import 'widgets/order_stat_item.dart';

class ProviderStatisticsScreen extends StatelessWidget {
  const ProviderStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final String userId = authService.userId;

    return FutureBuilder<UserModel>(
      future: FirestoreService().getUser(userId),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userSnapshot.hasError) {
          debugPrint('Error loading user: ${userSnapshot.error}');
          return const Center(child: Text('Failed to load user data.'));
        }

        if (!userSnapshot.hasData) {
          return const Center(child: Text('User not found.'));
        }

        UserModel user = userSnapshot.data!;

        return FutureBuilder<List<ServiceRequestModel>>(
          future: FirestoreService().getServiceRequests(providerId: user.id).first,
          builder: (context, requestSnapshot) {
            if (requestSnapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (requestSnapshot.hasError) {
              debugPrint('Error loading requests: ${requestSnapshot.error}');
              return const Center(child: Text('Failed to load service requests.'));
            }

            if (!requestSnapshot.hasData) {
              return const Center(child: Text('No service requests found.'));
            }

            List<ServiceRequestModel> requests = requestSnapshot.data!;

            // Calculate stats for the pie chart
            final completedCount =
                requests.where((r) => r.status == RequestStatus.completed).length;
            final pendingCount =
                requests.where((r) => r.status == RequestStatus.pending).length;
            final activeCount =
                requests.where((r) => r.status == RequestStatus.accepted).length;
            final cancelledCount =
                requests.where((r) => r.status == RequestStatus.rejected).length;

            // Calculate top services
            final serviceFrequency = <String, int>{};
            for (var request in requests) {
              serviceFrequency[request.serviceId] =
                  (serviceFrequency[request.serviceId] ?? 0) + 1;
            }

            final topServices = serviceFrequency.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final topServiceIds = topServices.take(5).map((e) => e.key).toList();

            return FutureBuilder<List<String>>(
              future: Future.wait(
                topServiceIds.map((id) async {
                  try {
                    return await FirestoreService().getServiceName(id) ?? 'Unknown Service';
                  } catch (e) {
                    debugPrint('Error fetching service name for $id: $e');
                    return 'Unknown Service';
                  }
                }),
              ),
              builder: (context, servicesSnapshot) {
                if (servicesSnapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (servicesSnapshot.hasError) {
                  debugPrint('Error loading service names: ${servicesSnapshot.error}');
                  return const Center(child: Text('Failed to load service names.'));
                }

                final topServiceNames = servicesSnapshot.data!;

                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: Text(
                      'Tasks Portfolio - ${user.name}',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PieChartWidget(
                            completedCount: completedCount,
                            pendingCount: pendingCount,
                            cancelledCount: cancelledCount,

                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Stats',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(),
                          OrderStatItem(
                            label: 'Total Orders',
                            value: requests.length.toString(),
                            textColor: Colors.blue,
                          ),
                          OrderStatItem(
                            label: 'Completed Orders',
                            value: completedCount.toString(),
                          ),
                          OrderStatItem(
                            label: 'Pending Orders',
                            value: pendingCount.toString(),
                          ),
                          OrderStatItem(
                            label: 'Cancelled Orders',
                            value: cancelledCount.toString(),
                          ),
                          OrderStatItem(
                            label: 'Active Orders',
                            value: activeCount.toString(),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Top Services',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(),
                          for (int i = 0; i < topServiceNames.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child:Text(
                                '${i + 1}. ${topServiceNames[i]} (${topServices[i].value} requests)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black, // Explicitly set the text color to black
                                ),
                              ),

                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}