namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class DocumentsDomainFundingTypeFundingPeriodSynchronizer : FundingTypePeriodReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingTypePeriodSheetType> fundingTypeFundingPeriods = ReadConfig(worksheetReader);

            DocumentsDomainFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(fundingTypeFundingPeriods, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingTypePeriodSheetType> fundingTypeFundingPeriods = ReadConfig(worksheetReader);

            DocumentsDomainFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(fundingTypeFundingPeriods, WriterBehaviour.Delete);
        }
    }
}