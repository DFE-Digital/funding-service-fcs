namespace ContractCreateDomain.Endpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IValueVariationService
    {
        void UpdateValueVariation(ExtendedContractType contractWithNewValues);
    }
}