class AppConstants {
  // API URLs
  static const String baseUrl = 'YOUR_API_BASE_URL';
  
  // Collection Names
  static const String usersCollection = 'users';
  static const String servicesCollection = 'services';
  static const String requestsCollection = 'serviceRequests';
  static const String reviewsCollection = 'reviews';
  static const String chatsCollection = 'chats';
  static String providersCollection = 'providers';
  static String categoryCollection = 'categories';
  
  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String serviceImagesPath = 'service_images';
  static const String categoriesImagesPath = 'categories_images';
  
  // Notification Channels
  static const String mainNotificationChannel = 'service_app_channel';
  static const String mainNotificationChannelName = 'Service App Notifications';
  
  // Map Constants
  static const double defaultZoomLevel = 15.0;
  static const double defaultSearchRadius = 5.0; // in km
  
  // Pagination
  static const int defaultPageSize = 10;
  
  // Commission Rate
  static const double platformCommissionRate = 0.20;
}