namespace FCT.Operations.Infrastructure
{
    public interface ISharepointOAuthAccessTokenFactory
    {
        string GetAccessToken();
        void ClearCache();
    }
}