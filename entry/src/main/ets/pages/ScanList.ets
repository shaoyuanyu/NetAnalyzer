import { ConfigurationConstant } from '@kit.AbilityKit';
import { WifiScanItem } from '../model/WifiData';
import { fetchScanList } from '../utils/WifiInfoService';
import { S } from '../utils/I18n';

class ScanColors {
  pageBg: ResourceColor = '#F1F3F5';
  cardBg: ResourceColor = '#FFFFFF';
  titleBarBg: ResourceColor = '#F1F3F5';
  textPrimary: ResourceColor = '#000000';
  textSecondary: ResourceColor = '#99000000';
  barEmpty: ResourceColor = '#E0E0E0';
  blueAccent: ResourceColor = '#007DFF';
  refreshBtnBg: ResourceColor = '#F1F3F5';
  connectedBg: ResourceColor = '#E8F5E9';
  signalGreen: ResourceColor = '#4CAF50';
  signalOrange: ResourceColor = '#FF9800';
  signalRed: ResourceColor = '#F44336';
}

function buildScanColors(mode: number): ScanColors {
  const c = new ScanColors();
  if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
    c.pageBg = '#1A1A1C';
    c.cardBg = '#2C2C2E';
    c.titleBarBg = '#1A1A1C';
    c.textPrimary = '#E5E5E7';
    c.textSecondary = '#99E5E5E7';
    c.barEmpty = '#3A3A3C';
    c.blueAccent = '#0A84FF';
    c.refreshBtnBg = '#1A1A1C';
    c.connectedBg = '#1A3D1B';
    c.signalGreen = '#30D158';
    c.signalOrange = '#FF9F0A';
    c.signalRed = '#FF453A';
  }
  return c;
}

function signalColorForItem(item: WifiScanItem, colors: ScanColors): ResourceColor {
  const p = item.signalPercent;
  if (p >= 60) {
    return colors.signalGreen;
  }
  if (p >= 30) {
    return colors.signalOrange;
  }
  return colors.signalRed;
}

@Component
export struct WifiScanPage {
  @State items: WifiScanItem[] = [];
  @State isLoading: boolean = true;
  @State colors: ScanColors = new ScanColors();
  @StorageProp('currentColorMode') @Watch('onColorModeChange')
  currentColorMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @StorageLink('appLanguage') appLanguage: string = 'zh';

  aboutToAppear(): void {
    this.colors = buildScanColors(this.currentColorMode);
    this.loadData();
  }

  onColorModeChange(): void {
    this.colors = buildScanColors(this.currentColorMode);
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    this.items = await fetchScanList();
    this.isLoading = false;
  }

  async onRefresh(): Promise<void> {
    await this.loadData();
  }

  build() {
    Stack() {
      Column() {
        if (this.isLoading) {
          this.loadingView();
        } else if (this.items.length === 0) {
          this.emptyView();
        } else {
          List({ space: 8 }) {
            ForEach(this.items, (item: WifiScanItem, index: number) => {
              ListItem() {
                this.scanItemCard(item);
              }
            }, (item: WifiScanItem) => item.bssid)
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
      Text(S(this.appLanguage).scanning).fontSize(14).fontColor(this.colors.textSecondary).margin({ top: 12 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  emptyView() {
    Column() {
      SymbolGlyph($r('sys.symbol.wifi'))
        .fontSize(64)
        .fontColor([this.colors.textSecondary])
      Text(S(this.appLanguage).no_networks_found)
        .fontSize(16).fontColor(this.colors.textSecondary).margin({ top: 12 })
      Button(S(this.appLanguage).refresh).margin({ top: 16 }).onClick(() => { this.onRefresh(); })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  scanItemCard(item: WifiScanItem) {
    Column() {
      Row() {
        Text(item.ssid)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.colors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)

        if (item.isConnected) {
          Text(S(this.appLanguage).badge_connected)
            .fontSize(10)
            .fontColor('#2E7D32')
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .backgroundColor(this.colors.connectedBg)
            .borderRadius(4)
            .margin({ left: 8 })
        }
      }
      .width('100%')
      .margin({ bottom: 6 })

      Row() {
        Text(S(this.appLanguage).label_bssid).fontSize(12).fontColor(this.colors.textSecondary)
        Blank()
        Text(item.bssid).fontSize(12).fontColor(this.colors.textPrimary).fontFamily('monospace')
      }
      .width('100%').padding({ top: 3, bottom: 3 })

      Row() {
        Text(S(this.appLanguage).label_strength).fontSize(12).fontColor(this.colors.textSecondary)
        Row({ space: 2 }) {
          ForEach([0, 1, 2, 3], (i: number) => {
            Row()
              .width(3)
              .height(5 + i * 3)
              .borderRadius(1.5)
              .backgroundColor(i < item.signalLevel ?
                signalColorForItem(item, this.colors) : this.colors.barEmpty)
          }, (_i: number) => String(_i))
        }
        .margin({ left: 6 })
        Blank()
        Text(`${item.rssi} dBm  ${item.signalPercent}%`)
          .fontSize(12)
          .fontColor(this.colors.textPrimary)
      }
      .width('100%').padding({ top: 3, bottom: 3 })

      Row() {
        Text(S(this.appLanguage).label_band).fontSize(12).fontColor(this.colors.textSecondary)
        Blank()
        Text(`${item.bandLabel}  Ch ${item.channel}  ${item.channelWidth}`)
          .fontSize(12).fontColor(this.colors.textPrimary)
      }
      .width('100%').padding({ top: 3, bottom: 3 })

      Row() {
        Text(S(this.appLanguage).label_security).fontSize(12).fontColor(this.colors.textSecondary)
        Blank()
        Text(item.securityType || item.capabilities || '-')
          .fontSize(12).fontColor(this.colors.textPrimary)
      }
      .width('100%').padding({ top: 3, bottom: 3 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(this.colors.cardBg)
    .borderRadius(10)
    .border({
      width: item.isConnected ? 1.5 : 0,
      color: item.isConnected ? this.colors.blueAccent : Color.Transparent,
      style: BorderStyle.Solid
    })
  }
}
