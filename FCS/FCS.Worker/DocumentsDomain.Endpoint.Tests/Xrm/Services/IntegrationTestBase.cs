namespace DocumentsDomain.Endpoint.Tests.Xrm.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AutoMapper;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.Xrm;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.Framework.Logging;

    public class IntegrationTestBase
    {
        protected IWindsorContainer Container { get; private set; }

        private static IOrganizationService _organizationService;

        private contract _masterContract;

        public IntegrationTestBase()
        {
            SetupIoC();
        }

        public static IOrganizationService CrmOrganizationService
        {
            get
            {
                if (_organizationService == null)
                {
                    _organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
                }

                return _organizationService;
            }
        }

        private void SetupIoC()
        {
            Container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(
                    Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleTransient(),
                    Component.For<IXrmOrganisationManager>().ImplementedBy<XrmOrganisationManager>().LifestyleTransient(),
                    Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleTransient(),
                    Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>(),
                    Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>());

            Container.BeginScope();
        }

        protected contract GetCorpContract()
        {
            if (_masterContract == null)
            {
                using (var resource = new TestResource("DocumentsDomain.Endpoint.Tests.Xrm.Resources", @"masterContract.xml"))
                {
                    var document = XDocument.Load(resource.Stream);

                    XmlSerializer serializer = new XmlSerializer(typeof(contract));
                    _masterContract = (contract)serializer.Deserialize(document.Root.CreateReader());
                }
            }

            if (_masterContract != null)
            {
                if (string.IsNullOrWhiteSpace(_masterContract.contractor.organisationIdentifier) || _masterContract.contractor.organisationIdentifier == "0")
                {
                    _masterContract.contractor.organisationIdentifier = "ORG" + _masterContract.contractor.ukprn;
                }
                _masterContract.contracts.Where(cn => cn.contractor != null).ToList().ForEach(cn => cn.contractor.organisationIdentifier = _masterContract.contractor.organisationIdentifier);
            }

            return _masterContract;
        }

        protected ExtendedContract TransformCorpContractToExtendedCorpContract(contract corpContract)
        {
            Mapper.CreateMap<contract, ExtendedContract>();
            Mapper.CreateMap<contractType, ExtendedContractType>();
            Mapper.CreateMap<contractAllocationsContractAllocation, ExtendedContractAllocation>();
            return Mapper.Map<contract, ExtendedContract>(corpContract);
        }

        protected void RemoveMasterAndChildContracts(Guid masterContractGuid)
        {
            if (masterContractGuid != Guid.Empty)
            {
                try
                {
                    IOrganizationService crmService = Container.Resolve<IOrganizationService>();
                    RemoveContractsForMaster(masterContractGuid, crmService);
                    RemoveContract(masterContractGuid, crmService);
                }
                catch (Exception)
                {
                    // ok
                }
            }
        }

        private void RemoveContractsForMaster(Guid masterContractGuid, IOrganizationService crmService)
        {
            var contracts = GetContractsForMaster(masterContractGuid);
            contracts.ForEach(c => CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, c.Id));
        }

        protected void RemoveContract(Guid contractGuid, IOrganizationService crmService)
        {
            CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, contractGuid);
        }

        protected IList<Entity> GetContractsForMaster(Guid masterContractGuid)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_parentcontractid", ConditionOperator.Equal, masterContractGuid)

            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        private class TestResource : IDisposable
        {
            public Stream Stream { get; }

            public TestResource(string nameSpace, string resourceName)
            {
                Stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}");
            }

            public void Dispose()
            {
                Stream?.Dispose();
                GC.SuppressFinalize(this);
            }
        }
    }

    public static class CrmEntityName
    {
        public const string Contract = "sfa_contract";
        public const string ContractAllocation = "sfa_contractallocation";
        public const string ContractDeliverable = "sfa_contractdeliverable";
        public const string ContractDeliverablePeriod = "sfa_contractdeliverableperiod";
        public const string Team = "team";
        public const string Task = "task";
    }

    public static class CrmManager
    {
        private static OrganizationService _organizationService;

        public static IList<Entity> GetCrmEntities(CrmLookupCriteria lookupCriteria)
        {
            var retrieveMultipleContractRequest = new RetrieveMultipleRequest();
            var contractQuery = new QueryExpression
            {
                EntityName = lookupCriteria.EntityName,
                ColumnSet = new ColumnSet(true)
            };

            contractQuery.Criteria = new FilterExpression();
            foreach (ColumnValueCriteria criteria in lookupCriteria.LookupCriteria)
            {
                contractQuery.Criteria.AddCondition(criteria.ColumnName, criteria.ConditionOperator, criteria.Value);
            }

            var executeMultipleReq = new ExecuteMultipleRequest()
            {
                Settings = new ExecuteMultipleSettings()
                {
                    ContinueOnError = false,
                    ReturnResponses = true
                },
                Requests = new OrganizationRequestCollection()
            };
            executeMultipleReq.Requests.Add(retrieveMultipleContractRequest);
            retrieveMultipleContractRequest.Query = contractQuery;
            var executeMultipleResp = (ExecuteMultipleResponse)CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(executeMultipleReq);

            var refEntityList = new List<Entity>();
            foreach (var r in executeMultipleResp.Responses.Where(r => r.Fault == null))
            {
                refEntityList.AddRange(((RetrieveMultipleResponse)r.Response).EntityCollection.Entities);
            }

            return refEntityList;
        }

        public static void DeleteEntity(IOrganizationService organizationService, string entityName, Guid primaryKey)
        {
            organizationService.Delete(entityName, primaryKey);
        }

        public static void DeleteEntity(Entity entity)
        {
            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(entity.LogicalName, entity.Id);
        }

        public static CrmConnection CrmConnection
        {
            get { return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString); }
        }

        private static void RemoveMasterAndChildContracts(Guid masterContractGuid)
        {
            if (masterContractGuid != Guid.Empty)
            {
                try
                {
                    IOrganizationService crmService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
                    RemoveContractsForMaster(masterContractGuid, crmService);
                    RemoveContract(masterContractGuid, crmService);
                }
                catch (Exception)
                {
                    // ok
                }
            }
        }

        private static void RemoveContractsForMaster(Guid masterContractGuid, IOrganizationService crmService)
        {
            var contracts = GetContractsForMaster(masterContractGuid);
            contracts.ForEach(c => CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, c.Id));
        }

        private static void RemoveContract(Guid contractGuid, IOrganizationService crmService)
        {
            CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, contractGuid);
        }

        private static IList<Entity> GetContractsForContractNumber(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_number", ConditionOperator.Equal, contractNumber)

            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        private static IList<Entity> GetContractsForMaster(Guid masterContractGuid)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_parentcontractid", ConditionOperator.Equal, masterContractGuid)

            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }
    }
    
    public static class CrmContractFieldName
    {
        public const string EndDate = "sfa_enddate";
        public const string StartDate = "sfa_startdate";
        public const string ContractType = "sfa_contracttype";
        public const string FundingType = "sfa_fundingtype";
        public const string PeriodId = "sfa_periodid";
        public const string Number = "sfa_number";
        public const string Version = "sfa_version";
        public const string SubVersion = "sfa_subversion";
        public const string Description = "sfa_description";
        public const string Ukprn = "sfa_ukprn";
        public const string ProviderName = "sfa_providername";
        public const string HierarchyType = "sfa_hierarchytype";
        public const string ContractValue = "sfa_contractvalue";
        public const string ContractStatus = "sfa_contractstatus";
        public const string LatestVersion = "sfa_latestversion";
        public const string CorrelationId = "sfa_correlation";
        public const string AmendmentType = "sfa_amendmenttype";
        public const string Variation = "sfa_variation";
        public const string Owner = "ownerid";
        public const string ParentContract = "sfa_parentcontractid";
        public const string SubStatus = "sfa_substatus";
        public const string DocumentRequired = "sfa_documentationrequired";
        public const string ServiceResponse = "sfa_serviceresponse";
        public const string PublishedDate = "sfa_contractpublisheddate";
    }

    public static class DateTimeExtensions
    {
        public static bool IsDateTimeEqualTo(this DateTime actual, DateTime expected)
        {
            return ((expected.Year == actual.Year)
                    && (expected.Month == actual.Month)
                    && (expected.Day == actual.Day)
                    && (expected.Hour == actual.Hour)
                    && (expected.Minute == actual.Minute)
                    && (expected.Second == actual.Second));
        }
    }
}
