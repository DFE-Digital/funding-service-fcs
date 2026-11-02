namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class MonitoringDeliverablesFundingStreamPeriodSynchronizer : FundingStreamPeriodReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodSheetType> sheetObjects = ReadConfig(worksheetReader);

            MonitoringDeliverablesFundingStreamPeriodWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodSheetType> sheetObjects = ReadConfig(worksheetReader);

            MonitoringDeliverablesFundingStreamPeriodWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.Delete);
        }
    }
}
