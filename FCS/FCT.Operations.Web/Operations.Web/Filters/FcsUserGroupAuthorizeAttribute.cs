namespace Operations.Web.Filters
{
    using System.Linq;
    using System.Web.Http;
    using System.Web.Http.Controllers;
    using System.Security.Claims;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging;

    public class AuthorizeFcsUserGroupAttribute : AuthorizeAttribute
    {
        private ILoggerFactory _loggerFactory;
        private readonly ILogger _logger;

        public AuthorizeFcsUserGroupAttribute()
        {
            _logger = GetLoggerFactory().CreateDefaultLogger();
        }
        protected override bool IsAuthorized(HttpActionContext actionContext)
        {
            var user = actionContext.RequestContext.Principal as ClaimsPrincipal;
            var groupStringValue = System.Configuration.ConfigurationManager.AppSettings["FcsUserGroup"];

            _logger.LogInformation(1, $"AuthorizeFcsUserGroupAttribute: IsAuthorized - user: {user.Identity.Name}, groupStringValue: {groupStringValue}");

            var groupClaims = user.FindAll("groups").ToList();

            _logger.LogInformation(1, $"AuthorizeFcsUserGroupAttribute: IsAuthorized - Iterating ClaimsPrincipal.Current groups. Count: {groupClaims.ToList().Count}");

            var sequence = 1;
            foreach (var claim in ClaimsPrincipal.Current.FindAll("groups"))
            {
                _logger.LogInformation(1, $"AuthorizeFcsUserGroupAttribute: IsAuthorized - {sequence} ClaimsPrincipal Value : {claim.Value}");
                _logger.LogInformation(1, $"AuthorizeFcsUserGroupAttribute: IsAuthorized - {sequence} ClaimsPrincipal Issuer : {claim.Issuer}");
                _logger.LogInformation(1, $"AuthorizeFcsUserGroupAttribute: IsAuthorized - {sequence} ClaimsPrincipal OriginalIssuer : {claim.OriginalIssuer}");
                _logger.LogInformation(1, $"AuthorizeFcsUserGroupAttribute: IsAuthorized - {sequence} ClaimsPrincipal Subject : {claim.Subject}");
                _logger.LogInformation(1, $"AuthorizeFcsUserGroupAttribute: IsAuthorized - {sequence} ClaimsPrincipal Type : {claim.Type}");
                _logger.LogInformation(1, $"AuthorizeFcsUserGroupAttribute: IsAuthorized - {sequence} ClaimsPrincipal ValueType : {claim.ValueType}");
                sequence++;
            }

            return groupClaims.Any(claim => claim.Value == groupStringValue);
        }

        private ILoggerFactory GetLoggerFactory()
        {
            if (_loggerFactory == null)
            {
                _loggerFactory = new LoggerFactory();
            }

            return _loggerFactory;
        }
    }
}