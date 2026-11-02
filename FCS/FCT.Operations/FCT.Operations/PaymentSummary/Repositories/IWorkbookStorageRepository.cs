namespace FCT.Operations.PaymentSummary.Repositories
{
    using Aspose.Cells;

    public interface IWorkbookStorageRepository
    {
        void Upload(Workbook workbook, string filename);

        bool Exists(string filename);

        byte[] GetWorkbookBytes(string filename);
    }
}