namespace XrmMigrator.Common
{
    using System;
    using System.Configuration;
    using System.Linq;

    public static class SettingsHelper
    {
        public enum Setting
        {
            OrgServiceUrl
        }

        public static string GetSettingvalue(Setting setting)
        {
            string settingsVal = null;
            var appSettings = ConfigurationManager.AppSettings;
            if (appSettings.AllKeys.Contains(setting.ToString()))
            {
                settingsVal = appSettings[setting.ToString()];
            }
            else
            {
                throw new Exception(string.Format("The appSettings config does not contain {0}", setting.ToString()));
            }

            return settingsVal;
        }
    }
}
