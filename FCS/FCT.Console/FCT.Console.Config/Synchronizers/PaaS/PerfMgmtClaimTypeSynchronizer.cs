namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PerfMgmtClaimTypeSynchronizer : ClaimTypeReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimTypeSheetType> claimTypes = ReadConfig(worksheetReader);

            PerfMgmtClaimTypeWriter.WriteToPaaSDatabase(claimTypes, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ClaimTypeSheetType> claimTypes = ReadConfig(worksheetReader);

            PerfMgmtClaimTypeWriter.WriteToPaaSDatabase(claimTypes, WriterBehaviour.Delete);
        }
    }
}
