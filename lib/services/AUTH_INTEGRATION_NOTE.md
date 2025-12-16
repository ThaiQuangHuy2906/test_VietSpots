# ⚠️ Authentication Integration Issue

## Problem
**The backend API does NOT have Supabase Auth endpoints!**

Currently `auth_service.dart` is calling Supabase Auth directly (`/auth/v1/signup`, `/auth/v1/token`, etc.), but the VietSpot backend does NOT expose these routes.

## Backend Authentication Model
Based on the API documentation:
- Backend uses **header-based authentication** with `X-User-ID`
- No JWT tokens, no `/auth/v1/*` endpoints
- The backend expects you to pass `X-User-ID` header for authenticated requests

## Current State
✅ `ApiService` already supports setting user ID via `setUserId()`  
✅ `_headers` includes `X-User-ID` when userId is set  
❌ `auth_service.dart` calls non-existent Supabase Auth endpoints  
❌ `auth_provider.dart` uses `AuthService` which won't work

## Solutions

### Option 1: Add Auth Endpoints to Backend (Recommended)
The backend needs to add authentication endpoints:
```python
# Backend needs these routes:
POST /api/auth/register
POST /api/auth/login
POST /api/auth/logout
GET  /api/auth/me
```

### Option 2: Use Supabase Auth Directly from Flutter
Keep `auth_service.dart` as is, but:
- User logs in via Supabase Auth
- Get Supabase user ID
- Pass that ID to backend via `X-User-ID` header

```dart
// After Supabase login:
final user = await authService.signInWithEmail(email, password);
if (user != null) {
  apiService.setUserId(user.id);  // Now backend calls work
}
```

### Option 3: Mock Authentication (Development Only)
For testing, generate a UUID and set it:
```dart
final mockUserId = Uuid().v4();
apiService.setUserId(mockUserId);
```

## Recommended Action
**Talk to the backend team** about adding proper auth endpoints. The current setup is incomplete.

## Files to Update if Backend Adds Auth
1. `auth_service.dart` - Change from Supabase URLs to backend URLs
2. `auth_provider.dart` - Already correct, just needs working `auth_service.dart`
3. `login_screen.dart` - Already correct
4. `registration_screen.dart` - Already correct

## Temporary Workaround
Until backend auth is ready, you can:
1. Keep Supabase Auth for user management
2. After login, extract user.id and call `apiService.setUserId(user.id)`
3. All API calls will include `X-User-ID` header

Example:
```dart
// In AuthProvider.login():
final authUser = await _authService.signInWithEmail(email, password);
if (authUser != null) {
  _apiService.setUserId(authUser.id);  // ← Add this
  // ... rest of login logic
}
```
