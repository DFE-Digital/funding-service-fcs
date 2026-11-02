namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtClaimReconciliationPublicationExceptionSynchronizer : ClaimReconciliationPublicationExceptionReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationPublicationExceptionSheetType> rows = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationPublicationExceptionWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            // Delete not required. 
            // AddOrUpdateConfig method resets the whole table and adds the necessary rows.
        }
    }
}
