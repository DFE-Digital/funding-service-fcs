namespace SFA.FCT.Xrm.Configuration.Tests.Contracts
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContracts
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractToFundingType()
        {
            CrmConfiguration.Entity("sfa_fundingtype").Relationship("sfa_contract")
                .HasFieldName("sfa_fundingtype")
                .HasDisplayName("Funding Type")
                .HasRequiredLevel(XrmRequirementLevel.None)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }
    }
}