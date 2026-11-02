namespace Operations.Web.Checkers
{
    using System;
    using System.Configuration;
    using System.Threading.Tasks;
    using Dtos;
    using Services;

    public class DctCheckAvailability : ICheckAvailability
    {
        private readonly IHttpUtility _httpUtility;
        private readonly IOAuthAccessTokenFactoryDct _oAuthAccessTokenFactoryDct;

        public DctCheckAvailability(IHttpUtility httpUtility,
            IOAuthAccessTokenFactoryDct oAuthAccessTokenFactoryDct)
        {
            _httpUtility = httpUtility;
            _oAuthAccessTokenFactoryDct = oAuthAccessTokenFactoryDct;
        }

        public string ServiceName => "DCT";

        public async Task<AvailabilityCheckResult> GetCheckResult()
        {
            var url = ConfigurationManager.AppSettings["DCT:Url"];
            var OauthClientId = ConfigurationManager.AppSettings["DCT:Oauth:ClientId"];
            var OauthScope = ConfigurationManager.AppSettings["DCT:Oauth:Scope"];
            var OauthClientSecret = ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"];
            var OauthTenant = ConfigurationManager.AppSettings["DCT:Oauth:Tenant"];

            var clientToken = _oAuthAccessTokenFactoryDct.GetAccessToken(
                clientId: OauthClientId, clientSecret: OauthClientSecret,
                scope: OauthScope, tenant: OauthTenant);

            try
            {
                _httpUtility.SetAuthorizationHeader("Bearer", clientToken);
                string iso8601FormatDate = new DateTime(2020, 01, 01, 00, 00, 00, DateTimeKind.Utc).ToString("O");

                url =
                    $"{url}/api/v1.0/summarised-actuals/collections?closedCollectionsSince={iso8601FormatDate}&pageSize={int.MaxValue}";
                HttpResult response = await _httpUtility.Get(url).ConfigureAwait(false);

                return new AvailabilityCheckResult(ServiceName, response.IsSuccess)
                {
                    Details = response.Message
                };
            }
            catch (Exception ex)
            {
                return new AvailabilityCheckResult(ServiceName, false)
                {
                    Details = ex.Message
                };
            }
        }
    }
}