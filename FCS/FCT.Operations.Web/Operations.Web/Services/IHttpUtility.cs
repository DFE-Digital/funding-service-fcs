namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using Dtos;

    public interface IHttpUtility : IDisposable
    {
        void SetAuthorizationHeader(string scheme, string token);

        void SetMediaTypeAcceptRequestHeaders(IReadOnlyCollection<MediaTypeWithQualityHeaderValue> mediaTypeToAcceptCollection);

        Task<HttpResult> Get(string url);

        Task<HttpResult> GetButAllowNotFound(string url);
    }
}