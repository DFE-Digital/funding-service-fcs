namespace ContractCreateDomain.Endpoint.Infrastructure.DTOs
{
    using Newtonsoft.Json;

    public enum Intent
    {
        NotSet,
        New,
        Update,
        UpdateAmendment,
        Amendment,
        RevisedNew,
        NewAmendment
    }

    public class SagaStorageValue : IHttpStorageValue
    {
        private SagaStorageValue()
        {
        }

        public SagaStorageValue(string sagaDataAsJson, Intent intent)
        {
            SagaDataAsJson = sagaDataAsJson;
            Intent = intent;
        }

        public SagaStorageValue(object sagaData, Intent intent)
        {
            SagaDataAsJson = JsonConvert.SerializeObject(sagaData);
            Intent = intent;
        }

        public string SagaDataAsJson { get; set; }

        public Intent Intent { get; set; }
        public string Etag { get; set; }
    }

    public interface IHttpStorageValue
    {
        string Etag { get; set; }
    }
}
