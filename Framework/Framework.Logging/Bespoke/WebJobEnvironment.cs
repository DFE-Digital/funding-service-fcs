
namespace SFA.FCT.Framework.Logging.Bespoke
{
        public class WebJobEnvironment : ICloudEnvironment
    {
        private string _deploymentId;
        private string _roleId;
        private string _roleName;

        public string GetRoleName()
        {
            return _roleName ?? (_roleName = System.Configuration.ConfigurationManager.AppSettings["WEBJOBS_NAME"]);
        }

        public string GetRoleId()
        {
            return _roleId ?? (_roleId = "0");
        }

        public string GetDeploymentId()
        {
            return _deploymentId ?? (_deploymentId = System.Configuration.ConfigurationManager.AppSettings["DeploymentId"]);
        }
    }
}
