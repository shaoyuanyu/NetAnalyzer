import { ConfigurationConstant } from '@kit.AbilityKit';
import { WifiInfoPage } from './Index';
import { WifiScanPage } from './ScanList';
import { SettingsPage } from './Settings';
import { S } from '../utils/I18n';

class TabColors {
  blueAccent: ResourceColor = '#007DFF';
  textSecondary: ResourceColor = '#99000000';
  tabBg: ResourceColor = '#FFFFFF';
}

function buildTabColors(mode: number): TabColors {
  const c = new TabColors();
  if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
    c.blueAccent = '#0A84FF';
    c.textSecondary = '#99E5E5E7';
    c.tabBg = '#2C2C2E';
  }
  return c;
}

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  @State tabColors: TabColors = new TabColors();
  @StorageProp('currentColorMode') @Watch('onColorModeChange')
  currentColorMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @StorageLink('appLanguage') appLanguage: string = 'zh';

  aboutToAppear(): void {
    this.tabColors = buildTabColors(this.currentColorMode);
  }

  onColorModeChange(): void {
    this.tabColors = buildTabColors(this.currentColorMode);
  }

  build() {
    Stack() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          WifiInfoPage()
        }
        .backgroundColor(this.tabColors.tabBg)
        .tabBar(this.tabBuilder(S(this.appLanguage).tab_wifi, $r('sys.symbol.wifi'), 0))

        TabContent() {
          WifiScanPage()
        }
        .backgroundColor(this.tabColors.tabBg)
        .tabBar(this.tabBuilder(S(this.appLanguage).tab_scan, $r('sys.symbol.dot_radiowaves_left_and_right'), 1))

        TabContent() {
          SettingsPage()
        }
        .backgroundColor(this.tabColors.tabBg)
        .tabBar(this.tabBuilder(S(this.appLanguage).tab_settings, $r('sys.symbol.gearshape'), 2))
      }
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .barHeight(56)
      .barMode(BarMode.Fixed)
      .scrollable(false)
      .width('100%')
      .height('100%')

      Text(this.appLanguage)
        .visibility(Visibility.None)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  tabBuilder(title: string, icon: Resource, index: number) {
    Column() {
      SymbolGlyph(icon)
        .fontSize(22)
        .fontColor([this.currentIndex === index ? this.tabColors.blueAccent : this.tabColors.textSecondary])
      Text(title)
        .fontSize(10)
        .fontColor(this.currentIndex === index ? this.tabColors.blueAccent : this.tabColors.textSecondary)
        .margin({ top: 2 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ top: 4 })
  }
}
