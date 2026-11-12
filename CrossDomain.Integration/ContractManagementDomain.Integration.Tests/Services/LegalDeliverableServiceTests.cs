namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using UnitTests.Common;

    [TestClass]
    public class LegalDeliverableServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LegalDeliverableService_ShouldRemoveNonLegalDeliverables()
        {
            // arrange
            Contract masterContract = TestResource.FromJson<Contract>("SFA.FCT.ContractManagementDomain.Integration.Tests", "Resources.NCS_Contract.json");
            IDictionary<string, IReadOnlyCollection<int>> deliverablesForFsp = new Dictionary<string, IReadOnlyCollection<int>>();
            deliverablesForFsp["NCS-EA1718"] = new List<int> { 1 };
            deliverablesForFsp["NCS-SEEDIC1718"] = new List<int> { 1 };
            deliverablesForFsp["NCS-IC1718"] = new List<int> { 1 };
            deliverablesForFsp["NCS-FWL1718"] = new List<int> { 1 };
            deliverablesForFsp["NCS-I1718"] = new List<int> { 1 };
            deliverablesForFsp["NCS-P1718"] = new List<int> { 1,2,3,4,5,7 }; // I have missed out 6 here on purpose, the test json has contains 1 and 6
            deliverablesForFsp["NCS-ASIST1718"] = new List<int> { 1 };
            deliverablesForFsp["NCS-C1718"] = new List<int> { 1,2,3,4,5 }; // I have missed out 6 here on purpose, the test json has contains 1 and 6

            Mock<IFundingStreamPeriodLegalDeliverableRepository> fundingStreamPeriodLegalDeliverableRepositoryMock = new Mock<IFundingStreamPeriodLegalDeliverableRepository>();
            fundingStreamPeriodLegalDeliverableRepositoryMock.Setup(
                r => r.GetLegalDeliverablesForFsp(It.IsAny<string>())).Returns(
                    (string fsp) => deliverablesForFsp[fsp]);

            LegalDeliverableService service = new LegalDeliverableService(fundingStreamPeriodLegalDeliverableRepositoryMock.Object);

            List<contractDeliverablesTypeContractDeliverable> deliverablesForNCS_P1718 = masterContract.contracts.First()
                .contractAllocations.Single(a => a.fundingStreamPeriodCode == "NCS-P1718")
                .contractDeliverables;

            List<contractDeliverablesTypeContractDeliverable> deliverablesForNCS_C1718 = masterContract.contracts.First()
               .contractAllocations.Single(a => a.fundingStreamPeriodCode == "NCS-C1718")
               .contractDeliverables;

            Assert.IsTrue(deliverablesForNCS_P1718.Any(d => d.deliverable.deliverableCode == 6), "We should have deliverable 6 at this point NCS_P1718");
            Assert.IsTrue(deliverablesForNCS_C1718.Any(d => d.deliverable.deliverableCode == 6), "We should have deliverable 6 at this point for NCS_C1718");
            // act
            service.RemoveNonLegalDeliverablesFromContract(masterContract);

            // assert
            deliverablesForNCS_P1718 = masterContract.contracts.First()
                .contractAllocations.Single(a => a.fundingStreamPeriodCode == "NCS-P1718")
                .contractDeliverables;

            deliverablesForNCS_C1718 = masterContract.contracts.First()
               .contractAllocations.Single(a => a.fundingStreamPeriodCode == "NCS-C1718")
               .contractDeliverables;

            List<contractDeliverablesTypeContractDeliverable> deliverablesForNCS_EA1718 = masterContract.contracts.First()
               .contractAllocations.Single(a => a.fundingStreamPeriodCode == "NCS-EA1718")
               .contractDeliverables;


            Assert.IsFalse(deliverablesForNCS_P1718.Any(d => d.deliverable.deliverableCode == 6), "We should not have deliverable 6 afer removal of non legal - NCS_P1718");
            Assert.IsFalse(deliverablesForNCS_C1718.Any(d => d.deliverable.deliverableCode == 6), "We should not have deliverable 6 afer removal of non legal - NCS_C1718");
            Assert.IsTrue(deliverablesForNCS_EA1718.Any(d => d.deliverable.deliverableCode == 1), "We should have deliverable 1 afer removal of non legal - NCS_EA1718");
        }
    }
}
