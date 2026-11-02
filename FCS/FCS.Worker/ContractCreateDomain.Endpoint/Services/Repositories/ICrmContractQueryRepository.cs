namespace ContractCreateDomain.Endpoint.Services.Repositories
{
    using DTOs;
    using Optional;

    public interface ICrmContractQueryRepository
    {
        Option<CrmContract> GetApprovedContract(string contractNumber);

        bool HasSiblingContractWithDraftStatus(string masterContractNumber, string contractNumber);

    }
}