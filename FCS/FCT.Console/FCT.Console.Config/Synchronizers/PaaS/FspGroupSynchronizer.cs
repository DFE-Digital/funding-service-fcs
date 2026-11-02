namespace FCT.Console.Config.Synchronizers.PaaS
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FspGroupSynchronizer : FspGroupReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            var sheetObjects = ReadConfig(worksheetReader);

            FspGroupWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            var sheetObjects = ReadConfig(worksheetReader);

            FspGroupWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.Delete);
        }
    }
}
