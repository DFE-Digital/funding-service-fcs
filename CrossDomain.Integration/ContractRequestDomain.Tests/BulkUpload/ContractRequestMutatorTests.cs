namespace ContractRequestDomain.Tests.BulkUpload
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractRequestMutatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AddNonLevyAllocationToContractRequest_AddsAllocationToChildContract()
        {
            var period = new periodType { period = "1799" };
            var startDate = new DateTime(2024, 8, 1);
            var childContract = new contractType
            {
                period = period,
                contractor = new Contractor { ukprn = 12345678 },
                startDate = startDate,
                contractAllocations = new List<contractAllocation>()
            };
            var request = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType> { childContract }
                }
            };

            new ContractRequestMutator().AddNonLevyAllocationToContractRequest(request);

            Assert.AreEqual(1, childContract.contractAllocations.Count);
            var allocation = childContract.contractAllocations[0];
            Assert.AreSame(period, allocation.period);
            Assert.AreEqual(12345678, allocation.ukprn);
            Assert.AreEqual(startDate, allocation.startDate);
            Assert.AreEqual("NONLEVY", allocation.fundingStreamCode);
            Assert.AreEqual("NONLEVY2019", allocation.fundingStreamPeriodCode);
            Assert.AreEqual(0, allocation.maximumContractValue);
            Assert.AreEqual(0, allocation.contractDeliverables.Count);
            Assert.IsTrue(Guid.TryParse(allocation.correlationId, out _));
        }
    }
}
