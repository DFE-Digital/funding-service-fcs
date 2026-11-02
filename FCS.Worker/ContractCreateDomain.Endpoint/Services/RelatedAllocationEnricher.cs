namespace ContractCreateDomain.Endpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Optional;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class RelatedAllocationEnricher : IRelatedAllocationEnricher
    {
        private static readonly string[] FundingTypesWithRelatedAllocations = {"AEB", "NLA"};

        private readonly IApprovedContractRepository _approvedContractRepository;

        public RelatedAllocationEnricher(IApprovedContractRepository approvedContractRepository)
        {
            _approvedContractRepository = approvedContractRepository;
        }

        public async Task EnrichWithRelatedAllocationsWhenAppropriate(contract corpContract, ConnectionInfo connectionInfo)
        {
            var fspsToHaveAllocationNumberReplaced = new Dictionary<string, RelatedAllocationInfo>
            {
                {"ANLAP-AS2019", new RelatedAllocationInfo("NONLEVY2019", (c, relatedFsp) => GetRelatedAllocationNumberFromLastApprovedStorage(c, relatedFsp, connectionInfo))},
                {"16-18NLAP-AS2019", new RelatedAllocationInfo("NONLEVY2019", (c, relatedFsp) => GetRelatedAllocationNumberFromLastApprovedStorage(c, relatedFsp, connectionInfo))},
                {"AEB-PRS1920", new RelatedAllocationInfo("AEB-AS1920", GetRelatedAllocationNumberFromInMemoryContract)},
                {"AEB-PRS2021", new RelatedAllocationInfo("AEB-AS2021", GetRelatedAllocationNumberFromInMemoryContract)},
                {"16-18NLAP-PRS2020", new RelatedAllocationInfo("16-18NLAP2018", GetRelatedAllocationNumberFromInMemoryContract)},
                {"ANLAP-PRS2020", new RelatedAllocationInfo("ANLAP2018", GetRelatedAllocationNumberFromInMemoryContract)}
            };

            if (FundingTypesWithRelatedAllocations.Contains(corpContract.fundingType.fundingTypeCode))
            {
                var allocationsToHaveNumbersReplaced = corpContract.contractAllocations
                    .Where(a => fspsToHaveAllocationNumberReplaced.Keys.Contains(a.fundingStreamPeriodCode))
                    .ToList();

                foreach (var allocationToHaveNumbersReplaced in allocationsToHaveNumbersReplaced)
                {
                    var relatedAllocationInfo = fspsToHaveAllocationNumberReplaced[allocationToHaveNumbersReplaced.fundingStreamPeriodCode];

                    var allocationNumberOption = await relatedAllocationInfo.GetRelatedAllocationNumber(
                        corpContract,
                        relatedAllocationInfo.RelatedFsp
                       );
                    allocationToHaveNumbersReplaced.OriginalAllocationNumber =
                        allocationToHaveNumbersReplaced.contractAllocationNumber;

                    allocationToHaveNumbersReplaced.contractAllocationNumber = allocationNumberOption.ValueOr(() => null);
                }
            }
        }

        public void EnrichWithRelatedAllocationsWhenAppropriate(ApprovedContractInfo contract)
        {
            var fspsToHaveAllocationNumberReplaced = new Dictionary<string, RelatedAllocationInfo>
            {
                {"ANLAP-AS2019", new RelatedAllocationInfo("NONLEVY2019")},
                {"16-18NLAP-AS2019", new RelatedAllocationInfo("NONLEVY2019")},
                {"AEB-PRS1920", new RelatedAllocationInfo("AEB-AS1920")},
                {"AEB-PRS2021", new RelatedAllocationInfo("AEB-AS2021")},
                {"16-18NLAP-PRS2020", new RelatedAllocationInfo("16-18NLAP2018")},
                {"ANLAP-PRS2020", new RelatedAllocationInfo("ANLAP2018")}
            };

            if (FundingTypesWithRelatedAllocations.Contains(contract.FundingType))
            {
                contract.Allocations
                    .Where(a => fspsToHaveAllocationNumberReplaced.Keys.Contains(a.FundingStreamPeriodCode))
                    .ToList()
                    .ForEach(a =>
                    {
                        RelatedAllocationInfo relatedAllocationInfo = fspsToHaveAllocationNumberReplaced[a.FundingStreamPeriodCode];
                        ApprovedContractAllocationInfo relatedAllocation = contract.Allocations
                            .SingleOrDefault(ra => ra.FundingStreamPeriodCode == relatedAllocationInfo.RelatedFsp);
                        a.ContractAllocationNumber = relatedAllocation?.ContractAllocationNumber;
                    });
            }
        }

        private async Task<Option<string>> GetRelatedAllocationNumberFromLastApprovedStorage(contract corpContract, string relatedFsp, ConnectionInfo connectionInfo)
        {
            return await _approvedContractRepository.FindAllocationNumberByUkprnAndFspCodeForLatestApproval(
                corpContract.contractor.ukprn,
                relatedFsp,
                connectionInfo);
        }

        private static Task<Option<string>> GetRelatedAllocationNumberFromInMemoryContract(contract corpContract, string relatedFsp)
        {
            var allocationNumber = corpContract.contractAllocations
                .SingleOrDefault(a => a.fundingStreamPeriodCode == relatedFsp)?.contractAllocationNumber;

            return Task.FromResult(allocationNumber.SomeNotNull());
        }

        private class RelatedAllocationInfo
        {
            public RelatedAllocationInfo(string relatedFsp)
            {
                RelatedFsp = relatedFsp;
            }

            public RelatedAllocationInfo(string relatedFsp, Func<contract, string, Task<Option<string>>> getRelatedAllocationNumber)
            {
                RelatedFsp = relatedFsp;
                GetRelatedAllocationNumber = getRelatedAllocationNumber;
            }

            public string RelatedFsp { get; }

            public Func<contract, string, Task<Option<string>>> GetRelatedAllocationNumber { get; }
        }
    }
}
