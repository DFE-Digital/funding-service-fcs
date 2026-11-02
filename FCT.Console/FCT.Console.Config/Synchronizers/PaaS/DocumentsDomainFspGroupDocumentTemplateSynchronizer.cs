namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class DocumentsDomainFspGroupDocumentTemplateSynchronizer : FspGroupDocumentTemplateReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FspGroupDocumentTemplateSheetType> sheetTypes = ReadConfig(worksheetReader);

            DocumentsDomainFspGroupDocumentTemplateWriter.WriteToPaaSDatabase(sheetTypes,
                WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            // Delete not required. 
            // AddOrUpdateConfig method resets the whole table and adds the necessary rows.
        }
    }
}