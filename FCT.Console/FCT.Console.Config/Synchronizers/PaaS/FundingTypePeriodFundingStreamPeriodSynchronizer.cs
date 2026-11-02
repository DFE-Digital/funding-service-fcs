namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FundingTypePeriodFundingStreamPeriodSynchronizer : FundingTypePeriodFundingStreamPeriodReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingTypePeriodFundingStreamPeriodSheetType> fundingTypePeriodFundingStreamPeriods =
                ReadConfig(worksheetReader);

            FundingTypePeriodFundingStreamPeriodWriter.WriteToPaaSDatabase(fundingTypePeriodFundingStreamPeriods, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingTypePeriodFundingStreamPeriodSheetType> fundingTypePeriodFundingStreamPeriods =
                ReadConfig(worksheetReader);

            FundingTypePeriodFundingStreamPeriodWriter.WriteToPaaSDatabase(fundingTypePeriodFundingStreamPeriods, WriterBehaviour.Delete);
        }
    }
}