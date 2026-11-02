namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypePeriodService
    {
        Task EnrichContract(ExtendedContractType extendedContractType, ConnectionInfo connectionInfo);
    }
}