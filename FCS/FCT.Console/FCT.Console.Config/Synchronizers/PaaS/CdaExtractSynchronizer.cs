namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class CdaExtractSynchronizer : CdaExtractReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<CdaExtractSheetType> sheetObjects = ReadConfig(worksheetReader);

            CdaExtractWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<CdaExtractSheetType> sheetObjects = ReadConfig(worksheetReader);

            CdaExtractWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.Delete);
        }
    }
}