import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.fuelguardpro.manager',
  appName: 'FuelGuard Manager',
  webDir: 'www',
  bundledWebRuntime: false,
  plugins: {
    Geolocation: {
      permissions: {
        location: 'This app uses location to sync fleet trip positions.'
      }
    }
  }
};

export default config;
