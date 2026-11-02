namespace SFA.FCT.Contracts.AcceptanceTests.Utilities.DTO
{
    public class CfsCodesToContractTypeConfig
    {
        // This relates to PC-CT tab in config workbook
        public string FundingTypeCode { get; set; }
        public string FundingPeriodCode { get; set; }
        public string ProviderCategory { get; set; }
        public string ContractType { get; set; }
        public PolicyStatus PolicyStatus { get; set; }
    }
}