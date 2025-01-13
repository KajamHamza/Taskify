import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { client, serviceProvider, admin }

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final UserType userType;
  final DateTime createdAt;
  final String? phoneNumber;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.userType,
    required this.createdAt,
    this.phoneNumber,
    this.isVerified = false,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'],
      name: data['name'],
      photoUrl: data['photoUrl'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == data['userType'],
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      phoneNumber: data['phoneNumber'],
      isVerified: data['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'userType': userType.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
    };
  }
}