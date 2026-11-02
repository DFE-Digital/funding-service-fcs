namespace Datafix.Tests.Tests
{
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class FundingClaimReconciliationRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimReconciliationRepository_UpdateStatus()
        {
            FundingClaimReconciliationRepository.UpdateStatusAndSubStatus(10045119, sfa_sfastatuscode.Published, sfa_sfasubstatuscode.ManuallyPublished, "2021_Final");
        }
    }
}
