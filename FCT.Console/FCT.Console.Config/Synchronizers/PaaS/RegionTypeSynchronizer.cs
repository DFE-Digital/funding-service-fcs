namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;
    public class RegionTypeSynchronizer : RegionTypeReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<RegionTypeSheetType> regionTypeRows = ReadConfig(worksheetReader);

            RegionTypeWriter.WriteToPaaSDatabase(regionTypeRows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<RegionTypeSheetType> regionTypeRows = ReadConfig(worksheetReader);

            RegionTypeWriter.WriteToPaaSDatabase(regionTypeRows, WriterBehaviour.Delete);
        }
    }
}
