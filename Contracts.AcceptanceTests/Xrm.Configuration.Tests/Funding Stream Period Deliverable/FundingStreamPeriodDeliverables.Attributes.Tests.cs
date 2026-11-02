namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream_Period_Deliverable
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationFundingStreamPeriodDeliverables 
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableHasDeliverableCode()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .Attribute("sfa_deliverablecode")
                .HasType(XrmDataType.WholeNumber);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableHasMandatory()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .Attribute("sfa_setting_mandatory")
                .HasType(XrmDataType.TwoOptions);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableHasParentType()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .Attribute("sfa_parentdeliverabletype")
                .HasType(XrmDataType.OptionSet);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableHasPlanningunit()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .Attribute("sfa_setting_planningunit")
                .HasType(XrmDataType.OptionSet);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableHasAllowProfile()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .Attribute("sfa_setting_allowprofile")
                .HasType(XrmDataType.TwoOptions);
        }
    }
}