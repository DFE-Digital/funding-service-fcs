namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class MonitoringDeliverablesFundingStreamPeriodDeliverableSynchronizer : FundingStreamPeriodDeliverablesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverables = ReadConfig(worksheetReader);

            MonitoringDeliverablesFundingStreamPeriodDeliverableWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverables = ReadConfig(worksheetReader);

            MonitoringDeliverablesFundingStreamPeriodDeliverableWriter.WriteToPaaSDatabase(fundingStreamPeriodDeliverables, WriterBehaviour.Delete);
        }
    }
}