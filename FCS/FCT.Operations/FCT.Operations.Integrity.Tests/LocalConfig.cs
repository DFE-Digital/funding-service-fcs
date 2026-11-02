namespace FCT.Operations.Integrity.Tests
{
    using System.Configuration;
    using SFA.FCS.Worker.Common;

    public class LocalConfig : IFcsConfiguration
    {
        public string this[string key]
        {
            get
            {
                if (key.StartsWith("ConnectionStrings:"))
                {
                    key = key.Replace("ConnectionStrings:", string.Empty);
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
