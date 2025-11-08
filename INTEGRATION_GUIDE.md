# Quick Start Integration Guide

This guide helps you integrate the new features into your Firebase backend.

## Step 1: Firebase Setup

### Create Firestore Indexes

Run these commands in Firebase CLI or add in Firebase Console:

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Navigate to your project
cd /path/to/restaurant-app

# Deploy indexes
firebase deploy --only firestore:indexes
```

Create `firestore.indexes.json` with:

```json
{
  "indexes": [
    {
      "collectionGroup": "posts",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "createdAt", "order": "DESCENDING" },
        { "fieldPath": "likesCount", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "reports",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

### Add Security Rules

In Firebase Console → Firestore → Rules, add:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user is admin
    // TODO: Implement proper admin check
    function isAdmin() {
      return isAuthenticated(); // Replace with actual admin check
    }
    
    // Posts collection
    match /posts/{postId} {
      allow read: if true;
      allow create: if isAuthenticated() && 
                    request.resource.data.userID == request.auth.uid;
      allow update: if isAuthenticated() && 
                    resource.data.userID == request.auth.uid;
      allow delete: if isAuthenticated() && 
                    resource.data.userID == request.auth.uid;
    }
    
    // Reports collection
    match /reports/{reportId} {
      allow read: if isAdmin(); // Only admins can read reports
      allow create: if isAuthenticated();
      allow update: if isAdmin(); // Only admins can update
      allow delete: if isAdmin();
    }
    
    // Blocked users collection
    match /blockedUsers/{blockId} {
      allow read: if isAuthenticated() && 
                  resource.data.blockedByUserID == request.auth.uid;
      allow create: if isAuthenticated() && 
                    request.resource.data.blockedByUserID == request.auth.uid;
      allow delete: if isAuthenticated() && 
                    resource.data.blockedByUserID == request.auth.uid;
    }
    
    // Badges collection (read-only for users)
    match /badges/{badgeId} {
      allow read: if true;
      allow write: if false; // Managed via Firebase Console
    }
    
    // Transactions collection
    match /transactions/{transactionId} {
      allow read: if isAuthenticated() && 
                  resource.data.userID == request.auth.uid;
      allow create: if isAuthenticated() && 
                    request.resource.data.userID == request.auth.uid;
      allow update: if false; // Server-side only
      allow delete: if false;
    }
  }
}
```

## Step 2: Seed Initial Data

### Add Sample Badges

In Firebase Console → Firestore → badges collection, create documents:

```javascript
// Badge 1
{
  badgeID: "badge_food_explorer",
  name: "Food Explorer",
  description: "Show your passion for discovering new restaurants",
  price: 2.99,
  currency: "USD",
  isActive: true,
  imageUrl: "",
  createdAt: new Date()
}

// Badge 2
{
  badgeID: "badge_taste_master",
  name: "Taste Master",
  description: "Demonstrate your refined culinary taste",
  price: 4.99,
  currency: "USD",
  isActive: true,
  imageUrl: "",
  createdAt: new Date()
}

// Badge 3
{
  badgeID: "badge_community_champion",
  name: "Community Champion",
  description: "Support the community and stand out",
  price: 9.99,
  currency: "USD",
  isActive: true,
  imageUrl: "",
  createdAt: new Date()
}
```

## Step 3: Payment Integration

### Stripe Integration

1. Sign up at https://stripe.com
2. Get your API keys (Dashboard → Developers → API keys)
3. Add to your project:

```dart
// In monetization_service.dart, update:
Future<Map<String, dynamic>> createStripePaymentIntent({
  required double amount,
  required String currency,
}) async {
  // Import stripe_payment package
  // Add to pubspec.yaml: stripe_payment: ^1.1.5
  
  const stripePublicKey = 'YOUR_STRIPE_PUBLIC_KEY';
  const stripeSecretKey = 'YOUR_STRIPE_SECRET_KEY'; // Server-side only!
  
  // Initialize Stripe
  StripePayment.setOptions(
    StripeOptions(
      publishableKey: stripePublicKey,
      merchantId: "Test",
      androidPayMode: 'test',
    ),
  );
  
  // Create payment intent via your backend
  // DO NOT use secret key in client app!
  final response = await http.post(
    Uri.parse('YOUR_BACKEND_URL/create-payment-intent'),
    body: json.encode({
      'amount': (amount * 100).toInt(), // Convert to cents
      'currency': currency.toLowerCase(),
    }),
  );
  
  return json.decode(response.body);
}
```

### PayPal Integration

1. Sign up at https://developer.paypal.com
2. Create a REST API app
3. Get your credentials

```dart
// In monetization_service.dart, update:
Future<Map<String, dynamic>> createPayPalOrder({
  required double amount,
  required String currency,
}) async {
  // Add to pubspec.yaml: flutter_paypal: ^1.0.6
  
  const clientId = 'YOUR_PAYPAL_CLIENT_ID';
  const secret = 'YOUR_PAYPAL_SECRET';
  
  // Create order via PayPal API
  final response = await http.post(
    Uri.parse('https://api-m.sandbox.paypal.com/v2/checkout/orders'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: json.encode({
      'intent': 'CAPTURE',
      'purchase_units': [
        {
          'amount': {
            'currency_code': currency,
            'value': amount.toString(),
          },
        },
      ],
    }),
  );
  
  return json.decode(response.body);
}
```

## Step 4: AI Moderation Integration

### Google Cloud Natural Language API

```dart
// In ai_moderation_service.dart, update moderateContent:
import 'package:googleapis/language/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

Future<ModerationResult> moderateContent(String content) async {
  final credentials = ServiceAccountCredentials.fromJson({
    // Your Google Cloud credentials
  });
  
  final client = await clientViaServiceAccount(
    credentials,
    [LanguageApi.cloudPlatformScope],
  );
  
  final api = LanguageApi(client);
  
  final document = Document(
    content: content,
    type: 'PLAIN_TEXT',
  );
  
  final response = await api.documents.moderateText(
    ModerateTextRequest(document: document),
  );
  
  // Process response
  final isFlagged = response.categories?.any((c) => c.confidence! > 0.7) ?? false;
  
  return ModerationResult(
    isFlagged: isFlagged,
    confidence: response.categories?.first.confidence ?? 0.0,
    reasons: response.categories?.map((c) => c.name!).toList() ?? [],
    categories: Map.fromEntries(
      response.categories?.map((c) => MapEntry(c.name!, c.confidence!)) ?? [],
    ),
  );
}
```

### OpenAI Moderation API

```dart
Future<ModerationResult> moderateContent(String content) async {
  const apiKey = 'YOUR_OPENAI_API_KEY';
  
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/moderations'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: json.encode({'input': content}),
  );
  
  final data = json.decode(response.body);
  final results = data['results'][0];
  
  return ModerationResult(
    isFlagged: results['flagged'],
    confidence: results['category_scores'].values.reduce(max),
    reasons: results['categories'].entries
        .where((e) => e.value == true)
        .map((e) => e.key.toString())
        .toList(),
    categories: Map<String, double>.from(results['category_scores']),
  );
}
```

## Step 5: Admin Role Setup

### Create Admin Collection

In Firestore, create an `admins` collection:

```javascript
// Document: admin@example.com
{
  userID: "USER_ID_HERE",
  email: "admin@example.com",
  role: "admin",
  permissions: ["moderation", "badges", "users"],
  createdAt: new Date()
}
```

### Update Admin Check

```dart
// Create lib/services/admin_service.dart
class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<bool> isUserAdmin() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;
    
    final adminDoc = await _firestore
        .collection('admins')
        .where('userID', isEqualTo: currentUser.uid)
        .limit(1)
        .get();
    
    return adminDoc.docs.isNotEmpty;
  }
}
```

### Update Profile Screen

```dart
// In profile.dart, update admin button visibility:
FutureBuilder<bool>(
  future: AdminService().isUserAdmin(),
  builder: (context, snapshot) {
    if (snapshot.data != true) return SizedBox.shrink();
    
    return IconButton(
      icon: Icon(Icons.admin_panel_settings),
      onPressed: () => Get.to(() => AdminModerationScreen()),
    );
  },
)
```

## Step 6: Testing

### Test Posts
```dart
// Create test post
final post = PostModel(
  userID: currentUserID,
  userName: 'Test User',
  content: 'This is a test post!',
  images: [],
);
await PostService().createPost(post);
```

### Test Reports
```dart
// Submit test report
final report = ReportModel(
  reportedByUserID: currentUserID,
  reportedByUserName: 'Reporter',
  reportedUserID: 'target_user_id',
  reportedUserName: 'Target User',
  contentID: 'post_id',
  contentType: 'post',
  reason: 'Spam',
  description: 'Test report',
);
await ModerationService().submitReport(report);
```

## Step 7: Environment Variables

Create `.env` file (add to .gitignore):

```
STRIPE_PUBLIC_KEY=pk_test_xxxxx
STRIPE_SECRET_KEY=sk_test_xxxxx
PAYPAL_CLIENT_ID=xxxxx
PAYPAL_SECRET=xxxxx
OPENAI_API_KEY=sk-xxxxx
GOOGLE_CLOUD_API_KEY=xxxxx
```

Use with `flutter_dotenv` package:

```yaml
# pubspec.yaml
dependencies:
  flutter_dotenv: ^5.0.2
```

```dart
// Load in main.dart
await dotenv.load(fileName: ".env");

// Use in services
final apiKey = dotenv.env['OPENAI_API_KEY'];
```

## Troubleshooting

### "Missing index" error
- Deploy Firestore indexes or create in console
- Wait 5-10 minutes for indexes to build

### "Permission denied" error
- Check Firestore security rules
- Verify user is authenticated
- Check admin role for moderation features

### "Payment failed" error
- Verify API keys are correct
- Check Stripe/PayPal dashboard for errors
- Test with test cards/accounts first

### "AI moderation not working"
- Verify API key is valid
- Check API quota limits
- Review API response in logs

## Next Steps

1. Set up production Firebase project
2. Configure payment processing
3. Implement proper admin authentication
4. Add monitoring and analytics
5. Test all features end-to-end
6. Deploy to production

For detailed documentation, see:
- NEW_FEATURES.md - Feature documentation
- IMPLEMENTATION_SUMMARY.md - Technical overview
