# Savrli City API Integration Guide

## Overview
This guide provides instructions for integrating with the Savrli City Concierge API V1. The API enables user signup, onboarding, and task management for the restaurant concierge service.

**API Version:** 1.0.0  
**Base URL (Staging):** `https://staging-api.savrli.city/v1`  
**Base URL (Production):** `https://api.savrli.city/v1`  
**API Spec:** See `openapi.yaml` for complete OpenAPI 3.0 specification

---

## Table of Contents
1. [Authentication](#authentication)
2. [API Endpoints](#api-endpoints)
3. [Request/Response Formats](#requestresponse-formats)
4. [Error Handling](#error-handling)
5. [Rate Limiting](#rate-limiting)
6. [Code Examples](#code-examples)
7. [Testing](#testing)

---

## Authentication

### JWT Bearer Token
Most endpoints require authentication using JWT Bearer tokens.

**Login Flow:**
1. User signs up via `/auth/signup`
2. User logs in to receive JWT token
3. Include token in subsequent requests

**Request Header:**
```http
Authorization: Bearer <your-jwt-token>
```

### Token Expiration
- Access tokens expire after 24 hours
- Refresh tokens expire after 30 days
- Implement token refresh logic in your application

---

## API Endpoints

### 1. User Signup
Register a new user account.

**Endpoint:** `POST /auth/signup`  
**Authentication:** Not required

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe",
  "phoneNumber": "+1-555-0123"
}
```

**Success Response (201):**
```json
{
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "message": "User registered successfully"
}
```

**Error Response (409):**
```json
{
  "error": "USER_EXISTS",
  "message": "User with this email already exists"
}
```

---

### 2. Concierge Onboarding
Submit user preferences and complete onboarding.

**Endpoint:** `POST /onboarding`  
**Authentication:** Required (Bearer token)

**Request Body:**
```json
{
  "preferences": {
    "cuisines": ["Italian", "Japanese", "Mexican"],
    "dietaryRestrictions": ["vegetarian", "gluten-free"],
    "priceRange": "moderate"
  },
  "location": {
    "city": "San Francisco",
    "zipCode": "94102",
    "address": "123 Main St"
  },
  "notifications": {
    "email": true,
    "push": true,
    "sms": false
  }
}
```

**Success Response (200):**
```json
{
  "status": "completed",
  "onboardingId": "660e8400-e29b-41d4-a716-446655440001",
  "message": "Onboarding completed successfully"
}
```

---

### 3. Create Primary Task
Create a new concierge task (e.g., restaurant reservation).

**Endpoint:** `POST /tasks/primary`  
**Authentication:** Required (Bearer token)

**Request Body:**
```json
{
  "taskType": "reservation",
  "details": {
    "restaurantName": "The Blue Duck",
    "partySize": 4,
    "dateTime": "2025-11-15T19:00:00Z",
    "specialRequests": "Window seat preferred"
  },
  "priority": "normal"
}
```

**Success Response (201):**
```json
{
  "taskId": "770e8400-e29b-41d4-a716-446655440002",
  "status": "pending",
  "createdAt": "2025-11-12T16:00:00Z",
  "estimatedCompletionTime": "2025-11-12T17:00:00Z"
}
```

---

### 4. Get Primary Tasks
Retrieve user's tasks with optional filtering.

**Endpoint:** `GET /tasks/primary`  
**Authentication:** Required (Bearer token)

**Query Parameters:**
- `status` (optional): Filter by status (pending, in-progress, completed, cancelled)
- `limit` (optional): Number of results (default: 20, max: 100)
- `offset` (optional): Pagination offset (default: 0)

**Example Request:**
```http
GET /tasks/primary?status=pending&limit=10&offset=0
Authorization: Bearer <token>
```

**Success Response (200):**
```json
{
  "tasks": [
    {
      "taskId": "770e8400-e29b-41d4-a716-446655440002",
      "taskType": "reservation",
      "status": "pending",
      "details": {
        "restaurantName": "The Blue Duck",
        "partySize": 4
      },
      "priority": "normal",
      "createdAt": "2025-11-12T16:00:00Z",
      "updatedAt": "2025-11-12T16:00:00Z"
    }
  ],
  "total": 1,
  "limit": 10,
  "offset": 0
}
```

---

## Request/Response Formats

### Content Type
All requests and responses use JSON:
```http
Content-Type: application/json
```

### Date Format
All dates use ISO 8601 format:
```
2025-11-15T19:00:00Z
```

### UUID Format
IDs use UUID v4 format:
```
550e8400-e29b-41d4-a716-446655440000
```

---

## Error Handling

### Standard Error Response
```json
{
  "error": "ERROR_CODE",
  "message": "Human-readable error message",
  "details": [
    "Additional error detail 1",
    "Additional error detail 2"
  ]
}
```

### Common HTTP Status Codes
- **200 OK** - Request succeeded
- **201 Created** - Resource created successfully
- **400 Bad Request** - Invalid request data
- **401 Unauthorized** - Missing or invalid authentication
- **403 Forbidden** - Insufficient permissions
- **404 Not Found** - Resource not found
- **409 Conflict** - Resource already exists
- **422 Unprocessable Entity** - Validation failed
- **429 Too Many Requests** - Rate limit exceeded
- **500 Internal Server Error** - Server error
- **503 Service Unavailable** - Service temporarily unavailable

### Error Codes
- `VALIDATION_ERROR` - Request validation failed
- `USER_EXISTS` - User already exists
- `USER_NOT_FOUND` - User not found
- `INVALID_CREDENTIALS` - Invalid login credentials
- `TOKEN_EXPIRED` - Authentication token expired
- `UNAUTHORIZED` - Not authorized to access resource
- `RATE_LIMIT_EXCEEDED` - Too many requests
- `INTERNAL_ERROR` - Internal server error

---

## Rate Limiting

### Limits
- **Authenticated requests:** 100 requests per minute
- **Unauthenticated requests:** 20 requests per minute

### Response Headers
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1699891200
```

### Handling Rate Limits
When rate limit is exceeded (HTTP 429), implement exponential backoff:
```javascript
const delay = Math.min(1000 * Math.pow(2, retryCount), 30000);
await sleep(delay);
```

---

## Code Examples

### JavaScript/TypeScript

#### Signup Example
```javascript
const API_BASE_URL = 'https://staging-api.savrli.city/v1';

async function signup(userData) {
  const response = await fetch(`${API_BASE_URL}/auth/signup`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message);
  }

  return await response.json();
}

// Usage
const newUser = await signup({
  email: 'user@example.com',
  password: 'SecurePass123!',
  firstName: 'John',
  lastName: 'Doe',
});
```

#### Authenticated Request Example
```javascript
async function createTask(taskData, authToken) {
  const response = await fetch(`${API_BASE_URL}/tasks/primary`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${authToken}`,
    },
    body: JSON.stringify(taskData),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message);
  }

  return await response.json();
}

// Usage
const task = await createTask({
  taskType: 'reservation',
  details: {
    restaurantName: 'The Blue Duck',
    partySize: 4,
    dateTime: '2025-11-15T19:00:00Z',
  },
}, userToken);
```

### Dart/Flutter

#### Signup Example
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiBaseUrl = 'https://staging-api.savrli.city/v1';

Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
  final response = await http.post(
    Uri.parse('$apiBaseUrl/auth/signup'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(userData),
  );

  if (response.statusCode != 201) {
    final error = jsonDecode(response.body);
    throw Exception(error['message']);
  }

  return jsonDecode(response.body);
}

// Usage
final newUser = await signup({
  'email': 'user@example.com',
  'password': 'SecurePass123!',
  'firstName': 'John',
  'lastName': 'Doe',
});
```

#### Authenticated Request Example
```dart
Future<Map<String, dynamic>> createTask(
  Map<String, dynamic> taskData,
  String authToken,
) async {
  final response = await http.post(
    Uri.parse('$apiBaseUrl/tasks/primary'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
    body: jsonEncode(taskData),
  );

  if (response.statusCode != 201) {
    final error = jsonDecode(response.body);
    throw Exception(error['message']);
  }

  return jsonDecode(response.body);
}

// Usage
final task = await createTask({
  'taskType': 'reservation',
  'details': {
    'restaurantName': 'The Blue Duck',
    'partySize': 4,
    'dateTime': '2025-11-15T19:00:00Z',
  },
}, userToken);
```

### cURL Examples

#### Signup
```bash
curl -X POST https://staging-api.savrli.city/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePass123!",
    "firstName": "John",
    "lastName": "Doe"
  }'
```

#### Create Task (Authenticated)
```bash
curl -X POST https://staging-api.savrli.city/v1/tasks/primary \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "taskType": "reservation",
    "details": {
      "restaurantName": "The Blue Duck",
      "partySize": 4,
      "dateTime": "2025-11-15T19:00:00Z"
    }
  }'
```

#### Get Tasks
```bash
curl -X GET "https://staging-api.savrli.city/v1/tasks/primary?status=pending&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## Testing

### Test Accounts
Use these test accounts in staging environment:

**Test User 1:**
- Email: `test1@savrli.city`
- Password: `TestPass123!`

**Test User 2:**
- Email: `test2@savrli.city`
- Password: `TestPass123!`

### Postman Collection
Import the OpenAPI spec (`openapi.yaml`) into Postman:
1. Open Postman
2. Click Import → File
3. Select `openapi.yaml`
4. Configure environment variables

### API Testing Tools
- **Postman** - Interactive API testing
- **Insomnia** - REST client alternative
- **curl** - Command-line testing
- **Cypress** - Automated E2E testing (see `cypress/integration/smoke_spec.cy.js`)

### Health Check
```bash
curl https://staging-api.savrli.city/health
```

Expected response:
```json
{
  "status": "healthy",
  "version": "1.0.0"
}
```

---

## Best Practices

### Security
- ✅ Always use HTTPS
- ✅ Never expose API keys in client code
- ✅ Store tokens securely (e.g., secure storage, keychain)
- ✅ Implement token refresh logic
- ✅ Validate all input data
- ✅ Handle errors gracefully

### Performance
- ✅ Implement request caching where appropriate
- ✅ Use pagination for large data sets
- ✅ Implement retry logic with exponential backoff
- ✅ Minimize API calls by batching when possible

### Error Handling
- ✅ Always check response status codes
- ✅ Parse and display error messages to users
- ✅ Log errors for debugging
- ✅ Implement fallback mechanisms

---

## Support

### Documentation
- OpenAPI Spec: `openapi.yaml`
- Operations Runbook: `docs/V1-runbook.md`
- Integration Tests: `cypress/integration/smoke_spec.cy.js`

### Contact
- **Technical Support:** devops@kaistable.com
- **API Issues:** api-support@kaistable.com
- **General Inquiries:** support@kaistable.com

### Resources
- [Firebase Console](https://console.firebase.google.com/)
- [GitHub Repository](https://github.com/Kaistable1/restaurant-app)
- [Status Page](https://status.savrli.city)

---

**Last Updated:** 2025-11-12  
**Version:** 1.0.0
