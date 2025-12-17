# Firestore Database Setup Guide

## Step 1: Create Firestore Database

1. Go to: https://console.firebase.google.com/project/casuco-spider/firestore
2. Click **"Create database"** button
3. Select startup mode: **"Start in test mode"**
4. Choose location: **us-central1** (or closest to you)
5. Click **"Create"**
6. Wait for database to initialize (30 seconds - 2 minutes)

## Step 2: Create Collection and Test Data

After database is created:

1. In Firestore console, click **"Start collection"**
2. Collection ID: `predictions`
3. Click **"Next"**
4. Add first document with auto ID, then add these fields:
   - `label` (String): "spider_type_1"
   - `confidence` (Number): 0.95
   - `timestamp` (Timestamp): 2024-12-11 (current date/time)
   - `imagePath` (String): "/path/to/image"
5. Click **"Save"**

## Step 3: Set Up Security Rules

1. In Firestore console, go to **"Rules"** tab
2. Replace the default rules with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /predictions/{document=**} {
      allow read, write: if true;
    }
  }
}
```

3. Click **"Publish"**

## Step 4: Verify Connection

1. Rebuild your Flutter app:
   ```
   flutter clean
   flutter pub get
   flutter run
   ```

2. In the app:
   - Capture an image
   - Tap "Submit Image"
   - Go to graph screen (chart icon in top right)
   - You should see your prediction in the table

## Troubleshooting

### Data not appearing in graph:
- Check Firebase Console → Firestore → Collections
- Make sure `predictions` collection exists
- Verify security rules allow read/write

### Permission denied error:
- Go back to Step 3 and update security rules
- Click "Publish" again
- Restart the app

### Still not working:
1. Check app logs: Look for "Error fetching predictions"
2. Go to Firebase Console and check:
   - Project ID is `casuco-spider` ✓
   - Firestore database exists ✓
   - Security rules published ✓

## Firebase Project Details

- **Project ID**: casuco-spider
- **Region**: us-central1
- **Collection**: predictions
- **Document Fields**: label, confidence, timestamp, imagePath
