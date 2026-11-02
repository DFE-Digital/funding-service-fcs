namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtClaimReconciliationAllocationGroupSynchronizer : ClaimReconciliationAllocationGroupReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationAllocationGroupSheetType> claimReconciliationAllocationGroups = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationAllocationGroupWriter.WriteToPaaSDatabase(claimReconciliationAllocationGroups, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconciliationAllocationGroupSheetType> claimReconciliationAllocationGroups = ReadConfig(worksheetReader);

            PerfMgmtClaimReconciliationAllocationGroupWriter.WriteToPaaSDatabase(claimReconciliationAllocationGroups, WriterBehaviour.Delete);
        }
    }
}
