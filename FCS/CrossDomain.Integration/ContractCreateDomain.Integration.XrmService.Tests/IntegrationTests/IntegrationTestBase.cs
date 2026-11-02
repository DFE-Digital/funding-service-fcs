namespace ContractCreateDomain.Integration.XrmService.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using Castle.Core.Internal;
    using Castle.Windsor;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Integration.XrmService.IoC;
    using SFA.FCT.Framework.Logging;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Utils;

    public class IntegrationTestBase
    {
        ////private CorporateContract.contract _masterContract;

        protected IWindsorContainer Container { get; private set; }

        private static OrganizationService _organizationService;

        public IntegrationTestBase()
        {
            SetupIoC();
        }

        public static OrganizationService CrmOrganizationService
        {
            get
            {
                if (_organizationService == null)
                {
                    _organizationService = new OrganizationService(CrmConnection);
                }

                return _organizationService;
            }
        }

        public static CrmConnection CrmConnection
        {
            get { return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString); }
        }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();

            Container = new WindsorContainer().Install(new LoggerInstaller(factory), new WindsorInstaller());
        }

        protected void RemoveMasterAndChildContracts(Guid masterContractGuid)
        {
            if (masterContractGuid != Guid.Empty)
            {
                try
                {
                    IOrganizationService crmService = CrmOrganizationService;
                    RemoveContractsForMaster(masterContractGuid, crmService);
                    RemoveContract(masterContractGuid, crmService);
                }
                catch (Exception)
                {
                    // ok
                }
            }
        }

        protected void RemoveMasterAndChildContracts(string masterContractNumber)
        {
             GetContractsForContractNumber(masterContractNumber).ForEach(e => RemoveMasterAndChildContracts(e.Id));
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
            CrmManager.DeleteEntity(CrmOrganizationService, CrmEntityName.Contract, contractGuid);
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

        protected IList<Entity> GetContractsForContractNumber(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_number", ConditionOperator.Equal, contractNumber)

            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        protected IList<Entity> GetOrganisationsForOrganisationId(string organisationId)
        {
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria
            {
                EntityName = "account",
                LookupCriteria = new List<ColumnValueCriteria>
                {
                    new ColumnValueCriteria("sfa_organisationid", ConditionOperator.Equal, organisationId)
                }
            };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        protected void RemoveOrganisation(Guid organisationGuid)
        {
            CrmManager.DeleteEntity(CrmOrganizationService, "account", organisationGuid);
        }
    }
}