namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Allocations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractAllocations
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void EntityContainsContractStatus()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_allocationstatus")
                .HasType(XrmDataType.OptionSet);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsAwardReference()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_awardreference")
                .HasDisplayName("Tender Award Reference")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsAllocationNumber()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_contractallocationnumber")
                .HasDisplayName("Contract Allocation Ref")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsDescription()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_description")
                .HasDisplayName("Contract Allocation Description")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsStartDate()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_startdate")
                .HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void EntityContainsEndDate()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_enddate")
                .HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsIttReference()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_ittreference")
                .HasDisplayName("Tender Specification Reference")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsLepCode()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_lepcode")
                .HasDisplayName("LEP Code")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityContainsUoPCode()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_uopcode")
                .HasDisplayName("UoP Code")
                .HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void EntityContainsMaximumContractValue()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_maximumcontractvalue")
                .HasDisplayName("Contract Allocation Value (£)")
                .HasType(XrmDataType.Decimal);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "572")]
        public void ContractEntityContainsAmendmentType()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_amendmentreason")
                .HasType(XrmDataType.Text)
                .HasDisplayName("Amendment Reason");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "572")]
        public void ContractEntityContainsVariation()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .Attribute("sfa_variation")
                .HasType(XrmDataType.Decimal)
                .HasDisplayName("Variation");
        }
    }
}