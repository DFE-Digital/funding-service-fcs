namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Deliverables
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractDeliverables
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsDeliverableCode()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_deliverablecode")
                .HasDisplayName("Deliverable Code")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsDeliverableDescription()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_deliverabledescription")
                .HasDisplayName("Deliverable Description")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsDeliverableName()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_deliverablename")
                .HasDisplayName("Deliverable")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsSsaCode()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_ssacode")
                .HasDisplayName("SSA Code")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsUnitCost()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_unitcost")
                .HasDisplayName("Unit Cost")
                .HasType(XrmDataType.Decimal);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityContainsPlannedValue()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_plannedvalue")
                .HasDisplayName("Planned Value (£)")
                .HasType(XrmDataType.Decimal);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityContainsActualValue()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_actualvalue")
                .HasDisplayName("Actual Value (£)")
                .HasType(XrmDataType.Decimal);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityContainsPlannedVolume()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_plannedvolume")
                .HasDisplayName("Planned Volume")
                .HasType(XrmDataType.WholeNumber);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityContainsActualVolume()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .Attribute("sfa_actualvolume")
                .HasDisplayName("Actual Volume")
                .HasType(XrmDataType.WholeNumber);
        }

        //////[TestMethod]
        ////[TestCategory("CRMConfiguration")]
        ////[TestProperty("StoryNo", "74")]
        ////public void EntityContainsPlanningUnit()
        ////{
        ////    CrmConfiguration.Entity("sfa_contractdeliverable")
        ////        .Attribute("sfa_planningunit")
        ////        .HasDisplayName("Planning Unit")
        ////        .HasType(XrmDataType.OptionSet);
        ////}
    }
}