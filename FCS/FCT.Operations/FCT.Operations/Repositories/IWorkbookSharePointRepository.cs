namespace FCT.Operations.Repositories
{
    public interface IWorkbookSharePointRepository
    {
        void Upload(string folderName, string filename, byte[] bytes);
    }
}