namespace SFA.FCT.ContractRequestDomain.BusinessLogic
{
    using CrossDomain.Integration.Entities.ExcelUpload;

    public class FscDataCache
    {
        public string Period { get; set; }

        public string PeriodType { get; set; }

        public string FundingType { get; set; }

        public FundingConfigurationType ReferenceData { get; set; }
    }
}
