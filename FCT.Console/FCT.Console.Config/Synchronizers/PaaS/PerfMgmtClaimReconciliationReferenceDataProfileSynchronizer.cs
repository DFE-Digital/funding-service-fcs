namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtClaimReconciliationReferenceDataProfileSynchronizer : ClaimReconciliationReferenceDataProfilesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationReferenceDataProfileSheetType> rows = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationReferenceDataProfileWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationReferenceDataProfileSheetType> rows = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationReferenceDataProfileWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);
        }
    }
}
