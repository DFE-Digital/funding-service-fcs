namespace FundingAllocation
{
    using Microsoft.Extensions.Configuration;
    using SFA.FCT.Framework.Logging.Bespoke;

    public class NetCoreCloudEnvironment : ICloudEnvironment
    {
        private readonly IConfigurationRoot _configuration;
        private readonly string _roleId;

        public NetCoreCloudEnvironment(IConfigurationRoot configuration, string roleId)
        {
            _configuration = configuration;
            _roleId = roleId;
        }

        public string GetRoleName()
        {
            return "role name";
        }

        public string GetRoleId()
        {
            return _roleId;
        }

        public string GetDeploymentId()
        {
            return _configuration["DeploymentId"];
        }
    }
}