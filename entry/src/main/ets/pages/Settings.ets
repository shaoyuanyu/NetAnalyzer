import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { bundleManager } from '@kit.AbilityKit';
import { S, LANG_EN, LANG_ZH, languageDisplayName } from '../utils/I18n';
import { saveThemePreference } from '../entryability/EntryAbility';

const MODE_FOLLOW = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
const MODE_LIGHT = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
const MODE_DARK = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;

class SettingsColors {
  pageBg: ResourceColor = '#F1F3F5';
  cardBg: ResourceColor = '#FFFFFF';
  textPrimary: ResourceColor = '#000000';
  textSecondary: ResourceColor = '#99000000';
  blueAccent: ResourceColor = '#007DFF';
  dividerColor: ResourceColor = '#E0E0E0';
}

function buildSettingsColors(mode: number): SettingsColors {
  const c = new SettingsColors();
  if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
    c.pageBg = '#1A1A1C';
    c.cardBg = '#2C2C2E';
    c.textPrimary = '#E5E5E7';
    c.textSecondary = '#99E5E5E7';
    c.blueAccent = '#0A84FF';
    c.dividerColor = '#3A3A3C';
  }
  return c;
}

@Component
export struct SettingsPage {
  @State colors: SettingsColors = new SettingsColors();
  @State appVersion: string = '';
  @State appName: string = '';
  @State showLangPicker: boolean = false;
  @State showThemePicker: boolean = false;
  @StorageProp('currentColorMode') @Watch('onColorModeChange')
  currentColorMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @StorageLink('themePreference') themePreference: number = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @StorageLink('appLanguage') appLanguage: string = 'zh';

  aboutToAppear(): void {
    this.colors = buildSettingsColors(this.currentColorMode);
    this.loadAppInfo();
  }

  onColorModeChange(): void {
    this.colors = buildSettingsColors(this.currentColorMode);
  }

  async loadAppInfo(): Promise<void> {
    try {
      const info = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
      this.appName = info.name || 'NetAnalyzer';
      this.appVersion = `${info.versionName || '1.0.0'} (${info.versionCode || 1})`;
    } catch (_e) {
      this.appName = 'NetAnalyzer';
      this.appVersion = '1.0.0';
    }
  }

  switchLanguage(lang: string): void {
    this.appLanguage = lang;
    this.showLangPicker = false;
  }

  switchTheme(mode: number): void {
    const ctx = getContext(this) as common.UIAbilityContext;
    ctx.getApplicationContext().setColorMode(mode);
    AppStorage.set('themePreference', mode);
    saveThemePreference(ctx, mode);
    if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
      AppStorage.set('currentColorMode', ctx.config.colorMode);
    } else {
      AppStorage.set('currentColorMode', mode);
    }
    this.showThemePicker = false;
  }

  themeDisplayName(): string {
    if (this.themePreference === MODE_LIGHT) {
      return S(this.appLanguage).theme_light;
    }
    if (this.themePreference === MODE_DARK) {
      return S(this.appLanguage).theme_dark;
    }
    return S(this.appLanguage).theme_follow_system;
  }

  build() {
    Stack() {
      Column() {
        Scroll() {
          Column() {
            this.appearanceCard();
            this.languageCard();
            this.aboutCard();
          }
          .width('100%')
        }
        .layoutWeight(1)
        .padding({ left: 20, right: 20, top: 4, bottom: 16 })
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .align(Alignment.Top)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.colors.pageBg)

      Text(this.appLanguage)
        .visibility(Visibility.None)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  appearanceCard() {
    Column() {
      this.cardHeader(S(this.appLanguage).card_appearance, $r('sys.symbol.paintbrush'))
      Row() {
        Text(S(this.appLanguage).label_theme)
          .fontSize(14)
          .fontColor(this.colors.textSecondary)
        Blank()
        Text(this.themeDisplayName())
          .fontSize(14)
          .fontColor(this.colors.textPrimary)
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(16)
          .fontColor([this.colors.textSecondary])
          .margin({ left: 4 })
      }
      .width('100%')
      .padding({ top: 4, bottom: 4 })
      .onClick(() => {
        this.showThemePicker = !this.showThemePicker;
      })

      if (this.showThemePicker) {
        Divider()
          .color(this.colors.dividerColor)
          .margin({ top: 8, bottom: 4 })

        Row() {
          Text(S(this.appLanguage).theme_follow_system)
            .fontSize(14)
            .fontColor(this.themePreference === MODE_FOLLOW ? this.colors.blueAccent : this.colors.textPrimary)
          Blank()
          if (this.themePreference === MODE_FOLLOW) {
            SymbolGlyph($r('sys.symbol.checkmark'))
              .fontSize(16)
              .fontColor([this.colors.blueAccent])
          }
        }
        .width('100%')
        .padding({ top: 8, bottom: 6 })
        .onClick(() => { this.switchTheme(MODE_FOLLOW); })

        Row() {
          Text(S(this.appLanguage).theme_light)
            .fontSize(14)
            .fontColor(this.themePreference === MODE_LIGHT ? this.colors.blueAccent : this.colors.textPrimary)
          Blank()
          if (this.themePreference === MODE_LIGHT) {
            SymbolGlyph($r('sys.symbol.checkmark'))
              .fontSize(16)
              .fontColor([this.colors.blueAccent])
          }
        }
        .width('100%')
        .padding({ top: 6, bottom: 6 })
        .onClick(() => { this.switchTheme(MODE_LIGHT); })

        Row() {
          Text(S(this.appLanguage).theme_dark)
            .fontSize(14)
            .fontColor(this.themePreference === MODE_DARK ? this.colors.blueAccent : this.colors.textPrimary)
          Blank()
          if (this.themePreference === MODE_DARK) {
            SymbolGlyph($r('sys.symbol.checkmark'))
              .fontSize(16)
              .fontColor([this.colors.blueAccent])
          }
        }
        .width('100%')
        .padding({ top: 6, bottom: 4 })
        .onClick(() => { this.switchTheme(MODE_DARK); })
      }
    }
    .width('100%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(10)
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .margin({ top: 8 })
  }

  @Builder
  languageCard() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.globe_badge_message'))
          .fontSize(20)
          .fontColor([this.colors.blueAccent])
        Text(S(this.appLanguage).label_language)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.colors.textPrimary)
          .margin({ left: 8 })
      }
      .width('100%')
      .margin({ bottom: 8 })

      Row() {
        Text(languageDisplayName(this.appLanguage, this.appLanguage))
          .fontSize(14)
          .fontColor(this.colors.textSecondary)
        Blank()
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(16)
          .fontColor([this.colors.textSecondary])
      }
      .width('100%')
      .padding({ top: 4, bottom: 4 })
      .onClick(() => {
        this.showLangPicker = !this.showLangPicker;
      })

      if (this.showLangPicker) {
        Divider()
          .color(this.colors.dividerColor)
          .margin({ top: 8, bottom: 4 })

        Row() {
          Text(S(this.appLanguage).lang_chinese)
            .fontSize(14)
            .fontColor(this.appLanguage === LANG_ZH ? this.colors.blueAccent : this.colors.textPrimary)
          Blank()
          if (this.appLanguage === LANG_ZH) {
            SymbolGlyph($r('sys.symbol.checkmark'))
              .fontSize(16)
              .fontColor([this.colors.blueAccent])
          }
        }
        .width('100%')
        .padding({ top: 8, bottom: 6 })
        .onClick(() => { this.switchLanguage(LANG_ZH); })

        Row() {
          Text(S(this.appLanguage).lang_english)
            .fontSize(14)
            .fontColor(this.appLanguage === LANG_EN ? this.colors.blueAccent : this.colors.textPrimary)
          Blank()
          if (this.appLanguage === LANG_EN) {
            SymbolGlyph($r('sys.symbol.checkmark'))
              .fontSize(16)
              .fontColor([this.colors.blueAccent])
          }
        }
        .width('100%')
        .padding({ top: 6, bottom: 4 })
        .onClick(() => { this.switchLanguage(LANG_EN); })
      }
    }
    .width('100%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(10)
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .margin({ top: 8 })
  }

  @Builder
  aboutCard() {
    Column() {
      this.cardHeader(S(this.appLanguage).card_about, $r('sys.symbol.info_circle'))
      Row() {
        Text(S(this.appLanguage).label_application)
          .fontSize(14)
          .fontColor(this.colors.textSecondary)
        Blank()
        Text(this.appName)
          .fontSize(14)
          .fontColor(this.colors.textPrimary)
      }
      .width('100%')
      .padding({ top: 8, bottom: 4 })
      Row() {
        Text(S(this.appLanguage).label_version)
          .fontSize(14)
          .fontColor(this.colors.textSecondary)
        Blank()
        Text(this.appVersion)
          .fontSize(14)
          .fontColor(this.colors.textPrimary)
      }
      .width('100%')
      .padding({ top: 4, bottom: 4 })
      Row() {
        Text(S(this.appLanguage).label_sdk)
          .fontSize(14)
          .fontColor(this.colors.textSecondary)
        Blank()
        Text(S(this.appLanguage).sdk_name)
          .fontSize(14)
          .fontColor(this.colors.textPrimary)
      }
      .width('100%')
      .padding({ top: 4, bottom: 4 })
    }
    .width('100%')
    .backgroundColor(this.colors.cardBg)
    .borderRadius(10)
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
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
}
