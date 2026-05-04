@Observed
export class WifiFullInfo {
  // Connection info
  ssid: string = '';
  bssid: string = '';
  isConnected: boolean = false;
  connState: string = '';
  isHiddenSsid: boolean = false;
  isRestricted: boolean = false;

  // AP properties
  bandLabel: string = '';
  frequency: string = '';
  channel: string = '';
  channelWidth: string = '';
  securityType: string = '';
  capabilities: string = '';

  // Signal
  rssi: number = 0;
  signalLevel: number = 0;
  signalPercent: number = 0;

  // Speed
  linkSpeed: string = '';
  uplinkBw: string = '';
  downlinkBw: string = '';

  // Network addresses
  deviceMac: string = '';
  ipAddress: string = '';
  subnetMask: string = '';
  gateway: string = '';
  dns1: string = '';
  dns2: string = '';
  interfaceName: string = '';
  mtu: number = 0;

  // Error
  errorMsg: string = '';
}

@Observed
export class WifiScanItem {
  ssid: string = '';
  bssid: string = '';
  rssi: number = 0;
  signalLevel: number = 0;
  signalPercent: number = 0;
  bandLabel: string = '';
  frequency: string = '';
  channel: string = '';
  channelWidth: string = '';
  securityType: string = '';
  capabilities: string = '';
  isConnected: boolean = false;
}

export const BAND_2G = 1;
export const BAND_5G = 2;
export const BAND_6G = 3;

export function intToIp(ip: number): string {
  if (!ip || ip < 0 || ip > 0xFFFFFFFF) {
    return '';
  }
  return (ip >>> 24) + '.' + (ip >> 16 & 0xFF) + '.' + (ip >> 8 & 0xFF) + '.' + (ip & 0xFF);
}

export function prefixToMask(prefix: number): string {
  if (prefix < 0 || prefix > 32) {
    return '';
  }
  const mask = prefix === 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) >>> 0;
  return intToIp(mask);
}

export function frequencyToChannel(freq: number): string {
  if (freq >= 2412 && freq <= 2484) {
    return String(Math.round((freq - 2412) / 5 + 1));
  } else if (freq >= 5035 && freq <= 5865) {
    return String(Math.round((freq - 5000) / 5));
  } else if (freq >= 5925 && freq <= 7125) {
    return String(Math.round((freq - 5950) / 5));
  }
  return '';
}

export function rssiToPercent(rssi: number): number {
  if (!rssi || rssi > 0) {
    return 0;
  }
  const percent = Math.round((rssi + 90) / 60 * 100);
  return percent < 0 ? 0 : (percent > 100 ? 100 : percent);
}

export function parseBand(band: number): string {
  switch (band) {
    case BAND_2G: return '2.4 GHz';
    case BAND_5G: return '5 GHz';
    case BAND_6G: return '6 GHz';
    default: return band ? String(band) : '';
  }
}

export function parseSecurityType(type: number): string {
  switch (type) {
    case 0: return 'OPEN';
    case 1: return 'WEP';
    case 2: return 'PSK';
    case 3: return 'EAP';
    case 4: return 'SAE';
    case 5: return 'EAP-SUITE-B';
    case 6: return 'OWE';
    case 7: return 'WAPI-CERT';
    case 8: return 'WAPI-PSK';
    default: return '';
  }
}

export function parseChannelWidth(width: number): string {
  switch (width) {
    case 0: return '20 MHz';
    case 1: return '40 MHz';
    case 2: return '80 MHz';
    case 3: return '160 MHz';
    case 4: return '80+80 MHz';
    default: return '';
  }
}

export function parseBearerType(type: number): string {
  switch (type) {
    case 0: return 'Cellular';
    case 1: return 'Wi-Fi';
    case 2: return 'Bluetooth';
    case 3: return 'Ethernet';
    case 4: return 'VPN';
    default: return '';
  }
}
