namespace SFA.FCT.Framework.Logging.Bespoke
{
    public class AppServiceEnvironment : ICloudEnvironment
    {
        private readonly string _roleName;
        private readonly string _roleId;
        private readonly string _deploymentId;

        public AppServiceEnvironment(string roleName, string roleId, string deploymentId)
        {
            _roleName = roleName;
            _roleId = roleId;
            _deploymentId = deploymentId;
        }

        public string GetRoleName()
        {
            return _roleName; // Environment.GetEnvironmentVariable("WEBJOBS_NAME");
        }

        public string GetRoleId()
        {
            return _roleId; // Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID").Substring(0, 6);
        }

        public string GetDeploymentId()
        {
            return _deploymentId;
        }
    }
}
