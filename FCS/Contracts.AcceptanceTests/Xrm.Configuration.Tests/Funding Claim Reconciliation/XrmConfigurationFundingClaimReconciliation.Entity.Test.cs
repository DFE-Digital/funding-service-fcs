namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Claim_Reconciliation
{

    using Microsoft.VisualStudio.TestTools.UnitTesting;



    [TestClass]
    public partial class XrmConfigurationFundingClaimReconciliation : TestBase
    {

        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "15127")]
        public void XrmConfigurationFundingClaimReconciliationEntityExists()
        {
            CrmConfiguration.Entity("sfa_fundingclaimreconciliation")
                .HasDisplayName("Funding Claim Reconciliation");
        }
    }
}
