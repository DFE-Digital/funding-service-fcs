using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingStreamPeriodDeliverables : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2172")]
        public void FundingStreamPeriodDeliverableToFundingStream()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstream").Relationship("sfa_fundingstreamperioddeliverable")
                .HasFieldName("sfa_fundingstreamid")
                .HasDisplayName("Funding Stream")
                ;
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2172")]
        public void FundingStreamPeriodDeliverableToFundingStreamPeriod()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperiod").Relationship("sfa_fundingstreamperioddeliverable")
                .HasFieldName("sfa_fundingstreamperiodid")
                .HasDisplayName("Funding Stream Period")
                ;
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2172")]
        public void FundingStreamPeriodDeliverableToParent()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable").Relationship("sfa_fundingstreamperioddeliverable")
                .HasFieldName("sfa_parentdeliverableid")
                .HasDisplayName("Parent Deliverable")
                ;
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2172")]
        public void FundingStreamPeriodDeliverableToDeliverable()
        {
            TestBase.CrmConfiguration.Entity("sfa_deliverable").Relationship("sfa_fundingstreamperioddeliverable")
                .HasFieldName("sfa_deliverableid")
                .HasDisplayName("Deliverable")
                ;
        }
    }
}