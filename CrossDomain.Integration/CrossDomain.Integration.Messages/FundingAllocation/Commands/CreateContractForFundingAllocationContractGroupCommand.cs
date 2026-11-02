namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using System.Collections.Generic;
    using Dtos;
    using Entities.CorporateContract;
    using Extensions;
    using LanguageExt;

    public class CreateContractForFundingAllocationContractGroupCommand
    {
        public IEnumerable<string> FundingAllocationIds { get; set; }

        public ContractItemsMappingResult ContractItemsMappings { get; set; }

        public ContractIntent ContractIntent { get; set; }

        public Option<CrmContractInfo> ContractInfoOption { get; set; }

        public override string ToString()
        {
            return $"Funding Ids: {FundingAllocationIds.ToCsv()}, Contract Item Mappings: {ContractItemsMappings}, ContractIntent: {ContractIntent}, ContractInfo: {ContractInfoOption}";
        }
    }
}
