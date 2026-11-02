namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Allocations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractAllocations
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void ContractRelationship()
        {
            CrmConfiguration.Entity("sfa_contract").Relationship("sfa_contractallocation")
                .HasFieldName("sfa_contractid")
                .HasDisplayName("Contract")
                .HasRequiredLevel(XrmRequirementLevel.BusinessRequired)
                .HasCascadeDelete(XrmCascadeDeleteType.Cascade);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void FundingStreamRelationships()
        {
            CrmConfiguration.Entity("sfa_fundingstream").Relationship("sfa_contractallocation")
                .HasFieldName("sfa_fundingstreamid")
                .HasDisplayName("Funding Stream")
                .HasRequiredLevel(XrmRequirementLevel.None)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void FundingStreamPeriodRelationships()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperiod").Relationship("sfa_contractallocation")
                .HasFieldName("sfa_fundingstreamperiodid")
                .HasDisplayName("Funding Stream Period")
                .HasRequiredLevel(XrmRequirementLevel.None)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "3549")]
        public void UnitofProcurementRelationship()
        {
            CrmConfiguration.Entity("sfa_unitofprocurement").Relationship("sfa_contractallocation")
                .HasFieldName("sfa_unitofprocurementid")
                .HasDisplayName("UoP Name")
                .HasRequiredLevel(XrmRequirementLevel.None)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }
    }
}