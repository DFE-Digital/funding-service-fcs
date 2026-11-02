namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Optional;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class RelatedAllocationEnricher
    {
        private static readonly string[] FundingTypesWithRelatedAllocations = { "AEB", "NLA" };

        private static readonly Dictionary<string, RelatedAllocationInfo> FspsToHaveAllocationNumberReplaced = new Dictionary<string, RelatedAllocationInfo>
        {
            {"ANLAP-AS2019", new RelatedAllocationInfo("NONLEVY2019", getDataFromStorage:true)},
            {"16-18NLAP-AS2019", new RelatedAllocationInfo("NONLEVY2019", getDataFromStorage: true)},
            {"AEB-PRS1920", new RelatedAllocationInfo("AEB-AS1920")},
            {"AEB-PRS2021", new RelatedAllocationInfo("AEB-AS2021")},
            {"16-18NLAP-PRS2020", new RelatedAllocationInfo("16-18NLAP2018")},
            {"ANLAP-PRS2020", new RelatedAllocationInfo("ANLAP2018")}
        };

        public static async Task EnrichWithRelatedAllocationsWhenAppropriate(contract corpContract, ILogger logger, IApprovedContractRepository approvedContractRepository, ConnectionInfo connectionInfo)
        {
            if (FundingTypesWithRelatedAllocations.Contains(corpContract.fundingType.fundingTypeCode))
            {
                var allocationsThatRequireNewNumbers = corpContract.contractAllocations
                    .Where(a => FspsToHaveAllocationNumberReplaced.Keys.Contains(a.fundingStreamPeriodCode))
                    .ToList();

                foreach (var allocationThatRequireNewNumber in allocationsThatRequireNewNumbers)
                {
                    RelatedAllocationInfo relatedAllocationInfo = FspsToHaveAllocationNumberReplaced[allocationThatRequireNewNumber.fundingStreamPeriodCode];
                    var optionalAlternativeAllocationNumber = await GetAlternativeAllocationNumber(
                        relatedAllocationInfo.GetDataFromStorage,
                        relatedAllocationInfo.RelatedFsp,
                        corpContract,
                        approvedContractRepository,
                        corpContract.contractor.ukprn,
                        connectionInfo);

                    var alternativeAllocationNumber = optionalAlternativeAllocationNumber.ValueOr(() => null);

                    logger.LogInformation(1, $"Increment:RelatedAllocationEnricher - allocation: {allocationThatRequireNewNumber.contractAllocationNumber}, related: {alternativeAllocationNumber}");

                    allocationThatRequireNewNumber.OriginalAllocationNumber = allocationThatRequireNewNumber.contractAllocationNumber;
                    allocationThatRequireNewNumber.contractAllocationNumber = alternativeAllocationNumber;
                }
            }
        }

        public static void EnrichWithRelatedAllocationsWhenAppropriate(ApprovedContractInfo contract)
        {
            if (FundingTypesWithRelatedAllocations.Contains(contract.FundingType))
            {
                contract.Allocations
                    .Where(a => FspsToHaveAllocationNumberReplaced.Keys.Contains(a.FundingStreamPeriodCode))
                    .ToList()
                    .ForEach(a =>
                    {
                        RelatedAllocationInfo relatedAllocationInfo = FspsToHaveAllocationNumberReplaced[a.FundingStreamPeriodCode];
                        ApprovedContractAllocationInfo relatedAllocation = contract.Allocations
                            .SingleOrDefault(ra => ra.FundingStreamPeriodCode == relatedAllocationInfo.RelatedFsp);
                        a.ContractAllocationNumber = relatedAllocation?.ContractAllocationNumber;
                    });
            }
        }

        private static async Task<Option<string>> GetAlternativeAllocationNumber(
            bool getDataFromStorage,
            string relatedFsp,
            contract corpContract,
            IApprovedContractRepository approvedContractRepository,
            int ukprn,
            ConnectionInfo connectionInfo)
        {
            if (getDataFromStorage)
            {
                return await approvedContractRepository
                    .FindAllocationNumberByUkprnAndFspCodeForLatestApproval(ukprn, relatedFsp, connectionInfo);
            }

            contractAllocationsContractAllocation relatedAllocation = corpContract.contractAllocations
                .SingleOrDefault(ra => ra.fundingStreamPeriodCode == relatedFsp);

            return (relatedAllocation?.contractAllocationNumber).SomeWhen(a => a != null);
        }

        private class RelatedAllocationInfo
        {
            public RelatedAllocationInfo(string relatedFsp)
            {
                RelatedFsp = relatedFsp;
            }

            public RelatedAllocationInfo(string relatedFsp, bool getDataFromStorage) : this(relatedFsp)
            {
                GetDataFromStorage = getDataFromStorage;
            }

            public string RelatedFsp { get; }

            public bool GetDataFromStorage { get; }
        }
    }
}