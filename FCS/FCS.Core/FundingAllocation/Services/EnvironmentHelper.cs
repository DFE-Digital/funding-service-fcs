namespace FundingAllocation.Services
{
    using Extensions;
    using Microsoft.Extensions.Configuration;

    public static class EnvironmentHelper
    {
        public static string GetEnvironmentSuffix(IConfigurationRoot appConfiguration)
        {
            string environmentName = appConfiguration["StorageTableSuffix"];

            return environmentName.IsEmpty() ? "Live" : environmentName;
        }
    }
}
