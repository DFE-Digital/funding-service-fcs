namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using Castle.Core.Internal;
    using Dtos;

    public class HttpUtility : IHttpUtility
    {
        private readonly HttpClient _client;
        private static readonly IEnumerable<HttpStatusCode> AllowedStatusCodes = new List<HttpStatusCode>{HttpStatusCode.OK, HttpStatusCode.NotFound};

        public HttpUtility()
        {
            _client = new HttpClient();
        }

        public void SetAuthorizationHeader(string scheme, string token)
        {
            _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(scheme, token);
        }

        public void SetMediaTypeAcceptRequestHeaders(IReadOnlyCollection<MediaTypeWithQualityHeaderValue> mediaTypeToAcceptCollection)
        {
            mediaTypeToAcceptCollection.ForEach(mci =>
            {
                _client.DefaultRequestHeaders.Accept.Add(mci);
            });
        }

        public async Task<HttpResult> Get(string url)
        {
            try
            {
                HttpResponseMessage response = await _client.GetAsync(url).ConfigureAwait(false);

                return new HttpResult
                {
                    IsSuccess = response.IsSuccessStatusCode,
                    Message = response.ReasonPhrase
                };
            }
            catch (Exception ex)
            {
                return new HttpResult
                {
                    IsSuccess = false,
                    Message = ex.Message
                };
            }
        }

        public async Task<HttpResult> GetButAllowNotFound(string url)
        {
            try
            {
                HttpResponseMessage response = await _client.GetAsync(url).ConfigureAwait(false);

                return new HttpResult
                {
                    IsSuccess = AllowedStatusCodes.Contains(response.StatusCode),
                    Message = response.ReasonPhrase
                };
            }
            catch (Exception ex)
            {
                return new HttpResult
                {
                    IsSuccess = false,
                    Message = ex.Message
                };
            }
        }

        public void Dispose()
        {
            _client.Dispose();
        }
    }
}