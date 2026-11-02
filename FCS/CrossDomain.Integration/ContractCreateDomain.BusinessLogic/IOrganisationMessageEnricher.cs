namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public interface IOrganisationMessageEnricher
    {
        void Enrich(contractRequestType masterContract);
    }
}
