namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Type
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationFundingTypes
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void FundingTypeHasAgency()
        {
            CrmConfiguration.Entity("sfa_agency").Relationship("sfa_fundingtype")
                .HasFieldName("sfa_agencyid")
                .HasDisplayName("Agency")
                .HasRequiredLevel(XrmRequirementLevel.None)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }
    }
}