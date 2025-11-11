# API Keys and Configuration Setup

This document explains how to configure API keys and service configuration files for local development.

## Overview

Sensitive API keys and configuration files are not committed to version control for security reasons. Instead, placeholder/example files are provided that you need to copy and configure with your own credentials.

## Required Configuration Files

### 1. Google Maps API Key (Android)

**File:** `android/app/src/main/res/values/strings.xml`

**Setup:**
1. Copy the example file:
   ```bash
   cp android/app/src/main/res/values/strings.xml.example android/app/src/main/res/values/strings.xml
   ```
2. Edit `strings.xml` and replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual Google Maps API key
3. Get your API key from [Google Cloud Console](https://console.cloud.google.com/apis/credentials)

### 2. Google Services (Android)

**File:** `android/app/google-services.json`

**Setup:**
1. Copy the example file:
   ```bash
   cp android/app/google-services.json.example android/app/google-services.json
   ```
2. Replace with your actual `google-services.json` file from Firebase Console
3. Download from [Firebase Console](https://console.firebase.google.com/) → Project Settings → General → Your apps

### 3. Google Services (iOS)

**File:** `ios/Runner/GoogleService-Info.plist`

**Setup:**
1. Copy the example file:
   ```bash
   cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
   ```
2. Replace with your actual `GoogleService-Info.plist` file from Firebase Console
3. Download from [Firebase Console](https://console.firebase.google.com/) → Project Settings → General → Your apps

## Important Notes

- **Never commit** the actual configuration files (`strings.xml`, `google-services.json`, `GoogleService-Info.plist`) to version control
- These files are already listed in `.gitignore` to prevent accidental commits
- Only commit the `.example` files if you make structural changes
- Keep your API keys secure and never share them publicly

## Verification

After setting up the configuration files, verify that:
1. All three configuration files exist locally
2. They contain your actual credentials (not the placeholder values)
3. The app builds successfully
4. Git status doesn't show these files as changes to be committed
