using System.Xml.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class TestBase
    {
        public static XrmPackageConfiguration CrmConfiguration { get; set; }

        public static XrmWebConnection Connection { get; private set; }

        [AssemblyInitialize()]
        public static void AssemblyInit(TestContext context)
        {
            string outputFolder = Properties.Settings.Default.SolutionExportPackagePath;
            string solution = "Default";
            string roleMapPath = Properties.Settings.Default.RolesMappingDoc;

            string connectionString;
            if (Properties.Settings.Default.AcceptanceTestMode)
            {
                connectionString = Properties.Settings.Default.CrmAcceptanceTestConnectionString;

            }
            else
            {
                connectionString = Properties.Settings.Default.CrmUnitTestConnectionString;
            }

            XDocument roleDoc = XDocument.Load(roleMapPath);

            Connection = new XrmWebConnection(connectionString)
            {
                OutputFolder = outputFolder,
                SolutionName = solution,
                RoleMapping = roleDoc
            };

            if (Properties.Settings.Default.DownloadSolution == true)
            {
                Connection.DownloadSolution();

                TestBase.CrmConfiguration = new XrmPackageConfiguration(outputFolder + '\\' + solution);
            }
            else
            {
                TestBase.CrmConfiguration = new XrmPackageConfiguration(Properties.Settings.Default.SolutionPackagePath);
            }
        }

        public static XrmWebConnection ConnectAsUser(string userName)
        {
            string connectionString = string.Empty;

            userName = userName.Replace(" ", "");
            if (Properties.Settings.Default["CrmConnectionString_" + userName] != null)
            {
                connectionString = Properties.Settings.Default["CrmConnectionString_" + userName].ToString();
            }
            else
            {
                Assert.Fail("No connection string found for User: " + userName);
            }

            var con = new XrmWebConnection(connectionString);

            return con;
        }

        public static XrmWebConnection ConnectAsRole(string roleName)
        {
            XDocument rolesDoc = XDocument.Load(Properties.Settings.Default.RolesMappingDoc);

            return ConnectAsUser(XrmWebConnection.GetUserFromRole(roleName, rolesDoc));
        }
    }
}