namespace ContractCreateDomain.Endpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractTypeTransformer
    {
        Contract TransformContractTypeToContract(contractType contractType);
        ExtendedContractType TransformContractTypeToExtendedContractType(contractType contractType);
        ContractRequest.contractType TransformCorpContractToContractRequest(CorporateContract.contractType contractType);
    }
}