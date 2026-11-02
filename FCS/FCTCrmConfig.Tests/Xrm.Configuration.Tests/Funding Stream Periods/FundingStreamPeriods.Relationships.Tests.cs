using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingStreamPeriods : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodToFundingStream()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstream").Relationship("sfa_fundingstreamperiod")
                .HasFieldName("sfa_fundingstreamcodeid")
                .HasDisplayName("Funding Stream Code")
                ;
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodToPeriod()
        {
            TestBase.CrmConfiguration.Entity("sfa_period").Relationship("sfa_fundingstreamperiod")
                    .HasFieldName("sfa_periodid")
                    .HasDisplayName("Funding Period")
                    .HasRequiredLevel(XrmRequirementLevel.BusinessRequired)
                    .HasCascadeDelete(XrmCascadeDeleteType.Restrict)
                    ;
        }
    }
}