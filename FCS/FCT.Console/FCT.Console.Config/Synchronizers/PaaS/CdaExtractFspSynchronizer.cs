namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class CdaExtractFspSynchronizer : CdaExtractFspReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<CdaExtractFspSheetType> sheetObjects = ReadConfig(worksheetReader);

            CdaExtractFspWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<CdaExtractFspSheetType> sheetObjects = ReadConfig(worksheetReader);

            CdaExtractFspWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.Delete);
        }
    }
}