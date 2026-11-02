namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtClaimReconciliationBehaviourSynchronizer : ClaimReconciliationBehaviourReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourTypes = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationBehaviourWriter.WriteToPaaSDatabase(claimReconciliationBehaviourTypes, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationBehaviourSheetType> claimReconciliationBehaviourTypes = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationBehaviourWriter.WriteToPaaSDatabase(claimReconciliationBehaviourTypes, WriterBehaviour.Delete);
        }
    }
}
