namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.CRM;

    public class CrmFundingStreamPeriodCappingGroupSynchronizer : FundingStreamPeriodCappingGroupsReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            new CrmFundingStreamPeriodCappingGroupWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            new CrmFundingStreamPeriodCappingGroupWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.Delete);
        }
    }
}
