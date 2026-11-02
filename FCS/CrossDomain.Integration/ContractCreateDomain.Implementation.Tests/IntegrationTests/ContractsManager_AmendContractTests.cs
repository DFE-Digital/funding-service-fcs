namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AutoMapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.Contract.XrmAdapterService.Tests.Utils;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Extensions;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using UnitTests.Common;

    [TestClass]
    public class ContractsManager_AmendContractTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsManager_AmendContract_ShouldSaveMasterWithMultipleChildren()
        {
            // arrange
            const string inflightNewStartSuspendedReason = "Inadequate Financial Health";
            const string newStartSuspendedReason = "Other";
            DateTime inflightStopNewStartsDate = DateTime.Now;
            DateTime stopNewStartsDate = inflightStopNewStartsDate.AddDays(1);
            const string inflightTerminationReason = "ProviderChange";

            var contractsManager = CreateContractsManager();
            ExtendedContract masterContract = GetExtendedCorpContract();
            var childContract = masterContract.contracts.Single();
            DeleteContractsWithContractNumber(childContract.contractNumber);
            DeleteContractsWithContractNumber(masterContract.contractNumber);
            childContract.InflightStopNewStartsDate = inflightStopNewStartsDate;
            childContract.InflightNewStartsSuspendedReason = inflightNewStartSuspendedReason;
            childContract.StopNewStartsDate = stopNewStartsDate;
            childContract.NewStartsSuspendedReason = newStartSuspendedReason;
            childContract.InflightTerminationDate = inflightStopNewStartsDate;
            childContract.InflightTerminationReason = inflightTerminationReason;

            childContract.contractAllocations.ForEach(ca =>
            {
                ca.InflightNewStartsSuspendedReason = inflightNewStartSuspendedReason;
                ca.NewStartsSuspendedReason = newStartSuspendedReason;
                ca.InflightStopNewStartsDate = inflightStopNewStartsDate;
                ca.StopNewStartsDate = stopNewStartsDate;
                ca.InflightTerminationDate = inflightStopNewStartsDate;
            });

            // act
            contractsManager.AmendContract(masterContract, Guid.NewGuid().ToString());

            // assert
            var contract = GetContract(childContract.contractNumber, 1, 0);
            Assert.AreEqual(newStartSuspendedReason, contract.sfa_defaultnewstartssuspendedreason.GetNewStartSuspendedReasonText(),
                "sfa_defaultnewstartssuspendedreason on the contract is not correct");
            Assert.AreEqual(stopNewStartsDate.Date, contract.sfa_defaultstopnewstartsdate.GetValueOrDefault().Date,
                "The sfa_defaultstopnewstartsdate on the contract is not correct");
            Assert.AreEqual(inflightStopNewStartsDate.Date, contract.sfa_inflightstopnewstartsdate.GetValueOrDefault().Date,
                "The sfa_inflightstopnewstartsdate on the contract is not correct");
            Assert.AreEqual(inflightNewStartSuspendedReason, contract.sfa_inflightnewstartssuspendedreason.GetNewStartSuspendedReasonText(),
                "The sfa_inflightnewstartssuspendedreason on the contract is not correct");
            Assert.AreEqual(inflightStopNewStartsDate.Date, contract.sfa_inflightterminationdate.GetValueOrDefault().Date,
                "The sfa_inflightterminationdate on the contract is not correct");
            Assert.AreEqual(inflightTerminationReason, contract.sfa_inflightterminationreason.GetText<sfa_TerminationReasons>(),
                "The sfa_inflightterminationreason on the contract is not correct");

            var allocations = GetAllocations(childContract.contractNumber, 1, 0).ToList();
            allocations.ForEach(allocation =>
            {
                Assert.AreEqual(inflightNewStartSuspendedReason,
                    allocation.sfa_inflightnewstartssuspendedreason.GetNewStartSuspendedReasonText(), "The sfa_inflightnewstartssuspendedreason is not correctly set");
                Assert.AreEqual(newStartSuspendedReason,
                    allocation.sfa_newstartssuspendedreason.GetNewStartSuspendedReasonText(), "The sfa_newstartssuspendedreason is not correctly set");
                Assert.AreEqual(inflightStopNewStartsDate.Date,
                    allocation.sfa_inflightstopnewstartsdate.GetValueOrDefault().Date, "The sfa_inflightstopnewstartsdate is not correctly set");
                Assert.AreEqual(stopNewStartsDate.Date,
                    allocation.sfa_stopnewstartsdate.GetValueOrDefault().Date, "The sfa_stopnewstartsdate is not correctly set");
                Assert.AreEqual(inflightStopNewStartsDate.Date,
                    allocation.sfa_inflightterminationdate.GetValueOrDefault().Date, "The sfa_inflightterminationdate is not correctly set");
            });
        }

        private static IContractsManager CreateContractsManager()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            return new ContractsManager
            {
                LookupManager = new LookupManager
                {
                    BatchCacheManager = new BatchCacheManager(),
                    EnduringCacheManager = new EnduringCacheManager(),
                    OrganizationService = organizationService
                },
                OrganizationService = organizationService,
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = organizationService
                },
                XrmWorkflowManager = new XrmWorkflowManager
                {
                    OrganizationService = organizationService
                }
            };
        }

        private void DeleteContractsWithContractNumber(string contractNumber)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria(CrmContractFieldName.Number, ConditionOperator.Equal, contractNumber)
            };

            var lookupCriteria = new CrmLookupCriteria { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            var contracts = CrmManager.GetCrmEntities(lookupCriteria);
            contracts.ForEach(c => RemoveContract(c.Id));
        }

        private void RemoveContract(Guid contractGuid)
        {
            var crmService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            ; ActionRetrier.RetryWhenExceptionThrown<System.ServiceModel.FaultException>(
                () => CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, contractGuid));
        }

        private ExtendedContract GetExtendedCorpContract()
        {
            return TransformCorpContractToExtendedCorpContract(GetCorpContract());
        }

        private static ExtendedContract TransformCorpContractToExtendedCorpContract(contract corpContract)
        {
            Mapper.CreateMap<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract, SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.ExtendedContract>();
            Mapper.CreateMap<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType, SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.ExtendedContractType>();
            Mapper.CreateMap<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractAllocationsContractAllocation, SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.ExtendedContractAllocation>();
            return Mapper.Map<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract, SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.ExtendedContract>(corpContract);
        }

        private static contract GetCorpContract()
        {
            using (var resource = new TestResource("ContractCreateDomain.Implementation.Tests", @"Resources.masterContract.xml"))
            {
                var document = XDocument.Load(resource.Stream);

                XmlSerializer serializer = new XmlSerializer(typeof(SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract));
                return (SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract)serializer.Deserialize(document.Root.CreateReader());
            }
        }

        private static IReadOnlyCollection<sfa_contractallocation> GetAllocations(string contractNumber, int version, int subVersion)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                return (from c in crmContext.sfa_contractSet
                    join a in crmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                    where c.sfa_number == contractNumber
                          && c.sfa_Version == version
                          && c.sfa_SubVersion == subVersion
                    select a).ToList();
            }
        }

        private static sfa_contract GetContract(string contractNumber, int version, int subVersion)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                return (from c in crmContext.sfa_contractSet
                    where c.sfa_number == contractNumber
                          && c.sfa_Version == version
                          && c.sfa_SubVersion == subVersion
                    select c).ToList().Single();
            }
        }
    }
}
