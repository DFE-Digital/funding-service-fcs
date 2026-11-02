namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.CRM;

    public class CrmFspDeliverableSynchronizer : FundingStreamPeriodDeliverablesReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            new CrmFspDeliverableWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            new CrmFspDeliverableWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.Delete);
        }
    }
}
