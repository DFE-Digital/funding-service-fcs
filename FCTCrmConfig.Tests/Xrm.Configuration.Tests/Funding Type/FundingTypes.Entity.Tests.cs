using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    [TestClass]
    public partial class XrmConfigurationFundingTypes : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo","70")]
        public void FundingTypeEntityExists()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingtype").HasDisplayName("Funding Type");
        }

        #endregion      
    }
}
