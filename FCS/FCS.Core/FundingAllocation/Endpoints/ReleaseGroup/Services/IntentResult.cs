namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using LanguageExt;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class IntentResult
    {
        public IntentResult(ContractIntent intent, CrmContractInfo existingCrmContract)
        {
            Intent = intent;
            ExistingCrmContract = existingCrmContract;
        }

        public ContractIntent Intent { get; }

        public Option<CrmContractInfo> ExistingCrmContract { get;  }
    }
}
