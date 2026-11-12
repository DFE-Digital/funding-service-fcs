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
            var path =XrmTestConfiguration.Configuration["XrmConfiguration:SolutionPackagePath"];

            Console.WriteLine($"SolutionPackagePath={path}");
            Console.WriteLine($"Exists={Directory.Exists(path)}");
            CrmConfiguration =new XrmPackageConfiguration(XrmTestConfiguration.Configuration["XrmConfiguration:SolutionPackagePath"]);

        }
    }
}