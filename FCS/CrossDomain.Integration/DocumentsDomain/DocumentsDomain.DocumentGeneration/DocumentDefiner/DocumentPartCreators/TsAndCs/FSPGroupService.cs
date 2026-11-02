namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.TsAndCs
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using DataStore.Repositories;

    public static class FSPGroupService
    {
        public static IReadOnlyCollection<FSPGroup> GetFspGroupsNewToTheContract(contractType contract, IFundingStreamPeriodRepository fundingStreamPeriodRepository)
        {
            var fspCodesWithHasBeenAddedOnContract = contract.contractAllocations.Select(ca => new {ca.fundingStreamPeriodCode, ca.HasBeenAdded})
                .Distinct()
                .ToList();

            var fspsWithGroups = fundingStreamPeriodRepository.GetFspsWithGroups(fspCodesWithHasBeenAddedOnContract.Select(f => f.fundingStreamPeriodCode));

            var fsps = fspCodesWithHasBeenAddedOnContract
                .Select(fspOnContract => new
                {
                    FspInfoOnContact = fspOnContract,
                    Fsp = fspsWithGroups.Single(fspWithGroup => fspWithGroup.FundingStreamPeriodCode == fspOnContract.fundingStreamPeriodCode)
                })
               .ToList();

            var fspGroupsWithAllAdded = fsps.GroupBy(fsp => fsp.Fsp.FSPGroupCode)
                .Where(g => g.All(a => a.FspInfoOnContact.HasBeenAdded))
                .SelectMany(g => g.Select(a => a.Fsp.FspGroup))
                .Distinct()
                .ToList();

            return fspGroupsWithAllAdded;
        }
    }
}
