namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using Readers;
    using ExcelTypes;
    using Writers;
    using Writers.PAAS;

    public class PolicyCacheFundingStreamPeriodSynchronizer : FundingStreamPeriodReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodSheetType> fundingStreamPeriods = ReadConfig(worksheetReader);

            PolicyFundingStreamPeriodWriter.WriteToPaaSDatabase(fundingStreamPeriods, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodSheetType> fundingStreamPeriods = ReadConfig(worksheetReader);

            PolicyFundingStreamPeriodWriter.WriteToPaaSDatabase(fundingStreamPeriods, WriterBehaviour.Delete);
        }
    }
}
