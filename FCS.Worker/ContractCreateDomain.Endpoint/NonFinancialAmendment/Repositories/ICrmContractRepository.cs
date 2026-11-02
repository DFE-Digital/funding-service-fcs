namespace ContractCreateDomain.Endpoint.NonFinancialAmendment.Repositories
{
    using Dtos;

    public interface ICrmContractRepository
    {
        bool IsContractApproved(string contractNumber, int versionNumber, int subversionNumber);

        bool IsContractApprovedWithSubstatus(string contractNumber, int versionNumber, int subversionNumber, string[] substatuses);

        void SetNonFinancialAmendmentFailedServiceResponseOnContract(string contractNumber, int versionNumber, int subVersionNumber);

        bool IsThereNoSubsequentDraftContracts(string contractNumber, int version, int subVersion);

        FundingTypeFundingPeriodKey GetFundingTypeFundingPeriodKeyForGivenContract(string contractNumber, int versionNumber, int subversionNumber);

        bool HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(string contractNumber);
    }
}