namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using CrossDomain.Integration.Entities.CorporateContract;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;

    public interface IContractValueAggregator
    {
        void Aggregate(ExtendedContractType masterContract);

        void Aggregate(contractType masterContract);

        void UpdateValueVariance(ExtendedContractType contractWithNewValues, ContractRequest.contractType contractWithOldValues);
    }
}