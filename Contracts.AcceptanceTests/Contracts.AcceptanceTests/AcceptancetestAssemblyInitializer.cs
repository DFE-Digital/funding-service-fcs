using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SFA.FCT.Contracts.AcceptanceTests;

namespace SFA.FCT.Contracts.AcceptanceTests
{
    public class AcceptancetestAssemblyInitializer
    {

        [AssemblyInitialize]
        public static void Init(TestContext context)
        {
            SFA.FCT.Contracts.AcceptanceTests.TestDbContextFactory.InitializeForTests();
        }

    }
}
