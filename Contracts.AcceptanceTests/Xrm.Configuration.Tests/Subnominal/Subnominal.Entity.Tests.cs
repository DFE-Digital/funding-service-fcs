namespace SFA.FCT.Xrm.Configuration.Tests.Subnominal
{using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
    [TestClass]
    public partial class XrmConfigurationSubnominals :TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "5043")]
        public void SubnominalEntityExists()
        {
            CrmConfiguration.Entity("sfa_subnominalaggregation").HasDisplayName("Subnominal Aggregation");
        }
    }
}
