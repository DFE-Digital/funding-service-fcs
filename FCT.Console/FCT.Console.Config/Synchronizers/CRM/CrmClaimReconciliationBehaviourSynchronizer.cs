namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using Readers;
    using Writers;
    using Writers.CRM;

    public class CrmClaimReconciliationBehaviourSynchronizer : ClaimReconciliationBehaviourReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            new CrmClaimReconciliationBehaviourWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            new CrmClaimReconciliationBehaviourWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.Delete);
        }
    }
}