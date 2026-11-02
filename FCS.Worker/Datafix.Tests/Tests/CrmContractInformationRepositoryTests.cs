namespace Datafix.Tests.Tests
{
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmContractInformationRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmContractInformationRepository_GetLastApprovedAndLatestVersionContractsWithoutDuplicates()
        {
            CrmContractInformationRepository repository = new CrmContractInformationRepository();
            
            var contracts = repository.GetLastApprovedAndLatestVersionContractsWithoutDuplicates();

            Assert.IsTrue(contracts.Any());
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmContractInformationRepository_GetContractTerminationInfos()
        {
            var contracts = CrmContractInformationRepository.GetContractTerminationInfos("Under Termination", sfa_contractstatus.Approved);

            Assert.IsTrue(contracts.Any());
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmContractInformationRepository_GetAllocationId()
        {
            var allocationInfo = CrmContractInformationRepository.GetAllocationInfo("APPLEVY-6154", 1, 0, "LEVY-6154");

            Assert.AreEqual("BCF5BF51-BEAF-4290-ACDA-000015ED98F7", allocationInfo.Id.ToString().ToUpper());
            Assert.AreEqual(2, allocationInfo.Deliverables.Count, "the wrong number of deliverables");
        }
    }
}
