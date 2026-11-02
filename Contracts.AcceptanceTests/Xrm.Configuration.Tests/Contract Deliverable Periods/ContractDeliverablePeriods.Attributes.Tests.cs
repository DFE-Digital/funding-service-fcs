namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Deliverable_Periods
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractDeliverablePeriods
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityContainsPlannedValue()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod")
                .Attribute("sfa_plannedvalue")
                .HasDisplayName("Planned Value (£)")
                .HasType(XrmDataType.Decimal);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityContainsActualValue()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod")
                .Attribute("sfa_actualvalue")
                .HasDisplayName("Actual Value (£)")
                .HasType(XrmDataType.Decimal);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityContainsPlannedVolume()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod")
                .Attribute("sfa_plannedvolume")
                .HasDisplayName("Planned Volume")
                .HasType(XrmDataType.WholeNumber);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityContainsActualVolume()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod")
                .Attribute("sfa_actualvolume")
                .HasDisplayName("Actual Volume")
                .HasType(XrmDataType.WholeNumber);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "4621")]
        public void EntityContainsPeriodName()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod")
                .Attribute("sfa_actualvolume")
                .HasDisplayName("Actual Volume")
                .HasType(XrmDataType.WholeNumber);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "4621")]
        public void EntityContainsDisplayOrder()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod")
                .Attribute("sfa_displayorder")
                .HasDisplayName("#")
                .HasType(XrmDataType.WholeNumber);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "707")]
        public void EntityContainsAggregate()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod")
                .Attribute("sfa_aggregate")
                .HasDisplayName("Aggregate")
                .HasType(XrmDataType.TwoOptions);
        }
    }
}