namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtClaimReconciliationDeliverableGroupSynchronizer : ClaimReconciliationDelGroupsReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationDelGroupsSheetType> rows = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationDelGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationDelGroupsSheetType> rows = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationDelGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);
        }
    }
}
