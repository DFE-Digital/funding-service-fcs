namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage;
    using NServiceBus;
    using Moq;
    using BusinessLogic;
    using BusinessLogic.Mapper;
    using Endpoint.Infrastructure;
    using NServiceBus.Testing;
    using Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.Framework.Logging.NullObjects;
    using Validation;
    using SFA.FCT.AllocationDelivery.DataStore.Repositories;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class ReportedActualsLoadedHandlerTests : EndpointIntegrationTestBase
    {
        private IAzureRepository<ReportedActual> _reportedActualRepository;
        private ReportedActual _reportedActualTemplate1 = new ReportedActual();
        private ReportedActual _reportedActualTemplate2 = new ReportedActual();

        private const string PartitionKey = "test-key";
        private const string OrgId = "ORG0006007";
        private const string FspCode = "ESF1420";
        private const string PeriodTypeCode = "CM";
        private const string CollectionType = "ESF";
        private const string ContractNumber1 = "ESIF-4848";
        private const string ContractNumber2 = "ESIF-4849";
        private const string Ukprn = "80019498";
        private const int ContractVersionNumber = 1;
        private const int ContractSubVersionNumber = 0;
        private const int DeliverableCode = 1;
        private const string Period = "201604";
        private const string UopCode = "";
        private const double ActualValue = 100d;
        private const int ActualVolume = 1;
        private const string CollectionReturnCode = "ESF11";

        private static readonly string[] AllocationNumbers = { "ESF-484", "ESF-485", "ESF-486", "ESF-487" };
        private static readonly DateTime StartDate = new DateTime(2016, 3, 1, 1, 0, 0);
        private static readonly DateTime EndDate = new DateTime(2016, 9, 30, 1, 0, 0);

        private const string MessageId = "ReportedActualsLoadedHandlerTests";

        [TestInitialize]
        public void SetupData()
        {
            _reportedActualRepository = Container.Resolve<IAzureRepository<ReportedActual>>();
            _reportedActualTemplate1 = new ReportedActual
            {
                CollectionType = "CC",
                CollectionReturnCode = "1",
                OrganisationId = "12",
                FundingStreamPeriodCode = "GG",
                UoPCode = "HH",
                DeliverableCode = "1",
                Period = "201506"
            };

            _reportedActualTemplate2 = new ReportedActual
            {
                CollectionType = "CC",
                CollectionReturnCode = "1",
                OrganisationId = "1233",
                FundingStreamPeriodCode = "GG",
                UoPCode = "HH",
                DeliverableCode = "1",
                Period = "201506"
            };

            try
            {
                _reportedActualRepository.AddRow(_reportedActualTemplate1);
                _reportedActualRepository.AddRow(_reportedActualTemplate2);
            }
            catch (StorageException)
            {

            }
        }

        public void ClearDown()
        {
            _reportedActualRepository.DeleteRows(_reportedActualTemplate1.PartitionKey);
            _reportedActualRepository.DeleteRows(_reportedActualTemplate2.PartitionKey);
        }

        // commented as activity close date is finished on 31st dec 2023
        //[TestMethod, TestCategory("IntegrationTest")]
        //public void ReportedActualsLoadedHandler_Handle_WithMultipleEsfContractsAndAllocations_StoresCorrectAllocationsInAuditTable()
        //{
        //    using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext())
        //    using (var monitoringDeliverablesContext = new MonitoringDeliverablesDbContext())
        //    {
        //        // Arrange
        //        CleardownTestDataIfExists(monitoringDeliverablesContext, allocationDeliveryDbContext);

        //        var reportedActuals = CreateReportedActualsList(AllocationNumbers);

        //        ReportedActualsLoadedHandler handler = SetUpHandler(monitoringDeliverablesContext, allocationDeliveryDbContext, reportedActuals);

        //        var message = new ReportedActualsLoadedCommand
        //        {
        //            PartitionKeys = new[] { PartitionKey },
        //            FundingStreamPeriodCode = FspCode
        //        };

        //        // Setup data in AllocationDeliverablePeriod table
        //        var contractNumbersAllocationNumbers = new List<KeyValuePair<string, string>>
        //        {
        //            new KeyValuePair<string, string>(ContractNumber1, AllocationNumbers[0]),
        //            new KeyValuePair<string, string>(ContractNumber1, AllocationNumbers[1]),
        //            new KeyValuePair<string, string>(ContractNumber2, AllocationNumbers[2]),
        //            new KeyValuePair<string, string>(ContractNumber2, AllocationNumbers[3])
        //        };
        //        var allocationDeliverablePeriods =
        //            CreateAllocationDeliverablePeriodList(contractNumbersAllocationNumbers);

        //        monitoringDeliverablesContext.AllocationDeliverablePeriods.AddOrUpdate(allocationDeliverablePeriods.ToArray());
        //        monitoringDeliverablesContext.SaveChanges();

        //        // Act
        //        handler.Handle(message, new TestableMessageHandlerContext()).Wait();

        //        // Assert
        //        var addedToDb = monitoringDeliverablesContext.AllocationDeliverablePeriodActualAudits.Where(a =>
        //            a.OrganisationId == OrgId
        //            && a.CollectionType == CollectionType
        //            && a.FundingStreamPeriodCode == FspCode
        //            && a.PeriodTypeCode == PeriodTypeCode
        //            && (a.ContractNumber == ContractNumber1 || a.ContractNumber == ContractNumber2)).ToList();

        //        Assert.AreEqual(addedToDb.Count, reportedActuals.Count);

        //        // Cleanup (did not put this in testcleanup as it is specific to this test)
        //        CleardownTestDataIfExists(monitoringDeliverablesContext, allocationDeliveryDbContext);
        //    }
        //}

        private ReportedActualsLoadedHandler SetUpHandler(MonitoringDeliverablesDbContext monitoringDeliverablesContext,
            IAllocationDeliveryDbContext allocationDeliveryDbContext, IReadOnlyCollection<ReportedActual> testReportedActuals)
        {
            // set up mock repository and dependencies of SUT
            Mock<IMultiSourceActualRepository> mockRepository = new Mock<IMultiSourceActualRepository>();
            var date = new SystemDate();
            LoggerNullObject logger = new LoggerNullObject();
            IMapper<EnrichedReportedActual, ContractAllocationActualsType> mapper = new EnrichedActualMapper();
            MonitoringDeliverableStore deliverableStore = new MonitoringDeliverableStore(logger);
            ActualEnricher actualEnricher = new ActualEnricher(deliverableStore, logger);
            FundingStreamConfigurationStore fundingStreamStore = new FundingStreamConfigurationStore { FundingStreamPeriodCache = new FundingStreamPeriodCache() };
            CurrentViewActualsComponent currentViewActualsComponent = new CurrentViewActualsComponent(deliverableStore);
            ActualsAuditMapper actualsAuditMapper = new ActualsAuditMapper(fundingStreamStore, date);
            ActualValidator actualValidator = new ActualValidator { Date = date, Logger = logger, Store = fundingStreamStore, AllocationsUnderTerminationQueryRepository = Mock.Of<IAllocationsUnderTerminationQueryRepository>() };
            IGenericSubmissionEnricher genericSubmissionEnricher = new GenericSubmissionEnricher(deliverableStore, date);
            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);
            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, monitoringDeliverablesContext.Database.Connection));

            mockRepository.Setup(m => m.GetReportedActuals(new[] { PartitionKey }, null, It.IsAny<ConnectionInfo>())).Returns(testReportedActuals);

         

            var handler = new ReportedActualsLoadedHandler(actualEnricher, actualValidator, mockRepository.Object,
                    logger, mapper, actualsAuditMapper, deliverableStore, currentViewActualsComponent,
                    genericSubmissionEnricher, fundingStreamStore,
                    processedMessageRepositoryMock.Object,
                    sessionConnectionFactoryMock.Object);

            return handler;
        }

        private static void CleardownTestDataIfExists(IMonitoringDeliverablesDbContext monitoringDeliverablesDbContext, IAllocationDeliveryDbContext allocationDeliveryDbContext)
        {
            IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> entitiesToRemove =
                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.Where(a =>
                    a.OrganisationId == OrgId
                    && a.CollectionType == CollectionType
                    && a.FundingStreamPeriodCode == FspCode
                    && a.PeriodTypeCode == PeriodTypeCode
                    && (a.ContractNumber == ContractNumber1 || a.ContractNumber == ContractNumber2)).ToList();

            IReadOnlyCollection<AllocationDeliverablePeriod> allocationDeliverablePeriodsToRemove =
                monitoringDeliverablesDbContext.AllocationDeliverablePeriods.Where(a =>
                    a.OrganisationId == OrgId
                    && a.FundingStreamPeriodCode == FspCode
                    && a.Ukprn == Ukprn
                    && (a.ContractNumber == ContractNumber1 || a.ContractNumber == ContractNumber2)
                    && AllocationNumbers.Any(an => a.ContractAllocationNumber.Contains(an))).ToList();

            // Remove entries we are expecting to add in test
            if (entitiesToRemove.Any())
            {
                monitoringDeliverablesDbContext.AllocationDeliverablePeriodActualAudits.RemoveRange(entitiesToRemove);
                monitoringDeliverablesDbContext.SaveChanges();
            }

            if (allocationDeliverablePeriodsToRemove.Any())
            {
                monitoringDeliverablesDbContext.AllocationDeliverablePeriods.RemoveRange(allocationDeliverablePeriodsToRemove);
                monitoringDeliverablesDbContext.SaveChanges();
            }

            allocationDeliveryDbContext.ProcessedMessages.RemoveWhere(m => m.MessageId == MessageId);
            allocationDeliveryDbContext.SaveChanges();
        }

        private static IReadOnlyCollection<AllocationDeliverablePeriod> CreateAllocationDeliverablePeriodList(
            IEnumerable<KeyValuePair<string, string>> contractNumbersAllocationNumbers)
        {
            return
                contractNumbersAllocationNumbers.Select(
                    contractNumbersAllocationNumber => new AllocationDeliverablePeriod
                    {
                        AllocationStartDate = StartDate,
                        AllocationEndDate = EndDate,
                        ContractAllocationNumber = contractNumbersAllocationNumber.Value,
                        ContractNumber = contractNumbersAllocationNumber.Key,
                        ContractVersionNumber = ContractVersionNumber,
                        ContractSubVersionNumber = ContractSubVersionNumber,
                        DeliverableCode = DeliverableCode,
                        FundingStreamPeriodCode = FspCode,
                        OrganisationId = OrgId,
                        Period = Period,
                        Ukprn = Ukprn,
                        UopCode = UopCode
                    }).ToList();
        }

        private static IReadOnlyCollection<ReportedActual> CreateReportedActualsList(
            string[] allocationNumbers)
        {
            return allocationNumbers.Select(
                allocationNumber => new ReportedActual
                {
                    ActualValue = ActualValue,
                    ActualVolume = ActualVolume,
                    CollectionReturnCode = CollectionReturnCode,
                    CollectionType = CollectionType,
                    ContractAllocationNumber = allocationNumber,
                    DeliverableCode = DeliverableCode.ToString(),
                    FundingStreamPeriodCode = FspCode,
                    OrganisationId = OrgId,
                    Period = Period,
                    PeriodTypeCode = PeriodTypeCode,
                    UoPCode = UopCode
                }).ToList();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ReportedActualsLoadedHandler_ShouldTransform()
        {
            var monitoringDbStore = new MonitoringDeliverableStore(Mock.Of<ILogger>());
            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock.Setup(r => r.GetConnection(It.IsAny<IMessageHandlerContext>())).Returns(
                new ConnectionInfo(null, new MonitoringDeliverablesDbContext().Database.Connection));

            ReportedActualsLoadedHandler handler = new ReportedActualsLoadedHandler(

                new ActualEnricher(monitoringDbStore, Mock.Of<ILogger>()),
                new ActualValidator
                {
                    Date = new SystemDate(),
                    AllocationsUnderTerminationQueryRepository = new AllocationsUnderTerminationQueryRepository(),
                    Logger = Mock.Of<ILogger>(),
                    Store = new FundingStreamConfigurationStore
                    {
                        FundingStreamPeriodCache = new FundingStreamPeriodCache()
                    }
                }, 
                new MultiSourceActualRepository(new AzureRepository<ReportedActual>(new AzureTableStore(), new EnvironmentContext()),
                    new SummarisedActualRepository()),
                Mock.Of<ILogger>(),
                new EnrichedActualMapper(),
                new ActualsAuditMapper(new FundingStreamConfigurationStore
                {
                    FundingStreamPeriodCache = new FundingStreamPeriodCache()
                }, new SystemDate()),
                monitoringDbStore,
                null,
                new GenericSubmissionEnricher(monitoringDbStore, new SystemDate()), 
                new FundingStreamConfigurationStore
                {
                    FundingStreamPeriodCache = new FundingStreamPeriodCache()
                }, 
                new ProcessedMessageRepository(),
                sessionConnectionFactoryMock.Object);

            handler.Handle(new ReportedActualsLoadedCommand
            {
                FundingStreamPeriodCode = "ALLF2021",
                SummarisedActualOrgFspGroupKeys = new SummarisedActualOrgFspGroupKey[1]
                {
                    new SummarisedActualOrgFspGroupKey
                    {
                        CollectionReturnCode = "R01",
                        CollectionType = "ILR2021",
                        OrganisationId = "ORG0017433",
                        FundingStreamPeriodCode = "ALLF2021"
                    },
                }
            }, new TestableMessageHandlerContext()).Wait();
        }
    }

    public class CertainDate : IDate
    {
        private DateTime _date;
        public CertainDate(DateTime date)
        {
            _date = date;
        }
        public DateTime GetCalculationDate()
        {
            return _date;
        }

        public DateTime GetCalculationDateWithKey(string key)
        {
            return _date;
        }
    }
}