namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Deliverables
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractDeliverables
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void ContractDeliverableRelationship()
        {
            CrmConfiguration.Entity("sfa_contractallocation").Relationship("sfa_contractdeliverable")
                .HasFieldName("sfa_contractallocationid")
                .HasDisplayName("Contract Allocation")
                .HasRequiredLevel(XrmRequirementLevel.BusinessRequired)
                .HasCascadeDelete(XrmCascadeDeleteType.Cascade);
        }
    }
}