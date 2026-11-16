namespace ADMonitoringDomain.Endpoint.Tests.Integration
{
    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using DataStore;
    using BusinessLogic;
    using Endpoint;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentGenerationDomain.BusinessLogic;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;
    
    using SFA.FCT.Framework.Logging.NullObjects;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using PaymentGenerationDomain.Integration.DataStore;
    using ADMonitoringDomain.Endpoint.Repositories;
    using NServiceBus;
    using NServiceBus.Testing;
    using EntityData= Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using ISessionConnectionFactory = Infrastructure.ISessionConnectionFactory;

    [TestClass]
    public class DwAllocationApprovedTests
    {
        #region 'Constants'

        //private const string CategoryNewContractAllocationApproved = "NewContractAllocationApproved";
        private const string PoPAlNo = "TestOLAS-1284";
        private const string PoAAlNo = "TestEOP-1284";
        private const string ExtAlNo = "TestALL-1284";
        private const string PoIAlNo = "TestLEVY-1284";
        private const string PoPConNo = "TestOLAS-1284";
        private const string PoAConNo = "TestEMP1-1284";
        private const string ExtConNo = "TestMain-1284";
        private const string PoIConNo = "TestLEVY-1284";
        private const int VerNo = 1;
        private const int AmendVerNo = 2;
        private const int SubVNo = 5;
        private const string PoPFspCode = "TestOLASS1516";
        private const string PoAFspCode = "TestEOP1517";
        private const string ExtFspCode = "Test42+ALLF1516";
        private const string PoIFspCode = "TestLEVY1799";
        private const string UopCode = "4";
        private const string AlPTypeCode = "AY";
        private const string OrgId = "ORG5678912";
        private const string AOrgId = "777111";
        private const string AOrgIdName = "UKPROVIDERREFERENCENUMBER";
        private const int DelCode = 7;
        private const decimal DelPlannedVal = 1000.2M;
        private const int DelPlannedVol = 2300;
        private const int ChildDelCode = 7;
        private const decimal ChildDelPlannedVal = 4800.4M;
        private const int ChildDelPlannedVol = 900;
        private const string Period1 = "201508";
        private const string Period1PeriodType = "CM";
        private const int Del1Ref = 1;
        private const decimal Period1Payment1Balancing = 2000.45M;
        private const decimal Period1Payment1Capping = 2100.12M;
        private const decimal Period1Payment1Net = 2200.99M;
        private const decimal Period1Payment1Profile = 3300.03M;
        private const decimal Period1Payment1Recon = 4400.01M;
        private const decimal Period1Payment2Balancing = 3456.45M;
        private const decimal Period1Payment2Capping = 2101.13M;
        private const decimal Period1Payment2Net = 2240.98M;
        private const decimal Period1Payment2Profile = 3500.53M;
        private const decimal Period1Payment2Recon = 4600.07M;
        private const string Period2 = "201509";
        private const string Period2PeriodType = "CM";
        private const int Del2Ref = 2;
        private const decimal Period2Payment1Balancing = 2020.45M;
        private const decimal Period2Payment1Capping = 2111.15M;
        private const decimal Period2Payment1Net = 2250.79M;
        private const decimal Period2Payment1Profile = 3330.13M;
        private const decimal Period2Payment1Recon = 44001.21M;
        private const decimal Period2Payment2Balancing = 2020.45M;
        private const decimal Period2Payment2Capping = 2300.11M;
        private const decimal Period2Payment2Net = 2200.96M;
        private const decimal Period2Payment2Profile = 3360.03M;
        private const decimal Period2Payment2Recon = 4405.04M;
        private const decimal Period1Agg1Val = 5000.6M;
        private const string Period1Agg1PayType = "PROFILE";
        private const string Period1Agg1SubnomCode = "88888";
        private const decimal Period1Agg1Del1Val = 5000.6M;
        private const int Period1Agg1Del1Code = 1;
        private const decimal Period2Agg1Val = 8900.4M;
        private const string Period2Agg1PayType = "CAPPING";
        private const string Period2Agg1SubnomCode = "99999";
        private const decimal Period2Agg1Del1Val = 5000.6M;
        private const int Period2Agg1Del1Code = 1;
        private const decimal Period2Agg1Del2Val = 5050.7M;
        private const int Period2Agg1Del2Code = 2;
        private const decimal Period2Agg2Val = 8111.6M;
        private const string Period2Agg2PayType = "RECONCILIATION";
        private const string Period2Agg2SubnomCode = "000001";
        private const decimal Period2Agg2Del1Val = 7856.88M;
        private const int Period2Agg2Del1Code = 1;
        private const int Ukprn = 12345678;

        #endregion

        [TestInitialize]
        public void Initialize()
        {
            TearDownTestData();
            LoggerFactory factory = new LoggerFactory();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            TearDownTestData();
        }

        private void TearDownTestData()
        {
            DeleteAllocations();
            DeletePolicyFsps();
            DeleteAllocationDeliveryEventsEReceived();
            DeleteAllocationDelivery();
            DeleteActuals();
            DeleteDeliverablePayments();
        }

        private void DeleteDeliverablePayments()
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                var existingRecords =
                    context.DeliverablePayments.Where(
                        x => x.AllocationNumber.Contains(PoPAlNo)
                             || x.AllocationNumber.Contains(PoAAlNo)
                             || x.AllocationNumber.Contains(ExtAlNo)
                             || x.AllocationNumber.Contains(PoIAlNo));

                existingRecords.ToList().ForEach(record =>
                {
                    context.DeliverablePayments.Remove(record);

                });
                context.SaveChanges();
            }
        }

        private void DeleteActuals()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {

                var existingRecords =
                    context.AllocationDeliverablePeriodActualAudits.Where(
                        x => x.ContractAllocationNumber.Contains(PoPAlNo)
                             || x.ContractAllocationNumber.Contains(PoAAlNo)
                             || x.ContractAllocationNumber.Contains(ExtAlNo)
                             || x.ContractAllocationNumber.Contains(PoIAlNo));

                existingRecords.ToList().ForEach(record =>
                {
                    context.AllocationDeliverablePeriodActualAudits.Remove(record);

                });
                context.SaveChanges();
            }
        }

        private static void DeleteAllocationDelivery()
        {
            using (var context = new AllocationDeliveryDbContext())
            {
                context.Database.ExecuteSqlCommand("Delete from [AllocationDelivery].[AllocationDeliveryEntry]");
            }
        }

        private static void DeleteAllocationDeliveryEventsEReceived()
        {
            using (var context = new AllocationDeliveryMonitoringDbContext())
            {

                var existingRecords =
                    context.AllocationDeliveryEventsReceived.Where(
                        x => x.AllocationNumber.Contains(PoPAlNo)
                             || x.AllocationNumber.Contains(PoAAlNo)
                             || x.AllocationNumber.Contains(ExtAlNo)
                             || x.AllocationNumber.Contains(PoIAlNo));

                existingRecords.ToList().ForEach(record =>
                {
                    context.AllocationDeliveryEventsReceived.Remove(record);

                });
                context.SaveChanges();
            }
        }

        private static void DeletePolicyFsps()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                var existingRecords =
                    context.PolicyFundingStreamPeriods.Where(
                        x => x.FundingStreamPeriod.Contains(PoPFspCode)
                             || x.FundingStreamPeriod.Contains(PoAFspCode)
                             || x.FundingStreamPeriod.Contains(ExtFspCode)
                             || x.FundingStreamPeriod.Contains(PoIFspCode));

                existingRecords.ToList().ForEach(record =>
                {
                    context.PolicyFundingStreamPeriods.Remove(record);

                });
                context.SaveChanges();
            }
        }

        private static void DeleteAllocations()
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                var existingRecords =
                    context.Allocations.Where(
                        x => x.AllocationNumber.Contains(PoPAlNo)
                             || x.AllocationNumber.Contains(PoAAlNo)
                             || x.AllocationNumber.Contains(ExtAlNo)
                             || x.AllocationNumber.Contains(PoIAlNo));

                existingRecords.ToList().ForEach(record =>
                {
                    context.Allocations.Remove(record);

                });
                context.SaveChanges();
            }
        }

        private ContractAllocationApprovedHandler SetupContractAllocationApprovedHandler()
        {
            IAllocationDeliveryDbContext allocationDeliveryDbContext = new AllocationDeliveryDbContext();
            IAllocationDeliveryMonitoringDbContext allocationDeliveryMonitoringDbContext = new AllocationDeliveryMonitoringDbContext();
            IPaymentManagementPolicyContext paymentManagementPolicyContext = new PaymentManagementPolicyContext();
            IPaymentSchedulePolicyContext paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();
            IMonitoringDeliverablesDbContext monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext();
            PaymentGenerationDbContext paymentGenerationDbContext = new PaymentGenerationDbContext();
            IDate dateProvider = new StaticDate(new OverrideDateDBContext());
            ILogger logger = new LoggerNullObject();
            IDataAccessManager dataAccessManager = new DataAccessManager(new SubnominalAggregationRepository(), logger);
            ISchemaValidator schemaValidator = new SchemaValidator();
            ContractManagementDbContext contractManagementDbContext = new ContractManagementDbContext();
            IApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();

            IAtomItemCreator atomItemCreator = new AtomItemCreator(dataAccessManager,
                approvedContractRepository, new AllocationDeliverablePeriodActualAuditRepository());

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(EntityData.ConnectionInfo.CreateFrom(new ContractManagementDbContext().Database.Connection));

            return new ContractAllocationApprovedHandler(
                logger,
                new AllocationDeliveryMonitoringRepository(dateProvider),
                new AllocationDeliveryPerformanceMapper(approvedContractRepository) { Logger = logger, SchemaValidator = schemaValidator },
                dateProvider,
                new AtomGenerator(atomItemCreator) { SchemaValidator = schemaValidator },
                sessionConnectionFactoryMock.Object);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_NewContractApproved_PayOnActualAllocation_ShouldCreateAllocationDeliveryEntry()
        {
            //Arrange
            var handler = SetupContractAllocationApprovedHandler();

            var message = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = "EOP1-1284",
                    contractReference = new contractReferenceType() { contractVersionNumber = 1, contractNumber = "EMP1-1284", contractSubVersionNumber = 0 },

                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = "EOP1517"
                    },
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = "ORG1234567",
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                       {
                           new alternativeOrganisationIdentifierType
                           {
                               OrganisationIdentifier = "ORG1234567",
                               OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                           }
                       }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable=new deliverableType
                            {
                                deliverableCode=1,
                                isLegal=true,
                                isMonitoring = true
                            },
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    plannedValue =100,
                                    period = new periodType
                                    {
                                        periodValue = "200601"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            SetUpApprovedContract("EMP1-1284", "EOP1-1284", 1);

            //Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryDb("EMP1-1284", "1", "EOP1-1284", "0", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_NewContractApproved_ExternallyPaidAllocation_ShouldCreateEntryInAllocationDeliveryPerformanceDb()
        {
            //Arrange
            SetUpData(PaymentMethod.NoPay, ExtAlNo, AmendVerNo, ExtConNo, ExtFspCode);

            var handler = SetupContractAllocationApprovedHandler();

            var message = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = ExtAlNo,
                    contractReference =
                        new contractReferenceType()
                        {
                            contractVersionNumber = 1,
                            contractNumber = ExtConNo,
                            contractSubVersionNumber = 0
                        },

                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = ExtFspCode
                    },
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = "ORG1234567",
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = "ORG1234567",
                                OrganisationIdentifierName =
                                    alternativeOrganisationIdentifierTypeOrganisationIdentifierName
                                        .UKPROVIDERREFERENCENUMBER
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable=new deliverableType
                            {
                                deliverableCode=1,
                                isLegal=true,
                                isMonitoring = true
                            },
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    plannedValue =100,
                                    period = new periodType
                                    {
                                        periodValue = "200601"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryDb(ExtConNo, "1", ExtAlNo, "0", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_NewContractApproved_AllocationDeliveryCommenced_PayOnProfileAllocation_ShouldNotCreateEntryInAllocationDeliveryPerformanceDb_WhenOtherEventsHaveNotBeenReceived()
        {
            //Arrange
            var handler = SetupContractAllocationApprovedHandler();

            var message = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = "OLAS-1284",
                    contractReference = new contractReferenceType() { contractVersionNumber = 1, contractNumber = "OLAS-1284", contractSubVersionNumber = 0 },

                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = "OLASS1516"
                    },
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = "ORG1234567",
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = "1234567",
                                OrganisationIdentifierName =
                                    alternativeOrganisationIdentifierTypeOrganisationIdentifierName
                                        .UKPROVIDERREFERENCENUMBER
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable=new deliverableType
                            {
                                deliverableCode=1,
                                isLegal=true,
                                isMonitoring = true
                            },
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    plannedValue =100,
                                    period = new periodType
                                    {
                                        periodValue = "200601"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            //Assert
            //AssertIfDataExistsInAllocationDeliveryMonitoringDb();
            AssertIfDataDoesNotExistsInAllocationDeliveryDb("OLAS-1284", "1", "OLAS-1284", "0", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_NewContractApproved_PaymentCalculated_PayOnProfileAllocation_ShouldNotCreateEntryInAllocationDeliveryPerformanceDb_WhenOtherEventsHaveNotBeenReceived()
        {
            //Arrange

            SetUpData(PaymentMethod.PayOnProfile, PoPAlNo, AmendVerNo, PoPConNo, PoPFspCode);

            var handler = SetupContractAllocationApprovedHandler();

            var message = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = PoPAlNo,
                    ContractNumber = PoPConNo,
                    VersionNumber = 1,
                    FundingStreamPeriodCode = PoPFspCode,
                    Organisation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Organisation
                    {
                        MainOrganisationIdentifier = "ORG1234567",
                        OrganisationIdentifiers = new List<OrganisationIdentifier>
                        {
                            new OrganisationIdentifier
                            {
                                OrganisationId = "1234567",
                                OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                            }
                        }
                    }
                }
            };

            //Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoPConNo, VerNo.ToString(), PoPAlNo, "0", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_NewContractApproved_PaymentAggregated_PayOnProfileAllocation_ShouldNotCreateEntryInAllocationDeliveryPerformanceDb_WhenOtherEventsHaveNotBeenReceived()
        {
            //Arrange
            SetUpData(PaymentMethod.PayOnProfile, PoPAlNo, AmendVerNo, PoPConNo, PoPFspCode);

            var handler = SetupContractAllocationApprovedHandler();

            var message = new PaymentAggregatedEvent
            {
                Allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = PoPAlNo,
                    VersionNumber = 1,
                    FundingStreamPeriodCode = PoPFspCode,
                    Organisation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Organisation
                    {
                        MainOrganisationIdentifier = "ORG1234567",
                        AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                        {
                            new OrgainsationIdentifier()
                            {
                                OrganisationId = "ORG1234567",
                                OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                            }
                        }
                    }
                }
            };

            //Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoPConNo, VerNo.ToString(), PoPAlNo, "0", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_NewContractApproved_PayOnProfileAllocation_ShouldCreateEntryInAllocationDeliveryPerformanceDb_WhenAllEventsHaveBeenReceived()
        {
            //Arrange
            SetUpData(PaymentMethod.PayOnProfile, PoPAlNo, AmendVerNo, PoPConNo, PoPFspCode);

            #region 'AllocationDeliveryCommenced Event'

            var handlerAllocationDeliveryCommence = SetupContractAllocationApprovedHandler();

            var messageAllocationDeliveryCommence = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = PoPAlNo,
                    contractReference = new contractReferenceType
                    {
                        contractNumber = PoPConNo,
                        contractVersionNumber = VerNo,
                        contractSubVersionNumber = SubVNo
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = PoPFspCode,
                        period = new periodType
                        {
                            periodType1 = new periodTypeType
                            {
                                periodTypeCode = (periodTypeCodeType)Enum.Parse(typeof(periodTypeCodeType), AlPTypeCode)
                            }
                        }
                    },
                    uopCode = UopCode,
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = OrgId,
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = AOrgId,
                                OrganisationIdentifierName = (alternativeOrganisationIdentifierTypeOrganisationIdentifierName)Enum.Parse(typeof(alternativeOrganisationIdentifierTypeOrganisationIdentifierName), AOrgIdName)
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = DelCode,
                                isLegal = true,
                                isMonitoring = true
                            },
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    period=new periodType
                                    {
                                        periodValue="200601"
                                    },
                                    plannedValue=10.0M,
                                    plannedVolume = 10
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handlerAllocationDeliveryCommence.Handle(messageAllocationDeliveryCommence, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryMonitoringDb(PoPAlNo, VerNo, "AllocationDeliveryCommencedEvent", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoPConNo, VerNo.ToString(), PoPAlNo, SubVNo.ToString(), AllocationDeliveryEntryCategory.NewContractAllocationApproved);

            #endregion

            #region 'PaymentSchedule Event'

            var handlerPaymentScheduleEvent = SetupContractAllocationApprovedHandler();
            var messagePaymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = PoPAlNo,
                    ContractNumber = PoPConNo,
                    FundingStreamPeriodCode = PoPFspCode,
                    ContractVersionNumber = VerNo,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del1Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment1Balancing,
                                   CappedPaymentAmount = Period1Payment1Capping,
                                   NetPaymentAmount = Period1Payment1Net,
                                   ProfilePaymentAmount = Period1Payment1Profile,
                                   ReconciliationPaymentAmount = Period1Payment1Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment1Balancing,
                                   CappedPaymentAmount = Period2Payment1Capping,
                                   NetPaymentAmount = Period2Payment1Net,
                                   ProfilePaymentAmount = Period2Payment1Profile,
                                   ReconciliationPaymentAmount = Period2Payment1Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del2Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment2Balancing,
                                   CappedPaymentAmount = Period1Payment2Capping,
                                   NetPaymentAmount = Period1Payment2Net,
                                   ProfilePaymentAmount = Period1Payment2Profile,
                                   ReconciliationPaymentAmount = Period1Payment2Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment2Balancing,
                                   CappedPaymentAmount = Period2Payment2Capping,
                                   NetPaymentAmount = Period2Payment2Net,
                                   ProfilePaymentAmount = Period2Payment2Profile,
                                   ReconciliationPaymentAmount = Period2Payment2Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        }
                    }
                }
            };

            //Act
            handlerPaymentScheduleEvent.Handle(messagePaymentScheduleEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryMonitoringDb(PoPAlNo, VerNo, "PaymentScheduleEvent", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoPConNo, VerNo.ToString(), PoPAlNo, "0", AllocationDeliveryEntryCategory.NewContractAllocationApproved);

            #endregion

            #region 'PaymentAggregated Event'

            var handlerPaymentAggregatedEvent = SetupContractAllocationApprovedHandler();

            var messagePaymentAggregatedEvent = new PaymentAggregatedEvent
            {
                Allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    VersionNumber = VerNo,
                    AllocationNumber = PoPAlNo,
                    FundingStreamPeriodCode = PoPFspCode,
                    AllocationPeriods = new List<AllocationPeriod>
                    {
                        new AllocationPeriod
                        {
                            Period = Period1,
                            PeriodTypeCode = (AllocationPeriodPeriodTypeCode)Enum.Parse(typeof(AllocationPeriodPeriodTypeCode), Period1PeriodType),
                            Aggregations = new List<Aggregation>
                            {
                                new Aggregation
                                {
                                    AggregatedValue = Period1Agg1Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period1Agg1PayType),
                                    PostedFlag = true,
                                    SubnominalCode = Period1Agg1SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period1Agg1Del1Code,
                                            DeliverableValue = Period1Agg1Del1Val
                                        }
                                    }
                                }
                            }
                        },
                        new AllocationPeriod
                        {
                            Period = Period2,
                            PeriodTypeCode = (AllocationPeriodPeriodTypeCode)Enum.Parse(typeof(AllocationPeriodPeriodTypeCode), Period2PeriodType),
                            Aggregations = new List<Aggregation>
                            {
                                new Aggregation
                                {
                                    AggregatedValue = Period2Agg1Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period2Agg1PayType),
                                    PostedFlag = true,
                                    SubnominalCode = Period2Agg1SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg1Del1Code,
                                            DeliverableValue = Period2Agg1Del1Val
                                        },
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg1Del2Code,
                                            DeliverableValue = Period2Agg1Del2Val
                                        }
                                    }
                                },
                                new Aggregation
                                {
                                    AggregatedValue = Period2Agg2Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period2Agg2PayType),
                                    PostedFlag = false,
                                    SubnominalCode = Period2Agg2SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg2Del1Code,
                                            DeliverableValue = Period2Agg2Del1Val
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handlerPaymentAggregatedEvent.Handle(messagePaymentAggregatedEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryMonitoringDb(PoPAlNo, VerNo, "PaymentAggregatedEvent", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
            AssertIfDataExistsInAllocationDeliveryDb(PoPConNo, VerNo.ToString(), PoPAlNo, "0", AllocationDeliveryEntryCategory.NewContractAllocationApproved);

            #endregion
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_AmendedContractApproved_PayOnProfileAllocation_ShouldCreateEntryInAllocationDeliveryPerformanceDb_WhenAllEventsHaveBeenReceived()
        {
            //Arrange

            SetUpData(PaymentMethod.PayOnProfile, PoPAlNo, AmendVerNo, PoPConNo, PoPFspCode);

            #region 'AllocationDeliveryCommenced Event'

            var handlerAllocationDeliveryCommence = SetupContractAllocationApprovedHandler();

            var messageAllocationDeliveryCommence = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = PoPAlNo,
                    contractReference = new contractReferenceType
                    {
                        contractNumber = PoPConNo,
                        contractVersionNumber = 2,
                        contractSubVersionNumber = 1
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = PoPFspCode,
                        period = new periodType
                        {
                            periodType1 = new periodTypeType
                            {
                                periodTypeCode = (periodTypeCodeType)Enum.Parse(typeof(periodTypeCodeType), AlPTypeCode)
                            }
                        }
                    },
                    uopCode = UopCode,
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = OrgId,
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = AOrgId,
                                OrganisationIdentifierName = (alternativeOrganisationIdentifierTypeOrganisationIdentifierName)Enum.Parse(typeof(alternativeOrganisationIdentifierTypeOrganisationIdentifierName), AOrgIdName)
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = DelCode,
                                isLegal = true,
                                isMonitoring = true
                            },
                            plannedValue = DelPlannedVal,
                            plannedVolume = DelPlannedVol,
                            contractDeliverables = new List<contractDeliverableType>
                            {
                                new contractDeliverableType
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = ChildDelCode,
                                        isLegal = true,
                                        isMonitoring = true
                                    },
                                    plannedValue = ChildDelPlannedVal,
                                    plannedVolume = ChildDelPlannedVol
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handlerAllocationDeliveryCommence.Handle(messageAllocationDeliveryCommence, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryMonitoringDb(PoPAlNo, AmendVerNo, "AllocationDeliveryCommencedEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoPConNo, AmendVerNo.ToString(), PoPAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion

            #region 'PaymentSchedule Event'

            var handlerPaymentScheduleEvent = SetupContractAllocationApprovedHandler();
            var messagePaymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = PoPAlNo,
                    ContractNumber = PoPConNo,
                    FundingStreamPeriodCode = PoPFspCode,
                    ContractVersionNumber = AmendVerNo,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del1Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment1Balancing,
                                   CappedPaymentAmount = Period1Payment1Capping,
                                   NetPaymentAmount = Period1Payment1Net,
                                   ProfilePaymentAmount = Period1Payment1Profile,
                                   ReconciliationPaymentAmount = Period1Payment1Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment1Balancing,
                                   CappedPaymentAmount = Period2Payment1Capping,
                                   NetPaymentAmount = Period2Payment1Net,
                                   ProfilePaymentAmount = Period2Payment1Profile,
                                   ReconciliationPaymentAmount = Period2Payment1Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del2Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment2Balancing,
                                   CappedPaymentAmount = Period1Payment2Capping,
                                   NetPaymentAmount = Period1Payment2Net,
                                   ProfilePaymentAmount = Period1Payment2Profile,
                                   ReconciliationPaymentAmount = Period1Payment2Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment2Balancing,
                                   CappedPaymentAmount = Period2Payment2Capping,
                                   NetPaymentAmount = Period2Payment2Net,
                                   ProfilePaymentAmount = Period2Payment2Profile,
                                   ReconciliationPaymentAmount = Period2Payment2Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        }
                    }
                }
            };

            //Act
            handlerPaymentScheduleEvent.Handle(messagePaymentScheduleEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoPConNo, AmendVerNo.ToString(), PoPAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion

            #region 'PaymentAggregated Event'

            var handlerPaymentAggregatedEvent = SetupContractAllocationApprovedHandler();

            var messagePaymentAggregatedEvent = new PaymentAggregatedEvent
            {
                Allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    VersionNumber = AmendVerNo,
                    AllocationNumber = PoPAlNo,
                    FundingStreamPeriodCode = PoPFspCode,
                    AllocationPeriods = new List<AllocationPeriod>
                    {
                        new AllocationPeriod
                        {
                            Period = Period1,
                            PeriodTypeCode = (AllocationPeriodPeriodTypeCode)Enum.Parse(typeof(AllocationPeriodPeriodTypeCode), Period1PeriodType),
                            Aggregations = new List<Aggregation>
                            {
                                new Aggregation
                                {
                                    AggregatedValue = Period1Agg1Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period1Agg1PayType),
                                    PostedFlag = true,
                                    SubnominalCode = Period1Agg1SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period1Agg1Del1Code,
                                            DeliverableValue = Period1Agg1Del1Val
                                        }
                                    }
                                }
                            }
                        },
                        new AllocationPeriod
                        {
                            Period = Period2,
                            PeriodTypeCode = (AllocationPeriodPeriodTypeCode)Enum.Parse(typeof(AllocationPeriodPeriodTypeCode), Period2PeriodType),
                            Aggregations = new List<Aggregation>
                            {
                                new Aggregation
                                {
                                    AggregatedValue = Period2Agg1Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period2Agg1PayType),
                                    PostedFlag = true,
                                    SubnominalCode = Period2Agg1SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg1Del1Code,
                                            DeliverableValue = Period2Agg1Del1Val
                                        },
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg1Del2Code,
                                            DeliverableValue = Period2Agg1Del2Val
                                        }
                                    }
                                },
                                new Aggregation
                                {
                                    AggregatedValue = Period2Agg2Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period2Agg2PayType),
                                    PostedFlag = false,
                                    SubnominalCode = Period2Agg2SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg2Del1Code,
                                            DeliverableValue = Period2Agg2Del1Val
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handlerPaymentAggregatedEvent.Handle(messagePaymentAggregatedEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryMonitoringDb(PoPAlNo, AmendVerNo, "PaymentAggregatedEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataExistsInAllocationDeliveryDb(PoPConNo, AmendVerNo.ToString(), PoPAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_AmendedContractApproved_PayOnActualAllocation_ShouldNotCreateEntryInAllocationDeliveryPerformanceDb_WhenPaymentEventsAreTriggeredByReceiptOfActuals()
        {
            //Arrange

            SetUpData(PaymentMethod.PayOnActuals, PoAAlNo, AmendVerNo, PoAConNo, PoAFspCode);

            #region 'AllocationDeliveryCommenced Event'

            var handlerAllocationDeliveryCommence = SetupContractAllocationApprovedHandler();

            var messageAllocationDeliveryCommence = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = PoAAlNo,
                    contractReference = new contractReferenceType
                    {
                        contractNumber = PoAConNo,
                        contractVersionNumber = 2,
                        contractSubVersionNumber = 1
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = PoAFspCode,
                        period = new periodType
                        {
                            periodType1 = new periodTypeType
                            {
                                periodTypeCode = (periodTypeCodeType)Enum.Parse(typeof(periodTypeCodeType), AlPTypeCode)
                            }
                        }
                    },
                    uopCode = UopCode,
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = OrgId,
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = AOrgId,
                                OrganisationIdentifierName = (alternativeOrganisationIdentifierTypeOrganisationIdentifierName)Enum.Parse(typeof(alternativeOrganisationIdentifierTypeOrganisationIdentifierName), AOrgIdName)
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = DelCode,
                                isLegal = true,
                                isMonitoring = true
                            },
                            plannedValue = DelPlannedVal,
                            plannedVolume = DelPlannedVol,
                            contractDeliverables = new List<contractDeliverableType>
                            {
                                new contractDeliverableType
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = ChildDelCode,
                                        isLegal = true,
                                        isMonitoring = true
                                    },
                                    plannedValue = ChildDelPlannedVal,
                                    plannedVolume = ChildDelPlannedVol
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handlerAllocationDeliveryCommence.Handle(messageAllocationDeliveryCommence, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryMonitoringDb(PoAAlNo, AmendVerNo, "AllocationDeliveryCommencedEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoAConNo, AmendVerNo.ToString(), PoAAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion

            #region 'PaymentSchedule Event'

            var handlerPaymentScheduleEvent = SetupContractAllocationApprovedHandler();
            var messagePaymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = PoAAlNo,
                    ContractNumber = PoAConNo,
                    FundingStreamPeriodCode = PoAFspCode,
                    ContractVersionNumber = AmendVerNo,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del1Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment1Balancing,
                                   CappedPaymentAmount = Period1Payment1Capping,
                                   NetPaymentAmount = Period1Payment1Net,
                                   ProfilePaymentAmount = Period1Payment1Profile,
                                   ReconciliationPaymentAmount = Period1Payment1Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment1Balancing,
                                   CappedPaymentAmount = Period2Payment1Capping,
                                   NetPaymentAmount = Period2Payment1Net,
                                   ProfilePaymentAmount = Period2Payment1Profile,
                                   ReconciliationPaymentAmount = Period2Payment1Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del2Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment2Balancing,
                                   CappedPaymentAmount = Period1Payment2Capping,
                                   NetPaymentAmount = Period1Payment2Net,
                                   ProfilePaymentAmount = Period1Payment2Profile,
                                   ReconciliationPaymentAmount = Period1Payment2Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment2Balancing,
                                   CappedPaymentAmount = Period2Payment2Capping,
                                   NetPaymentAmount = Period2Payment2Net,
                                   ProfilePaymentAmount = Period2Payment2Profile,
                                   ReconciliationPaymentAmount = Period2Payment2Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        }
                    }
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationActualsVerified
            };

            //Act
            handlerPaymentScheduleEvent.Handle(messagePaymentScheduleEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryMonitoringDb(PoAAlNo, AmendVerNo, "PaymentScheduleEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoAConNo, AmendVerNo.ToString(), PoAAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion

            #region 'PaymentAggregated Event'

            var handlerPaymentAggregatedEvent = SetupContractAllocationApprovedHandler();
            var messagePaymentAggregatedEvent = new PaymentAggregatedEvent
            {
                Allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    VersionNumber = AmendVerNo,
                    AllocationNumber = PoAAlNo,
                    FundingStreamPeriodCode = PoAFspCode,
                    AllocationPeriods = new List<AllocationPeriod>
                    {
                        new AllocationPeriod
                        {
                            Period = Period1,
                            PeriodTypeCode = (AllocationPeriodPeriodTypeCode)Enum.Parse(typeof(AllocationPeriodPeriodTypeCode), Period1PeriodType),
                            Aggregations = new List<Aggregation>
                            {
                                new Aggregation
                                {
                                    AggregatedValue = Period1Agg1Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period1Agg1PayType),
                                    PostedFlag = true,
                                    SubnominalCode = Period1Agg1SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period1Agg1Del1Code,
                                            DeliverableValue = Period1Agg1Del1Val
                                        }
                                    }
                                }
                            }
                        },
                        new AllocationPeriod
                        {
                            Period = Period2,
                            PeriodTypeCode = (AllocationPeriodPeriodTypeCode)Enum.Parse(typeof(AllocationPeriodPeriodTypeCode), Period2PeriodType),
                            Aggregations = new List<Aggregation>
                            {
                                new Aggregation
                                {
                                    AggregatedValue = Period2Agg1Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period2Agg1PayType),
                                    PostedFlag = true,
                                    SubnominalCode = Period2Agg1SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg1Del1Code,
                                            DeliverableValue = Period2Agg1Del1Val
                                        },
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg1Del2Code,
                                            DeliverableValue = Period2Agg1Del2Val
                                        }
                                    }
                                },
                                new Aggregation
                                {
                                    AggregatedValue = Period2Agg2Val,
                                    PaymentType = (AggregationPaymentType)Enum.Parse(typeof(AggregationPaymentType), Period2Agg2PayType),
                                    PostedFlag = false,
                                    SubnominalCode = Period2Agg2SubnomCode,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = Period2Agg2Del1Code,
                                            DeliverableValue = Period2Agg2Del1Val
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationActualsVerified
            };

            //Act
            handlerPaymentAggregatedEvent.Handle(messagePaymentAggregatedEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryMonitoringDb(PoAAlNo, AmendVerNo, "PaymentAggregatedEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(PoAConNo, AmendVerNo.ToString(), PoAAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_AmendedContractApproved_ExternallyPaidAllocation_ShouldCreateEntryInAllocationDeliveryPerformanceDb_WhenAllEventsHaveBeenReceived()
        {
            //Arrange

            SetUpData(PaymentMethod.NoPay, ExtAlNo, AmendVerNo, ExtConNo, ExtFspCode);

            #region 'AllocationDeliveryCommenced Event'

            var handlerAllocationDeliveryCommence = SetupContractAllocationApprovedHandler();

            var messageAllocationDeliveryCommence = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = ExtAlNo,
                    contractReference = new contractReferenceType
                    {
                        contractNumber = ExtConNo,
                        contractVersionNumber = 2,
                        contractSubVersionNumber = 1
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = ExtFspCode,
                        period = new periodType
                        {
                            periodType1 = new periodTypeType
                            {
                                periodTypeCode = (periodTypeCodeType)Enum.Parse(typeof(periodTypeCodeType), AlPTypeCode)
                            }
                        }
                    },
                    uopCode = UopCode,
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = OrgId,
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = AOrgId,
                                OrganisationIdentifierName = (alternativeOrganisationIdentifierTypeOrganisationIdentifierName)Enum.Parse(typeof(alternativeOrganisationIdentifierTypeOrganisationIdentifierName), AOrgIdName)
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = DelCode,
                                isLegal = true,
                                isMonitoring = true
                            },
                            plannedValue = DelPlannedVal,
                            plannedVolume = DelPlannedVol,
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    plannedValue = DelPlannedVal,
                                    plannedVolume = DelPlannedVol,
                                    period = new periodType
                                    {
                                        periodValue = "200601"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handlerAllocationDeliveryCommence.Handle(messageAllocationDeliveryCommence, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryMonitoringDb(ExtAlNo, AmendVerNo, "AllocationDeliveryCommencedEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(ExtConNo, AmendVerNo.ToString(), ExtAlNo, "1", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion

            #region 'PaymentSchedule Event'

            var handlerPaymentScheduleEvent = SetupContractAllocationApprovedHandler();
            var messagePaymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = ExtAlNo,
                    ContractNumber = ExtConNo,
                    FundingStreamPeriodCode = ExtFspCode,
                    ContractVersionNumber = AmendVerNo,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del1Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment1Balancing,
                                   CappedPaymentAmount = Period1Payment1Capping,
                                   NetPaymentAmount = Period1Payment1Net,
                                   ProfilePaymentAmount = Period1Payment1Profile,
                                   ReconciliationPaymentAmount = Period1Payment1Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment1Balancing,
                                   CappedPaymentAmount = Period2Payment1Capping,
                                   NetPaymentAmount = Period2Payment1Net,
                                   ProfilePaymentAmount = Period2Payment1Profile,
                                   ReconciliationPaymentAmount = Period2Payment1Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del2Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment2Balancing,
                                   CappedPaymentAmount = Period1Payment2Capping,
                                   NetPaymentAmount = Period1Payment2Net,
                                   ProfilePaymentAmount = Period1Payment2Profile,
                                   ReconciliationPaymentAmount = Period1Payment2Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment2Balancing,
                                   CappedPaymentAmount = Period2Payment2Capping,
                                   NetPaymentAmount = Period2Payment2Net,
                                   ProfilePaymentAmount = Period2Payment2Profile,
                                   ReconciliationPaymentAmount = Period2Payment2Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        }
                    }
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationDeliveryCommenced
            };

            //Act
            handlerPaymentScheduleEvent.Handle(messagePaymentScheduleEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryMonitoringDb(PoAAlNo, AmendVerNo, "PaymentScheduleEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataExistsInAllocationDeliveryDb(ExtConNo, AmendVerNo.ToString(), ExtAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfCappingDataExistsInAllocationDeliveryDb(Period1Payment1Capping, AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_AmendedContractApproved_ExternallyPaidAllocation_ShouldNotCreateEntryInAllocationDeliveryPerformanceDb_WhenPaymentEventsAreTriggeredByReceiptOfActuals()
        {
            //Arrange

            SetUpData(PaymentMethod.NoPay, ExtAlNo, AmendVerNo, ExtConNo, ExtFspCode);

            #region 'AllocationDeliveryCommenced Event'

            var handlerAllocationDeliveryCommence = SetupContractAllocationApprovedHandler();

            var messageAllocationDeliveryCommence = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = ExtAlNo,
                    contractReference = new contractReferenceType
                    {
                        contractNumber = ExtConNo,
                        contractVersionNumber = 2,
                        contractSubVersionNumber = 1
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = ExtFspCode,
                        period = new periodType
                        {
                            periodType1 = new periodTypeType
                            {
                                periodTypeCode = (periodTypeCodeType)Enum.Parse(typeof(periodTypeCodeType), AlPTypeCode)
                            }
                        }
                    },
                    uopCode = UopCode,
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = OrgId,
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = AOrgId,
                                OrganisationIdentifierName = (alternativeOrganisationIdentifierTypeOrganisationIdentifierName)Enum.Parse(typeof(alternativeOrganisationIdentifierTypeOrganisationIdentifierName), AOrgIdName)
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = DelCode,
                                isLegal = true,
                                isMonitoring = true
                            },
                            plannedValue = DelPlannedVal,
                            plannedVolume = DelPlannedVol,
                            contractDeliverables = new List<contractDeliverableType>
                            {
                                new contractDeliverableType
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = ChildDelCode,
                                        isLegal = true,
                                        isMonitoring = true
                                    },
                                    plannedValue = ChildDelPlannedVal,
                                    plannedVolume = ChildDelPlannedVol
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handlerAllocationDeliveryCommence.Handle(messageAllocationDeliveryCommence, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryMonitoringDb(ExtAlNo, AmendVerNo, "AllocationDeliveryCommencedEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(ExtConNo, AmendVerNo.ToString(), ExtAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion

            #region 'PaymentSchedule Event'

            var handlerPaymentScheduleEvent = SetupContractAllocationApprovedHandler();
            var messagePaymentScheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = ExtAlNo,
                    ContractNumber = ExtConNo,
                    FundingStreamPeriodCode = ExtFspCode,
                    ContractVersionNumber = AmendVerNo,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del1Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment1Balancing,
                                   CappedPaymentAmount = Period1Payment1Capping,
                                   NetPaymentAmount = Period1Payment1Net,
                                   ProfilePaymentAmount = Period1Payment1Profile,
                                   ReconciliationPaymentAmount = Period1Payment1Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment1Balancing,
                                   CappedPaymentAmount = Period2Payment1Capping,
                                   NetPaymentAmount = Period2Payment1Net,
                                   ProfilePaymentAmount = Period2Payment1Profile,
                                   ReconciliationPaymentAmount = Period2Payment1Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = Del2Ref,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                               new ScheduledPayment
                               {
                                   Period = Period1,
                                   BalancingPaymentAmount = Period1Payment2Balancing,
                                   CappedPaymentAmount = Period1Payment2Capping,
                                   NetPaymentAmount = Period1Payment2Net,
                                   ProfilePaymentAmount = Period1Payment2Profile,
                                   ReconciliationPaymentAmount = Period1Payment2Recon,
                                   PeriodTypeCode = Period1PeriodType
                               },
                               new ScheduledPayment
                               {
                                   Period = Period2,
                                   BalancingPaymentAmount = Period2Payment2Balancing,
                                   CappedPaymentAmount = Period2Payment2Capping,
                                   NetPaymentAmount = Period2Payment2Net,
                                   ProfilePaymentAmount = Period2Payment2Profile,
                                   ReconciliationPaymentAmount = Period2Payment2Recon,
                                   PeriodTypeCode = Period2PeriodType
                               }
                            }
                        }
                    }
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationActualsVerified
            };

            //Act
            handlerPaymentScheduleEvent.Handle(messagePaymentScheduleEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataDoesNotExistsInAllocationDeliveryMonitoringDb(PoAAlNo, AmendVerNo, "PaymentScheduleEvent", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            AssertIfDataDoesNotExistsInAllocationDeliveryDb(ExtConNo, AmendVerNo.ToString(), PoAAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);

            #endregion
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_NewContractApproved_PayOnInstructionAllocation_ShouldCreateEntryInAllocationDeliveryPerformanceDb()
        {
            //Arrange
            SetUpData(PaymentMethod.PayOnInstruction, PoIAlNo, AmendVerNo, PoIConNo, PoIFspCode);

            var handler = SetupContractAllocationApprovedHandler();

            var message = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = PoIAlNo,
                    contractReference =
                        new contractReferenceType()
                        {
                            contractVersionNumber = 1,
                            contractNumber = PoIConNo,
                            contractSubVersionNumber = 0
                        },

                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = PoIFspCode
                    },
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = "ORG1234567",
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = "ORG1234567",
                                OrganisationIdentifierName =
                                    alternativeOrganisationIdentifierTypeOrganisationIdentifierName
                                        .UKPROVIDERREFERENCENUMBER
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable=new deliverableType
                            {
                                deliverableCode=1,
                                isLegal=true,
                                isMonitoring = true
                            },
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    plannedValue =100,
                                    period = new periodType
                                    {
                                        periodValue = "200601"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            //Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryDb(PoIConNo, "1", PoIAlNo, "0", AllocationDeliveryEntryCategory.NewContractAllocationApproved);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_PaymentAggregatedEvent_PayOnInstructionAllocation_ShouldCreateEntryInAllocationDeliveryPerformanceDb()
        {
            //Arrange
            SetUpData(PaymentMethod.PayOnInstruction, PoIAlNo, AmendVerNo, PoIConNo, PoIFspCode);

            var handler = SetupContractAllocationApprovedHandler();

            var message = new PaymentAggregatedEvent
            {
                Allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = PoIAlNo,
                    VersionNumber = AmendVerNo,
                    FundingStreamPeriodCode = PoIFspCode,
                    Organisation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Organisation
                    {
                        MainOrganisationIdentifier = "ORG1234567",
                        AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                        {
                            new OrgainsationIdentifier()
                            {
                                OrganisationId = "ORG1234567",
                                OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                            }
                        }
                    }
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationDeliveryCommenced,
                TimesMessageDeferred = 0
            };

            //Act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            //Assert
            AssertIfDataExistsInAllocationDeliveryDb(PoIConNo, "2", PoIAlNo, "0", AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
        }

        private static void AssertIfDataDoesNotExistsInAllocationDeliveryDb(string contractNumber, string contractVersionNumber, string allocationNumber, string subVersionNumber, AllocationDeliveryEntryCategory allocationDeliveryCategory)
        {
            var versionNumberToInt = int.Parse(contractVersionNumber);
            var subVersionNumberToInt = int.Parse(subVersionNumber);

            using (var context = new AllocationDeliveryDbContext())
            {
                var createdRecordAllocationDelivery =
                    context.AllocationDeliveryEntries.Where(
                        x =>
                            x.AllocationDeliveryCategory == allocationDeliveryCategory
                            && x.VersionNumber == versionNumberToInt
                            && x.AllocationNumber.Contains(allocationNumber)
                            && x.SubVersionNumber == subVersionNumberToInt)
                            .ToList()
                            .SingleOrDefault(allocationDeliveryEntry => allocationDeliveryEntry.GetAllocationDeliveryPerformanceXml().Contains("<contractNumber>" + contractNumber + "</contractNumber>")
                            && allocationDeliveryEntry.GetAllocationDeliveryPerformanceXml().Contains("<contractVersionNumber>" + contractVersionNumber + "</contractVersionNumber>"));

                Assert.IsNull(createdRecordAllocationDelivery, "The allocation delivery performance record was created");
            }
        }

        private static void AssertIfDataExistsInAllocationDeliveryDb(string contractNumber, string contractVersionNumber, string allocationNumber, string subVersionNumber, AllocationDeliveryEntryCategory allocationDeliveryCategory)
        {
            var versionNumberToInt = int.Parse(contractVersionNumber);
            var subVersionNumberToInt = int.Parse(subVersionNumber);

            using (var context = new AllocationDeliveryDbContext())
            {
                var createdRecord =
                    context.AllocationDeliveryEntries.Where(
                        x => x.AllocationDeliveryCategory == allocationDeliveryCategory
                            && x.VersionNumber == versionNumberToInt
                            && x.AllocationNumber.Contains(allocationNumber)
                            && x.SubVersionNumber == subVersionNumberToInt)
                            .ToList()
                            .SingleOrDefault(allocationDeliveryEntry => allocationDeliveryEntry.GetAllocationDeliveryPerformanceXml().Contains("<contractNumber>" + contractNumber + "</contractNumber>")
                            && allocationDeliveryEntry.GetAllocationDeliveryPerformanceXml().Contains("<contractVersionNumber>" + contractVersionNumber + "</contractVersionNumber>"));

                Assert.IsNotNull(createdRecord, "The allocation delivery performance record was not created");
            }
        }

        private static void AssertIfCappingDataExistsInAllocationDeliveryDb(decimal cappingPaymentValue, AllocationDeliveryEntryCategory allocationDeliveryCategory)
        {

            using (var context = new AllocationDeliveryDbContext())
            {
                var createdRecord =
                    context.AllocationDeliveryEntries.Where(
                        x => x.AllocationDeliveryCategory == allocationDeliveryCategory)
                        .ToList()
                        .SingleOrDefault(a => a.GetAllocationDeliveryPerformanceXml().Contains("<CappingPayment>" + cappingPaymentValue + "</CappingPayment>"));

                Assert.IsNotNull(createdRecord, "The allocation delivery performance record was not created");
            }
        }

        private static void AssertIfDataExistsInAllocationDeliveryMonitoringDb(string allocationNumber, int contractVersionNumber, string eventName, AllocationDeliveryEntryCategory allocationDeliveryCategory)
        {
            using (var context = new AllocationDeliveryMonitoringDbContext())
            {
                var createdRecord =
                    context.AllocationDeliveryEventsReceived.SingleOrDefault(
                        x => x.CategoryName == allocationDeliveryCategory.ToString()
                             && x.AllocationNumber.Contains(allocationNumber)
                            && x.VersionNumber == contractVersionNumber
                            && x.EventName == eventName
                            && x.SerializedXml.Length > 0);


                Assert.IsNotNull(createdRecord, "The allocation delivery monitoring performance record was not created");
            }
        }

        private static void AssertIfDataDoesNotExistsInAllocationDeliveryMonitoringDb(string allocationNumber, int contractVersionNumber, string eventName, AllocationDeliveryEntryCategory allocationDeliveryCategory)
        {
            using (var context = new AllocationDeliveryMonitoringDbContext())
            {
                var createdRecord =
                    context.AllocationDeliveryEventsReceived.SingleOrDefault(
                        x => x.CategoryName == allocationDeliveryCategory.ToString()
                             && x.AllocationNumber.Contains(allocationNumber)
                            && x.VersionNumber == contractVersionNumber
                            && x.EventName == eventName
                            && x.SerializedXml.Length > 0);


                Assert.IsNull(createdRecord, "The allocation delivery monitoring performance record was created");
            }
        }

        private void SetUpData(PaymentMethod paymentMethod, string allocationNumber, int versionNumber,
            string contractNumber, string fundingStreamPeriodCode)
        {
            PaymentSchedulePolicyContext paymentSchedulePolicyContext = SetupAllocations(allocationNumber, versionNumber, contractNumber, fundingStreamPeriodCode);
            PaymentManagementPolicyContext paymentManagementPolicyContext = SetupPolicyFsps(paymentMethod, fundingStreamPeriodCode);

            if (versionNumber > 1)
            {
                MonitoringDeliverablesDbContext monitoringDeliverablesDbContext = SetupActuals(allocationNumber, versionNumber, contractNumber, fundingStreamPeriodCode);

                monitoringDeliverablesDbContext.SaveChanges();
            }

            SetUpApprovedContract(contractNumber, allocationNumber, versionNumber);
            
            paymentSchedulePolicyContext.SaveChanges();
            paymentManagementPolicyContext.SaveChanges();
        }

        private static void SetUpApprovedContract(string contractNumber, string allocationNumber, int versionNumber)
        {
            ClearDownDataForContractNumber(contractNumber);

            using (var context = new ContractManagementDbContext())
            {
                var fundingTypePeriod = context.FundingTypeFundingPeriodItems.First();

                ApprovedContract contract = 
                    new ApprovedContract(contractNumber, versionNumber, 0, fundingTypePeriod.FundingTypeCode, fundingTypePeriod.FundingPeriodName, Ukprn, OrgId, 
                                         string.Empty, DateTime.Now.AddDays(7).Date, DateTime.Now.AddYears(1).Date)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                    {
                        new ApprovedContractAllocation
                        {
                            ContractAllocationNumber = allocationNumber
                        }
                    }
                };

                context.ApprovedContracts.Add(contract);
                context.SaveChanges();
            }
        }

        private static void ClearDownDataForContractNumber(string contractNumber)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                var contractIdsToDelete = dbContext.ApprovedContracts.Where(c => contractNumber == c.ContractNumber).Select(c => c.ApprovedContractId).ToList();
                dbContext.ApprovedContracts.RemoveWhere(c => contractIdsToDelete.Contains(c.ApprovedContractId));
                dbContext.ApprovedContractAllocations.RemoveWhere(ca => contractIdsToDelete.Contains(ca.ApprovedContractId));
                dbContext.SaveChanges();
            }
        }

        private static MonitoringDeliverablesDbContext SetupActuals(string allocationNumber, int versionNumber,
            string contractNumber, string fundingStreamPeriodCode)
        {
            var monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext();

            if (fundingStreamPeriodCode == ExtFspCode)
            {
                #region 'Setup ALLF actuals'

                #region 'Per 1'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 10.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201508",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 2'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 12.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201509",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 3'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 10.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201510",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 4'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 12.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201511",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 5'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 10.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201512",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 6'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 12.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201601",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 7'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 10.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201602",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 8'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 12.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201603",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 9'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 10.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201604",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 10'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 12.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201605",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region 'Per 11'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 12.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201606",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #region Per 12'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 12.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201607",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion

                #endregion
            }
            else
            {
                #region 'Setup normal actuals'

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 10.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201508,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201508",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Add(new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = 12.1,
                    ActualVolume = 1,
                    AllocationEndDate = new DateTime(2016, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "R01",
                    CollectionReturnPeriod = 201509,
                    CollectionType = "ILR1516",
                    ContractAllocationNumber = allocationNumber,
                    ContractNumber = contractNumber,
                    ContractSubVersion = 1,
                    ContractVersion = versionNumber - 1,
                    DeliverableCode = 4,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    OrganisationId = "ORG0000007",
                    ParentDeliverableCode = 1,
                    Period = "201508",
                    PeriodTypeCode = "CM",
                    Ukprn = "100006",
                    UopCode = string.Empty
                });

                #endregion
            }

            return monitoringDeliverablesDbContext;
        }

        private static PaymentManagementPolicyContext SetupPolicyFsps(PaymentMethod paymentMethod, string fundingStreamPeriodCode)
        {
            var paymentManagementPolicyContext = new PaymentManagementPolicyContext();
            var fundingStreamPeriod = paymentManagementPolicyContext.PolicyFundingStreamPeriods.SingleOrDefault(
                fsp => fsp.FundingStreamPeriod == fundingStreamPeriodCode);
            if (fundingStreamPeriod != null)
            {
                paymentManagementPolicyContext.PolicyFundingStreamPeriods.Remove(fundingStreamPeriod);
            }
            paymentManagementPolicyContext.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
            {
                FundingStreamPeriod = fundingStreamPeriodCode,
                PaymentMethod = paymentMethod
            });
            return paymentManagementPolicyContext;
        }

        private static PaymentSchedulePolicyContext SetupAllocations(string allocationNumber, int versionNumber, string contractNumber, string fundingStreamPeriodCode)
        {
            var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();

            var allocation = paymentSchedulePolicyContext.Allocations.SingleOrDefault(
                alloc => alloc.AllocationNumber == allocationNumber && alloc.VersionNumber == versionNumber);
            if (allocation != null)
            {
                paymentSchedulePolicyContext.Allocations.Remove(allocation);
            }
            paymentSchedulePolicyContext.Allocations.Add(
                new SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model.Allocation
                {
                    AllocationNumber = allocationNumber,
                    VersionNumber = versionNumber,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    ContractNumber = contractNumber,
                    ContractVersionNumber = versionNumber,
                    //,
                    //AllocationStartDate = new DateTime(2015,8,1),
                    //AllocationEndDate = new DateTime(2016,7,31)
                });

            SetupDeliverables(paymentSchedulePolicyContext, allocationNumber,versionNumber);

            return paymentSchedulePolicyContext;
        }

        private static void SetupDeliverables(PaymentSchedulePolicyContext paymentSchedulePolicyContext, string allocationNumber, int versionNumber)
        {
            paymentSchedulePolicyContext.DeliverablePayments.RemoveWhere(payment => payment.AllocationNumber == allocationNumber && payment.VersionNumber == versionNumber);
            //paymentSchedulePolicyContext.DeliverablePayments.Add(
            //    new DeliverablePayment()
            //    {
            //        AllocationNumber = allocationNumber,
            //        VersionNumber = versionNumber,
            //        DeliverableCode = 1,
            //        Period = "201608",
            //        PlannedValue = 100
            //    }
            //    );

            paymentSchedulePolicyContext.DeliverablePayments.Add(new DeliverablePayment
            {
                CollectionReturnCode = "R01",
                ActualValue = 11,
                ActualVolume = 1,
                Period = "201508",
                AllocationNumber = allocationNumber,
                PeriodTypeCode = PeriodTypeCode.CM,
                BalancingPaymentAmount = 10,
                DeliverableCode = 3,
                CappedPaymentAmount = Period1Payment1Capping,
                NetPaymentAmount = 10,
                PlannedValue = 5,
                PlannedVolume = 5,
                VersionNumber = versionNumber,
                ProfilePaymentAmount = 10.1m,
                ReconciliationPaymentAmount = null
            });

            paymentSchedulePolicyContext.DeliverablePayments.Add(new DeliverablePayment
            {
                CollectionReturnCode = "R01",
                ActualValue = 11,
                ActualVolume = 1,
                Period = "201508",
                AllocationNumber = allocationNumber,
                PeriodTypeCode = PeriodTypeCode.CM,
                BalancingPaymentAmount = 10,
                DeliverableCode = 4,
                CappedPaymentAmount = Period1Payment1Capping,
                NetPaymentAmount = 10,
                PlannedValue = 5,
                PlannedVolume = 5,
                VersionNumber = versionNumber,
                ProfilePaymentAmount = 10.1m,
                ReconciliationPaymentAmount = null
            });
        }
    }
}
