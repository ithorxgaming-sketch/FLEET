FUELGUARD PRO — TWO ANDROID APP SOURCE SCAFFOLD
================================================

This package creates TWO separate Android app projects:
  1. FuelGuard-Manager  (com.fuelguardpro.manager)
  2. FuelGuard-Driver   (com.fuelguardpro.driver)

The existing HTML/CSS/JS workspace files from the latest supplied ZIP are
copied into each app's www/ folder. The Supabase URL and browser-safe
publishable key remain as they were in the supplied source. No Gemini
integration has been added.

IMPORTANT SOURCE INSPECTION FINDINGS
------------------------------------
The latest ZIP is not a fully native-ready, production-verified website:
- The manager HTML contains demo/prototype fallback handlers for some actions.
  The Supabase integration script replaces/wires many manager actions, but
  every workflow still needs device testing.
- The driver HTML includes local-demo inline GPS/trip/fuel handlers alongside
  the Supabase integration script. This means the source needs conflict
  testing before calling the Android apps complete.
- The existing README explicitly says GPS tracking runs while the driver page
  is active and may pause when the browser is backgrounded or the screen locks.
- Capacitor Geolocation permission is declared, but reliable Android background
  GPS requires a dedicated native foreground-service implementation and
  Android 13+ notification permission handling. This scaffold does NOT claim
  background GPS is already implemented.
- Camera/file picker and WhatsApp handoff must be tested on a physical Android
  device. WhatsApp links cannot silently send a message.

SECURITY
--------
- No Supabase service-role key is included. Keep RLS enabled.
- Manager and driver roles are checked by the existing integration script.
- App separation by package ID is not a substitute for Supabase RLS policies.
- Do not put passwords or secret keys in source code.

BUILD
-----
Install Node.js LTS and Android Studio (Android SDK + platform tools).
Open each project folder separately and run:
  npm install
  npx cap add android
  npx cap sync android
  npx cap open android

Then build an APK from Android Studio. You must build each project separately.
For release distribution, configure app signing securely in Android Studio.

Before real fleet use, test login, role separation, vehicle assignment, trips,
GPS, SOS, fuel proof upload, manager review, and WhatsApp on two test accounts
and physical Android devices.
