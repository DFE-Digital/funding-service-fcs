namespace FCT.Operations.Infrastructure
{
    using Microsoft.SharePoint.Client;
    using System.Net.Http;
    public interface IAuthenticationHelper
    {
        HttpClient EnsureClient(string url);
    }
}