namespace Operations.Web.Checkers
{
    using System;
    using System.Threading.Tasks;
    using Dtos;
    using Services;

    public class FeedReadCheckAvailability : ICheckAvailability
    {
        private readonly IHttpUtility _httpUtility;

        private readonly IAuthenticationHelper _azureAuthHelper;

        private readonly CheckerHttpRequestInformation _checkerHttpRequestInformation;

        public FeedReadCheckAvailability(IHttpUtility httpUtility, IAuthenticationHelper azureAuthHelper, CheckerHttpRequestInformation checkerHttpRequestInformation)
        {
            _httpUtility = httpUtility;
            _azureAuthHelper = azureAuthHelper;
            _checkerHttpRequestInformation = checkerHttpRequestInformation;
        }

        public string ServiceName => _checkerHttpRequestInformation.ServiceToCheck.ToString();

        public async Task<AvailabilityCheckResult> GetCheckResult()
        {
            try
            {
                var authResult = _azureAuthHelper.GetAuthenticationResult(_checkerHttpRequestInformation.AuthenticationRequest);
                string accessToken = authResult;
                _httpUtility.SetAuthorizationHeader("Bearer", accessToken);
                _httpUtility.SetMediaTypeAcceptRequestHeaders(_checkerHttpRequestInformation.VendorAtomMediaTypes);

                HttpResult response = await _httpUtility.Get($"{_checkerHttpRequestInformation.BaseUrl}{_checkerHttpRequestInformation.PageToCheck}").ConfigureAwait(false);

                AvailabilityCheckResult result = new AvailabilityCheckResult(_checkerHttpRequestInformation.GetServiceName(), response.IsSuccess)
                {
                    Details = response.Message
                };

                return result;
            }
            catch (Exception exception)
            {
                return new AvailabilityCheckResult(ServiceName, false)
                {
                    Details = exception.Message
                };
            }
        }
    }
}