# 🍽️ Annam - Food Management & Waste Reduction Platform

[![Flutter Version](https://img.shields.io/badge/Flutter-3.0.2%2B-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Annam** is a comprehensive Flutter-based mobile application designed to revolutionize food management in educational institutions while actively contributing to food waste reduction and community welfare. The platform connects canteens, students, NGOs, and cattle owners in a sustainable ecosystem that minimizes food waste and maximizes resource utilization.

## 🌟 Project Vision

**"Project Annam is an initiative working towards reducing malnutrition and making access to healthy food easier for children while minimizing food waste through community collaboration."**

## 📱 Key Features

### 🎯 Multi-User Platform
Annam supports four distinct user roles, each with specialized functionality:

#### 👨‍🎓 **Students**
- **Food Ordering**: Browse and order meals from college canteens
- **Order Management**: Track order history and manage cart
- **Real-time Updates**: Get notifications about order status
- **Profile Management**: Maintain personal profiles with preferences

#### 🏪 **Canteen Owners**
- **Menu Management**: Create, update, and manage food items and categories
- **Order Processing**: Receive and process student orders
- **Inventory Tracking**: Monitor food inventory and availability
- **Surplus Food Distribution**: Post excess food to NGOs and cattle owners
- **Analytics Dashboard**: View sales and distribution analytics
- **Multi-Channel Distribution**: 
  - Direct student sales
  - Surplus food to NGOs for community feeding
  - Food waste to cattle owners for livestock feed

#### 🏢 **NGO Organizations**
- **Food Collection**: Access surplus food from canteens for community programs
- **Beneficiary Management**: Organize food distribution to underprivileged communities
- **Impact Tracking**: Monitor food collection and distribution metrics
- **Collaboration Tools**: Coordinate with multiple canteens and organizations

#### 🐄 **Cattle Owners**
- **Waste Food Collection**: Collect food waste for cattle feed
- **Quality Management**: Ensure food waste meets livestock feeding standards
- **Pickup Coordination**: Schedule collection from canteens
- **Transaction History**: Track all food waste acquisitions

### 🔧 Core Functionalities

#### 🔐 **Authentication & Authorization**
- **Multi-role Registration**: Role-based signup with validation
- **Secure Authentication**: Firebase Authentication integration
- **Role-based Access Control**: Different interfaces for different user types
- **Profile Management**: Comprehensive user profile management

#### 🎨 **User Experience**
- **Material Design 3**: Modern, intuitive interface
- **Dark/Light Theme**: Customizable theme preferences
- **Responsive Design**: Optimized for various screen sizes
- **Custom Animations**: Smooth transitions and micro-interactions
- **Offline Capabilities**: Limited functionality without internet

#### 📊 **Real-time Data Management**
- **Cloud Firestore**: Real-time database synchronization
- **Image Storage**: Firebase Storage for profile pictures and food images
- **Live Updates**: Real-time order status and inventory updates
- **Data Analytics**: Comprehensive reporting and analytics

#### 🗺️ **Location Services**
- **Google Maps Integration**: Location-based services for delivery
- **Address Management**: Store and manage multiple addresses
- **Geolocation**: Automatic location detection for nearby canteens

## 🛠️ Technical Architecture

### **Frontend Framework**
- **Flutter 3.0.2+**: Cross-platform mobile development
- **Dart Language**: Type-safe, modern programming language
- **Material Design 3**: Google's latest design system

### **Backend Services**
- **Firebase Suite**: Comprehensive backend-as-a-service
  - **Authentication**: User management and security
  - **Cloud Firestore**: NoSQL real-time database
  - **Cloud Storage**: File and image storage
  - **Cloud Functions**: Serverless backend logic

### **State Management**
- **Riverpod**: Modern state management solution
- **Provider Pattern**: Reactive programming approach

### **Key Dependencies**
```yaml
dependencies:
  flutter: sdk: flutter
  firebase_core: ^4.0.0           # Firebase core functionality
  firebase_auth: ^6.0.1           # Authentication services
  cloud_firestore: ^6.0.0         # Real-time database
  firebase_storage: ^13.0.0       # File storage
  google_maps_flutter: ^2.3.1     # Maps integration
  image_picker: ^1.1.2            # Image selection
  shared_preferences: ^2.2.3      # Local storage
  http: ^1.1.0                    # HTTP requests
  flutter_riverpod: ^2.5.1        # State management
  lottie: ^3.1.2                  # Animations
  shimmer: ^3.0.0                 # Loading animations
  rive: ^0.13.12                  # Interactive animations
  intl: ^0.20.2                   # Internationalization
  flutter_rating_bar: ^4.0.1      # Rating components
  carousel_slider: ^5.1.1         # Image carousels
  calendar_date_picker2: ^2.0.1   # Date selection
  flutter_markdown: ^0.7.3+1      # Markdown rendering
```

## 📁 Project Structure

```
lib/
├── main.dart                    # Application entry point
├── auth/                        # Authentication modules
│   ├── startup_view.dart       # Splash screen
│   ├── on_boarding_view.dart   # Onboarding screens
│   ├── login_signup.dart       # Authentication UI
│   ├── role_page.dart          # Role selection
│   └── authWrapper.dart        # Authentication wrapper
├── students/                    # Student-specific features
│   ├── student_main_tab.dart   # Main navigation
│   ├── orders/                 # Order management
│   ├── history/                # Order history
│   └── profile/                # Profile management
├── canteen/                     # Canteen owner features
│   ├── canteen_main_tab.dart   # Main navigation
│   ├── home/                   # Dashboard
│   ├── menu/                   # Menu management
│   ├── history/                # Transaction history
│   ├── profile/                # Profile management
│   ├── CanteenNGO/            # NGO food distribution
│   └── CanteenCattle/         # Cattle food distribution
├── ngo/                         # NGO-specific features
│   ├── main_tab.dart           # Main navigation
│   ├── menu/                   # Food collection
│   ├── history/                # Collection history
│   └── profile/                # Profile management
├── cattle/                      # Cattle owner features
│   ├── cattle_maintab.dart     # Main navigation
│   ├── menu/                   # Food waste collection
│   ├── history/                # Collection history
│   └── profile/                # Profile management
├── common_widget/               # Reusable UI components
├── utils/                       # Utility functions
├── theme/                       # Theme management
├── const/                       # Constants and static data
└── Firebase/                    # Firebase operations
```

## 🚀 Getting Started

### Prerequisites

Before running the project, ensure you have the following installed:

- **Flutter SDK**: Version 3.0.2 or higher
- **Dart SDK**: Version 3.0.2 or higher
- **Android Studio**: With Android SDK
- **VS Code**: With Flutter and Dart extensions (recommended)
- **Git**: For version control

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/shiva396/annam.git
   cd annam
   ```

2. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable the following services:
     - Authentication (Email/Password)
     - Cloud Firestore
     - Cloud Storage
   - Download `google-services.json` for Android
   - Place it in `android/app/` directory

4. **Android Setup**
   ```bash
   # For Android development
   flutter doctor -v  # Check for any setup issues
   ```

5. **Configure Firebase**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Configure Flutter for Firebase
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

6. **Google Maps Setup**
   - Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Add the API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE"/>
   ```

### Running the Application

1. **Start an Emulator or Connect Device**
   ```bash
   flutter devices  # Check available devices
   ```

2. **Run the Application**
   ```bash
   flutter run
   ```

3. **Build for Release**
   ```bash
   # Android APK
   flutter build apk --release
   
   # Android App Bundle
   flutter build appbundle --release
   ```

## 🔧 Configuration

### Firebase Configuration
Update `lib/firebase/firebase_options.dart` with your Firebase project configuration:

```dart
static const FirebaseOptions currentPlatform = FirebaseOptions(
  apiKey: 'your-api-key',
  appId: 'your-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-storage-bucket',
);
```

### Database Structure
The app uses Cloud Firestore with the following collections:

```
Collections:
├── role/
│   └── role (document)
│       └── role: {email: userRole} (map)
├── college/ (canteen owners data)
├── students/ (student profiles)
├── ngo/ (NGO profiles)
├── cattle_owner/ (cattle owner profiles)
├── ngo_posts/ (NGO food distribution posts)
├── cattle_posts/ (cattle food waste posts)
└── orders/ (student orders)
```

## 🎯 User Workflows

### Student Journey
1. **Registration**: Sign up with email and select "Student" role
2. **Profile Setup**: Complete profile with college information
3. **Browse Menu**: View available food items from canteen
4. **Place Order**: Add items to cart and place order
5. **Track Order**: Monitor order status in real-time
6. **Order History**: View past orders and reorder favorites

### Canteen Owner Journey
1. **Registration**: Sign up and select "Canteen Owner" role
2. **Setup**: Complete business profile and college association
3. **Menu Management**: Add food items, categories, and pricing
4. **Order Processing**: Receive and fulfill student orders
5. **Surplus Management**: Post excess food to NGOs/cattle owners
6. **Analytics**: Monitor sales, waste reduction metrics

### NGO Workflow
1. **Registration**: Sign up as NGO with organization details
2. **Browse Opportunities**: View available surplus food from canteens
3. **Request Food**: Accept food distribution offers
4. **Coordinate Pickup**: Schedule collection from canteens
5. **Community Distribution**: Distribute collected food to beneficiaries
6. **Impact Tracking**: Monitor food collection and distribution impact

### Cattle Owner Process
1. **Registration**: Register as cattle owner with facility details
2. **Browse Waste**: View available food waste from canteens
3. **Quality Check**: Ensure waste meets livestock feeding standards
4. **Accept Offers**: Confirm food waste collection
5. **Pickup Coordination**: Schedule waste collection
6. **Utilization**: Use collected waste for cattle feed

## 🌍 Environmental Impact

### Sustainability Features
- **Waste Reduction**: Diverts food waste from landfills
- **Resource Optimization**: Maximizes food resource utilization
- **Carbon Footprint**: Reduces transportation through local networks
- **Circular Economy**: Creates value from waste products

### Social Impact
- **Hunger Relief**: Provides food access to underprivileged communities
- **Education Support**: Ensures student nutrition in educational institutions
- **Community Building**: Connects various stakeholders in food ecosystem
- **Economic Benefits**: Creates value chains for all participants

## 🔒 Security Features

- **Firebase Authentication**: Secure user authentication
- **Role-based Access**: Restricted access based on user roles
- **Data Encryption**: End-to-end data encryption
- **Input Validation**: Comprehensive input sanitization
- **Privacy Protection**: GDPR-compliant data handling

## 📊 Analytics & Monitoring

- **User Engagement**: Track user interactions and app usage
- **Food Waste Metrics**: Monitor waste reduction achievements
- **Distribution Efficiency**: Track food distribution effectiveness
- **Performance Monitoring**: App performance and crash reporting

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Generate test coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📱 Supported Platforms

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 11.0+ (planned for future release)

## 🤝 Contributing

We welcome contributions to improve Annam! Please follow these steps:

1. **Fork the Repository**
2. **Create Feature Branch**: `git checkout -b feature/AmazingFeature`
3. **Commit Changes**: `git commit -m 'Add some AmazingFeature'`
4. **Push to Branch**: `git push origin feature/AmazingFeature`
5. **Open Pull Request**

### Development Guidelines
- Follow Flutter and Dart best practices
- Maintain code documentation
- Write unit tests for new features
- Ensure UI/UX consistency
- Test on multiple devices and screen sizes

## 📞 Support

For support, feature requests, or bug reports:

- **Email**: [support@annam.app](mailto:support@annam.app)
- **GitHub Issues**: [Create an Issue](https://github.com/shiva396/annam/issues)
- **Documentation**: [Wiki](https://github.com/shiva396/annam/wiki)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **Firebase**: For comprehensive backend services
- **Open Source Community**: For various packages and libraries
- **Educational Institutions**: For inspiration and use cases
- **Environmental Organizations**: For sustainability guidance

## 🔮 Roadmap

### Upcoming Features
- [ ] **iOS Support**: Native iOS application
- [ ] **Web Portal**: Administrative web interface
- [ ] **AI Integration**: Smart food waste prediction
- [ ] **IoT Integration**: Smart bin monitoring
- [ ] **Multi-language Support**: Localization for multiple languages
- [ ] **Payment Integration**: Multiple payment gateways
- [ ] **Blockchain**: Supply chain transparency
- [ ] **ML Analytics**: Advanced analytics and insights

### Long-term Vision
- Scale to multiple cities and regions
- Integration with government food security programs
- Partnership with major food chains and restaurants
- Development of IoT-enabled waste monitoring systems
- AI-powered demand forecasting and waste prediction

---

**Made with ❤️ for a sustainable future**

*Annam - Bridging the gap between food waste and food security* 
