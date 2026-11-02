namespace AllocationDeliveryDomain.Endpoint.Infrastructure
{
    public interface IOAuthAccessTokenFactory
    {
        void ClearCache(string clientId);

        string GetAccessToken(string clientId, string clientSecret, string scope, string tenant);
    }
}
