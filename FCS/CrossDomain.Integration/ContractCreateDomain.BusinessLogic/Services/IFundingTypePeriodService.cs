namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public interface IFundingTypePeriodService
    {
        void EnrichContract(ExtendedContractType extendedContractType);
    }
}
