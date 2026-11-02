namespace FCT.Operations.Repositories
{
    using Infrastructure;

    public class WorkbookSharePointRepository : IWorkbookSharePointRepository
    {
        private readonly IOffice365StorageWrapper _office365Adapter;

        public WorkbookSharePointRepository(IOffice365StorageWrapper office365Adapter)
        {
            _office365Adapter = office365Adapter;
        }

        public void Upload(string folderName, string filename, byte[] bytes)
        {
            if (!_office365Adapter.DoesFolderExist(folderName))
            {
                _office365Adapter.CreateFolder(folderName);
            }

            _office365Adapter.UpsertFile(filename, bytes, folderName);
        }
    }
}