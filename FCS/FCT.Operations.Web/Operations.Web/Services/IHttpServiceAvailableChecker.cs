namespace Operations.Web.Services
{
    using System.Threading.Tasks;
    using static Factory.OAuthAccessTokenFactoryNoCache;

    public interface IHttpServiceAvailableChecker
    {
        Task<bool> GetSuccessFromCallingUrl(string url, SecureApplication service);
    }
}