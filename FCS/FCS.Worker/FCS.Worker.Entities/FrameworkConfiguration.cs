namespace SFA.FCS.Worker.Common
{
    using System.Configuration;

    public class FrameworkConfiguration : IFcsConfiguration
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
