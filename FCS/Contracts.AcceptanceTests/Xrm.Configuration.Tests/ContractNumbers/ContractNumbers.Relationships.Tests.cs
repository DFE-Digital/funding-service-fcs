namespace SFA.FCT.Xrm.Configuration.Tests.ContractNumbers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractNumbers
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "432")]
        public void ContractNumberRelationship()
        {
            CrmConfiguration.Entity("sfa_agency").Relationship("sfa_contractnumber")
                .HasFieldName("sfa_agencyid")
                .HasDisplayName("Agency")
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);

            CrmConfiguration.Entity("sfa_fundingstream").Relationship("sfa_contractnumber")
                .HasFieldName("sfa_fundingstreamid")
                .HasDisplayName("Funding Stream")
                .HasRequiredLevel(XrmRequirementLevel.None)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);

            CrmConfiguration.Entity("sfa_fundingtype").Relationship("sfa_contractnumber")
                .HasFieldName("sfa_fundingtypeid")
                .HasDisplayName("Funding Type")
                .HasRequiredLevel(XrmRequirementLevel.None)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }
    }
}