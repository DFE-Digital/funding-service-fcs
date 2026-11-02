namespace SFA.FCT.Xrm.Configuration.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Properties;
    using TestFramework;

    [TestClass]
    public class TestBase
    {
        public static XrmPackageConfiguration CrmConfiguration { get; set; }

        [AssemblyInitialize]
        public static void AssemblyInit(TestContext context)
        {
            CrmConfiguration = new XrmPackageConfiguration(Settings.Default.SolutionPackagePath);
            
        }
    }
}