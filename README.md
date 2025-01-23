# **TASKIFY**

**TASKIFY** is a Flutter-based mobile application that provides an on-demand service platform, connecting clients with service providers. The platform includes two user-facing apps (client and service provider) and an admin dashboard for backend management. TASKIFY aims to simplify the process of discovering, booking, and managing services while offering a seamless experience for all stakeholders.

---

## **Features**

### **For Clients**
- **Service Discovery**: Search for services by name, category, or location.  
- **Service Details**: View comprehensive details about services, including reviews and pricing.  
- **Real-Time Chat**: Communicate with service providers in real-time.  
- **Booking**: Book services with ease and track the status of requests.  
- **Reviews and Complaints**: Submit reviews and file complaints directly through the app.  

### **For Service Providers**
- **Service Management**: Create, update, and manage service listings.  
- **Request Management**: View and manage incoming service requests.  
- **Performance Tracking**: Access statistics like request volume, revenue, and ratings.  
- **Real-Time Chat**: Communicate with clients in real-time.  

### **For Admins**
- **User Management**: Oversee client and service provider accounts.  
- **Complaint Resolution**: Resolve disputes and complaints.  
- **Reports**: Generate platform performance and revenue reports.  

---

## **Technical Stack**
- **Mobile App**: Flutter (iOS and Android).  
- **Admin Dashboard**: React.js with Vite.  
- **Database**: Firestore (NoSQL, real-time synchronization).  
- **Payment Integration**: Stripe (secure payment processing).  
- **Project Management**: GitHub (version control and collaboration).  

---

## **Installation**

### **Prerequisites**
- Flutter SDK (version 3.0 or higher).  
- Node.js and npm (for the admin dashboard).  
- Firebase project with Firestore and Authentication enabled.  
- Stripe account for payment processing.  
- Google Maps API key for location-based services.  

### **Steps to Run the App**
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/TASKIFY.git
   cd TASKIFY
   ```

2. **Set Up Firebase**:
   - Create a Firebase project and enable Firestore and Authentication.  
   - Download the `google-services.json` file and place it in the `android/app` directory.  

3. **Set Up Stripe**:
   - Create a Stripe account and obtain the API keys.  
   - Add the Stripe API keys to the Firebase environment.  

4. **Set Up Google Maps API**:
   - Enable the Google Maps API in the Google Cloud Console.  
   - Add the API key to the Flutter app configuration.  

5. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

6. **Run the App**:
   ```bash
   flutter run
   ```

### **Steps to Run the Admin Dashboard**
1. Navigate to the admin dashboard directory:
   ```bash
   cd admin-dashboard
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

---

## **License**
This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
