namespace Operations.Worker.Storage
{
    public interface ILargeMessageStorageService
    {
        void StoreMessageBody(string key, byte[] bytes);
        byte[] GetMessageBody(string key);
    }
}
