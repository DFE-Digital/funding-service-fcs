namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using Dto;
    using LanguageExt;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using System.Threading.Tasks;

    public interface IContractNumbersAndVersionIntentService
    {
        Task<(string contractNumber, string masterContractNumber, int version)> GetContractNumberReferencesAndVersion(ContractIntent contractIntent, Option<CrmContractInfo> contractInfoOption, string fundingTypeCode);
    }
}