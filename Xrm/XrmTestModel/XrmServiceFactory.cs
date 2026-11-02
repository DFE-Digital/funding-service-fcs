namespace XrmTestModel
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;

    public class XrmServiceFactory : IXrmServiceFactory
    {
        private const string CrmIntegration = "CRMIntegration";
        private readonly IDictionary<string, IOrganizationService> _orgServiceDictionary = new Dictionary<string,IOrganizationService>();

        public IXrmConnectionString XrmConnectionStrings { get; set; }

        public IOrganizationService Create()
        {
            if (_orgServiceDictionary.ContainsKey(CrmIntegration))
            {
                return _orgServiceDictionary[CrmIntegration];
            }

            var orgSvc = CreateOrganizationService(CrmIntegration);

            return orgSvc;
        }

        public IOrganizationService Create(string userName)
        {
            if (_orgServiceDictionary.ContainsKey(userName))
            {
                return _orgServiceDictionary[userName];
            }

            var orgSvc = CreateOrganizationService(userName);

            return orgSvc;
        }

        private IOrganizationService CreateOrganizationService(string userName)
        {
            var orgSvc =
                new OrganizationService(
                    CrmConnection.Parse(
                        XrmConnectionStrings.ConnectionStringDictionary.Single(c => c.Key == userName).Value));

            _orgServiceDictionary.Add(userName, orgSvc);
            return orgSvc;
        }
    }
}
