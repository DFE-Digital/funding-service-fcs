namespace PaymentGenerationDomain.Integration.DataStore.Tests
{
    using System;
    using SFA.FCS.Worker.Common;
    using System.Configuration;

    public class LocalConfig : IFcsConfiguration
    {
        public string this[string key]
        {
            get
            {
                if (key.Contains(":"))
                {
                    key = key.Substring(key.IndexOf(":", StringComparison.Ordinal) + 1);
                }
                var configConnectionString = ConfigurationManager.ConnectionStrings[key];
                if (configConnectionString != null)
                {
                    return configConnectionString.ConnectionString;
                }

                return ConfigurationManager.AppSettings[key];
            }
        }
    }
}
