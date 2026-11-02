namespace FCT.Operations.Cda.Tests
{
    using System.Configuration;
    using SFA.FCS.Worker.Common;

    public class LocalConfig : IFcsConfiguration
    {
        public string this[string key]
        {
            get
            {
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
