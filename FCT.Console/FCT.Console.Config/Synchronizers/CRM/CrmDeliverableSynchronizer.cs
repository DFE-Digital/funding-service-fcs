namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.CRM;

    public class CrmDeliverableSynchronizer : DeliverablesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            new CrmDeliverableWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            new CrmDeliverableWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.Delete);
        }
    }
}
