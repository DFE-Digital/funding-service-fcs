namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Runtime.Caching;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Microsoft.Xrm.Sdk.WebServiceClient;
    using Newtonsoft.Json;
    using Polly;
    using Utilities;

    public static class CrmConnectionFactory
    {
        public static IOrganizationService GetConnection()
        {
            return new RetryOnErrorOrganizationServiceCrmOnline(OAuthCrmConnectionFactory.GetOrganizationService());
        }

        public static IOrganizationService GetNonRetryingConnection()
        {
            return OAuthCrmConnectionFactory.GetOrganizationService();
        }

        public static IOrganizationService GetConnectionForSpecificUser(string userName)
        {
            var connection = new RetryOnErrorOrganizationServiceCrmOnline(OAuthCrmConnectionFactory.GetOrganizationService(userName));

            return connection;
        }

        private static Guid GetUserId(string userName, IOrganizationService orgService)
        {
            using (var xrmContext = new XrmServiceContext(orgService))
            {
                return xrmContext.SystemUserSet.First(u => u.FullName == userName).Id;
            }
        }

        private static class OAuthCrmConnectionFactory
        {
            private const string AccessTokenCacheKey = "DYNAMICS_365_OAUTH_ACCESS_TOKEN";
            private const int AccessTokenCacheExpirationMinutes = 55;

            private static readonly HttpClient _httpClient;
            private static readonly MemoryCache _objectCache = MemoryCache.Default;

            static OAuthCrmConnectionFactory()
            {
                System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
                _httpClient = new HttpClient();
                _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/x-www-form-urlencoded"));
            }

            public static OrganizationWebProxyClient GetOrganizationService(string crmUser = null)
            {
                Uri baseUri = new Uri(TestConfiguration.Configuration["ida:ResourceId_CrmOnline"]);
                Uri serviceUri = new Uri(baseUri, @"xrmservices/2011/organization.svc/web?SdkClientVersion=8.2");

                Lazy<string> newLazyAccessToken = new Lazy<string>(GetAccessTokenWithRetry);

                Lazy<string> existingLazyAccessToken = (Lazy<string>)_objectCache.AddOrGetExisting(
                    AccessTokenCacheKey,
                    newLazyAccessToken,
                    new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.UtcNow.AddMinutes(AccessTokenCacheExpirationMinutes) });

                var crmOnlineWebProxyClient = new OrganizationWebProxyClient(serviceUri, true)
                {
                    HeaderToken = (existingLazyAccessToken ?? newLazyAccessToken).Value
                };

                if (crmUser != null)
                {
                    crmOnlineWebProxyClient.CallerId = GetUserId(crmUser, crmOnlineWebProxyClient);
                }

                return crmOnlineWebProxyClient;
            }

            private static string GetAccessTokenWithRetry()
            {
                return Policy
                    .Handle<Exception>(_ => true)
                    .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                    .Execute(GetAccessToken);
            }

            private static string GetAccessToken()
            {
                string aadInstance =TestConfiguration.Configuration["ida:AADInstance_CrmOnline"];
                string tenant =TestConfiguration.Configuration["ida:Tenant_CrmOnline"];
                string clientId =TestConfiguration.Configuration["ida:ClientId_CrmOnline"];
                string appKey =TestConfiguration.Configuration["ida:AppKey_CrmOnline"];
                string resourceId =TestConfiguration.Configuration["ida:ResourceId_CrmOnline"];

                string authority = string.Format(aadInstance, tenant);

                FormUrlEncodedContent formContent = new FormUrlEncodedContent(new[]
                {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("resource", resourceId),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", appKey),
            });

                HttpResponseMessage response = _httpClient.PostAsync(authority + "/oauth2/token", formContent).Result;
                response.EnsureSuccessStatusCode();

                dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

                return jsonObject.access_token;
            }
        }
    }

    public class RetryOnErrorOrganizationServiceCrmOnline : IOrganizationService
    {
        private readonly OrganizationWebProxyClient _crmOnlineWebProxyClient;

        public RetryOnErrorOrganizationServiceCrmOnline(OrganizationWebProxyClient crmOnlineWebProxyClient)
        {
            _crmOnlineWebProxyClient = crmOnlineWebProxyClient;
        }

        public Guid Create(Entity entity)
        {
            return FunctionRetrier.RetryWhenExceptionThrown(() => _crmOnlineWebProxyClient.Create(entity));
        }

        public Entity Retrieve(string entityName, Guid id, ColumnSet columnSet)
        {
            return FunctionRetrier.RetryWhenExceptionThrown(() =>
                _crmOnlineWebProxyClient.Retrieve(entityName, id, columnSet));
        }

        public void Update(Entity entity)
        {
            ActionRetrier.RetryWhenExceptionThrown(() => _crmOnlineWebProxyClient.Update(entity));
        }

        public void Delete(string entityName, Guid id)
        {
            const string entityDoesNotExistExceptionMessage = "Does Not Exist";

            try
            {
                ActionRetrier.RetryWhenExceptionMatchesPredicate(
                    () => _crmOnlineWebProxyClient.Delete(entityName, id),
                    10, // allow more time for eventually consistent associations to be deleted in CRM Online
                    ex => !ex.Message.Contains(entityDoesNotExistExceptionMessage));
            }
            catch (Exception ex) when (ex.Message.Contains(entityDoesNotExistExceptionMessage))
            {
                // this is okay, the object has already been deleted
            }
        }

        public OrganizationResponse Execute(OrganizationRequest request)
        {
            return FunctionRetrier.RetryWhenExceptionThrown(() =>_crmOnlineWebProxyClient.Execute(request));
        }

        public void Associate(string entityName, Guid entityId, Relationship relationship, EntityReferenceCollection relatedEntities)
        {
            ActionRetrier.RetryWhenExceptionThrown(() => _crmOnlineWebProxyClient.Associate(
                entityName,
                entityId,
                relationship,
                relatedEntities));
        }

        public void Disassociate(string entityName, Guid entityId, Relationship relationship,
            EntityReferenceCollection relatedEntities)
        {
            ActionRetrier.RetryWhenExceptionThrown(() => _crmOnlineWebProxyClient.Disassociate(
                entityName,
                entityId,
                relationship,
                relatedEntities));
        }

        public EntityCollection RetrieveMultiple(QueryBase query)
        {
            return FunctionRetrier.RetryWhenExceptionThrown(() => _crmOnlineWebProxyClient.RetrieveMultiple(query));
        }
    }
}
