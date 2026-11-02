namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using System.Collections.Generic;
    using Dtos;
    using Entities.CorporateContract;
    using Extensions;

    public class UpdateContractWithFundingAllocationsCommand
    {
        public UpdateContractWithFundingAllocationsCommand(CrmContractInfo crmContractInfo, int contractingUkprn, ContractIntent contractIntent, 
            ContractItemsMappingResult contractItemsMappings, IEnumerable<string> fundingIds)
        {
            CrmContractInfo = crmContractInfo;
            ContractingUkprn = contractingUkprn;
            ContractIntent = contractIntent;
            ContractItemsMappings = contractItemsMappings;
            FundingIds = fundingIds;
        }

        public CrmContractInfo CrmContractInfo { get; }

        public int ContractingUkprn { get; }

        public ContractIntent ContractIntent { get; }

        public ContractItemsMappingResult ContractItemsMappings { get; }

        public IEnumerable<string> FundingIds { get; }

        public override string ToString()
        {
            return $"CrmContractInfo: [{CrmContractInfo}], ContractingUkprn: {ContractingUkprn}, ContractIntent: {ContractIntent}, " +
                   $"ContractItemsMappings: [{ContractItemsMappings}], FundingIds: [{string.Join(", ", FundingIds.GetValueOrEmpty())}]";
        }
    }
}
