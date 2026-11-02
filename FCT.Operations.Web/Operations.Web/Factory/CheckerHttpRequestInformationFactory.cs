namespace Operations.Web.Factory
{
    using System.Configuration;
    using System.Linq;
    using System.Net.Http.Headers;
    using Dtos;
    using Enums;

    public static class CheckerHttpRequestInformationFactory
    {
        public static CheckerHttpRequestInformation GetAuthenticationForService(ServiceInterface service)
        {
            CheckerHttpRequestInformation requestInformation = null;

            switch (service)
            {
                case ServiceInterface.ContractFeed:
                {
                    string pageToCheck = "/api/contracts/notifications/approvals";
                    string cmsBaseUrl = ConfigurationManager.AppSettings["ContractManagementServiceUrl"];
                    string cmsAdInstance = ConfigurationManager.AppSettings["ContractManagementService:AADInstance"];
                    string cmsTenant = ConfigurationManager.AppSettings["ContractManagementService:Tenant"];
                    string cmsClientId = ConfigurationManager.AppSettings["ContractManagementService:ClientId"];
                    string cmsAppKey = ConfigurationManager.AppSettings["ContractManagementService:AppKey"];
                    string cmsResourceId = ConfigurationManager.AppSettings["ContractManagementService:ResourceId"];
                    string mediaType = "application/vnd.sfa.contract.v1+atom+xml";
                    var ar = new AuthenticationRequest(cmsAdInstance, cmsTenant, cmsClientId, cmsAppKey, cmsResourceId);
                    requestInformation = new CheckerHttpRequestInformation(service, cmsBaseUrl, pageToCheck, new[] {new MediaTypeWithQualityHeaderValue(mediaType)},ar);
                    break;
                }
                case ServiceInterface.DeliverableSettingFeed:
                {
                    string pageToCheck = "/api/funding-policies/deliverables/settings/notifications/changes";
                    string fpsBaseUrl = ConfigurationManager.AppSettings["ContractManagementServiceUrl"];
                    string fpsAdInstance = ConfigurationManager.AppSettings["ContractManagementService:AADInstance"];
                    string fpsTenant = ConfigurationManager.AppSettings["ContractManagementService:Tenant"];
                    string fpsClientId = ConfigurationManager.AppSettings["ContractManagementService:ClientId"];
                    string fpsAppKey = ConfigurationManager.AppSettings["ContractManagementService:AppKey"];
                    string fpsResourceId = ConfigurationManager.AppSettings["ContractManagementService:ResourceId"];
                    string mediaType = "application/vnd.sfa.funding-policy.deliverable.setting.v1+atom+xml";
                    var ar = new AuthenticationRequest(fpsAdInstance, fpsTenant, fpsClientId, fpsAppKey, fpsResourceId);
                    requestInformation = new CheckerHttpRequestInformation(service, fpsBaseUrl, pageToCheck, new[] { new MediaTypeWithQualityHeaderValue(mediaType) }, ar);
                    break;
                }
                case ServiceInterface.AdpFeed:
                {
                    string pageToCheck = "/api/allocation-delivery/monitoring/notifications/all";
                    string cmsBaseUrl = ConfigurationManager.AppSettings["ContractManagementServiceUrl"];
                    string cmsAdInstance = ConfigurationManager.AppSettings["ContractManagementService:AADInstance"];
                    string cmsTenant = ConfigurationManager.AppSettings["ContractManagementService:Tenant"];
                    string cmsClientId = ConfigurationManager.AppSettings["ContractManagementService:ClientId"];
                    string cmsAppKey = ConfigurationManager.AppSettings["ContractManagementService:AppKey"];
                    string cmsResourceId = ConfigurationManager.AppSettings["ContractManagementService:ResourceId"];
                    string mediaType = "application/vnd.sfa.allocation-delivery.allocation-delivery-performance.v1+atom+xml";
                    var ar = new AuthenticationRequest(cmsAdInstance, cmsTenant, cmsClientId, cmsAppKey, cmsResourceId);
                    requestInformation = new CheckerHttpRequestInformation(service, cmsBaseUrl, pageToCheck, new[] { new MediaTypeWithQualityHeaderValue(mediaType) }, ar);
                    break;
                }
                case ServiceInterface.OrgService:
                {
                    string pageToCheck = "api/v1/test";
                    string orgBaseUrl = ConfigurationManager.AppSettings["OrgService:BaseUrl"];
                    string orgAdInstance = ConfigurationManager.AppSettings["OrgService:AADInstance"];
                    string orgTenant = ConfigurationManager.AppSettings["OrgService:Tenant"];
                    string orgClientId = ConfigurationManager.AppSettings["OrgService:ClientId"];
                    string orgAppKey = ConfigurationManager.AppSettings["OrgService:AppKey"];
                    string orgResourceId = ConfigurationManager.AppSettings["OrgService:ResourceId"];
                    var ar = new AuthenticationRequest(orgAdInstance, orgTenant, orgClientId, orgAppKey, orgResourceId);
                    requestInformation = new CheckerHttpRequestInformation(service, orgBaseUrl, pageToCheck, Enumerable.Empty<MediaTypeWithQualityHeaderValue>().ToList(), ar);
                    break;
                }
            }

            return requestInformation;
        }
    }
}