namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using Readers;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Writers;
    using Writers.CRM;

    public class CrmClaimReconciliationPublicationExceptionSynchronizer : ClaimReconciliationPublicationExceptionReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            CrmTableCleaner.DeleteAllRows(sfa_claimreconciliationpublicationexception.EntityLogicalName, CrmHelper.GetConnection());
            new CrmClaimReconciliationPublicationExceptionWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            // Delete not required. 
            // AddOrUpdateConfig method resets the whole table and adds the necessary rows.
        }
    }
}
