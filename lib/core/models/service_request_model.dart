import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus {
  pending,
  accepted,
  rejected,
  completed,
  cancelled,
  paid,
  inProgress
}

class ServiceRequestModel {
  final String id;
  final String serviceId;
  final String clientId;
  final String providerId;
  final double proposedPrice;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? paymentIntentId;
  final bool isPaid;

  ServiceRequestModel({
    required this.id,
    required this.serviceId,
    required this.clientId,
    required this.providerId,
    required this.proposedPrice,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.paymentIntentId,
    this.isPaid = false,
  });

  factory ServiceRequestModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ServiceRequestModel(
      id: doc.id,
      serviceId: data['serviceId'],
      clientId: data['clientId'],
      providerId: data['providerId'],
      proposedPrice: data['proposedPrice'].toDouble(),
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      paymentIntentId: data['paymentIntentId'],
      isPaid: data['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'clientId': clientId,
      'providerId': providerId,
      'proposedPrice': proposedPrice,
      'status': status.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'paymentIntentId': paymentIntentId,
      'isPaid': isPaid,
    };
  }
}