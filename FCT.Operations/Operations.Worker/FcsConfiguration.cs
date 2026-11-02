namespace Operations.Worker
{
    using Microsoft.Extensions.Configuration;
    using SFA.FCS.Worker.Common;

    public class FcsConfiguration : IFcsConfiguration
    {
        private readonly IConfigurationRoot _configuration;

        public FcsConfiguration(IConfigurationRoot configuration)
        {
            _configuration = configuration;
        }

        public string this[string key] => _configuration[key];

        public IConfigurationRoot ConfigurationRoot => _configuration;
    }
}
