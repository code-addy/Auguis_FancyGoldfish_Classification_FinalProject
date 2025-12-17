# How to Find and Create Firebase Storage Bucket

## Your Configuration
- **Project ID:** auguis-goldfish
- **Expected Bucket:** auguis-goldfish.firebasestorage.app
- **Firebase Console URL:** https://console.firebase.google.com/project/casuco-spiders/storage

---

## STEP-BY-STEP: Locate or Create Bucket

### Step 1: Open Firebase Console
1. Go to: https://console.firebase.google.com/
2. You should see your projects listed
3. Click on: **casuco-spiders** project

### Step 2: Navigate to Storage
1. In the LEFT MENU, look for **"Storage"**
2. Click it (it's usually under "Firestore Database" and "Realtime Database")

### Step 3: What You'll See

**IF YOU SEE THIS MESSAGE:**
```
"Cloud Storage is empty"
"Get Started"
```
→ **BUCKET DOESN'T EXIST** (this is your problem)
→ Click **"Get Started"** button

**IF YOU SEE A BUCKET LISTED:**
```
casuco-spiders.firebasestorage.app
    ├── Rules
    ├── Files
    └── Usage
```
→ **BUCKET EXISTS** but storage rules are blocking access

---

## IF BUCKET DOESN'T EXIST: Create It

### 1. Click "Get Started"
### 2. In Dialog Box:
- **Choose location:** `us-central1` (default is fine)
- Click **"Create"**

### 3. Wait for Bucket to Create
- Takes ~1-2 minutes
- You'll see loading bar
- When done, bucket will appear in list

### 4. After Bucket Created, Set Rules

**Click the "Rules" tab** (next to "Files")

Replace ALL content in the rules editor with:
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

**Click "Publish" button** (blue button at bottom right)

---

## IF BUCKET EXISTS BUT UPLOAD STILL FAILS

### Check 1: Verify Bucket Name
- In Storage tab, look at the bucket name
- Should match: `casuco-spiders.firebasestorage.app`
- If different, note the correct name

### Check 2: Verify Rules Are Published
- Click "Rules" tab
- Should see the rules you published
- If empty or different, update with above rules
- Click "Publish"

### Check 3: Check Rules Status
Look for green checkmark or "Published" indicator

---

## QUICK VERIFICATION CHECKLIST

1. **Bucket Exists**
   - [ ] Go to https://console.firebase.google.com/project/casuco-spiders/storage
   - [ ] See `casuco-spiders.firebasestorage.app` listed

2. **Rules Are Published**
   - [ ] Click "Rules" tab
   - [ ] Should contain: `allow read, write: if true;`
   - [ ] Should have green checkmark or "Published" status

3. **App Config Matches**
   - [ ] In `android/app/google-services.json`
   - [ ] Verify: `"storage_bucket": "casuco-spiders.firebasestorage.app"`

---

## If You Still Get Error

**Try this:**

1. **Delete Bucket and Recreate**
   - Click bucket → Settings (gear icon)
   - Delete bucket
   - Wait 24 hours (can take up to 24h to fully delete)
   - Create new bucket with same name

2. **Or: Download Fresh google-services.json**
   - Firebase Console → Project Settings (gear icon at top)
   - Download Android config file again
   - Replace `android/app/google-services.json`
   - Run: `flutter clean && flutter pub get && flutter run`

3. **Or: Contact Firebase Support**
   - If bucket creation fails repeatedly
   - Go to Firebase Console → Help & Support → Contact Support

---

## Firebase Console Direct Links

- Main: https://console.firebase.google.com/
- Your Project: https://console.firebase.google.com/project/casuco-spiders
- Your Storage: https://console.firebase.google.com/project/casuco-spiders/storage
- Project Settings: https://console.firebase.google.com/project/casuco-spiders/settings/general

---

## Screenshot Guide

### What "Get Started" Button Looks Like:
```
┌─────────────────────────────────┐
│ Cloud Storage                   │
│                                 │
│ Cloud Storage is empty          │
│                                 │
│      [ Get Started Button ]     │
└─────────────────────────────────┘
```

### What Storage Tab Looks Like After Creation:
```
┌──────────────────────────────────────┐
│ Storage                              │
│ ├─ casuco-spiders.firebasestorage.app
│ │  ├─ Rules  ← Click here
│ │  ├─ Files
│ │  └─ Usage
│ └─ ...more options
└──────────────────────────────────────┘
```

### What Rules Tab Looks Like:
```
┌────────────────────────────────┐
│ Rules                          │
│                                │
│ rules_version = '2';           │
│ service firebase.storage {     │
│   match /b/{bucket}/o {        │
│     match /{allPaths=**} {     │
│       allow read, write: if true;
│     }                          │
│   }                            │
│ }                              │
│                                │
│ [Publish]  [Cancel]            │
└────────────────────────────────┘
```

---

## Still Stuck?

**Run this in PowerShell to check if Flutter can reach Firebase:**

```powershell
flutter clean
flutter pub get
flutter run
```

Then in the app:
1. Take a photo
2. Try to submit
3. Look at console output for exact error message
4. Copy and share that error

The exact error message will tell us exactly what's wrong!
