namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtFundingStreamPeriodSynchronizer : FundingStreamPeriodReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodSheetType> fspDeliverableClaims = ReadConfig(worksheetReader);

            PerfMgmtFundingStreamPeriodWriter.WriteToPaaSDatabase(fspDeliverableClaims, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodSheetType> fspDeliverableClaims = ReadConfig(worksheetReader);

            PerfMgmtFundingStreamPeriodWriter.WriteToPaaSDatabase(fspDeliverableClaims, WriterBehaviour.Delete);
        }
    }
}