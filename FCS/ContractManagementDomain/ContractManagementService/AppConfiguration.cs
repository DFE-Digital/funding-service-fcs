namespace ContractManagementService
{
    using Microsoft.Extensions.Configuration;
    using SFA.FCS.Worker.Common;

    public class AppConfiguration : IFcsConfiguration
    {
        private static IConfiguration _configuration;

        public AppConfiguration(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // todo: may change this
        public static IConfiguration Configuration() => _configuration;

        public string this[string key] => _configuration[key];
    }
}
