namespace FCT.Console.Config.Tests.CommonSecreteUtility
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Configuration;
    using Azure.Identity;
    using Azure.Security.KeyVault.Secrets;
    using System.Collections.Specialized;
    public class KeyVaultTestConfiguration
    {
        private readonly Dictionary<string, string> _values =
                    new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        public KeyVaultTestConfiguration()
        {
            LoadAppConfigValues();
            LoadSelectedKeyVaultValues();
            LoadEnvironmentVariables();
        }

        private void LoadAppConfigValues()
        {
            foreach (string key in ConfigurationManager.AppSettings)
                _values[key] = ConfigurationManager.AppSettings[key];

            foreach (ConnectionStringSettings cs in ConfigurationManager.ConnectionStrings)
                _values[$"ConnectionStrings:{cs.Name}"] = cs.ConnectionString;
        }

        private void LoadSelectedKeyVaultValues()
        {
               var useKeyVault =
                    bool.TryParse(ConfigurationManager.AppSettings["UseKeyVault"], out var enabled)
                    && enabled;

            if (!useKeyVault)
            {
                // ✅ Local execution → do NOT touch Key Vault
                return;
            }
            string kvUri = ConfigurationManager.AppSettings["KeyVault:Uri"];

            var client = new SecretClient(new Uri(kvUri), new DefaultAzureCredential());

            foreach (var map in SecretMappings)
            {
                string keyVaultName = map.Key;
                string configKey = map.Value;

                try
                {
                    var secret = client.GetSecret(keyVaultName).Value.Value;                  
                    _values[configKey] = secret;
                    ForceAppSettingsValue(configKey, secret);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Warning: KeyVault secret '{keyVaultName}' not found. Reason: {ex.Message}");
                }
            }
        }


        private static void ForceAppSettingsValue(string key, string value)
        {
            var appSettings = ConfigurationManager.AppSettings as NameValueCollection;
            
            typeof(NameValueCollection)
                .GetMethod("BaseAdd", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance)
                .Invoke(appSettings, new object[] { key, value });

            appSettings[key] = value;
        }
        private void LoadEnvironmentVariables()
        {
            foreach (DictionaryEntry e in Environment.GetEnvironmentVariables())
                _values[e.Key.ToString()] = e.Value.ToString();
        }
        public string this[string key]
        {
            get
            {
                _values.TryGetValue(key, out var value);
                return value;
            }
        }

        private static readonly Dictionary<string, string> SecretMappings =
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
        { "SharepointOauthClientSecret", "Sharepoint:Oauth:ClientSecret" },
        { "fcsPaaSDBConnectionstring", "ConnectionStrings:CommonDBContext" },
         { "StorageConnectionString", "StorageConnectionString" }
            };

    }
}
