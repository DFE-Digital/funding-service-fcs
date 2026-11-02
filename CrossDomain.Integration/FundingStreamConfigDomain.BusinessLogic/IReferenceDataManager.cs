namespace SFA.FCT.FundingStreamConfigDomain.BusinessLogic
{
    using CrossDomain.Integration.Entities.ExcelUpload;

    public interface IReferenceDataManager
    {
        FundingConfigurationType GetFundingConfiguration(string period, string periodType, string fundingType);
    }
}
