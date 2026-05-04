import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Configuration } from '@kit.AbilityKit';
import { detectSystemLanguage } from '../utils/I18n';
import { preferences } from '@kit.ArkData';

const DOMAIN = 0x0000;
const PREF_NAME = 'netanalyzer_settings';
const KEY_THEME = 'theme_preference';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.restoreTheme();
    AppStorage.setOrCreate('appLanguage', detectSystemLanguage());
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  restoreTheme(): void {
    let prefMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
    try {
      const pref = preferences.getPreferencesSync(this.context, { name: PREF_NAME });
      prefMode = pref.getSync(KEY_THEME, ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) as number;
    } catch (_e) {
      // use default
    }
    this.applyTheme(prefMode);
  }

  applyTheme(prefMode: number): void {
    this.context.getApplicationContext().setColorMode(prefMode);
    AppStorage.setOrCreate('themePreference', prefMode);
    if (prefMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
      AppStorage.setOrCreate('currentColorMode', this.context.config.colorMode);
    } else {
      AppStorage.setOrCreate('currentColorMode', prefMode);
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    const pref = AppStorage.get('themePreference') as number;
    if (pref === undefined || pref === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
      AppStorage.set('currentColorMode', newConfig.colorMode);
    }
    hilog.info(DOMAIN, 'testTag', 'Color mode updated: %{public}d', newConfig.colorMode);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/MainPage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}

export function saveThemePreference(context: Context, mode: number): void {
  try {
    const pref = preferences.getPreferencesSync(context, { name: PREF_NAME });
    pref.putSync(KEY_THEME, mode);
    pref.flushSync();
  } catch (_e) {
    // ignore
  }
}
