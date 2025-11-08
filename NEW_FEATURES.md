# New Features Documentation

This document describes the newly implemented features for trending/explore feed, moderation workflow, and monetization.

## Features Overview

### 1. Trending/Explore Feed

**Location**: New tab in bottom navigation (Explore icon)

**Features**:
- **Trending Tab**: Displays posts with the most likes from the last 7 days
- **Recent Tab**: Shows all posts ordered by creation date
- **Post Display**: 
  - User avatar and name (clickable to view profile)
  - Post content with text and images
  - Like/unlike functionality with real-time count
  - Comment count display
  - Restaurant tags (if applicable)
  - Report and delete options via menu

**Files**:
- `lib/screens/trending_screen/trending_screen.dart` - Main screen
- `lib/screens/trending_screen/widgets/post_widget.dart` - Post card widget
- `lib/models/post_model.dart` - Post data model
- `lib/services/post_service.dart` - Firestore service for posts

**Firestore Collection**: `posts`

### 2. Block/Report Moderation Workflow

**User-Facing Features**:

1. **Report Content**:
   - Available on posts (via menu)
   - Available on user profiles (via menu)
   - Report reasons: Spam, Harassment, Inappropriate Content, Hate Speech, Violence, False Information, Other
   - Optional description field
   - AI moderation stub integration

2. **Block Users**:
   - Block from user profile screen
   - Unblock from the same screen
   - Blocked status indicator
   - Prevents interaction with blocked users

**Admin Features**:

1. **Moderation Screen**:
   - Access via admin icon in Profile screen
   - Filter reports by: Pending, Reviewed, All
   - View report details:
     - Reporter and reported user
     - Content type and ID
     - Reason and description
     - AI moderation flag
     - Timestamp
   - Actions:
     - Dismiss report
     - Take action (resolve)
     - Add resolution notes

**Files**:
- `lib/screens/moderation_screen/admin_moderation_screen.dart` - Admin panel
- `lib/screens/trending_screen/widgets/report_dialog.dart` - Report submission dialog
- `lib/screens/user_profile_screen/user_profile_screen.dart` - User profile with block/report
- `lib/models/report_model.dart` - Report data model
- `lib/models/blocked_user_model.dart` - Blocked user model
- `lib/services/moderation_service.dart` - Moderation operations
- `lib/services/ai_moderation_service.dart` - AI moderation stub

**Firestore Collections**:
- `reports` - User-submitted reports
- `blockedUsers` - User block relationships

### 3. AI Moderation Stub

**Purpose**: Placeholder for integrating AI-based content moderation services

**Integration Points**:
- Google Cloud Natural Language API
- AWS Comprehend
- OpenAI Moderation API
- Perspective API

**Current Implementation**:
- Simple keyword-based filtering (demo)
- Confidence scoring
- Category analysis structure
- Ready for production API integration

**Files**:
- `lib/services/ai_moderation_service.dart`

### 4. Monetization Features

**Access**: Profile screen → "Premium Features" menu item

**Features**:

1. **Badges Tab**:
   - Display available premium badges
   - Purchase flow with payment method selection (Stripe/PayPal)
   - Demo mode with placeholder data
   - Badge details: name, description, price

2. **Transactions Tab**:
   - View purchase history
   - Transaction details: type, amount, status, date
   - Status indicators: Pending, Completed, Failed

**Payment Integration Stubs**:
- Stripe payment intent creation (placeholder)
- PayPal order creation (placeholder)
- Transaction recording in Firestore
- Ready for production integration

**Files**:
- `lib/screens/monetization_screen/monetization_screen.dart` - Main monetization UI
- `lib/models/badge_model.dart` - Badge data model
- `lib/models/transaction_model.dart` - Transaction data model
- `lib/services/monetization_service.dart` - Monetization service

**Firestore Collections**:
- `badges` - Available badges catalog
- `transactions` - User transactions
- `userBadges` - User-owned badges (placeholder)

## Navigation Changes

**Main Navigation** (`lib/screens/nav_bar/main_screen.dart`):
- Added 5th tab: "Explore" (Trending screen)
- Updated tab bar to accommodate new screen

**Profile Screen** (`lib/screens/nav_bar/profile.dart`):
- Added "Premium Features" menu item
- Added admin moderation icon in app bar

## Modular Structure

All new features are organized as separate modules:

```
lib/
├── models/           # Data models
│   ├── post_model.dart
│   ├── report_model.dart
│   ├── blocked_user_model.dart
│   ├── badge_model.dart
│   └── transaction_model.dart
├── services/         # Business logic & Firestore
│   ├── post_service.dart
│   ├── moderation_service.dart
│   ├── ai_moderation_service.dart
│   └── monetization_service.dart
└── screens/          # UI screens
    ├── trending_screen/
    ├── moderation_screen/
    ├── monetization_screen/
    └── user_profile_screen/
```

## Backend Integration

### Required Firestore Indexes

Create these composite indexes in Firebase Console:

1. **posts collection**:
   - Fields: `createdAt` (Descending), `likesCount` (Descending)
   - Query scope: Collection

2. **reports collection**:
   - Fields: `status` (Ascending), `createdAt` (Descending)
   - Query scope: Collection

### Security Rules

Add these Firestore security rules:

```javascript
// Posts
match /posts/{postId} {
  allow read: if true;
  allow create: if request.auth != null;
  allow update: if request.auth != null && 
                request.auth.uid == resource.data.userID;
  allow delete: if request.auth != null && 
                request.auth.uid == resource.data.userID;
}

// Reports
match /reports/{reportId} {
  allow read: if request.auth != null;  // Admins only in production
  allow create: if request.auth != null;
  allow update: if request.auth != null; // Admins only in production
}

// Blocked Users
match /blockedUsers/{blockId} {
  allow read: if request.auth != null && 
              request.auth.uid == resource.data.blockedByUserID;
  allow create: if request.auth != null;
  allow delete: if request.auth != null && 
                request.auth.uid == resource.data.blockedByUserID;
}

// Badges
match /badges/{badgeId} {
  allow read: if true;
  allow write: if false; // Admins only via Firebase Console
}

// Transactions
match /transactions/{transactionId} {
  allow read: if request.auth != null && 
              request.auth.uid == resource.data.userID;
  allow create: if request.auth != null;
  allow update: if false; // Server-side only
}
```

## Production Checklist

### AI Moderation
- [ ] Choose and integrate AI moderation service
- [ ] Configure API keys
- [ ] Set moderation thresholds
- [ ] Test with real content

### Payments
- [ ] Set up Stripe/PayPal accounts
- [ ] Configure API keys in secure storage
- [ ] Implement webhook handlers
- [ ] Test payment flows
- [ ] Add error handling and retries

### Admin Access
- [ ] Implement proper role-based access control
- [ ] Create admin user collection
- [ ] Add authentication middleware
- [ ] Remove demo access from production

### Content Filtering
- [ ] Filter blocked users' content from feeds
- [ ] Hide posts from blocked users
- [ ] Implement content filtering based on reports

### Performance
- [ ] Add pagination for large post lists
- [ ] Implement caching for frequently accessed data
- [ ] Optimize Firestore queries
- [ ] Add image optimization

## Demo Usage

1. **Test Trending Feed**:
   - Navigate to "Explore" tab
   - Switch between Trending and Recent tabs
   - Like/unlike posts
   - Click on user avatars to view profiles

2. **Test Reporting**:
   - Open post menu → Report
   - Fill out report form
   - View report in Admin Moderation screen

3. **Test Blocking**:
   - Click user avatar → Block User
   - Verify blocked status indicator
   - Unblock from the same screen

4. **Test Monetization**:
   - Profile → Premium Features
   - View available badges
   - Test purchase flow (demo mode)
   - Check transactions tab

5. **Test Admin Panel**:
   - Profile → Admin icon (top right)
   - View pending reports
   - Review and resolve reports
   - Filter by status
