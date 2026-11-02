namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    using System.Collections.Generic;

    public class GetUpdateDraftContractValidationReferenceDataComplete
    {
        public IEnumerable<string> ContractTypes { get; set; }

        public IEnumerable<string> LepCodes { get; set; }

        public IEnumerable<string> UopCodes { get; set; } 
    }
}
