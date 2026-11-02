namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtFspDeliverableClaimSynchronizer : FundingStreamPeriodDeliverablesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fspDeliverableClaims = ReadConfig(worksheetReader);

            PerfMgmtFspDeliverableClaimWriter.WriteToPaaSDatabase(fspDeliverableClaims, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fspDeliverableClaims = ReadConfig(worksheetReader);

            PerfMgmtFspDeliverableClaimWriter.WriteToPaaSDatabase(fspDeliverableClaims, WriterBehaviour.Delete);
        }
    }
}