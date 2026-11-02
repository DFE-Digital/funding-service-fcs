namespace Operations.Web.Dtos
{
    public class AuthenticationRequest
    {
        public string AdInstance { get; }
        public string Tenant { get; }
        public string ClientId { get; }
        public string AppKey { get; }
        public string ResourceId { get; }

        public AuthenticationRequest(string adInstance, string tenant, string clientId, string appKey, string resourceId)
        {
            AdInstance = adInstance;
            Tenant = tenant;
            ClientId = clientId;
            AppKey = appKey;
            ResourceId = resourceId;
        }
}
}