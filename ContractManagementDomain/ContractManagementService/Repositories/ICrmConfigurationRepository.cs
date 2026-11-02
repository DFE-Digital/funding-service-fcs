namespace ContractManagementService.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    public interface ICrmConfigurationRepository
    {
        Task<FundingConfigurationType> GetFundingConfiguration(string period, string periodType, string fundingType);
        Task<FSCDeliverableStructureDefinitionResponse> GetDeliverableConfiguration(string fundingStreamPeriodCode);
    }
}