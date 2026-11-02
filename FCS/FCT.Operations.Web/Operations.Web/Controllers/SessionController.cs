namespace Operations.Web.Controllers
{
    using System;
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Security.Claims;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using System.Web.Http;
    using DataStore.Repositories;
    using Dtos;
    using Newtonsoft.Json;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Filters;

    [RoutePrefix("session")]
    public class SessionController : ApiController
    {
        private const string ValidAuthenticationToken = "";
        private readonly ISessionRepository _sessionRepository;
        private readonly ILogger _logger;

        public SessionController(ISessionRepository sessionRepository, ILogger logger)
        {
            _sessionRepository = sessionRepository;
            _logger = logger;
        }

        [HttpPost, Route]
        public async Task<HttpResponseMessage> Create([FromBody]string authenticationToken)
        {
            _logger.LogInformation(1, $"SessionController - create called started");

            bool appSvcAuth = false;

            var acceptEasyAuth = ConfigurationManager.AppSettings["AcceptEasyAuth"];
            var xmsclientprincipalname = Request.Headers.Contains("X-MS-CLIENT-PRINCIPAL-NAME");

            _logger.LogInformation(1, $"ConfigurationManager.AppSettings['AcceptEasyAuth']: {acceptEasyAuth}");
            _logger.LogInformation(1, $"Request.Headers.Contains('X-MS-CLIENT-PRINCIPAL-NAME')): {xmsclientprincipalname}");

            // if we are on an app service and we accept EasyAuth and it has authenticated the caller 
            // then accept that as permission to start a session.
            if (ConfigurationManager.AppSettings["AcceptEasyAuth"] != null &&
                ConfigurationManager.AppSettings["AcceptEasyAuth"].ToLower() == "true" &&
                Request.Headers.Contains("X-MS-CLIENT-PRINCIPAL-NAME"))
            {
                _logger.LogInformation(1, "We are on an app service and we accept EasyAuth and it has authenticated the caller");
                appSvcAuth = true;
                authenticationToken = string.Empty;
            }

            if (appSvcAuth || authenticationToken == ValidAuthenticationToken)
            {
                Guid sessionToken = await _sessionRepository.CreateSessionAsync();

                _logger.LogInformation(1, $"SessionController - session created, identity.Name: {User.Identity.Name}");

                return CreateResponseWithCookie(sessionToken.ToString());
            }

            _logger.LogInformation(1, $"14-SessionController - create called complete");
            return new HttpResponseMessage(HttpStatusCode.Unauthorized);
        }

        private static HttpResponseMessage CreateResponseWithCookie(string sessionToken)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Created);
            response.Headers.AddCookies(new[] { new CookieHeaderValue("session-token", sessionToken) { Secure = true, HttpOnly = true, Path = "/" } });
            response.Content = new JsonContent(new SessionAuthenticationResult(sessionToken));

            return response;
        }

        private class JsonContent : StringContent
        {
            public JsonContent(object content)
                : this(JsonConvert.SerializeObject(content), Encoding.UTF8)
            {
            }

            private JsonContent(string content, Encoding encoding)
                : base(content, encoding, "application/json")
            {
            }
        }
    }
}
