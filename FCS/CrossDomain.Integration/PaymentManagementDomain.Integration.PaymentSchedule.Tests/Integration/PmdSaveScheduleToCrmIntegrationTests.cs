namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Xml.Linq;
    using AutoMapper;
    using Castle.Windsor;
    using ContractCreateDomain.BusinessLogic;
    using ContractCreateDomain.Implementation.Persistence;
    using ContractCreateDomain.Integration.ContractRequest.IoC;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;
    using MoreLinq;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using ContractCreateDomain.Implementation;
    using UnitTests.Common;
    using Utils;
    using contractor = CrossDomain.Integration.Entities.CorporateContract.contractor;
    using contractType = CrossDomain.Integration.Entities.ContractRequest.contractType;
    using deliverableType = CrossDomain.Integration.Entities.CorporateContract.deliverableType;
    using hierarchyType = CrossDomain.Integration.Entities.CorporateContract.hierarchyType;
    using periodTypeType = CrossDomain.Integration.Entities.CorporateContract.periodTypeType;
    using XmlSerializer = System.Xml.Serialization.XmlSerializer;
    using CrmConnectionFactory = FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class PmdSaveScheduleToCrmIntegrationTests
    {
        private Mock<IMessageContext> _messageContextMock;
        private Guid _masterContractGuid;
        public EntityReference ConfirmReceiptofSignedContract;
        private Mock<IBus> _busMock;
        private readonly Mock<IContractsPaymentManager> _contractsPaymentManagerMock = new Mock<IContractsPaymentManager>();
        private IWindsorContainer Container { get; set; }
        public static EntityReference ApprovedStatus;
        public static EntityReference PublishedToProvider;
        public static contractType AmendedContract;
        private contract _masterContract;
        private static IOrganizationService _organizationService;

        private static CrmConnection CrmConnection => CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);

        private static IOrganizationService CrmOrganizationService => _organizationService ?? (_organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService());

        protected contract GetCorpContract()
        {
            if (_masterContract == null)
            {
                using (var resource = new TestResource("SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests",
                        @"Resources.masterContract.xml"))
                {
                    var document = XDocument.Load(resource.Stream);

                    XmlSerializer serializer =
                        new XmlSerializer(typeof(contract));
                    _masterContract = (contract)serializer.Deserialize(document.Root.CreateReader());
                }
            }

            return _masterContract;
        }

        protected ExtendedContract GetExtendedCorpContract()
        {
            return TransformCorpContractToExtendedCorpContract(GetCorpContract());
        }

        private static ExtendedContract TransformCorpContractToExtendedCorpContract(contract corpContract)
        {
            Mapper.CreateMap<contract, ExtendedContract>();
            Mapper.CreateMap<CrossDomain.Integration.Entities.CorporateContract.contractType, ExtendedContractType>();
            Mapper.CreateMap<contractAllocationsContractAllocation, ExtendedContractAllocation>();
            return Mapper.Map<contract, ExtendedContract>(corpContract);
        }

        [TestCleanup]
        public void CleanUp()
        {
            RemoveContractsForMaster(_masterContractGuid, CrmOrganizationService);
            RemoveMasterContract(_masterContractGuid, CrmOrganizationService);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsPaymentManager_GetFundingTypeForAllocation_ShouldReturnFundingTypeCode_ForGivenAllocationNumber()
        {
            // Arrange
            SetupMocks();
            CreateTestLevyContract("1113");

            var mgr = new ContractsPaymentManager(Mock.Of<ILogger>(), CrmOrganizationService)
            {
                ContractVersionNumber = 1,
                DeliverableCode = "1",
                AllocationNumber = "LEVY-1113",
                ContractNumber = "APPLEVY-1713"
            };

            // Act
            var fundingTypeCode = mgr.GetFundingTypeForAllocation("LEVY-1113");

            // Assert
            Assert.AreEqual("LEVY", fundingTypeCode);
        }

        private static ExtendedContractType SetupContract(string masterContractNumber, string newContractNumber)
        {
            string contractNumber = "LEVY-" + newContractNumber;
            string fundingTypeStreamCode = "LEVY";

            return new ExtendedContractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = fundingTypeStreamCode
                },
                fundingStream = new fundingStream
                {
                    fundingStreamCode = fundingTypeStreamCode
                },
                contractNumber = masterContractNumber,
                contractVersionNumber = 1,
                contractSubVersionNumber = 0,
                contractor = new contractor
                {
                    organisationIdentifier = "ORG000671",
                    ukprn = 10000671,
                    legalName = "NACRO",
                    organisationAddressIdentifier = 0
                },
                hierarchyType = hierarchyType.MASTERCONTRACT,
                startDate = new DateTime(2015, 08, 01),
                endDate = new DateTime(2016, 07, 31),
                contractValue = 0,
                parentContractVersionNumber = 0,
                amendmentType = "None",

                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContractType
                    {
                        contractNumber = contractNumber,
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 0,
                        description = "AT Data 24Plus",
                        contractor = new contractor
                        {
                            organisationIdentifier = "ORG000671",
                            ukprn = 10000671,
                            legalName = "NACRO",
                            organisationAddressIdentifier = 0,
                            Status = "Active"
                        },
                        hierarchyType = hierarchyType.CONTRACT,
                        contractType1 = "Contract for Services",
                        startDate = new DateTime(2015, 08, 01),
                        endDate = new DateTime(2016, 07, 31),
                        contractValue = 8000,
                        parentContractVersionNumber = 0,
                        amendmentType = amendmentType.None.ToString(),
                        period = new period
                        {
                            period1 = "1599",
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodTypeCodeType.AY,
                                periodTypeName = periodTypeNameType.ACADEMICYEAR
                            },
                            startDate = new DateTime(0001, 01, 01),
                            endDate = new DateTime(0001, 01, 01)
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeCode = fundingTypeStreamCode
                        },
                        fundingStream = new fundingStream
                        {
                            fundingStreamCode = fundingTypeStreamCode
                        },
                        contractAllocations = new List<ExtendedContractAllocation>
                        {
                            new ExtendedContractAllocation
                            {
                                contractAllocationNumber = "LEVY-" + newContractNumber,
                                hierarchyType = contractAllocationsContractAllocationHierarchyType.CONTRACTALLOCATION,
                                fundingStreamPeriodCode = fundingTypeStreamCode + "1599",
                                startDate = new DateTime(0001, 01, 01),
                                endDate = new DateTime(0001, 01, 01),
                                maximumContractValue = 9999,
                                period = new period
                                {
                                    period1 = "1517",
                                    periodType = new periodTypeType
                                    {
                                        periodTypeCode = periodTypeCodeType.AY,
                                        periodTypeName = periodTypeNameType.ACADEMICYEAR
                                    },
                                    startDate = new DateTime(0001, 01, 01),
                                    endDate = new DateTime(0001, 01, 01)
                                },
                                fundingStream = new fundingStream
                                {
                                    fundingStreamCode = fundingTypeStreamCode
                                },
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1,
                                            deliverableName = "Total LEVY Funding",
                                        },
                                        deliverableDescription = "Total LEVY Funding",
                                        unitCost = 0.0m,
                                        plannedVolume = 0,
                                        plannedValue = 2000.0m,
                                        DisplayOrder =1,
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 8,
                                                year = 2015,
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeCode = periodTypeCodeType.CM,
                                                    periodTypeName = periodTypeNameType.CALENDARMONTH
                                                },
                                                unitCost = 0.0m,
                                                plannedVolume = 0,
                                                plannedValue = 5000.00m,
                                                aggregate = false,
                                                periodName = "Aug-15",
                                                displayOrder = 201508
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 9,
                                                year = 2015,
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeCode = periodTypeCodeType.CM,
                                                    periodTypeName = periodTypeNameType.CALENDARMONTH
                                                },
                                                unitCost = 0.0m,
                                                plannedVolume = 0,
                                                plannedValue = 50000.00m,
                                                aggregate = false,
                                                periodName = "Sep-15",
                                                displayOrder = 201509
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };
        }

        private ExtendedContractType CreateTestLevyContract(string newContractNumber)
        {
            const string batchId = "XX";
            string correlationId = Guid.NewGuid().ToString();
            string masterContractNumber = "SFA-" + newContractNumber;

            var masterContract = SetupContract(masterContractNumber, newContractNumber);

            if (ApprovedStatus == null || ConfirmReceiptofSignedContract == null)
                using (var xrmservice = new XrmServiceContext(CrmOrganizationService))
                {
                    var approvedSubStatus = (from status in xrmservice.sfa_statusSet
                                             where status.sfa_name == "Approved"
                                             select status.Id).FirstOrDefault();
                    ApprovedStatus = new EntityReference(sfa_status.EntityLogicalName, approvedSubStatus);

                    var publishedToProvider = (from status in xrmservice.sfa_statusSet
                                               where status.sfa_name == "Published to Provider"
                                               select status.Id).FirstOrDefault();
                    PublishedToProvider = new EntityReference(sfa_status.EntityLogicalName, publishedToProvider);

                    var confirmPublicationToProvider = (from status in xrmservice.sfa_transitionSet
                                                        where status.sfa_name == "Confirm Receipt of Signed Contract"
                                                        select status.Id).FirstOrDefault();
                    ConfirmReceiptofSignedContract = new EntityReference(sfa_transition.EntityLogicalName,
                        confirmPublicationToProvider);
                }


            masterContract.contractNumber = masterContractNumber;
            int ukprn = masterContract.contractor.ukprn;
            IContractsManager contractsManager = new ContractsManager
            {
                LookupManager = new LookupManager
                {
                    OrganizationService = CrmOrganizationService,
                    EnduringCacheManager = new EnduringCacheManager(),
                    BatchCacheManager = new BatchCacheManager()
                },
                OrganizationService = CrmOrganizationService,
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = CrmOrganizationService
                }
            };
            contractsManager.BatchId = batchId;
            Guid masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
            Assert.IsTrue(masterContractGuid != null);
            _masterContractGuid = masterContractGuid;

            var newMasterContract = contractsManager.GetLatestContract(
                masterContractNumber, masterContract.contracts.Select(c => c.contractNumber));

            var contractRequestTransformer = new ContractRequestTransformer();

            var newExtendedContract = contractRequestTransformer.TransformToCorpContractType(new contractRequestType { contract = newMasterContract });

            var contractId = newMasterContract.contracts[0].Id;

            if (contractId != null)
            {
                IList<Entity> allocations = GetAllocationsForContract(contractId.Value);

                foreach (var allocation in allocations)
                {
                    UpdatePaymentPostedFlag(allocation.Id);
                }

                UpdateContractStatusToApproved(contractId.Value);

            }

            return masterContract;
        }

        public void ChangeContractStateToBpproved(Guid? contractGuid)
        {
            using (var xrmService = new XrmServiceContext(CrmOrganizationService))
            {
                var columnValues = new List<ColumnValueCriteria>
                {
                    new ColumnValueCriteria("sfa_contractid", ConditionOperator.Equal, contractGuid)

                };
                CrmLookupCriteria lookupCriteria = new CrmLookupCriteria
                {
                    EntityName = CrmEntityName.Contract,
                    LookupCriteria = columnValues
                };
                Entity amendedContract = CrmManager.GetCrmEntities(lookupCriteria).First();
                using (var xrmservice = new XrmServiceContext(CrmOrganizationService))
                {
                    var contractToUpdate = new sfa_contract()
                    {
                        Id = amendedContract.Id,
                        sfa_contractId = contractGuid,
                        sfa_SubStatus = PublishedToProvider,
                        sfa_ContractStatusEnum = sfa_contractstatus.Approved,
                        sfa_NextAction = ConfirmReceiptofSignedContract


                    };

                    xrmservice.Attach(contractToUpdate);
                    xrmservice.UpdateObject(contractToUpdate);
                    xrmservice.SaveChanges();

                }

            }


        }

        private static void UpdatePaymentPostedFlag(Guid allocationId)
        {

            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                IQueryable<sfa_contractdeliverableperiod> query = from ca in xrmContext.sfa_contractallocationSet
                                                                  join del in xrmContext.sfa_contractdeliverableSet on ca.sfa_contractallocationId
                                                                      equals del.sfa_ContractAllocationId.Id
                                                                  join cdp in xrmContext.sfa_contractdeliverableperiodSet on del.sfa_contractdeliverableId equals
                                                                      cdp.sfa_ContractDeliverableId.Id
                                                                  where ca.sfa_contractallocationId == allocationId &&
                                                                        (cdp.sfa_Period == 8 || cdp.sfa_Period == 9 || cdp.sfa_Period == 10)
                                                                  select cdp;


                foreach (var cdp in query)
                {
                    var contractDeliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.Id,
                        sfa_contractdeliverableperiodId = cdp.sfa_contractdeliverableperiodId,
                        sfa_PaymentPosted = true
                    };

                    CrmOrganizationService.Update(contractDeliverablePeriodToUpdate);
                }

            }

        }

        private void SetupMocks()
        {
            Dictionary<string, string> headers = new Dictionary<string, string>();
            headers.Add(Headers.CorrelationId, Guid.NewGuid().ToString());

            _messageContextMock = new Mock<IMessageContext>();
            _messageContextMock
                .SetupGet(p => p.Headers)
                .Returns(() => headers);

            _busMock = new Mock<IBus>();
            _busMock
                .As<IManageMessageHeaders>()
                .SetupGet(x => x.SetHeaderAction)
                .Returns((o, s1, s2) => { });

            _busMock.SetupGet(p => p.CurrentMessageContext).Returns(() => _messageContextMock.Object);

            _contractsPaymentManagerMock.Setup(x => x.UpdateAllocationSchedulesInCrm(It.IsAny<Allocation>(), It.IsAny<AllocationInfo>(), It.IsAny<IReadOnlyCollection<DeliverableInfo>>(), It.IsAny<IReadOnlyCollection<DeliverablePeriodYear>>()));
        }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();
            Container = new WindsorContainer();
            Container.Install(new WindsorInstaller(factory));
        }

        private static void UpdateContractStatusToApproved(Guid contractId)
        {
            var contractToUpdate = new sfa_contract
            {
                Id = contractId,
                sfa_ContractStatusEnum = sfa_contractstatus.Approved,
                sfa_LastApprovedVersion = true,
                sfa_SubStatus = ApprovedStatus
            };

            CrmOrganizationService.Update(contractToUpdate);
        }

        protected IList<Entity> GetContractsForMaster(Guid masterContractGuid)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_parentcontractid", ConditionOperator.Equal, masterContractGuid)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria
            {
                EntityName = CrmEntityName.Contract,
                LookupCriteria = columnValues
            };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        protected IList<Entity> GetAllocationsForContract(Guid contractGuid)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contractid", ConditionOperator.Equal, contractGuid)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria
            {
                EntityName = CrmEntityName.ContractAllocation,
                LookupCriteria = columnValues
            };

            return CrmManager.GetCrmEntities(lookupCriteria);
        }

        private void RemoveContractsForMaster(Guid masterContractGuid, IOrganizationService crmService)
        {
            var contracts = GetContractsForMaster(masterContractGuid);
            contracts.ForEach(c => CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, c.Id));
        }

        private static void RemoveMasterContract(Guid masterContractGuid, IOrganizationService crmService)
        {
            var columnValues = new List<ColumnValueCriteria>
            {
                new ColumnValueCriteria("sfa_contractid", ConditionOperator.Equal, masterContractGuid)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria
            {
                EntityName = CrmEntityName.Contract,
                LookupCriteria = columnValues
            };

            CrmManager.DeleteEntity(crmService, CrmEntityName.Contract, masterContractGuid);
        }
    }
}