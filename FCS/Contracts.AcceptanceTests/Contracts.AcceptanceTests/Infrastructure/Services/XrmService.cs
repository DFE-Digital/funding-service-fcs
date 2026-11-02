namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using Microsoft.Xrm.Sdk;
    using NUnit.Framework;
    using Xrm.TestFramework;

    public static class XrmService
    {
        static XrmService()
        {
            string outputFolder = TestContext.CurrentContext.TestDirectory;
            const string solution = "Default";
            const string solutionPath = @"TFSLN";

            IOrganizationService organizationService = CrmConnectionFactory.GetConnection();

            Connection = new XrmWebConnection(organizationService)
            {
                OutputFolder = outputFolder,
                SolutionName = solution,
            };

            Configuration = new XrmPackageConfiguration($"{outputFolder}\\{solutionPath}");
        }

        public static XrmWebConnection Connection { get; }

        public static XrmPackageConfiguration Configuration { get; }

        public static XrmWebConnection ConnectAsUser(string userName)
        {
            IOrganizationService connection = CrmConnectionFactory.GetConnectionForSpecificUser(userName.ToUpper());

            return new XrmWebConnection(connection);
        }
    }
}