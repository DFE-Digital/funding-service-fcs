namespace FundingAllocation.Dto
{
    using System.Collections.Generic;
    using Extensions;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class FundingAllocationContractGroup
    {
        public FundingAllocationContractGroup(int contractingUkprn, string fundingType, string fundingPeriod, IReadOnlyCollection<string> fundingAllocationIds, ContractItemsMappingResult contractItemsMappings)
        {
            ContractingUkprn = contractingUkprn;
            FundingType = fundingType;
            FundingPeriod = fundingPeriod;
            FundingAllocationIds = fundingAllocationIds;
            ContractItemsMappings = contractItemsMappings;
        }

        public int ContractingUkprn { get; }
        public string FundingType { get; }
        public string FundingPeriod { get; }
        public IReadOnlyCollection<string> FundingAllocationIds { get; }
        public ContractItemsMappingResult ContractItemsMappings { get; }

        public override string ToString()
        {
            return $"ContractingUkprn: {ContractingUkprn}, FundingType: {FundingType}, FundingPeriod: {FundingPeriod}" + 
                   $" ContractItemsMappings: [{ContractItemsMappings}], FundingAllocationIds: [{string.Join(", ", FundingAllocationIds.GetValueOrEmpty())}]";
        }
    }
}