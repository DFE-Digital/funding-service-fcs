using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingPeriod : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingPeriodToPeriodType()
        {
            TestBase.CrmConfiguration.Entity("sfa_periodtype").Relationship("sfa_period")
                .HasFieldName("sfa_periodtypeid")
                .HasDisplayName("Period Type")
                ;
        }
    }
}
