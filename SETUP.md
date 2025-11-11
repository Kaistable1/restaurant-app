# Configuration Setup Guide

This guide explains how to set up the local configuration files for the restaurant app.

## Overview

To protect sensitive API keys and configuration data, the following files are not committed to the repository:
- `android/app/google-services.json` - Firebase configuration for Android
- `ios/Runner/GoogleService-Info.plist` - Firebase configuration for iOS  
- `android/app/src/main/res/values/strings.xml` - Android string resources including Google Maps API key

Template files with `.example` extensions are provided as references.

## Setup Instructions

### 1. Android Google Maps API Key

Copy the example strings file and add your API key:

```bash
cp android/app/src/main/res/values/strings.xml.example android/app/src/main/res/values/strings.xml
```

Then edit `android/app/src/main/res/values/strings.xml` and replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual Google Maps API key.

### 2. Firebase Configuration (Android)

Copy the example file and add your Firebase configuration:

```bash
cp android/app/google-services.json.example android/app/google-services.json
```

Then replace the placeholder values in `android/app/google-services.json` with your actual Firebase project configuration. You can download this file from the Firebase Console:
1. Go to Firebase Console (https://console.firebase.google.com)
2. Select your project
3. Go to Project Settings
4. Under "Your apps", select your Android app
5. Download the `google-services.json` file

### 3. Firebase Configuration (iOS)

Copy the example file and add your Firebase configuration:

```bash
cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
```

Then replace the placeholder values in `ios/Runner/GoogleService-Info.plist` with your actual Firebase project configuration. You can download this file from the Firebase Console:
1. Go to Firebase Console (https://console.firebase.google.com)
2. Select your project
3. Go to Project Settings
4. Under "Your apps", select your iOS app
5. Download the `GoogleService-Info.plist` file

## Security Note

**NEVER commit the actual configuration files to version control.** These files contain sensitive API keys and should remain local to your development environment. The `.gitignore` file is configured to prevent accidentally committing these files.

## Obtaining API Keys

### Google Maps API Key
1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Maps SDK for Android
4. Create credentials (API Key)
5. Restrict the API key to your app's package name and SHA-1 fingerprint

### Firebase Configuration
1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Add Android and/or iOS apps to your Firebase project
4. Download the configuration files as described above
