namespace FundingAllocation.Dto
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class FundingAllocationValidationInput
    {
        public FundingAllocationValidationInput(string fundingId, ContractItemsMappingInput mappingInput, IReadOnlyCollection<string> fundingLineCodes)
        {
            FundingId = fundingId;
            MappingInput = mappingInput;
            FundingLineCodes = fundingLineCodes;
        }

        public string FundingId { get; }
        public ContractItemsMappingInput MappingInput { get; }
        public IReadOnlyCollection<string> FundingLineCodes { get; }
    }
}
