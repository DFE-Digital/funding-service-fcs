namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using DTOs;

    public interface ISagaDataStorage
    {
        void UploadSagaData<T>(string key, T sagaData) where T : IHttpStorageValue;

        T GetSagaData<T>(string key) where T : IHttpStorageValue;
    }
}
