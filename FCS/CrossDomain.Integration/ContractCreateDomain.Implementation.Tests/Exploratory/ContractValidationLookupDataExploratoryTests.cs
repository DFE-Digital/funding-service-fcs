namespace ContractCreateDomain.Implementation.Tests.Exploratory
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests;

    [TestClass]
    public class ContractValidationLookupDataExploratoryTests : IntegrationTestBase
    {
        [TestMethod, TestCategory("DataDependent")]
        public void ShouldCheckExistingContractsWithContractNumbers()
        {
            IContractValidationLookupDataCreator manager = Container.Resolve<IContractValidationLookupDataCreator>();

            var contractRequest = GetContractRequest();
            var masterContract = contractRequest.contract;
            masterContract.CRMIntent = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.intent.Amendment;

            foreach (var subContract in masterContract.contracts)
            {
                subContract.contractNumber = "24Loans-1048";
            }

            manager.CreateLookupDataAndSetContractPresence(contractRequest);

            foreach (var subContract in masterContract.contracts)
            {
                Assert.IsTrue(subContract.IsDraftContractWithContractNumberPresentInCrm);
            }
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldCheckExistingDraftContractsWithContractNumbersButWithoutAnAllowedSubStatusFor()
        {
            IContractValidationLookupDataCreator manager = Container.Resolve<IContractValidationLookupDataCreator>();

            var contractRequest = GetContractRequest();
            var masterContract = contractRequest.contract;
            masterContract.CRMIntent = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.intent.Amendment;

            foreach (var subContract in masterContract.contracts)
            {
                // this has a draft contract with a sub status that we don't support
                subContract.contractNumber = "KLM-789";
            }

            manager.CreateLookupDataAndSetContractPresence(contractRequest);

            foreach (var subContract in masterContract.contracts)
            {
                Assert.IsFalse(subContract.IsDraftContractWithContractNumberPresentInCrm);
            }
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldCheckExistingOfDraftContractsWithIncludedStatusWithContractNumber()
        {
            // when we look for a draft contract we should check that status is in 'In Review or Unassigned'
            IContractValidationLookupDataCreator manager = Container.Resolve<IContractValidationLookupDataCreator>();

            var contractRequest = GetContractRequest();
            var masterContract = contractRequest.contract;
            masterContract.CRMIntent = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.intent.Amendment;

            foreach (var subContract in masterContract.contracts)
            {
                subContract.contractNumber = "24Loans-1048";
            }

            manager.CreateLookupDataAndSetContractPresence(contractRequest);

            foreach (var subContract in masterContract.contracts)
            {
                Assert.IsTrue(subContract.IsDraftContractWithContractNumberPresentInCrm);
            }
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldCheckExistingMasterContracts_ForNewAmendment()
        {
            // we look for a Master contract  
            IContractValidationLookupDataCreator manager = Container.Resolve<IContractValidationLookupDataCreator>();

            var contractRequest = GetContractRequest();
            var masterContract = contractRequest.contract;
            masterContract.contractNumber = "SFA-2061";
            masterContract.CRMIntent = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.intent.NewAmendment;
            var subContract = contractRequest.contract.contracts.First();

            manager.CreateLookupDataAndSetContractPresence(contractRequest);

            Assert.IsTrue(masterContract.IsMasterContractWithMatchingMasterContractNumberPresentInCrm,
                "Master Contract not in CRM for new amendment");

        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldCheckExistingOfDraftContractsWithoutContractNumber()
        {
            // when we look for a draft contract we should check that status is in 'In Review or Unassigned'
            IContractValidationLookupDataCreator manager = Container.Resolve<IContractValidationLookupDataCreator>();

            var contractRequest = GetContractRequest();
            var masterContract = contractRequest.contract;
            masterContract.CRMIntent = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.intent.Amendment;
            var subContract = contractRequest.contract.contracts.First();
            subContract.fundingTypeCode = "24+LOANS";
            subContract.contractNumber = "24Loans-2142";

            subContract.startDate = new DateTime(2015, 8, 1);
            subContract.startDate = DateTime.SpecifyKind(subContract.startDate.Value, DateTimeKind.Utc);
            subContract.endDate = new DateTime(2016, 7, 31);
            subContract.endDate = DateTime.SpecifyKind(subContract.endDate.Value, DateTimeKind.Utc);
            subContract.period.period = "1516";
            contractRequest.contract.contractor.ukprn = 10001971;

            manager.CreateLookupDataAndSetContractPresence(contractRequest);

            foreach (var contract in masterContract.contracts)
            {
                Assert.IsTrue(contract.IsPresentInCrm);
            }
        }
    }
}