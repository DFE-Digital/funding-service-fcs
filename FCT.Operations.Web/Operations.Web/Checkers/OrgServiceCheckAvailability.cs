namespace Operations.Web.Checkers
{
    using System;
    using System.Threading.Tasks;
    using Dtos;
    using Services;

    public class OrgServiceCheckAvailability : ICheckAvailability
    {
        private readonly IHttpUtility _httpUtility;
        private readonly IAuthenticationHelper _azureAuthHelper;
        private readonly CheckerHttpRequestInformation _checkerHttpRequestInformation;

        public OrgServiceCheckAvailability(
            IHttpUtility httpUtility,
            IAuthenticationHelper azureAuthHelper,
            CheckerHttpRequestInformation checkerHttpRequestInformation)
        {
            _httpUtility = httpUtility;
            _azureAuthHelper = azureAuthHelper;
            _checkerHttpRequestInformation = checkerHttpRequestInformation;
        }

        public string ServiceName => "OrgService";

        public async Task<AvailabilityCheckResult> GetCheckResult()
        {
            try
            {
                string url = $"{_checkerHttpRequestInformation.BaseUrl}{_checkerHttpRequestInformation.PageToCheck}";

                string accessToken = _azureAuthHelper.GetAuthenticationResult(_checkerHttpRequestInformation.AuthenticationRequest);
                 
                _httpUtility.SetAuthorizationHeader("Bearer", accessToken);

                HttpResult response = await _httpUtility.GetButAllowNotFound(url).ConfigureAwait(false);

                return new AvailabilityCheckResult(ServiceName, response.IsSuccess)
                {
                    Details = response.Message
                };
            }
            catch (Exception ex)
            {
                return new AvailabilityCheckResult(ServiceName, false) { Details = ex.Message };
            }
        }
    }
}