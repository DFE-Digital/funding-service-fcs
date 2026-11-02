namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.ReleaseGroup;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    
    [TestClass]
    public class FundingAllocationExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationExtensions_GetContractAllocations_ShouldReturnAllocations()
        {
            // arrange
            const int deliveryUkprn = 12345678;
            const decimal plannedValue = 10m;
            const int numberOfDeliverables = 2;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";
            FundingAllocation fundingAllocation = new FundingAllocation(
                string.Empty, string.Empty, "AY-2021",
                "PSG", string.Empty, 0, 1, 1, 0, 1);
            var providerFundingAllocation = new ProviderFundingAllocation(string.Empty, string.Empty)
            {
                ProviderFunding = new ProviderFunding(string.Empty, deliveryUkprn, string.Empty, string.Empty)
            };

            var fundingAllocationLines = Enumerable.Range(0, numberOfDeliverables)
                .Select(i => new FundingAllocationLine(string.Empty, string.Empty)).ToList();

            providerFundingAllocation.ProviderFunding.FundingAllocationLines.AddRange(fundingAllocationLines);
            
            fundingAllocation.ProviderFundingAllocations.Add(providerFundingAllocation);
            fundingAllocationLines.ForEach(fal => fal.FundingAllocationProfilePeriods.Add(new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202101, plannedValue)));

            int delCode = 1;
            FspCodeDeliverable GetFspAndDeliverableCode(ProviderFundingInfo d) => new FspCodeDeliverable("FSP1", delCode, $"some name{delCode++}", 1, fsCode, allocationPrefix);

            // act
            var contractAllocations = new List<FundingAllocation>{fundingAllocation}.GetContractAllocationInfos(GetFspAndDeliverableCode);

            // assert
            Assert.AreEqual(1, contractAllocations.Count, "The number of allocations is incorrect");
            var contractAllocation = contractAllocations.Single();
            Assert.AreEqual("FSP1", contractAllocation.FundingStreamPeriodCode, "The FundingStreamPeriodCode is incorrect");
            Assert.AreEqual(fsCode, contractAllocation.FundingStreamCode, "The FundingStreamCode is incorrect");
            Assert.AreEqual(allocationPrefix, contractAllocation.AllocationReferencePrefix, "The AllocationReferencePrefix is incorrect");

            Assert.AreEqual(2, contractAllocation.Deliverables.Count, "The number of deliverables is incorrect");
            
            Assert.IsTrue(new List<int>{1, 2}.All(delCode => contractAllocation.Deliverables.Select(d => d.DeliverableCode).Contains(delCode)),
                "The deliverable codes are not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationExtensions_GetContractAllocations_ShouldReturnOneAllocationFromTwoFundingAllocationsWhenTheFspsAndDeliveryUkprnAreTheSame()
        {
            // arrange
            const int deliveryUkprn = 12345678;
            const decimal plannedValue = 10m;
            const int numberOfDeliverables = 2;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";
            List<FundingAllocation> fundingAllocations = new List<FundingAllocation>
            {
                new FundingAllocation(
                    string.Empty, string.Empty, "AY-2021",
                    "PSG", string.Empty, 0, 1, 1, 0, 1),
                new FundingAllocation(
                    string.Empty, string.Empty, "AY-2021",
                    "PSG", string.Empty, 0, 1, 1, 0, 1),
            };
            var providerFundingAllocation = new ProviderFundingAllocation(string.Empty, string.Empty)
            {
                ProviderFunding = new ProviderFunding(string.Empty, deliveryUkprn, string.Empty, string.Empty)
            };

            var fundingAllocationLines = Enumerable.Range(0, numberOfDeliverables)
                .Select(i => new FundingAllocationLine(string.Empty, string.Empty)).ToList();

            providerFundingAllocation.ProviderFunding.FundingAllocationLines.AddRange(fundingAllocationLines);

            fundingAllocations[0].ProviderFundingAllocations.Add(providerFundingAllocation);
            fundingAllocations[1].ProviderFundingAllocations.Add(providerFundingAllocation);
            fundingAllocationLines.ForEach(fal => fal.FundingAllocationProfilePeriods.Add(new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202101, plannedValue)));

            int delCode = 1;
            FspCodeDeliverable GetFspAndDeliverableCode(ProviderFundingInfo d) => new FspCodeDeliverable("FSP1", delCode, $"some name{delCode++}", 1, fsCode, allocationPrefix);

            // act
            var contractAllocations = fundingAllocations.GetContractAllocationInfos(GetFspAndDeliverableCode);

            // assert
            Assert.AreEqual(1, contractAllocations.Count, "The number of allocations is incorrect");
            var contractAllocation = contractAllocations.Single();
            Assert.AreEqual(4, contractAllocation.Deliverables.Count, "The number of deliverables is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationExtensions_GetContractAllocations_ShouldReturnTwoAllocationFromTwoFundingAllocationsWhereThereAreTwoFsps()
        {
            // arrange
            const int deliveryUkprn = 12345678;
            const decimal plannedValue = 10m;
            const int numberOfDeliverables = 2;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";
            List<FundingAllocation> fundingAllocations = new List<FundingAllocation>
            {
                new FundingAllocation(
                    string.Empty, string.Empty, "AY-2021",
                    "PSG", string.Empty, 0, 1, 1, 0, 1),
                new FundingAllocation(
                    string.Empty, string.Empty, "AY-2021",
                    "PSG", string.Empty, 0, 1, 1, 0, 1),
            };
            var providerFundingAllocation = new ProviderFundingAllocation(string.Empty, string.Empty)
            {
                ProviderFunding = new ProviderFunding(string.Empty, deliveryUkprn, string.Empty, string.Empty)
            };

            var fundingAllocationLines = Enumerable.Range(0, numberOfDeliverables)
                .Select(i => new FundingAllocationLine(string.Empty, string.Empty)).ToList();

            providerFundingAllocation.ProviderFunding.FundingAllocationLines.AddRange(fundingAllocationLines);

            fundingAllocations[0].ProviderFundingAllocations.Add(providerFundingAllocation);
            fundingAllocations[1].ProviderFundingAllocations.Add(providerFundingAllocation);
            fundingAllocationLines.ForEach(fal => fal.FundingAllocationProfilePeriods.Add(new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202101, plannedValue)));

            int delCode = 1;
            int numTimesCalled = 0;
            FspCodeDeliverable GetFspAndDeliverableCode(ProviderFundingInfo d)
            {
                int fspSuffix = numTimesCalled++ / 2;

                return new FspCodeDeliverable($"FSP{fspSuffix}", delCode, $"some name{delCode++}", 1, fsCode,
                    allocationPrefix);
            }

            // act
            var contractAllocations = fundingAllocations.GetContractAllocationInfos(GetFspAndDeliverableCode);

            // assert
            Assert.AreEqual(2, contractAllocations.Count, "The number of allocations is incorrect");
            Assert.IsTrue(contractAllocations.All(ca => ca.Deliverables.Count == 2),
                "The allocations have the wrong number of deliverables");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationExtensions_GetContractAllocations_ShouldReturnTwoAllocationsFromTwoFundingAllocationsWhenTheDeliveryUkprnIsDifferent()
        {
            // arrange
            const int deliveryUkprn = 12345678;
            const int deliveryUkprn2 = 12345679;
            const decimal plannedValue = 10m;
            const int numberOfDeliverables = 2;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";
            List<FundingAllocation> fundingAllocations = new List<FundingAllocation>
            {
                new FundingAllocation(
                    string.Empty, string.Empty, "AY-2021",
                    "PSG", string.Empty, 0, 1, 1, 0, 1),
                new FundingAllocation(
                    string.Empty, string.Empty, "AY-2021",
                    "PSG", string.Empty, 0, 1, 1, 0, 1),
            };
            var providerFundingAllocation1 = new ProviderFundingAllocation(string.Empty, string.Empty)
            {
                ProviderFunding = new ProviderFunding(string.Empty, deliveryUkprn, string.Empty, string.Empty)
            };
            var providerFundingAllocation2 = new ProviderFundingAllocation(string.Empty, string.Empty)
            {
                ProviderFunding = new ProviderFunding(string.Empty, deliveryUkprn2, string.Empty, string.Empty)
            };
            var fundingAllocationLines = Enumerable.Range(0, numberOfDeliverables)
                .Select(i => new FundingAllocationLine(string.Empty, string.Empty)).ToList();

            providerFundingAllocation1.ProviderFunding.FundingAllocationLines.AddRange(fundingAllocationLines);
            providerFundingAllocation2.ProviderFunding.FundingAllocationLines.AddRange(fundingAllocationLines);

            fundingAllocations[0].ProviderFundingAllocations.Add(providerFundingAllocation1);
            fundingAllocations[1].ProviderFundingAllocations.Add(providerFundingAllocation2);
            fundingAllocationLines.ForEach(fal => fal.FundingAllocationProfilePeriods.Add(new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202101, plannedValue)));

            int delCode = 1;
            FspCodeDeliverable GetFspAndDeliverableCode(ProviderFundingInfo d) => new FspCodeDeliverable("FSP1", delCode, $"some name{delCode++}", 1, fsCode, allocationPrefix);

            // act
            var contractAllocations = fundingAllocations.GetContractAllocationInfos(GetFspAndDeliverableCode);

            // assert
            Assert.AreEqual(2, contractAllocations.Count, "The number of allocations is incorrect");
            Assert.IsTrue(contractAllocations.All(ca => ca.Deliverables.Count == 2),
                "The allocations have the wrong number of deliverables");
        }
    }
}
