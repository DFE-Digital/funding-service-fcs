
namespace XrmTestModel
{
    using System.Collections.Generic;
    using System.Linq;

    using Microsoft.PowerPlatform.Dataverse.Client;
    using Microsoft.Xrm.Sdk;

    public class XrmServiceFactory : IXrmServiceFactory
    {
        private const string CrmIntegration = "CRMIntegration";

        private readonly IDictionary<string, IOrganizationService> _orgServiceDictionary =
            new Dictionary<string, IOrganizationService>();

        public IXrmConnectionString ?XrmConnectionStrings { get; set; }

        public IOrganizationService Create()
        {
            if (_orgServiceDictionary.ContainsKey(CrmIntegration))
            {
                return _orgServiceDictionary[CrmIntegration];
            }

            return CreateOrganizationService(CrmIntegration);
        }

        public IOrganizationService Create(string userName)
        {
            if (_orgServiceDictionary.ContainsKey(userName))
            {
                return _orgServiceDictionary[userName];
            }

            return CreateOrganizationService(userName);
        }

        private IOrganizationService CreateOrganizationService(string userName)
        {
            string connectionString =
                XrmConnectionStrings.ConnectionStringDictionary
                    .Single(c => c.Key == userName)
                    .Value;

            ServiceClient serviceClient =
                new ServiceClient(connectionString);

            _orgServiceDictionary.Add(userName, serviceClient);

            return serviceClient;
        }
    }
}
