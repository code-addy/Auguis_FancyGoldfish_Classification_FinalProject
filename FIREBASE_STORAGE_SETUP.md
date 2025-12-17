# Firebase Storage Setup Guide

## Error: "Storage bucket error: Please check Firebase Storage is configured and public access is allowed"

This error occurs when the Firebase Storage bucket is not properly configured or accessible. Follow these steps to fix it:

---

## Step 1: Verify Firebase Storage Bucket Exists

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **auguis-goldfish**
3. Navigate to **Storage** in the left menu
4. Check if you see a bucket (for example: `auguis-goldfish.firebasestorage.app`)
5. If no bucket exists, click **Get Started** to create one

---

## Step 2: Update Firebase Storage Security Rules

1. In Firebase Console → **Storage** → Click the **Rules** tab
2. Replace all existing rules with the following:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow public read/write to uploads folder
    match /uploads/{allPaths=**} {
      allow read, write: if true;
    }
    
    // Allow any authenticated user
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

3. Click **Publish** to save and deploy the rules

---

## Step 3: Enable Public Access (Optional but Recommended for Testing)

If the above rules don't work, use this more permissive rule (⚠️ **ONLY FOR DEVELOPMENT/TESTING**):

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

---

## Step 4: Verify Android Configuration

1. Check `android/app/google-services.json` exists and contains your goldfish project info, e.g.:
   ```json
   "project_id": "auguis-goldfish",
   "storage_bucket": "auguis-goldfish.firebasestorage.app"
   ```

2. Ensure `android/build.gradle.kts` has:
   ```kotlin
   buildscript {
     dependencies {
       classpath("com.google.gms:google-services:4.3.15")
     }
   }
   ```

3. Ensure `android/app/build.gradle.kts` has:
   ```kotlin
   plugins {
     id("com.google.gms.google-services")
   }
   ```

---

## Step 5: Update Flutter App (if needed)

If the storage reference path is incorrect, update `lib/home_screen.dart` `uploadImage()` method:

Current (should work):
```dart
final storageRef = FirebaseStorage.instance.ref('uploads/$fileNameBase');
```

Alternative if issues persist:
```dart
final storageRef = FirebaseStorage.instance
    .ref()
    .child('uploads')
    .child(fileNameBase);
```

---

## Step 6: Rebuild and Test

```powershell
flutter clean
flutter pub get
flutter run
```

---

## Troubleshooting

| Error | Solution |
|-------|----------|
| `object-not-found` | Bucket doesn't exist or path is wrong. Check Firebase Console Storage exists. |
| `permission-denied` | Rules don't allow access. Update security rules (see Step 2). |
| No bucket shown in Firebase Console | Create bucket by clicking "Get Started" in Storage tab. |
| Still failing | Delete app data, clear cache, and rebuild: `flutter clean && flutter pub get` |

---

## Quick Checklist

- [ ] Firebase Storage bucket exists in Console
- [ ] Security rules are updated and published
- [ ] `google-services.json` is present in `android/app/`
- [ ] `android/build.gradle.kts` has Google Services classpath
- [ ] `android/app/build.gradle.kts` applies Google Services plugin
- [ ] `lib/main.dart` initializes Firebase with `Firebase.initializeApp()`
- [ ] App rebuilt after any changes: `flutter clean && flutter pub get && flutter run`
