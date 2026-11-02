namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream_Period_Deliverable
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    public partial class XrmConfigurationFundingStreamPeriodDeliverables
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2172")]
        public void FundingStreamPeriodDeliverableToFundingStream()
        {
            CrmConfiguration.Entity("sfa_fundingstream").Relationship("sfa_fundingstreamperioddeliverable")
                .HasFieldName("sfa_fundingstreamid")
                .HasDisplayName("Funding Stream");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2172")]
        public void FundingStreamPeriodDeliverableToFundingStreamPeriod()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperiod").Relationship("sfa_fundingstreamperioddeliverable")
                .HasFieldName("sfa_fundingstreamperiodid")
                .HasDisplayName("Funding Stream Period");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2172")]
        public void FundingStreamPeriodDeliverableToParent()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable").Relationship("sfa_fundingstreamperioddeliverable")
                .HasFieldName("sfa_parentdeliverableid")
                .HasDisplayName("Parent Deliverable");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2172")]
        public void FundingStreamPeriodDeliverableToDeliverable()
        {
            CrmConfiguration.Entity("sfa_deliverable").Relationship("sfa_fundingstreamperioddeliverable")
                .HasFieldName("sfa_deliverableid")
                .HasDisplayName("Deliverable");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void FundingStreamPeriodDeliverableToContractDeliverable()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable").Relationship("sfa_contractdeliverable")
                .HasFieldName("sfa_fundingstreamperioddeliverableid")
                .HasDisplayName("Funding Stream Period Deliverable");
        }
    }
}