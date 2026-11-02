namespace SFA.FCT.Operations.Integrity.Storage
{
    public interface ICheckerDocumentStoreWriter
    {
        void WriteCheckerResult(byte[] document, string filename);
    }
}
