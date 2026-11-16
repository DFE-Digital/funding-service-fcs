namespace SFA.FCT.Contracts.AcceptanceTests
{
    using Azure.Identity;
    using Azure.Security.KeyVault.Secrets;
    using Microsoft.Extensions.Configuration;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Collections.Specialized;

    public class KeyVaultTestConfiguration
    {
        private readonly Dictionary<string, string> _values =
                    new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        public IConfiguration configuration = TestConfiguration.Configuration;

        public KeyVaultTestConfiguration()
        {

            LoadAppConfigValues();
            LoadSelectedKeyVaultValues();
            LoadEnvironmentVariables();
        }

        //private void LoadAppConfigValues()
        //{
        //    foreach (string key in ConfigurationManager.AppSettings)
        //        _values[key] =TestConfiguration.Configuration[key];

        //    foreach (ConnectionStringSettings cs in ConfigurationManager.ConnectionStrings)
        //        _values[$"ConnectionStrings:{cs.Name}"] = cs.ConnectionString;
        //}

        private void LoadAppConfigValues()
        {           

            foreach (var item in configuration.AsEnumerable())
            {
                if (!string.IsNullOrEmpty(item.Value))
                {
                    _values[item.Key] = item.Value;
                }
            }

            var connectionStrings = configuration.GetSection("ConnectionStrings");

            foreach (var connection in connectionStrings.GetChildren())
            {
                _values[$"ConnectionStrings:{connection.Key}"] = connection.Value;
            }
        }

        private void LoadSelectedKeyVaultValues()
        {

            var useKeyVault =
                   bool.TryParse(TestConfiguration.Configuration["UseKeyVault"], out var enabled)
                   && enabled;

            if (!useKeyVault)
            {
                // ✅ Local execution → do NOT touch Key Vault
                return;
            }


            try
            {
                string kvUri = TestConfiguration.Configuration["KeyVault:Uri"];

                if (string.IsNullOrWhiteSpace(kvUri))
                    return;

                // var client = new SecretClient(new Uri(kvUri), new AzureCliCredential());
                var client = new SecretClient(new Uri(kvUri),new DefaultAzureCredential());


                foreach (var map in SecretMappings)
                {
                    try
                    {
                        var secret = client.GetSecret(map.Key).Value.Value;


                        foreach (var configKey in map.Value)
                        {
                            _values[configKey] = secret;

                            if (configKey.StartsWith("ConnectionStrings:", StringComparison.OrdinalIgnoreCase))
                            {
                                var name = configKey.Split(':')[1];
                                ForceConnectionStringValue(name, secret);
                            }
                            else
                            {
                                ForceAppSettingsValue(configKey, secret);
                            }
                        }

                    }
                    catch (Exception ex)
                    {
                        // ✅ DO NOT FAIL TESTS
                        Console.WriteLine($"KeyVault secret load failed: {map.Key} - {ex.Message}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"KeyVault initialization failed: {ex.Message}");
            }
        }


        //private static void ForceAppSettingsValue(string key, string value)
        //{
        //    var appSettings = TestConfiguration.Configuration as NameValueCollection;

        //    typeof(NameValueCollection)
        //        .GetMethod("BaseAdd", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance)
        //        .Invoke(appSettings, new object[] { key, value });

        //    appSettings[key] = value;
        //}
        private static void ForceAppSettingsValue(string key, string value)
        {
            TestConfiguration.ForceAppSettingValue(key, value);
        }

        //private static void ForceConnectionStringValue(string name, string value)
        //{
        //    var settings = ConfigurationManager.ConnectionStrings;

        //    var field = typeof(ConfigurationElementCollection)
        //        .GetField("bReadOnly", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);

        //    field.SetValue(settings, false);

        //    var existing = settings[name];
        //    if (existing != null)
        //    {
        //        settings.Remove(name);
        //    }

        //    settings.Add(new ConnectionStringSettings(name, value));

        //    field.SetValue(settings, true);
        //}

        private static void ForceConnectionStringValue(string name, string value)
        {
            TestConfiguration.ForceConnectionStringValue(name, value);
        }
        private void LoadEnvironmentVariables()
        {
            //foreach (DictionaryEntry e in Environment.GetEnvironmentVariables())
            //    _values[e.Key.ToString()] = e.Value.ToString();

            foreach (var map in SecretMappings)
            {
                var envValue = Environment.GetEnvironmentVariable(map.Key);

                if (string.IsNullOrWhiteSpace(envValue))
                    continue;

                foreach (var configKey in map.Value)
                {
                    _values[configKey] = envValue;
                    ForceAppSettingsValue(configKey, envValue);
                }
            }

        }
        public string this[string key]
        {
            get
            {
                _values.TryGetValue(key, out var value);
                return value;
            }
        }

        private static readonly Dictionary<string, List<string>> SecretMappings =
            new Dictionary<string, List<string>>(StringComparer.OrdinalIgnoreCase)
            {
                { "SharepointOauthClientSecret",  new List<string>{"Sharepoint:Oauth:ClientSecret" } },
                { "fcsPaaSDBConnectionstring", new List<string>{"ConnectionStrings:CommonDBContext" , "organisationDomainDatabase", "ConnectionStrings:PerformanceManagementDbContext" } },
                { "CRMAppKey", new List<string>{"ida:AppKey_CrmOnline", "CrmOnline:AppKey" } },
                { "AzureServiceBus", new List < string > { "AzureServiceBus" } },
                { "StorageConnectionString", new List < string > { "AzureStorage:ConnectionString", "ConnectionStrings:StorageConnectionString" } },
                { "AzureWebJobsDashboard", new List < string > { "AzureWebJobsDashboard" } },
                { "clientSecret", new List < string > { "clientSecret" } },
                { "NServiceBusTransport", new List < string > { "NServiceBus/Transport", "Microsoft.ServiceBus.ConnectionString", "ConnectionStrings:NServiceBusTransport" } },
                { "CrmReplicaDb", new List < string > { "CrmReplicaDbContext", "CrmGwtReplicaDbContext" } },
                { "CrmConnectionString", new List < string > { "CrmConnectionString" , "CrmConnectionString_CRMIntegration" } },
                { "idaAppKeyFundingStreamConfig",  new List<string>{ "ida:AppKey_FundingStreamConfig", "FundingStreamConfig:AppKey" } },
                { "idaAppKeyContractPublish",  new List<string>{ "ida:AppKey_ContractPublish", "ContractPublish:AppKey" } },
                { "idaAppKeyOPSWEB", new List < string > { "ida:AppKey_OPS_WEB", "OpsWeb:AppKey" } }
            };
    }
}
