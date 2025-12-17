# Fix Firebase Credentials Error

## Error Message:
```
"The project does not exist or you do not have permission to list apps in the project"
```

This means:
- The `google-services.json` file has invalid/expired credentials, OR
- The Firebase project was deleted or you lost access, OR
- The credentials don't match the actual Firebase project

---

## Solution: Regenerate google-services.json

### Step 1: Go to Firebase Console
1. Open: https://console.firebase.google.com/
2. Look for your Firebase projects
3. If you see **"casuco-spiders"** → click it
4. If you DON'T see it → you may need to create a new project

### Step 2: Download Fresh google-services.json

If project exists:
1. Click **casuco-spiders** project
2. Click gear icon ⚙️ (Project Settings) at top left
3. Go to **"Your apps"** section
4. Find your Android app (should say "com.example.imageclassifierapp")
5. Click **"google-services.json"** download button
6. Save the file

### Step 3: Replace Old File
1. Delete old file: `android/app/google-services.json`
2. Copy new `google-services.json` into `android/app/` folder
3. Verify file is there: `android/app/google-services.json`

### Step 4: Rebuild App
```powershell
flutter clean
flutter pub get
flutter run
```

---

## If Project NOT Found:

### Option A: Create New Firebase Project
1. Go to: https://console.firebase.google.com/
2. Click **"Create a project"** or **"Add project"**
3. Enter name: `casuco-spiders`
4. Follow setup wizard
5. Download `google-services.json` for your Android app
6. Place in `android/app/google-services.json`

### Option B: Use Different Project
If you want to use an existing Firebase project:
1. Note the project ID
2. Update `android/app/google-services.json` with credentials from that project
3. Create Storage bucket in that project (Storage tab → Get Started)
4. Set Storage rules (see FIND_FIREBASE_BUCKET.md)

---

## Step-by-Step with Screenshots

### 1. Firebase Console Main Page
```
https://console.firebase.google.com/

You should see:
┌─────────────────────────────────┐
│ My Projects                     │
│                                 │
│ □ casuco-spiders                │
│ □ other-project                 │
│ ...                             │
└─────────────────────────────────┘
```

### 2. Project Settings Location
```
Once inside project, look for:

⚙️ (gear icon) at TOP LEFT
│
├─ Project Settings
├─ Users and permissions
├─ Service accounts
└─ ...
```

### 3. Download google-services.json
```
In Project Settings → "Your apps" section:

┌──────────────────────────────┐
│ Your apps                    │
│                              │
│ Android                      │
│ ├─ com.example.imageclassifierapp
│    ├─ [Download] google-services.json
│    └─ ...                   │
└──────────────────────────────┘
```

---

## Verify New File Works

After replacing file:

1. Open `android/app/google-services.json` in editor
2. Look for these fields:
   ```json
   "project_id": "casuco-spiders",
   "storage_bucket": "casuco-spiders.firebasestorage.app"
   ```
3. If `storage_bucket` is empty: 
   - Go to Firebase → Storage → Create bucket
4. If `storage_bucket` exists: Good!

---

## Still Getting Error?

### Check 1: Is google-services.json in correct location?
```
✅ CORRECT:
android/app/google-services.json

❌ WRONG:
android/google-services.json
app/google-services.json
src/google-services.json
```

### Check 2: Is file valid JSON?
1. Open `android/app/google-services.json`
2. Should start with: `{`
3. Should end with: `}`
4. No syntax errors

### Check 3: Can you access Firebase Console?
1. Try: https://console.firebase.google.com/
2. Can you log in? Can you see "casuco-spiders" project?
3. If NO project shown → create new one or ask project owner for access

### Check 4: Rebuild without cache
```powershell
flutter clean
rm -r build  # or: rmdir /s /q build (Windows)
flutter pub get
flutter run
```

---

## If All Else Fails

### Nuclear Option: Start Fresh
1. Delete: `android/app/google-services.json`
2. Create NEW Firebase project with different name
3. Download new `google-services.json`
4. Place in `android/app/`
5. Rebuild: `flutter clean && flutter pub get && flutter run`

This ensures no old/corrupted credentials

---

## Quick Reference Commands

```powershell
# Check if google-services.json exists
Test-Path "android/app/google-services.json"

# View contents (to verify it has data)
Get-Content "android/app/google-services.json"

# Clean rebuild
flutter clean
flutter pub get
flutter run
```

---

## Need Help?

If you're still stuck, run this and share the output:
```powershell
flutter pub get
```

If it says permission denied or similar, the issue is confirmed to be credentials.

Once you regenerate `google-services.json`, everything should work!
