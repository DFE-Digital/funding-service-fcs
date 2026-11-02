namespace Operations.Web.Tests.ServiceTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.Web.Infrastructure;
    using Operations.Web.Repositories;
    using Operations.Web.Services;
    using System.Collections.Generic;

    [TestClass]
    public class IntegrityCheckerServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void IntegrityCheckerService_ShouldStartIntegrityCheck()
        {
            IntegrityCheckerService service = new IntegrityCheckerService(new NServiceBusSender());

            service.StartIntegrityChecker("ANITA_PAAS_EXTRACT").Wait();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractDataCleanup_Check()
        {
            ContractCleanupService service = new ContractCleanupService(new ContractAtomFeedQueryRepository(), new CrmContractInformationRepository());
            List<string> fundingIds = new List<string>()
                    {
                        "PP-FY-2526-Contracting-Provider-10001232-1_0","DADA-AY-2425-Contracting-Provider-10002869-4_0"
                };
            service.CleanContractData(fundingIds).Wait();
        }
    }
}
