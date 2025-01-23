import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/models/category_model.dart';

Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Reference to the Firestore collection
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  // List of categories to add
  List<CategoryModel> categoryList = [
    CategoryModel(id: '1', name: 'Driver', imageUrl: 'lib/assets/images/image1.jpg'),
    CategoryModel(id: '2', name: 'Teacher', imageUrl: 'lib/assets/images/image2.jpg'),
    CategoryModel(id: '3', name: 'Cleaner', imageUrl: 'lib/assets/images/image3.jpg'),
  ];

  // Add each category to Firestore
  for (CategoryModel category in categoryList) {
    await categories.doc(category.id).set(category.toMap());
  }

  print('Categories added successfully');
}