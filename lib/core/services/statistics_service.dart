import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_request_model.dart';

class StatisticsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getProviderStatistics(
    String providerId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final QuerySnapshot requests = await _db
          .collection('serviceRequests')
          .where('providerId', isEqualTo: providerId)
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate)
          .get();

      double totalRevenue = 0;
      Map<RequestStatus, int> statusCounts = {};
      Map<String, double> dailyRevenue = {};

      for (var doc in requests.docs) {
        final request = ServiceRequestModel.fromFirestore(doc);

        // Calculate total revenue
        if (request.status == RequestStatus.completed) {
          totalRevenue += request.proposedPrice;
        }

        // Count requests by status
        statusCounts[request.status] = (statusCounts[request.status] ?? 0) + 1;

        // Calculate daily revenue
        if (request.status == RequestStatus.completed) {
          String dateKey = request.createdAt.toIso8601String().split('T')[0];
          dailyRevenue[dateKey] = (dailyRevenue[dateKey] ?? 0) + request.proposedPrice;
        }
      }

      return {
        'totalRevenue': totalRevenue,
        'totalRequests': requests.size,
        'statusCounts': statusCounts,
        'dailyRevenue': dailyRevenue,
      };
    } catch (e) {
      throw Exception('Failed to get provider statistics: $e');
    }
  }
}