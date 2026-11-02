namespace FCT.Console.Config.Synchronizers.PaaS
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FundingAllocationStatusSubStatusConfigSynchronizer: StatusSubStatusConfigReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            var allStatuses = ReadConfig();
            StatusSubStatusConfigWriter.WriteToPaaSDatabase(allStatuses, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            // Nothing to do
        }
    }
}
