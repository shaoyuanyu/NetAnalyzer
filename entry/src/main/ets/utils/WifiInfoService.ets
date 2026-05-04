import { wifiManager } from '@kit.ConnectivityKit';
import { connection } from '@kit.NetworkKit';
import {
  WifiFullInfo,
  WifiScanItem,
  intToIp,
  prefixToMask,
  frequencyToChannel,
  rssiToPercent,
  parseBand,
  parseSecurityType,
  parseChannelWidth
} from '../model/WifiData';

export async function fetchFullWifiInfo(): Promise<WifiFullInfo> {
  const result = new WifiFullInfo();

  try {
    const isActive = wifiManager.isWifiActive();
    if (!isActive) {
      result.errorMsg = 'Wi-Fi is not enabled';
      return result;
    }

    const isConnected = wifiManager.isConnected();
    if (!isConnected) {
      result.connState = 'NOT CONNECTED';
      result.errorMsg = 'Not connected to Wi-Fi';
      return result;
    }

    const linkedInfo = await wifiManager.getLinkedInfo();

    result.isConnected = true;
    result.connState = 'CONNECTED';
    result.ssid = linkedInfo.ssid || '';
    result.bssid = linkedInfo.bssid || '';
    result.isHiddenSsid = linkedInfo.isHidden === true;
    result.isRestricted = linkedInfo.isRestricted === true;
    result.rssi = linkedInfo.rssi;
    result.linkSpeed = linkedInfo.linkSpeed ? String(linkedInfo.linkSpeed) + ' Mbps' : '';
    result.deviceMac = linkedInfo.macAddress || '';
    result.bandLabel = parseBand(linkedInfo.band ?? 0);
    result.frequency = linkedInfo.frequency ? String(linkedInfo.frequency) + ' MHz' : '';
    result.channel = frequencyToChannel(linkedInfo.frequency ?? 0);
    result.signalLevel = wifiManager.getSignalLevel(linkedInfo.rssi, linkedInfo.band ?? 1);
    result.signalPercent = rssiToPercent(linkedInfo.rssi);

    if (linkedInfo.ipAddress) {
      result.ipAddress = intToIp(linkedInfo.ipAddress);
    }

    // Scan info for matching AP
    try {
      const scanList = wifiManager.getScanInfoList();
      if (scanList) {
        for (let i = 0; i < scanList.length; i++) {
          const scan = scanList[i];
          if (scan.bssid === linkedInfo.bssid) {
            result.channelWidth = parseChannelWidth(scan.channelWidth ?? 0);
            result.securityType = parseSecurityType(scan.securityType ?? -1);
            result.capabilities = scan.capabilities || '';
            break;
          }
        }
      }
    } catch (_e) {
      // Scan info not available
    }

    // Network connection properties
    try {
      const netHandle = await connection.getDefaultNet();
      if (netHandle) {
        const results: Array<connection.ConnectionProperties | connection.NetCapabilities | null> =
          await Promise.all([
            getConnPropertiesSafe(netHandle),
            getNetCapabilitiesSafe(netHandle)
          ]);
        const connProp = results[0] as connection.ConnectionProperties | null;
        const netCap = results[1] as connection.NetCapabilities | null;

        if (connProp) {
          result.interfaceName = connProp.interfaceName ?? '';
          result.mtu = connProp.mtu ?? 0;

          if (connProp.linkAddresses && connProp.linkAddresses.length > 0) {
            const linkAddr = connProp.linkAddresses[0];
            if (linkAddr.address) {
              result.ipAddress = linkAddr.address.address ?? result.ipAddress;
            }
            if (linkAddr.prefixLength !== undefined && linkAddr.prefixLength !== null) {
              result.subnetMask = prefixToMask(linkAddr.prefixLength as number);
            }
          }

          if (connProp.dnses && connProp.dnses.length > 0) {
            result.dns1 = connProp.dnses[0].address ?? '';
            if (connProp.dnses.length > 1) {
              result.dns2 = connProp.dnses[1].address ?? '';
            }
          }

          if (connProp.routes) {
            for (let i = 0; i < connProp.routes.length; i++) {
              const route = connProp.routes[i];
              if (route.hasGateway && route.gateway?.address && route.isDefaultRoute) {
                result.gateway = route.gateway.address;
                break;
              }
            }
            if (!result.gateway) {
              for (let i = 0; i < connProp.routes.length; i++) {
                const route = connProp.routes[i];
                if (route.hasGateway && route.gateway?.address) {
                  result.gateway = route.gateway.address;
                  break;
                }
              }
            }
          }
        }

        if (netCap) {
          if (netCap.linkUpBandwidthKbps) {
            result.uplinkBw = formatBandwidth(netCap.linkUpBandwidthKbps);
          }
          if (netCap.linkDownBandwidthKbps) {
            result.downlinkBw = formatBandwidth(netCap.linkDownBandwidthKbps);
          }
        }
      }
    } catch (_e) {
      // Network info not available
    }

  } catch (_err) {
    result.errorMsg = 'Error fetching WiFi info';
  }

  return result;
}

function formatBandwidth(kbps: number): string {
  if (kbps >= 1000000) {
    return (kbps / 1000000).toFixed(1) + ' Gbps';
  } else if (kbps >= 1000) {
    return (kbps / 1000).toFixed(0) + ' Mbps';
  }
  return kbps + ' kbps';
}

async function getConnPropertiesSafe(
  netHandle: connection.NetHandle
): Promise<connection.ConnectionProperties | null> {
  try {
    return await connection.getConnectionProperties(netHandle);
  } catch (_e) {
    return null;
  }
}

async function getNetCapabilitiesSafe(
  netHandle: connection.NetHandle
): Promise<connection.NetCapabilities | null> {
  try {
    return await connection.getNetCapabilities(netHandle);
  } catch (_e) {
    return null;
  }
}

export async function fetchScanList(): Promise<WifiScanItem[]> {
  const items: WifiScanItem[] = [];

  try {
    const isActive = wifiManager.isWifiActive();
    if (!isActive) {
      return items;
    }

    const linkedInfo = await wifiManager.getLinkedInfo();
    const connectedBssid = linkedInfo ? linkedInfo.bssid : '';

    const scanList = wifiManager.getScanInfoList();
    if (!scanList || scanList.length === 0) {
      return items;
    }

    for (let i = 0; i < scanList.length; i++) {
      const scan = scanList[i];
      const item = new WifiScanItem();
      item.ssid = scan.ssid || '<Hidden>';
      item.bssid = scan.bssid || '';
      item.rssi = scan.rssi;
      item.signalLevel = wifiManager.getSignalLevel(scan.rssi, scan.band ?? 1);
      item.signalPercent = rssiToPercent(scan.rssi);
      item.bandLabel = parseBand(scan.band ?? 0);
      item.frequency = scan.frequency ? String(scan.frequency) + ' MHz' : '';
      item.channel = frequencyToChannel(scan.frequency ?? 0);
      item.channelWidth = parseChannelWidth(scan.channelWidth ?? 0);
      item.securityType = parseSecurityType(scan.securityType ?? -1);
      item.capabilities = scan.capabilities || '';
      item.isConnected = scan.bssid === connectedBssid;
      items.push(item);
    }

    items.sort((a: WifiScanItem, b: WifiScanItem) => b.rssi - a.rssi);

  } catch (_e) {
    // Return whatever we've collected
  }

  return items;
}
