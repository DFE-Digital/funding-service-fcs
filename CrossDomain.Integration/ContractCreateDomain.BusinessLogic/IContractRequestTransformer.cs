namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System.Collections.Generic;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractRequestTransformer
    {
        CorporateContract.ExtendedContractType TransformToCorpContractType(ContractRequest.contractRequestType contractRequestType);

        CorporateContract.Contract TransformToCorpContract(CorporateContract.ExtendedContractType extendedContractType);

        ContractRequest.contractType TransformAllocationsToContractRequestContract(IEnumerable<ContractRequest.AllocationValueData> allocationValueDataItems, string contractNumber, int ukprn);
    }
}
