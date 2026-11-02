namespace ContractManagementDomain.Endpoint.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AutoMapper;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.Services;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using UnitTests.Common;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

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
                .Register(
                    Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetRetryOnErrorOrganizationService()).LifestyleScoped(),
                    Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleScoped(),
                    Component.For<IXrmManager>().ImplementedBy<XrmManager>().LifestyleScoped(),
                    Component.For<IXrmOrganisationManager>().ImplementedBy<XrmOrganisationManager>().LifestyleScoped(),
                    Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleScoped(),
                    Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>().LifestyleScoped(),
                    Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>().LifestyleScoped());

            Container.BeginScope();
        }

        protected contract GetCorpContract()
        {
            if (_masterContract == null)
            {
                using (var resource = new TestResource("ContractManagementDomain.Endpoint.Tests", "Resources.masterContract.xml"))
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

        protected void RemoveContract(Guid contractGuid)
        {
            RemoveContract(contractGuid, Container.Resolve<IOrganizationService>());
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

        protected IList<Entity> GetContractForGuid(Guid contractGuid)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_contractid", ConditionOperator.Equal, contractGuid)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        protected IList<Entity> GetContractsForUkprn(string ukprn)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_ukprn", ConditionOperator.Equal, ukprn)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }
    }

    public static class CrmEntityName
    {
        public const string Contract = "sfa_contract";
        public const string ContractAllocation = "sfa_contractallocation";
        public const string ContractDeliverable = "sfa_contractdeliverable";
        public const string ContractDeliverablePeriod = "sfa_contractdeliverableperiod";
        public const string ContractTransitionHistory = "sfa_contracttransitionhistory";
        public const string Team = "team";
        public const string Task = "task";
    }

    public static class CrmManager
    {
        private static IOrganizationService _organizationService;

        public static int GetNumContractsInCrmForUser(String ukprn)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_ukprn", ConditionOperator.Equal, ukprn),
                new ColumnValueCriteria("createdon", ConditionOperator.GreaterThan, DateTime.Now.Date)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return GetCrmEntities(lookupCriteria).Count;
        }

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
            var executeMultipleResp = (ExecuteMultipleResponse)CrmOrganizationService.Execute(executeMultipleReq);

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
    }

    public static class CrmContractFieldName
    {
        public const string EndDate = "sfa_enddate";
        public const string StartDate = "sfa_startdate";
        public const string ContractType = "sfa_contracttype";
        public const string ContractAdviser = "sfa_contractadviser";
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
        public const string ContractValueBase = "sfa_contractvalue_base";
        public const string ContractStatus = "sfa_contractstatus";
        public const string LatestVersion = "sfa_latestversion";
        public const string CorrelationId = "sfa_correlation";
        public const string AmendmentType = "sfa_amendmenttype";
        public const string Variation = "sfa_variation";
        public const string Owner = "ownerid";
        public const string ContractAdvisor = "sfa_contractadviser";
        public const string PreviousVersion = "sfa_previousversion";
        public const string ParentContract = "sfa_parentcontractid";
        public const string SubStatus = "sfa_substatus";
        public const string DocumentRequired = "sfa_documentationrequired";
        public const string ReasonForRejection = "sfa_reasonforrejection";
        public const string ServiceResponse = "sfa_serviceresponse";
        public const string CurrentTask = "sfa_currenttask";
        public const string PublishedDate = "sfa_contractpublisheddate";
        public const string WithdrawnDate = "sfa_datewithdrawn";
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
            && (expected.Second == actual.Second)
            && (expected.Kind == actual.Kind));
        }
    }

    public class CrmLookupCriteria
    {
        public string EntityName { get; set; }

        public List<ColumnValueCriteria> LookupCriteria { get; set; }
    }

    public class ColumnValueCriteria
    {
        public ColumnValueCriteria(string columnName, ConditionOperator conditionOperator, object value)
        {
            ColumnName = columnName;
            ConditionOperator = conditionOperator;
            Value = value;
        }

        public string ColumnName { get; private set; }

        public ConditionOperator ConditionOperator { get; private set; }

        public object Value { get; private set; }
    }
}
