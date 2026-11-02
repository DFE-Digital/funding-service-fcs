namespace ContractRequestDomain.EngagementWatcher.Services
{
    public interface IOAuthAccessTokenFactory
    {
        void ClearCache();

        string GetAccessToken(string clientId, string appKey, string resourceId);
    }
}