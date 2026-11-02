namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Type
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationFundingTypes : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void FundingTypeEntityExists()
        {
            CrmConfiguration.Entity("sfa_fundingtype").HasDisplayName("Funding Type");
        }

        #endregion
    }
}