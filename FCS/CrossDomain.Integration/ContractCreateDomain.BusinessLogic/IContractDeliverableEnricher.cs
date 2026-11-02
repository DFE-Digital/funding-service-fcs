namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractDeliverableEnricher
    {
        void Enrich(contractType masterContract);

        void Enrich(ExtendedContractType masterContract);
    }
}
