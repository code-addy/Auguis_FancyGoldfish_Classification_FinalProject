# Firebase Storage Bucket Setup

## Error: "BUCKET NOT FOUND"

This means the Firebase Storage bucket does not exist or is not yet created in your `auguis-goldfish` project.

---

## Quick Fix: Create Storage Bucket

### Step 1: Go to Firebase Console
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **auguis-goldfish**
3. In the left menu, click **Storage**

### Step 2: Create Bucket
1. Click **Get Started** button
2. In the dialog that appears:
   - **Location:** Select `us-central1` (or your preferred region)
   - Click **Create**
3. Wait for bucket to be created (takes ~1 minute)

### Step 3: Verify Bucket Created
- You should see: `auguis-goldfish.firebasestorage.app` listed

### Step 4: Set Security Rules
1. Click **Rules** tab
2. Replace all content with:
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
3. Click **Publish**

### Step 5: Rebuild App
```powershell
flutter clean
flutter pub get
flutter run
```

---

## If Bucket Still Not Found

### Option 1: Check Bucket Name
- Go to Storage tab in Firebase Console
- Copy the **exact** bucket name (should match `google-services.json`)
- In `google-services.json`, verify something like:
```json
"storage_bucket": "auguis-goldfish.firebasestorage.app"
```

### Option 2: Update App to Use Correct Bucket Name
If your bucket name is different, update `lib/home_screen.dart`:

Find the line:
```dart
final storageRef = FirebaseStorage.instance
    .ref()
    .child('uploads')
    .child(fileNameBase);
```

Replace with (if your bucket has a different name):
```dart
final storageRef = FirebaseStorage.instance
    .refFromURL('gs://YOUR-BUCKET-NAME/uploads/$fileNameBase');
```

Where `YOUR-BUCKET-NAME` is the exact name from Firebase Console (without `.firebasestorage.app`)

### Option 3: Regenerate google-services.json
1. Delete current `android/app/google-services.json`
2. Go to Firebase Console → Project Settings (gear icon)
3. Download new `google-services.json` for Android
4. Replace the file in `android/app/google-services.json`
5. Rebuild: `flutter clean && flutter pub get && flutter run`

---

## Verification Checklist

- [ ] Bucket exists in Firebase Console Storage tab
- [ ] Bucket name matches `google-services.json`
- [ ] Security rules are published (allow read/write)
- [ ] `google-services.json` is in `android/app/` directory
- [ ] App rebuilt after changes
