namespace FCT.Console.Config.Tests.CommonSecreteUtility
{
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System;
    using System.Configuration;
    [TestClass]
    public class TestFrameworkInitializer
    {
        [AssemblyInitialize]
        public static void Init(TestContext context)
        {
            TestDbContextFactory.InitializeForTests();
        }
    }

}
