namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories;
    using TechTalk.SpecFlow;
    using NUnit.Framework.Legacy;

    [Binding]
    public class FundingClaimReconcilationSteps
    {
        [Then(@"there is no claim data in the PaaS funding claim tables for any of the following")]
        [Then(@"there is no claim data in the PaaS funding claim reconciliation tables for any of the following")]
        public void ThenThereIsNoClaimDataInThePaaSFundingClaimTablesForAnyOfTheFollowing(Table table)
        {
            IReadOnlyCollection<FundingClaimAllocationInfo> expectedFundingClaimAllocations = table.Rows
                .Select(r => new FundingClaimAllocationInfo(
                    r["UKPRN"],
                    r["FundingPeriod"],
                    r["FundingClaimType"],
                    r["AllocationRef"]))
                .ToList();

            expectedFundingClaimAllocations.ForEach(fca =>
            {
                bool isPresent = FundingClaimRepository.IsFundingClaimAllocationPresent(
                    ukprn: int.Parse(fca.Ukprn),
                    period: fca.FundingPeriod,
                    claimType: fca.FundingClaimType.Replace(" ", string.Empty).ToUpper(),
                    allocationNumber: fca.AllocationRef);

                ClassicAssert.IsFalse(isPresent, $"The Funding Claim Allocation is present (it should be) - {fca}");
            });
        }

        private class FundingClaimAllocationInfo
        {
            public FundingClaimAllocationInfo(string ukprn, string fundingPeriod, string fundingClaimType, string allocationRef)
            {
                Ukprn = ukprn;
                FundingPeriod = fundingPeriod;
                FundingClaimType = fundingClaimType;
                AllocationRef = allocationRef;
            }

            public string Ukprn { get; }

            public string FundingPeriod { get; }

            public string FundingClaimType { get; }

            public string AllocationRef { get; }

            public override string ToString()
            {
                return $"Ukprn: {Ukprn}, FundingPeriod: {FundingPeriod}, FundingClaimType: {FundingClaimType}, AllocationRef: {AllocationRef}";
            }
        }
    }
}
