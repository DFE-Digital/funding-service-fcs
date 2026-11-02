

namespace SFA.FCT.Xrm.Configuration.Tests.Claim_Type
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationClaimType : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "15127")]
        public void XrmConfigurationClaimTypeEntityExists()
        {
            CrmConfiguration.Entity("sfa_claimtype")
                .HasDisplayName("Claim Type");
        }
    }
}
