namespace SFA.FCT.Framework.Logging.Bespoke
{
    public interface ICloudEnvironment
    {
        string GetRoleName();

        string GetRoleId();

        string GetDeploymentId();
    }
}