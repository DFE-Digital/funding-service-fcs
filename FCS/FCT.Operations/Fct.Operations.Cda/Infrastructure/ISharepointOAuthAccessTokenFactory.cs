namespace FCT.Operations.Cda.Infrastructure
{
    public interface ISharepointOAuthAccessTokenFactory
    {
        string GetAccessToken();
        void ClearCache();
    }
}