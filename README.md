# Hydrant Hose Coverage — Android tablet app

The Hydrant Hose Coverage tool packaged as an offline Android app for Samsung Galaxy Tab
(works on any Android 8+ tablet, S Pen and Samsung DeX included).

## Get the APK (GitHub Actions — no Android Studio needed)

1. Create a new GitHub repository (private is fine) and upload everything in this folder,
   keeping the folder structure (including the hidden `.github` folder).
2. Open the repo's **Actions** tab. The **Build APK** workflow runs on every push to `main`
   (or press **Run workflow**). It takes about 4–6 minutes.
3. Open the finished run and download **HydrantHoseCoverage-apk** under *Artifacts*.
   Unzip it to get `HydrantHoseCoverage-1.0.N.apk`.

## Install on the Samsung tablet

1. Copy the APK to the tablet (Google Drive, USB, email to yourself…) and tap it in **My Files**.
2. When asked, allow **Install unknown apps** for the app you opened it from
   (Settings ▸ Apps ▸ ⋮ ▸ Special access ▸ Install unknown apps).
3. Tap **Install**. If Play Protect warns about an unknown developer, choose **Install anyway**.

New builds install straight over the old one (same signing key, `keystore/sideload.jks`), keeping
your settings. As in the browser version, drawings are kept by **Save** / **Open** (.json files).

## What's different from the browser version

- Runs fully offline: pdf.js, three.js and the fonts are bundled inside the APK.
- Two-finger pinch to zoom and pan on the 2D plan (the 3D view already had it).
- On-screen touch bar for things that needed a keyboard: Undo, Redo, Finish (wall/area),
  Delete (last point or selection), Cancel, Rotate (hydrant/reel), Straight (= Shift, locks
  walls to 0/90°), Free place (= Alt, don't snap equipment to walls), Fit.
- Larger buttons, checkboxes and inputs for fingers; hints say "tap" and "pinch".
- Save / Save as / snapshot images open Android's **Save to** picker (Downloads, Drive, OneDrive…).
- Import plan and Open use Android's file picker (PDF, images, saved .json progress files).
- Back button closes dialogs and cancels the current tool before leaving the app.
- Screen stays on while the app is open; rotating the tablet does not reload the drawing.

## Updating the tool

Edit `web/index.html` (it is the same page as the Claude artifact) and push — the workflow
re-bundles it and builds a new APK.

To build locally in Android Studio instead: run `bash scripts/make_offline.sh` once
(needs internet), then open this folder and use *Build ▸ Build APK(s)*.

## Before any Google Play release

The bundled key is for side-loading only (its password is in `app/build.gradle`).
For Play, create your own keystore and add repository secrets `KEYSTORE_FILE`,
`KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD` (and decode the keystore to that path in the
workflow), or use Play App Signing. Package name: `engineering.firify.hydrant`.
