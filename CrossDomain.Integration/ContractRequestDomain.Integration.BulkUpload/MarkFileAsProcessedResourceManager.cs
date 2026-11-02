namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using System.Transactions;
    using BusinessLogic.Interfaces;

    public class MarkFileAsProcessedResourceManager : IEnlistmentNotification
    {
        private IBulkUploadFileAccess _bulkUploadFileAccess;
        private string _filename;

        public MarkFileAsProcessedResourceManager(IBulkUploadFileAccess bulkUploadFileAccess, string filename)
        {
            _bulkUploadFileAccess = bulkUploadFileAccess;
            _filename = filename;
        }

        public void Commit(Enlistment enlistment)
        {
            enlistment.Done();
        }

        public void InDoubt(Enlistment enlistment)
        {
            enlistment.Done();
        }

        public void Prepare(PreparingEnlistment preparingEnlistment)
        {
            _bulkUploadFileAccess.MarkFileAsRetrieved(_filename);
            preparingEnlistment.Prepared();
        }

        public void Rollback(Enlistment enlistment)
        {
            enlistment.Done();
        }
    }
}
