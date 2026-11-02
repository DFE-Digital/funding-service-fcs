using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingStreams : TestBase
    {
        #region Relationships

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamHasChildFundingStreamPeriod()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstream")
                .Relationship("sfa_fundingstreamperiod")
                    .HasFieldName("sfa_fundingstreamcodeid")
                    .HasDisplayName("Funding Stream Code")
                    .HasRequiredLevel(XrmRequirementLevel.BusinessRequired)
                    .HasCascadeDelete(XrmCascadeDeleteType.Restrict)
                    ;
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void FundingStreamChildContractAllocation()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstream")
                .Relationship("sfa_contractallocation")
                    .HasFieldName("sfa_fundingstreamid")
                    .HasDisplayName("Funding Stream")
                    .HasRequiredLevel(XrmRequirementLevel.None)
                    .HasCascadeDelete(XrmCascadeDeleteType.Restrict)
                    ;
        }

        #endregion
    }
}