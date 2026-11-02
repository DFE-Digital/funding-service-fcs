namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using CrossDomain.Integration.Events;

    public interface IContractValidator
    {
        void Enrich(NewContractRequestEvent message);
    }
}
