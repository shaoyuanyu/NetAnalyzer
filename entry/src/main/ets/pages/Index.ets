import { ConfigurationConstant } from '@kit.AbilityKit';
import { WifiFullInfo } from '../model/WifiData';
import { fetchFullWifiInfo } from '../utils/WifiInfoService';
import { S } from '../utils/I18n';

class AppColors {
  pageBg: ResourceColor = '#F1F3F5';
  cardBg: ResourceColor = '#FFFFFF';
  titleBarBg: ResourceColor = '#F1F3F5';
  textPrimary: ResourceColor = '#000000';
  textSecondary: ResourceColor = '#99000000';
  barEmpty: ResourceColor = '#E0E0E0';
  blueAccent: ResourceColor = '#007DFF';
  refreshBtnBg: ResourceColor = '#F1F3F5';
  signalGreen: ResourceColor = '#4CAF50';
  signalOrange: ResourceColor = '#FF9800';
  signalRed: ResourceColor = '#F44336';
}

function buildColors(mode: number): AppColors {
  const c = new AppColors();
  const isDark = mode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  if (isDark) {
    c.pageBg = '#1A1A1C';
    c.cardBg = '#2C2C2E';
    c.titleBarBg = '#1A1A1C';
    c.textPrimary = '#E5E5E7';
    c.textSecondary = '#99E5E5E7';
    c.barEmpty = '#3A3A3C';
    c.blueAccent = '#0A84FF';
    c.refreshBtnBg = '#1A1A1C';
    c.signalGreen = '#30D158';
    c.signalOrange = '#FF9F0A';
    c.signalRed = '#FF453A';
  }
  return c;
}

@Component
export struct WifiInfoPage {
  @State wifiData: WifiFullInfo = new WifiFullInfo();
  @State isLoading: boolean = true;
  @State isRefreshing: boolean = false;
  @State colors: AppColors = new AppColors();
  @StorageProp('currentColorMode') @Watch('onColorModeChange')
  currentColorMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @StorageLink('appLanguage') appLanguage: string = 'zh';

  aboutToAppear(): void {
    this.colors = buildColors(this.currentColorMode);
    this.loadData();
  }

  onColorModeChange(): void {
    this.colors = buildColors(this.currentColorMode);
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    const data = await fetchFullWifiInfo();
    this.wifiData = data;
    this.isLoading = false;
    this.isRefreshing = false;
  }

  async onRefresh(): Promise<void> {
    this.isRefreshing = true;
    const data = await fetchFullWifiInfo();
    this.wifiData = data;
    this.isRefreshing = false;
  }

  build() {
    Stack() {
      Column() {
        if (this.isLoading) {
          this.loadingView();
        } else if (this.wifiData.errorMsg !== '' && !this.wifiData.isConnected) {
          this.errorView();
        } else {
          Scroll() {
            Column() {
              this.connectionCard();
              this.apCard();
              this.signalCard();
              this.speedCard();
              this.networkCard();
            }.width('100%')
          }
          .layoutWeight(1)
          .padding({ left: 20, right: 20, top: 4, bottom: 16 })
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.colors.pageBg)

      Text(this.appLanguage)
        .visibility(Visibility.None)

      Button() {
        SymbolGlyph($r('sys.symbol.arrow_clockwise'))
          .fontSize(22)
          .fontColor([Color.White])
      }
      .type(ButtonType.Circle)
      .width(52)
      .height(52)
      .backgroundColor(this.colors.blueAccent)
      .shadow({ radius: 12, color: '#33000000', offsetY: 4 })
      .position({ x: '85%', y: '88%' })
      .onClick(() => { this.onRefresh(); })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  loadingView() {
    Column() {
      LoadingProgress().width(48).height(48).color(this.colors.blueAccent)
      Text(S(this.appLanguage).loading_wifi_info)
        .fontSize(14)
        .fontColor(this.colors.textSecondary)
        .margin({ top: 12 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  errorView() {
    Column() {
      SymbolGlyph($r('sys.symbol.wifi'))
        .fontSize(64)
        .fontColor([this.colors.textSecondary])
      Text(this.wifiData.errorMsg)
        .fontSize(16)
        .fontColor(this.colors.textSecondary)
        .margin({ top: 12 })
      Button(S(this.appLanguage).retry)
        .margin({ top: 16 })
        .onClick(() => { this.onRefresh(); })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  connectionCard() {
    Column() {
      this.cardHeader(S(this.appLanguage).card_connection_info, $r('sys.symbol.wifi'))
      this.infoRow(S(this.appLanguage).label_ssid, this.wifiData.ssid || '-')
      this.infoRow(S(this.appLanguage).label_bssid, this.wifiData.bssid || '-')
      this.infoRow(S(this.appLanguage).label_status, this.wifiData.connState || '-')
      this.infoRow(S(this.appLanguage).label_hidden_ssid,
        this.wifiData.isHiddenSsid ? S(this.appLanguage).yes : S(this.appLanguage).no)
      this.infoRow(S(this.appLanguage).label_restricted,
        this.wifiData.isRestricted ? S(this.appLanguage).yes : S(this.appLanguage).no)
    }
    .width('100%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(10)
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .margin({ top: 8 })
  }

  @Builder
  apCard() {
    Column() {
      this.cardHeader(S(this.appLanguage).card_access_point, $r('sys.symbol.doc'))
      this.infoRow(S(this.appLanguage).label_band, this.wifiData.bandLabel || '-')
      this.infoRow(S(this.appLanguage).label_frequency, this.wifiData.frequency || '-')
      this.infoRow(S(this.appLanguage).label_channel, this.wifiData.channel || '-')
      this.infoRow(S(this.appLanguage).label_channel_width, this.wifiData.channelWidth || '-')
      this.infoRow(S(this.appLanguage).label_security, this.wifiData.securityType || '-')
      this.infoRow(S(this.appLanguage).label_capabilities, this.wifiData.capabilities || '-')
    }
    .width('100%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(10)
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .margin({ top: 8 })
  }

  @Builder
  signalCard() {
    Column() {
      this.cardHeader(S(this.appLanguage).card_signal, $r('sys.symbol.star'))
      this.infoRow(S(this.appLanguage).label_rssi,
        this.wifiData.rssi ? String(this.wifiData.rssi) + ' dBm' : '-')
      Row() {
        Text(S(this.appLanguage).label_strength)
          .fontSize(14).fontColor(this.colors.textSecondary)
        Blank()
        Row({ space: 2 }) {
          ForEach([0, 1, 2, 3], (i: number) => {
            Row()
              .width(3)
              .height(6 + i * 4)
              .borderRadius(1.5)
              .backgroundColor(i < (this.wifiData.signalLevel ?? 0) ?
                this.signalColor() : this.colors.barEmpty)
          }, (_i: number) => String(_i))
        }
        .margin({ left: 8 })
        Text((this.wifiData.signalPercent ?? 0) + '%')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.signalColor())
          .margin({ left: 8 })
      }
      .width('100%')
      .padding({ top: 6, bottom: 6 })
    }
    .width('100%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(10)
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .margin({ top: 8 })
  }

  @Builder
  speedCard() {
    Column() {
      this.cardHeader(S(this.appLanguage).card_speed, $r('sys.symbol.chevron_right'))
      this.infoRow(S(this.appLanguage).label_link_speed, this.wifiData.linkSpeed || '-')
      this.infoRow(S(this.appLanguage).label_uplink, this.wifiData.uplinkBw || '-')
      this.infoRow(S(this.appLanguage).label_downlink, this.wifiData.downlinkBw || '-')
    }
    .width('100%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(10)
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .margin({ top: 8 })
  }

  @Builder
  networkCard() {
    Column() {
      this.cardHeader(S(this.appLanguage).card_network_address, $r('sys.symbol.person'))
      this.infoRow(S(this.appLanguage).label_device_mac, this.wifiData.deviceMac || '-')
      this.infoRow(S(this.appLanguage).label_ip_address, this.wifiData.ipAddress || '-')
      this.infoRow(S(this.appLanguage).label_subnet_mask, this.wifiData.subnetMask || '-')
      this.infoRow(S(this.appLanguage).label_gateway, this.wifiData.gateway || '-')
      this.infoRow(S(this.appLanguage).label_dns, this.wifiData.dns1 || '-')
      if (this.wifiData.dns2) {
        this.infoRow(S(this.appLanguage).label_dns_alt, this.wifiData.dns2)
      }
      this.infoRow(S(this.appLanguage).label_interface, this.wifiData.interfaceName || '-')
      this.infoRow(S(this.appLanguage).label_mtu, this.wifiData.mtu ? String(this.wifiData.mtu) : '-')
    }
    .width('100%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(12)
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .margin({ top: 8 })
  }

  @Builder
  cardHeader(title: string, icon: Resource) {
    Row() {
      SymbolGlyph(icon)
        .fontSize(20)
        .fontColor([this.colors.blueAccent])
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.colors.textPrimary)
        .margin({ left: 8 })
    }
    .width('100%')
    .margin({ bottom: 4 })
  }

  @Builder
  infoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor(this.colors.textSecondary)
      Blank()
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.colors.textPrimary)
        .textAlign(TextAlign.End)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .constraintSize({ maxWidth: '60%' })
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
  }

  signalColor(): ResourceColor {
    const p = this.wifiData.signalPercent ?? 0;
    if (p >= 60) {
      return this.colors.signalGreen;
    }
    if (p >= 30) {
      return this.colors.signalOrange;
    }
    return this.colors.signalRed;
  }
}
