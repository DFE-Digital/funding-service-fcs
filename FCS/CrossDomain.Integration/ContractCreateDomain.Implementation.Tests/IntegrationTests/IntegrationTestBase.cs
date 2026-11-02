namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AutoMapper;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Newtonsoft.Json;
    using Contract.XrmAdapterService.Tests.Utils;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Persistence;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using MoreLinq;
    using Services;
    using UnitTests.Common;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    public class IntegrationTestBase
    {
        private CorporateContract.contract _masterContract;

        protected IWindsorContainer Container { get; private set; }

        private static IOrganizationService _organizationService;

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

        protected CorporateContract.contract GetCorpContract()
        {
            if (_masterContract == null)
            {
                using (var resource = new TestResource("ContractCreateDomain.Implementation.Tests", @"Resources.masterContract.xml"))
                {
                    var document = XDocument.Load(resource.Stream);

                    XmlSerializer serializer = new XmlSerializer(typeof(CorporateContract.contract));
                    _masterContract = (CorporateContract.contract)serializer.Deserialize(document.Root.CreateReader());
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

        protected CorporateContract.contract GetCorpContractForWithdraw()
        {
            using (var resource = new TestResource("ContractCreateDomain.Implementation.Tests", @"Resources.masterContract.xml"))
            {
                var document = XDocument.Load(resource.Stream);

                XmlSerializer serializer = new XmlSerializer(typeof(CorporateContract.contract));
                return (CorporateContract.contract)serializer.Deserialize(document.Root.CreateReader());
            }
        }

        protected CorporateContract.ExtendedContract GetExtendedCorpContract()
        {
            return TransformCorpContractToExtendedCorpContract(GetCorpContract());
        }

        protected CorporateContract.ExtendedContract TransformCorpContractToExtendedCorpContract(CorporateContract.contract corpContract)
        {
            Mapper.CreateMap<CorporateContract.contract, CorporateContract.ExtendedContract>();
            Mapper.CreateMap<CorporateContract.contractType, CorporateContract.ExtendedContractType>();
            Mapper.CreateMap<CorporateContract.contractAllocationsContractAllocation, CorporateContract.ExtendedContractAllocation>();
            return Mapper.Map<CorporateContract.contract, CorporateContract.ExtendedContract>(corpContract);
        }

        protected contractRequestType GetContractRequest()
        {
            using (var resource = new TestResource("ContractCreateDomain.Implementation.Tests", @"Resources.contractRequestType.json"))
            {
                return
                    (contractRequestType)
                        new JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(contractRequestType));
            }
        }

        protected void RemoveMasterAndChildContracts(Guid masterContractGuid)
        {
            if (masterContractGuid != Guid.Empty)
            {
                try
                {
                    RemoveContractsForMaster(masterContractGuid, CrmOrganizationService);
                    RemoveContract(masterContractGuid);
                }
                catch (Exception)
                {
                    // ok
                }
            }
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

        protected IList<Entity> GetAllocationsForContract(Guid contractGuid)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_contractid", ConditionOperator.Equal, contractGuid)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.ContractAllocation, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        protected IList<Entity> GetDeliverablesForAllocation(string allocationNumber)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_allocationref", ConditionOperator.Equal, allocationNumber)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.ContractDeliverable, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        protected IEnumerable<Entity> GetContracts(string contractNumber, int versionNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                 new ColumnValueCriteria(CrmContractFieldName.Number, ConditionOperator.Equal, contractNumber),
                 new ColumnValueCriteria(CrmContractFieldName.Version, ConditionOperator.Equal, versionNumber),
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }


        private void RemoveContractsForMaster(Guid masterContractGuid, IOrganizationService crmService)
        {
            var contracts = GetContractsForMaster(masterContractGuid);
            contracts.ForEach(c => CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, c.Id));
        }

        protected void RemoveContract(Guid contractGuid)
        {
            var crmService = CrmOrganizationService;

            ActionRetrier.RetryWhenExceptionThrown<System.ServiceModel.FaultException>(
                () => CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, contractGuid));
        }

        protected void DeleteContractsWithContractNumber(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                 new ColumnValueCriteria(CrmContractFieldName.Number, ConditionOperator.Equal, contractNumber)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            var contracts = CrmManager.GetCrmEntities(lookupCriteria);
            contracts.ForEach(c => RemoveContract(c.Id));
        }
        
        protected void UpdateOrganisationUpin(int ukprn, string upin)
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                var account = xrmContext.AccountSet.Single(a => a.sfa_UKPRN == ukprn.ToString());
                account.sfa_orgupin = upin;
                xrmContext.UpdateObject(account);
                xrmContext.SaveChanges();
            }
        }

        protected void UpdateStatusOnContract(string contractNumber, sfa_contractstatus status)
        {
            IReadOnlyCollection<sfa_contract> contracts = null;
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                contracts = xrmContext.sfa_contractSet.Where(c =>
                    c.sfa_number == contractNumber).ToList();
            }

            contracts.ForEach(c =>
            {
                c["sfa_contractstatus"] = new OptionSetValue((int)status);
                c.EntityState = EntityState.Changed;
                CrmOrganizationService.Update(c);
            });
        }

        protected void UpdateStatusOnContract(string contractNumber, int versionNo, int subVersionNo, sfa_contractstatus status)
        {
            IReadOnlyCollection<sfa_contract> contracts;
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                contracts = xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNo && c.sfa_SubVersion == subVersionNo)
                    .ToList();
            }

            contracts.ForEach(c =>
            {
                c["sfa_contractstatus"] = new OptionSetValue((int)status);
                c.EntityState = EntityState.Changed;
                CrmOrganizationService.Update(c);
            });
        }
    }
}