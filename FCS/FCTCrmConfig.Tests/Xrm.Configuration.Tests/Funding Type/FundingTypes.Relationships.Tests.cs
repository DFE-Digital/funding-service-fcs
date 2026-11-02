using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingTypes : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void FundingTypeHasAgency()
        {
            TestBase.CrmConfiguration.Entity("sfa_agency").Relationship("sfa_fundingtype")
                        .HasFieldName("sfa_agencyid")
                        .HasDisplayName("Agency")
                        .HasRequiredLevel(XrmRequirementLevel.None)
                        .HasCascadeDelete(XrmCascadeDeleteType.Restrict)
                        ;
        }
    }
}
