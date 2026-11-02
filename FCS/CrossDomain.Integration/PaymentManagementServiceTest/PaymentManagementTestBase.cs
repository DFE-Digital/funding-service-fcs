namespace PaymentManagementServiceTest
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class PaymentManagementTestBase : IntegrationTestBase
    {
        public ExtendedContractType CorporateContract { get; private set; }

        public Guid CorporateContractGuid { get; private set; }

        public PaymentManagementTestBase()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";

            const string amendmentReason = "Test";

            CorporateContract = GetExtendedCorpContract();

            //// add the amendment reaon to the allocations
            CorporateContract.contracts.ForEach(c => c.contractAllocations.ForEach(ca => ca.reasonForAmendment = amendmentReason));

            var contractsManager = Container.Resolve<IContractsManager>();
            contractsManager.BatchId = batchId;
            CorporateContractGuid = contractsManager.CreateContract(CorporateContract, correlationId);
            Assert.IsTrue(CorporateContractGuid != null);
        }
    }
}
