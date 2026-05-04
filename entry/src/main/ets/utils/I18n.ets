export const LANG_EN = 'en';
export const LANG_ZH = 'zh';

class STR {
  // Tab bar
  tab_wifi: string = 'WiFi';
  tab_scan: string = 'Scan';
  tab_settings: string = 'Settings';
  // Index - WifiInfoPage
  title_netanalyzer: string = 'NetAnalyzer';
  loading_wifi_info: string = 'Loading WiFi info...';
  retry: string = 'Retry';
  card_connection_info: string = 'Connection Info';
  label_ssid: string = 'SSID';
  label_bssid: string = 'BSSID';
  label_status: string = 'Status';
  label_hidden_ssid: string = 'Hidden SSID';
  label_restricted: string = 'Restricted';
  yes: string = 'Yes';
  no: string = 'No';
  card_access_point: string = 'Access Point';
  label_band: string = 'Band';
  label_frequency: string = 'Frequency';
  label_channel: string = 'Channel';
  label_channel_width: string = 'Channel Width';
  label_security: string = 'Security';
  label_capabilities: string = 'Capabilities';
  card_signal: string = 'Signal';
  label_rssi: string = 'RSSI';
  label_level: string = 'Level';
  label_strength: string = 'Strength';
  card_speed: string = 'Speed';
  label_link_speed: string = 'Link Speed';
  label_uplink: string = 'Uplink';
  label_downlink: string = 'Downlink';
  card_network_address: string = 'Network Address';
  label_device_mac: string = 'Device MAC';
  label_ip_address: string = 'IP Address';
  label_subnet_mask: string = 'Subnet Mask';
  label_gateway: string = 'Gateway';
  label_dns: string = 'DNS';
  label_dns_alt: string = 'DNS Alt';
  label_interface: string = 'Interface';
  label_mtu: string = 'MTU';
  // ScanList - WifiScanPage
  title_wifi_scan: string = 'Wi-Fi Scan';
  scanning: string = 'Scanning...';
  no_networks_found: string = 'No networks found';
  refresh: string = 'Refresh';
  badge_connected: string = 'Connected';
  networks_suffix: string = ' networks';
  // Settings
  title_settings: string = 'Settings';
  card_appearance: string = 'Appearance';
  label_theme: string = 'Theme';
  theme_follow_system: string = 'Follow System';
  theme_light: string = 'Light';
  theme_dark: string = 'Dark';
  label_language: string = 'Language';
  lang_english: string = 'English';
  lang_chinese: string = '中文';
  card_about: string = 'About';
  label_application: string = 'Application';
  label_version: string = 'Version';
  label_sdk: string = 'SDK';
  sdk_name: string = 'HarmonyOS NEXT';
}

const EN = new STR();

const ZH = new STR();
ZH.tab_wifi = 'WiFi';
ZH.tab_scan = '扫描';
ZH.tab_settings = '设置';
ZH.title_netanalyzer = 'NetAnalyzer';
ZH.loading_wifi_info = '正在加载 WiFi 信息...';
ZH.retry = '重试';
ZH.card_connection_info = '连接信息';
ZH.label_ssid = 'SSID';
ZH.label_bssid = 'BSSID';
ZH.label_status = '状态';
ZH.label_hidden_ssid = '隐藏 SSID';
ZH.label_restricted = '受限';
ZH.yes = '是';
ZH.no = '否';
ZH.card_access_point = '接入点';
ZH.label_band = '频段';
ZH.label_frequency = '频率';
ZH.label_channel = '信道';
ZH.label_channel_width = '信道宽度';
ZH.label_security = '安全类型';
ZH.label_capabilities = '能力';
ZH.card_signal = '信号';
ZH.label_rssi = 'RSSI';
ZH.label_level = '等级';
ZH.label_strength = '强度';
ZH.card_speed = '速度';
ZH.label_link_speed = '连接速率';
ZH.label_uplink = '上行';
ZH.label_downlink = '下行';
ZH.card_network_address = '网络地址';
ZH.label_device_mac = '设备 MAC';
ZH.label_ip_address = 'IP 地址';
ZH.label_subnet_mask = '子网掩码';
ZH.label_gateway = '网关';
ZH.label_dns = 'DNS';
ZH.label_dns_alt = 'DNS 备用';
ZH.label_interface = '接口';
ZH.label_mtu = 'MTU';
ZH.title_wifi_scan = 'Wi-Fi 扫描';
ZH.scanning = '正在扫描...';
ZH.no_networks_found = '未发现网络';
ZH.refresh = '刷新';
ZH.badge_connected = '已连接';
ZH.networks_suffix = ' 个网络';
ZH.title_settings = '设置';
ZH.card_appearance = '外观';
ZH.label_theme = '主题';
ZH.theme_follow_system = '跟随系统';
ZH.theme_light = '浅色';
ZH.theme_dark = '深色';
ZH.label_language = '语言';
ZH.lang_english = 'English';
ZH.lang_chinese = '中文';
ZH.card_about = '关于';
ZH.label_application = '应用';
ZH.label_version = '版本';
ZH.label_sdk = 'SDK';
ZH.sdk_name = 'HarmonyOS NEXT';

export function S(lang: string): STR {
  if (lang === LANG_ZH) {
    return ZH;
  }
  return EN;
}

export function detectSystemLanguage(): string {
  return LANG_ZH;
}

export function languageDisplayName(lang: string, currentLang: string): string {
  if (lang === LANG_ZH) {
    return S(currentLang).lang_chinese;
  }
  return S(currentLang).lang_english;
}
