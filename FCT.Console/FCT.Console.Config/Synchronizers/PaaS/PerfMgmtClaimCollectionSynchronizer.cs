namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtClaimCollectionSynchronizer : ClaimCollectionsReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimCollectionsSheetType> claimCollections = ReadConfig(worksheetReader);

            PerfMgmtClaimCollectionWriter.WriteToPaaSDatabase(claimCollections, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimCollectionsSheetType> claimCollections = ReadConfig(worksheetReader);

            PerfMgmtClaimCollectionWriter.WriteToPaaSDatabase(claimCollections, WriterBehaviour.Delete);
        }
    }
}
