namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.CRM;

    public class CrmFspGroupSynchronizer : FspGroupReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            var sheetObjects = ReadConfig(worksheetReader);

            new CrmFspGroupWriter().WriteToCrmDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            var sheetObjects = ReadConfig(worksheetReader);

            new CrmFspGroupWriter().WriteToCrmDatabase(sheetObjects, WriterBehaviour.Delete);
        }
    }
}
