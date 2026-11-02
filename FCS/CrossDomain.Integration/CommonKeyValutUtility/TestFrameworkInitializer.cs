using ContractManagement.DataStore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Configuration;

namespace CommonKeyVaultUtility
{    
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
