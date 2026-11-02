namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic.Enricher;
    using BusinessLogic.Mapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using BusinessLogic;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using IoC;
    using Repositories;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.Framework.Logging;
    using Validation;
    using SFA.FCT.AllocationDelivery.DataStore.Repositories;

    [TestClass]
    public class ReportedActualsLoadedHandlerTests
    {
        //private Mock<IActualEnricher> _mockActualEnricher;
        //private Mock<IActualValidator> _mockActualValidator;
        //private Mock<IMultiSourceActualRepository> _mockMultiSourceActualRepository;
        //private Mock<ILogger> _mockLogger;
        //private Mock<IBus> _mockIBus;
        //private Mock<IMapper<EnrichedReportedActual, ContractAllocationActualsType>> _mockMapper;
        //private Mock<IActualsAuditMapper> _mockAuditsActualMapper;
        //private Mock<IFundingStreamConfigurationStore> _mockFundingStreamConfigurationStore;
        //private Mock<ICurrentViewActualsComponent> _mockCurrentViewActualsComponent;
        //private Mock<IMonitoringDeliverableStore> _mockMonitoringDeliverableStore;
        //private Mock<IGenericSubmissionEnricher> _mockGenericSubmissionEnricher;
        //private Mock<IProcessedMessageRepository> _processedMessageRepositoryMock;

        //[TestInitialize]
        //public void Initialize()
        //{
        //    _mockActualEnricher = new Mock<IActualEnricher>();
        //    _mockActualValidator = new Mock<IActualValidator>();
        //    _mockMultiSourceActualRepository = new Mock<IMultiSourceActualRepository>();
        //    _mockLogger = new Mock<ILogger>();
        //    _mockIBus = new Mock<IBus>();
        //    _mockMapper = new Mock<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>();
        //    _mockAuditsActualMapper = new Mock<IActualsAuditMapper>();
        //    _mockFundingStreamConfigurationStore = new Mock<IFundingStreamConfigurationStore>();
        //    _mockCurrentViewActualsComponent = new Mock<ICurrentViewActualsComponent>();
        //    _mockMonitoringDeliverableStore = new Mock<IMonitoringDeliverableStore>();
        //    _mockGenericSubmissionEnricher = new Mock<IGenericSubmissionEnricher>();
        //    _processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();

        //    Mock<IMessageContext> messageContextMock = new Mock<IMessageContext>();
        //    messageContextMock.SetupGet(x => x.Id).Returns("d2afee7d-c2e3-46cb-991c-2461ce07ae90");
        //    _mockIBus.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsLoadedHandler_ShouldPublishReportedActuals_WhenLoadedAndValid()
        //{
        //    using (ShimsContext.Create())
        //    {
        //        #region Shim setup Database


        //        ShimDbContextTransaction transaction =
        //            new ShimDbContextTransaction
        //            {
        //                Commit = () => { },
        //                Rollback = () => { },
        //                Dispose = () => { }
        //            };

        //        ShimDatabase database = new ShimDatabase
        //        {
        //            BeginTransaction = () => transaction.Instance
        //        };


        //        ShimDbContext.AllInstances.DatabaseGet =
        //            (@this) => database.Instance;

        //        #endregion

        //        Mock<IMonitoringDeliverablesDbContext> contextMock = new Mock<IMonitoringDeliverablesDbContext>();
        //        Mock<IMonitoringDeliverableStore> storeMock = new Mock<IMonitoringDeliverableStore>();
        //        storeMock.SetupGet(x => x.Context).Returns(contextMock.Object);
        //        contextMock.SetupGet(x => x.Database).Returns(database);
        //        // Arrange
        //        const string partitionKey = "COLLECTIONCODE-ORG0000001-CL1516-00001";

        //        ReportedActual actual1 = new ReportedActual();
        //        ReportedActual actual2 = new ReportedActual();

        //        EnrichedReportedActual validEnrichedActual = new EnrichedReportedActual
        //        {
        //            ContractAllocationNumber = "Allocation1"
        //        };
        //        EnrichedReportedActual invalidEnrichedActual = new EnrichedReportedActual
        //        {
        //            ContractAllocationNumber = "Allocation2"
        //        };


        //        List<AllocationDeliverablePeriodActualAudit> auditActuals = new List<AllocationDeliverablePeriodActualAudit>
        //        {
        //            new AllocationDeliverablePeriodActualAudit
        //            {
        //                FundingStreamPeriodCode = "Code123",
        //                DeliverableCode = 123,
        //                ParentDeliverableCode = 456
        //            }
        //        };

        //        List<ReportedActual> actuals = new List<ReportedActual> {actual1, actual2};
        //        List<EnrichedReportedActual> enrichedActuals = new List<EnrichedReportedActual> {validEnrichedActual, invalidEnrichedActual};

        //        _mockMultiSourceActualRepository.Setup(a => a.GetReportedActuals(new[] { partitionKey }, null)).Returns(actuals);
        //        _mockActualEnricher.Setup(a => a.Enrich(actuals)).Returns(enrichedActuals);

        //        _mockActualValidator.Setup(a => a.Validate(validEnrichedActual, false)).Returns(new List<string>());
        //        _mockActualValidator.Setup(a => a.Validate(invalidEnrichedActual, false))
        //            .Returns(new List<string>() {"Contract allocation is invalid"});

        //        _mockActualValidator.Setup(a => a.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>()))
        //            .Returns(new List<EnrichedReportedActual> (){validEnrichedActual});

        //        _mockFundingStreamConfigurationStore.Setup(a => a.GetFundingStreamPeriod(It.IsAny<string>())).Returns(new FundingStreamPeriod {ZeroiseMissingActuals = false});
                
        //        _mockCurrentViewActualsComponent.Setup(a => a.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(It.IsAny<List<EnrichedReportedActual>>()))
        //            .Returns(new List<EnrichedReportedActual>() { validEnrichedActual });

        //        _mockMapper.Setup(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>()))
        //            .Returns((IEnumerable<EnrichedReportedActual> e) =>
        //                e.Select(MapSingleEnrichedReportedActual));

        //        _mockAuditsActualMapper.Setup(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>())).Returns(auditActuals);

        //        _processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>())).Returns(true);

        //        _mockIBus.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>())).Verifiable();

        //        // Act
        //        ReportedActualsLoadedHandler handler = new ReportedActualsLoadedHandler(_mockIBus.Object, _mockActualEnricher.Object, _mockActualValidator.Object,
        //             _mockMultiSourceActualRepository.Object, _mockLogger.Object, _mockMapper.Object, _mockAuditsActualMapper.Object,
        //             storeMock.Object, _mockCurrentViewActualsComponent.Object, _mockGenericSubmissionEnricher.Object, 
        //            _mockFundingStreamConfigurationStore.Object, 
        //             _processedMessageRepositoryMock.Object);

        //        handler.Handle(new ReportedActualsLoadedCommand {PartitionKeys = new [] {partitionKey}});

        //        // Assert
        //        _mockIBus.Verify(
        //            b =>
        //                b.Publish(
        //                    It.Is<IAllocationActualsVerified>(
        //                        x => x.AllocationActuals.ContractAllocationNumber == "Allocation1")), Times.Once(),
        //            "Handle_ReportedActualsLoadedCommand didn't publish the valid reported actual");
        //        _mockIBus.Verify(
        //            b =>
        //                b.Publish(
        //                    It.Is<IAllocationActualsVerified>(
        //                        x => x.AllocationActuals.ContractAllocationNumber == "Allocation2")), Times.Never(),
        //            "Handle_ReportedActualsLoadedCommand published the invalid reported actual");

        //    }
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsLoadedHandler_ShouldNotPublishReportedActuals_WhenCalcDateIsGreaterThanFSPActivityCloseDate()
        //{
        //    DateTime activityCloseDate = new DateTime(2020, 1, 1);

        //    using (ShimsContext.Create())
        //    {
        //        #region Shim setup Database


        //        ShimDbContextTransaction transaction =
        //            new ShimDbContextTransaction
        //            {
        //                Commit = () => { },
        //                Rollback = () => { },
        //                Dispose = () => { }
        //            };

        //        ShimDatabase database = new ShimDatabase
        //        {
        //            BeginTransaction = () => transaction.Instance
        //        };


        //        ShimDbContext.AllInstances.DatabaseGet =
        //            (@this) => database.Instance;

        //        #endregion

        //        Mock<IMonitoringDeliverablesDbContext> contextMock = new Mock<IMonitoringDeliverablesDbContext>();
        //        Mock<IMonitoringDeliverableStore> storeMock = new Mock<IMonitoringDeliverableStore>();
        //        storeMock.SetupGet(x => x.Context).Returns(contextMock.Object);
        //        contextMock.SetupGet(x => x.Database).Returns(database);
        //        // Arrange
        //        const string partitionKey = "COLLECTIONCODE-ORG0000001-CL1516-00001";

        //        ReportedActual actual1 = new ReportedActual();

        //        List<ReportedActual> actuals = new List<ReportedActual> { actual1 };

        //        _mockMultiSourceActualRepository.Setup(a => a.GetReportedActuals(new[] { partitionKey }, null)).Returns(actuals);

        //        _mockActualValidator.Setup(a => a.IsCalcDateAfterFspActivityCloseDate(It.IsAny<string>())).Returns(true);

        //        _mockFundingStreamConfigurationStore.Setup(a => a.GetFundingStreamPeriod(It.IsAny<string>())).Returns(new FundingStreamPeriod { ActivityCloseDate = activityCloseDate});

        //        _processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>())).Returns(true);

        //        // Act
        //        ReportedActualsLoadedHandler handler = new ReportedActualsLoadedHandler(_mockIBus.Object, _mockActualEnricher.Object, _mockActualValidator.Object,
        //             _mockMultiSourceActualRepository.Object, _mockLogger.Object, _mockMapper.Object, _mockAuditsActualMapper.Object,
        //             storeMock.Object, _mockCurrentViewActualsComponent.Object, _mockGenericSubmissionEnricher.Object, 
        //            _mockFundingStreamConfigurationStore.Object,
        //             _processedMessageRepositoryMock.Object);

        //        handler.Handle(new ReportedActualsLoadedCommand { PartitionKeys = new[] { partitionKey } });

        //        // Assert
        //        _mockIBus.Verify(
        //            b =>
        //                b.Publish(
        //                    It.Is<IAllocationActualsVerified>(
        //                        x => x.AllocationActuals.ContractAllocationNumber == "Allocation1")), Times.Never(),
        //            "Handle_ReportedActualsLoadedCommand published an event");

        //    }
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsLoadedHandler_ShouldSaveReportedActualsAudit_WhenLoadedAndValid()
        //{
        //    using (ShimsContext.Create())
        //    {
        //        #region Shim setup Database


        //        ShimDbContextTransaction transaction =
        //            new ShimDbContextTransaction
        //            {
        //                Commit = () => { },
        //                Rollback = () => { },
        //                Dispose = () => { }
        //            };

        //        ShimDatabase database = new ShimDatabase
        //        {
        //            BeginTransaction = () => transaction.Instance
        //        };


        //        ShimDbContext.AllInstances.DatabaseGet =
        //            (@this) => database.Instance;

        //        #endregion

        //        Mock<IMonitoringDeliverablesDbContext> contextMock = new Mock<IMonitoringDeliverablesDbContext>();
        //        Mock<IMonitoringDeliverableStore> storeMock = new Mock<IMonitoringDeliverableStore>();
        //        storeMock.SetupGet(x => x.Context).Returns(contextMock.Object);
        //        contextMock.SetupGet(x => x.Database).Returns(database);

        //        // Arrange
        //        const string partitionKey = "COLLECTIONCODE-ORG0000001-CL1516-00001";

        //        ReportedActual actual1 = new ReportedActual();
        //        ReportedActual actual2 = new ReportedActual();

        //        EnrichedReportedActual validEnrichedActual = new EnrichedReportedActual
        //        {
        //            ContractAllocationNumber = "Allocation1"
        //        };
        //        EnrichedReportedActual invalidEnrichedActual = new EnrichedReportedActual
        //        {
        //            ContractAllocationNumber = "Allocation2"
        //        };


        //        List<AllocationDeliverablePeriodActualAudit> auditActuals = new List<AllocationDeliverablePeriodActualAudit>
        //        {
        //            new AllocationDeliverablePeriodActualAudit
        //            {
        //                FundingStreamPeriodCode = "Code123",
        //                DeliverableCode = 123,
        //                ParentDeliverableCode = 456
        //            }
        //        };

        //        List<ReportedActual> actuals = new List<ReportedActual> { actual1, actual2 };
        //        List<EnrichedReportedActual> enrichedActuals = new List<EnrichedReportedActual> { validEnrichedActual, invalidEnrichedActual };

        //        _mockMultiSourceActualRepository.Setup(a => a.GetReportedActuals(new[] { partitionKey }, null)).Returns(actuals);
        //        _mockActualEnricher.Setup(a => a.Enrich(actuals)).Returns(enrichedActuals);

        //        _mockActualValidator.Setup(a => a.Validate(validEnrichedActual, false)).Returns(new List<string>());
        //        _mockActualValidator.Setup(a => a.Validate(invalidEnrichedActual, false))
        //            .Returns(new List<string>() {"Contract allocation is invalid"});

        //        _mockActualValidator.Setup(a => a.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>()))
        //            .Returns(new List<EnrichedReportedActual>() { validEnrichedActual });

        //        _mockCurrentViewActualsComponent.Setup(a => a.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(It.IsAny<List<EnrichedReportedActual>>()))
        //            .Returns(new List<EnrichedReportedActual>() { validEnrichedActual });

        //        _mockMapper.Setup(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>()))
        //            .Returns((IEnumerable<EnrichedReportedActual> e) =>
        //                e.Select(MapSingleEnrichedReportedActual));

        //        _mockAuditsActualMapper.Setup(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>())).Returns(auditActuals);
        //        _mockFundingStreamConfigurationStore.Setup(a => a.GetFundingStreamPeriod(It.IsAny<string>())).Returns(new FundingStreamPeriod { ZeroiseMissingActuals = false });
        //        _mockIBus.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>())).Verifiable();

        //        storeMock.Setup(m => m.StoreActualsAudit(It.IsAny<IEnumerable<AllocationDeliverablePeriodActualAudit>>())).Verifiable();
        //        _processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>())).Returns(true);

        //        // Act
        //        ReportedActualsLoadedHandler handler = new ReportedActualsLoadedHandler(_mockIBus.Object, _mockActualEnricher.Object, _mockActualValidator.Object,
        //            _mockMultiSourceActualRepository.Object, _mockLogger.Object, _mockMapper.Object, _mockAuditsActualMapper.Object,
        //            storeMock.Object, _mockCurrentViewActualsComponent.Object, _mockGenericSubmissionEnricher.Object,
        //            _mockFundingStreamConfigurationStore.Object,
        //            _processedMessageRepositoryMock.Object);

        //        handler.Handle(new ReportedActualsLoadedCommand { PartitionKeys = new[] { partitionKey } });

        //        // Assert
        //        storeMock.Verify(m => m.StoreActualsAudit(It.IsAny<IEnumerable<AllocationDeliverablePeriodActualAudit>>()), Times.Once);
        //    }
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsLoadedHandler_ShouldCallAddMissingActualsWithZeroValues_WhenZeroiseMissingActualsIsTrueForFundingStreamPeriod()
        //{
        //    // Arrange
        //    const string testPartitionKey = "PartitionKey";

        //    ReportedActualsLoadedHandler handler = new ReportedActualsLoadedHandler(
        //        _mockIBus.Object,
        //        _mockActualEnricher.Object,
        //        _mockActualValidator.Object,
        //        _mockMultiSourceActualRepository.Object,
        //        _mockLogger.Object,
        //        _mockMapper.Object,
        //        _mockAuditsActualMapper.Object,
        //        _mockMonitoringDeliverableStore.Object,
        //        _mockCurrentViewActualsComponent.Object,
        //        _mockGenericSubmissionEnricher.Object,
        //        _mockFundingStreamConfigurationStore.Object,
        //        _processedMessageRepositoryMock.Object);

        //    List<ReportedActual> reportedActuals = new List<ReportedActual> {new EnrichedReportedActual
        //    {
        //        ActualValue = 10,
        //        ContractAllocationNumber = "allNum",
        //        DeliverableCode = "1",
        //        Period = "201608",
        //        FundingStreamPeriodCode = "fspCode"
        //    }};

        //    List<EnrichedReportedActual> enrichedReportedActuals = new List<EnrichedReportedActual> {new EnrichedReportedActual
        //    {
        //        ActualValue = 10,
        //        ContractAllocationNumber = "allNum",
        //        DeliverableCode = "1",
        //        Period = "201608",
        //        FundingStreamPeriodCode = "fspCode"
        //    }};

        //    _mockMultiSourceActualRepository.Setup(x => x.GetReportedActuals(new[] { testPartitionKey }, null)).Returns(reportedActuals).Verifiable();
        //    _mockActualEnricher.Setup(x => x.Enrich(It.IsAny<List<ReportedActual>>())).Returns(enrichedReportedActuals).Verifiable();
        //    _mockActualValidator.Setup(x => x.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>())).Returns(enrichedReportedActuals).Verifiable();
        //    _mockFundingStreamConfigurationStore.Setup(x => x.GetFundingStreamPeriod(It.IsAny<string>())).Returns(new FundingStreamPeriod {Code = "fspCode", ZeroiseMissingActuals = true}).Verifiable();
        //    _mockGenericSubmissionEnricher.Setup(x => x.AddMissingActualsWithZeroValues(enrichedReportedActuals, It.IsAny<FundingStreamZeroisationBehaviour>())).Returns(enrichedReportedActuals).Verifiable();
        //    _mockCurrentViewActualsComponent.Setup(x => x.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(It.IsAny<List<EnrichedReportedActual>>())).Returns(enrichedReportedActuals).Verifiable();
        //    _processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>())).Returns(true);

        //    // Act
        //    handler.Handle(new ReportedActualsLoadedCommand {PartitionKeys = new[] {testPartitionKey}});

        //    // Assert
        //    _mockGenericSubmissionEnricher.Verify();
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsLoadedHandler_ShouldHandleMultiplePartitionKeys()
        //{
        //    // arrange
        //    const string testFsp = "TestFsp";
        //    const string allocNum = "ABC-123";
        //    const string orgId = "12345678";
        //    const string uop = "UOP";

        //    List<ReportedActual> inputActuals = new List<ReportedActual>
        //    {
        //        new ReportedActual
        //        {
        //            CollectionReturnCode = "R01",
        //            CollectionType = "ILR1819",
        //            ActualValue = 1f,
        //            ContractAllocationNumber = allocNum,
        //            OrganisationId = orgId,
        //            FundingStreamPeriodCode = testFsp,
        //            UoPCode = uop,
        //            Period = "01",
        //            PeriodTypeCode = "CM",
        //            DeliverableCode = "1",
        //            PartitionKey = "PK1"
        //        },
        //        new ReportedActual
        //        {
        //            CollectionReturnCode = "APPS20",
        //            CollectionType = "APPS",
        //            ActualValue = 1f,
        //            ContractAllocationNumber = allocNum,
        //            OrganisationId = orgId,
        //            FundingStreamPeriodCode = testFsp,
        //            UoPCode = uop,
        //            Period = "01",
        //            PeriodTypeCode = "CM",
        //            DeliverableCode = "1",
        //            PartitionKey = "PK2"
        //        }
        //    };

        //    _mockMultiSourceActualRepository.Setup(m => m.GetReportedActuals(It.IsAny<string[]>(), It.IsAny<SummarisedActualOrgFspGroupKey[]>()))
        //        .Returns((string[] partitionKeys, SummarisedActualOrgFspGroupKey[] groupKeys) => inputActuals.Where(a => partitionKeys.Contains(a.PartitionKey)).ToList());

        //    _mockFundingStreamConfigurationStore.Setup(m => m.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod {Code = testFsp});

        //    _mockActualValidator.Setup(m => m.IsCalcDateAfterFspActivityCloseDate(It.IsAny<string>())).Returns(false);

        //    _mockActualEnricher.Setup(m => m.Enrich(It.IsAny<IEnumerable<ReportedActual>>()))
        //        .Returns((IEnumerable<ReportedActual> actuals) => actuals.Select(a => new EnrichedReportedActual
        //        {
        //            ActualValue = a.ActualValue,
        //            PartitionKey = a.PartitionKey,
        //            FundingStreamPeriodCode = a.FundingStreamPeriodCode,
        //            CollectionReturnCode = a.CollectionReturnCode,
        //            CollectionType = a.CollectionType,
        //            OrganisationId = a.OrganisationId,
        //            Ukprn = a.OrganisationId,
        //            DeliverableCode = a.DeliverableCode,
        //            Period = a.Period,
        //            PeriodTypeCode = a.PeriodTypeCode,
        //            UoPCode = a.UoPCode,
        //            ContractNumber = "MAIN-123",
        //            ContractVersion = 1,
        //            ContractSubVersion = 0
        //        }));

        //    _mockActualValidator.Setup(m => m.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>()))
        //        .Returns((List<EnrichedReportedActual> enrichedActuals) => enrichedActuals);

        //    _mockAuditsActualMapper.Setup(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>()))
        //        .Returns((IEnumerable<EnrichedReportedActual> actuals) => actuals.Select(a => 
        //            new AllocationDeliverablePeriodActualAudit()));

        //    _processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>())).Returns(true);

        //    // mapper is real implementation since we care how it groups actuals to map
        //    ReportedActualsLoadedHandler handler = new ReportedActualsLoadedHandler(
        //        _mockIBus.Object,
        //        _mockActualEnricher.Object,
        //        _mockActualValidator.Object,
        //        _mockMultiSourceActualRepository.Object,
        //        _mockLogger.Object,
        //        new EnrichedActualMapper(),
        //        _mockAuditsActualMapper.Object,
        //        _mockMonitoringDeliverableStore.Object,
        //        _mockCurrentViewActualsComponent.Object,
        //        _mockGenericSubmissionEnricher.Object,
        //        _mockFundingStreamConfigurationStore.Object,
        //        _processedMessageRepositoryMock.Object);

        //    ReportedActualsLoadedCommand command = new ReportedActualsLoadedCommand
        //    {
        //        FundingStreamPeriodCode = testFsp,
        //        PartitionKeys = inputActuals.Select(a => a.PartitionKey).ToArray()
        //    };

        //    // act
        //    handler.Handle(command);

        //    // assert
        //    _mockMonitoringDeliverableStore.Verify(
        //        m => m.StoreActualsAudit(
        //            It.Is((IEnumerable<AllocationDeliverablePeriodActualAudit> audits) => audits.Count() == 2)), 
        //            Times.Once,
        //            "Monitoring Deliverables store should store exactly two AllocationDeliverablePeriodActualAudit");

        //    _mockIBus.Verify(m => m.Publish(It.IsAny<AllocationActualsVerified>()), Times.Once,
        //        "Exactly one AllocationActualsVerified event should be published");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsLoadedHandler_ShouldResolveFromContainer()
        //{
        //    IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));

        //    container.Register(Component.For<IBus>().Instance(Mock.Of<IBus>()));
        //    container.Register(Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleScoped().Named("OverrideMonitoringDeliverablesDbContext").IsDefault());
        //    container.Register(Component.For<IFundingStreamConfigurationStore>().ImplementedBy<FundingStreamConfigurationStore>().LifestyleScoped().Named("OverrideFundingStreamConfigurationStore").IsDefault());
        //    container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped().Named("OverrideOverrideDateDBContext").IsDefault());
        //    container.Register(Component.For<IAllocationDeliveryDbContext>().ImplementedBy<AllocationDeliveryDbContext>().LifestyleScoped().IsDefault());

        //    container.BeginScope();

        //    ReportedActualsLoadedHandler handler =
        //        container.Register(Component.For<ReportedActualsLoadedHandler>())
        //            .Resolve<ReportedActualsLoadedHandler>();

        //    Assert.IsNotNull(handler);
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsLoadedHandler_ShouldNotContinueProcessingIfEnricherReturnsNoEnrichedActuals()
        //{
        //    // arrange
        //    Mock<IActualEnricher> actualEnricherMock = new Mock<IActualEnricher>();
        //    Mock<IActualValidator> actualValidatorMock = new Mock<IActualValidator>();
        //    Mock<IMultiSourceActualRepository> multiSourceActualRepositoryMock = new Mock<IMultiSourceActualRepository>();
        //    Mock<IMapper<EnrichedReportedActual, ContractAllocationActualsType>> mapperMock = new Mock<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>();
        //    Mock<IActualsAuditMapper> actualsAuditMapperMock = new Mock<IActualsAuditMapper>();
        //    Mock<IMonitoringDeliverableStore> deliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
        //    Mock<ICurrentViewActualsComponent> currentViewActualsComponentMock = new Mock<ICurrentViewActualsComponent>();
        //    Mock<IGenericSubmissionEnricher> genericSubmissionEnricherMock = new Mock<IGenericSubmissionEnricher>();
        //    Mock<IFundingStreamConfigurationStore> fundingConfigurationStoreMock = new Mock<IFundingStreamConfigurationStore>();
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();

        //    ReportedActualsLoadedHandler handler = new ReportedActualsLoadedHandler(
        //        busMock.Object,
        //        actualEnricherMock.Object,
        //        actualValidatorMock.Object,
        //        multiSourceActualRepositoryMock.Object,
        //        Mock.Of<ILogger>(),
        //        mapperMock.Object,
        //        actualsAuditMapperMock.Object,
        //        deliverableStoreMock.Object,
        //        currentViewActualsComponentMock.Object,
        //        genericSubmissionEnricherMock.Object,
        //        fundingConfigurationStoreMock.Object,
        //        processedMessageRepositoryMock.Object);

        //    actualEnricherMock.Setup(m => m.Enrich(It.IsAny<IEnumerable<ReportedActual>>()))
        //        .Returns(new List<EnrichedReportedActual>());

        //    actualValidatorMock.Setup(m => m.IsCalcDateAfterFspActivityCloseDate(It.IsAny<string>()))
        //        .Returns(false);

        //    fundingConfigurationStoreMock.Setup(m => m.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod());

        //    multiSourceActualRepositoryMock.Setup(m => m.GetReportedActuals(It.IsAny<string[]>(), It.IsAny<SummarisedActualOrgFspGroupKey[]>()))
        //        .Returns(new List<ReportedActual>
        //        {
        //            new ReportedActual()
        //        });

        //    processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>())).Returns(true);

        //    Mock<IMessageContext> messageContextMock = new Mock<IMessageContext>();
        //    messageContextMock.SetupGet(x => x.Id).Returns("d2afee7d-c2e3-46cb-991c-2461ce07ae90");
        //    busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

        //    ReportedActualsLoadedCommand command = new ReportedActualsLoadedCommand
        //    {
        //        FundingStreamPeriodCode = "AEBC1718",
        //        PartitionKeys = new [] { "PK1" }
        //    };

        //    // act
        //    handler.Handle(command);

        //    // assert
        //    actualValidatorMock.Verify(m => m.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>()), Times.Never, 
        //        "Validator was called");
        //    actualsAuditMapperMock.Verify(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>()), Times.Never, 
        //        "Actuals Audit Mapper was called");
        //    busMock.Verify(m => m.Publish(It.IsAny<AllocationActualsVerified>()), Times.Never,
        //        "Bus Publish was called");

        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsLoadedHandler_ShouldNotProcessIfWeHaveAlreadyProcessed()
        //{
        //    // arrange
        //    Mock<IActualEnricher> actualEnricherMock = new Mock<IActualEnricher>();
        //    Mock<IActualValidator> actualValidatorMock = new Mock<IActualValidator>();
        //    Mock<IMultiSourceActualRepository> multiSourceActualRepositoryMock = new Mock<IMultiSourceActualRepository>();
        //    Mock<IMapper<EnrichedReportedActual, ContractAllocationActualsType>> mapperMock = new Mock<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>();
        //    Mock<IActualsAuditMapper> actualsAuditMapperMock = new Mock<IActualsAuditMapper>();
        //    Mock<IMonitoringDeliverableStore> deliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
        //    Mock<ICurrentViewActualsComponent> currentViewActualsComponentMock = new Mock<ICurrentViewActualsComponent>();
        //    Mock<IGenericSubmissionEnricher> genericSubmissionEnricherMock = new Mock<IGenericSubmissionEnricher>();
        //    Mock<IFundingStreamConfigurationStore> fundingConfigurationStoreMock = new Mock<IFundingStreamConfigurationStore>();
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();

        //    ReportedActualsLoadedHandler handler = new ReportedActualsLoadedHandler(
        //        busMock.Object,
        //        actualEnricherMock.Object,
        //        actualValidatorMock.Object,
        //        multiSourceActualRepositoryMock.Object,
        //        Mock.Of<ILogger>(),
        //        mapperMock.Object,
        //        actualsAuditMapperMock.Object,
        //        deliverableStoreMock.Object,
        //        currentViewActualsComponentMock.Object,
        //        genericSubmissionEnricherMock.Object,
        //        fundingConfigurationStoreMock.Object,
        //        processedMessageRepositoryMock.Object);

        //    processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>())).Returns(false);

        //    Mock<IMessageContext> messageContextMock = new Mock<IMessageContext>();
        //    messageContextMock.SetupGet(x => x.Id).Returns("d2afee7d-c2e3-46cb-991c-2461ce07ae90");
        //    busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

        //    // act
        //    handler.Handle(new ReportedActualsLoadedCommand());

        //    // assert
        //    actualValidatorMock.Verify(m => m.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>()), Times.Never,
        //        "Validator was called");
        //    actualsAuditMapperMock.Verify(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>()), Times.Never,
        //        "Actuals Audit Mapper was called");
        //    busMock.Verify(m => m.Publish(It.IsAny<AllocationActualsVerified>()), Times.Never,
        //        "Bus Publish was called");

        //}

        //private static ContractAllocationActualsType MapSingleEnrichedReportedActual(ReportedActual actual)
        //    {
        //        return new ContractAllocationActualsType
        //        {
        //            ContractAllocationNumber = actual.ContractAllocationNumber
        //        };
        //    }
    }
}
