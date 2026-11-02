namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtClaimReconAllocGroupFSPsSynchronizer : ClaimReconAllocGroupFSPsReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconAllocGroupFSPSheetType> claimReconAllocGroupFSPs = ReadConfig(worksheetReader);

            PerfMgmtClaimReconAllocGroupFSPsWriter.WriteToPaaSDatabase(claimReconAllocGroupFSPs, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimReconAllocGroupFSPSheetType> claimReconAllocGroupFSPs = ReadConfig(worksheetReader);

            PerfMgmtClaimReconAllocGroupFSPsWriter.WriteToPaaSDatabase(claimReconAllocGroupFSPs, WriterBehaviour.Delete);
        }
    }
}
