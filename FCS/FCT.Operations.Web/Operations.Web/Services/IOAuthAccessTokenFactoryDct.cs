namespace Operations.Web.Services
{
    public interface IOAuthAccessTokenFactoryDct
    {
        void ClearCache(string clientId);

        string GetAccessToken(string clientId, string clientSecret, string scope, string tenant);
    }
}