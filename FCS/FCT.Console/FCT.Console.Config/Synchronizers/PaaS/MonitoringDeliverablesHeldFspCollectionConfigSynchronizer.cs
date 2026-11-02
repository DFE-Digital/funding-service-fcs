namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class MonitoringDeliverablesHeldFspCollectionConfigSynchronizer : ActualsCollectionReturnsReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ActualsCollectionReturnsSheetType> actualsCollectionReturns = ReadConfig(worksheetReader);

            MonitoringDeliverablesHeldFspCollectionConfigWriter.WriteToPaaSDatabase(actualsCollectionReturns, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ActualsCollectionReturnsSheetType> actualsCollectionReturns = ReadConfig(worksheetReader);

            MonitoringDeliverablesHeldFspCollectionConfigWriter.WriteToPaaSDatabase(actualsCollectionReturns, WriterBehaviour.Delete);
        }
    }
}