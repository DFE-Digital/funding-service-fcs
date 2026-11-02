namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using Optional;
    using Repositories;
    using Routing;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ReportedActualsRoutingCommandHandlerTests
    {
        //[TestMethod, TestCategory("UnitTest")]
        //public void
        //    ReportedActualsRoutingCommandHandler_ShouldSendReportedActualsLoadedCommand_WhenFspPaymentMethodIsPayOnActuals()
        //{
        //    // arrange
        //    Mock<IAzureRepository<ReportedActual>> reportedActualRepository =
        //        new Mock<IAzureRepository<ReportedActual>>();
        //    reportedActualRepository.Setup(r => r.GetRows(It.IsAny<string>())).Returns(new List<ReportedActual>()
        //    {
        //        new ReportedActual()
        //    });

        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock.Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod
        //        {
        //            PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnActuals
        //        }.Some());

        //    Mock<IBus> bus = new Mock<IBus>();
        //    IList<object> messages = new List<object>();
        //    bus.Setup(b => b.Send(It.IsAny<object>())).Callback((object m) => messages.Add(m));

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        reportedActualRepository.Object,
        //        fspRepositoryMock.Object,
        //        bus.Object,
        //        new Mock<ILogger>().Object,
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    // act
        //    handler.Handle(new ReportedActualsRoutingCommand {PartitionKey = "PK1"});

        //    // assert
        //    Assert.AreEqual(1, messages.Count);
        //    Assert.IsTrue(messages.First() is ReportedActualsLoadedCommand, "The command is of the wrong type");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void
        //    ReportedActualsRoutingCommandHandler_ShouldSendReportedPaymentInstructionsLoadedCommand_WhenFspPaymentMethodIsPayOnInstruction()
        //{
        //    // arrange
        //    Mock<IAzureRepository<ReportedActual>> reportedActualRepository =
        //        new Mock<IAzureRepository<ReportedActual>>();
        //    reportedActualRepository.Setup(r => r.GetRows(It.IsAny<string>())).Returns(new List<ReportedActual>()
        //    {
        //        new ReportedActual()
        //    });

        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock.Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod
        //        {
        //            PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnInstruction
        //        }.Some);

        //    Mock<IBus> bus = new Mock<IBus>();
        //    IList<object> messages = new List<object>();
        //    bus.Setup(b => b.Send(It.IsAny<object>())).Callback((object m) => messages.Add(m));

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        reportedActualRepository.Object,
        //        fspRepositoryMock.Object,
        //        bus.Object,
        //        new Mock<ILogger>().Object,
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    // act
        //    handler.Handle(new ReportedActualsRoutingCommand {PartitionKey = "PK1"});

        //    // assert
        //    Assert.AreEqual(1, messages.Count);
        //    Assert.IsTrue(messages.First() is ReportedPaymentInstructionsLoadedCommand,
        //        "The command is of the wrong type");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsRoutingCommandHandler_ShouldSendWriteKeyToHeldTable_WhenFspIsMultiReturnCode()
        //{
        //    // arrange
        //    Mock<IAzureRepository<ReportedActual>> reportedActualRepository =
        //        new Mock<IAzureRepository<ReportedActual>>();
        //    reportedActualRepository.Setup(r => r.GetRows(It.IsAny<string>())).Returns(new List<ReportedActual>()
        //    {
        //        new ReportedActual()
        //    });

        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock.Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod
        //        {
        //            MultiCollectionReturns = true
        //        }.Some);

        //    Mock<IBus> bus = new Mock<IBus>();
        //    IList<object> messages = new List<object>();
        //    bus.Setup(b => b.Send(It.IsAny<object>())).Callback((object m) => messages.Add(m));

        //    Mock<IHeldReportedActualGroupCommandRepository> heldReportedActualGroupCommandRepositoryMock =
        //        new Mock<IHeldReportedActualGroupCommandRepository>();


        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        reportedActualRepository.Object,
        //        fspRepositoryMock.Object,
        //        bus.Object,
        //        new Mock<ILogger>().Object,
        //        heldReportedActualGroupCommandRepositoryMock.Object);

        //    // act
        //    handler.Handle(new ReportedActualsRoutingCommand {PartitionKey = "PK1"});

        //    // assert
        //    heldReportedActualGroupCommandRepositoryMock.Verify(h => h.Add(It.IsAny<HeldReportedActualGroup>()),
        //        Times.Once);
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsRoutingCommandHandler_ShouldNotUseAzureTableStorage_WhenStagingSourceIsAzureSql()
        //{
        //    // arrange
        //    Mock<IAzureRepository<ReportedActual>> reportedActualRepositoryMock =
        //        new Mock<IAzureRepository<ReportedActual>>();

        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock
        //        .Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod
        //        {
        //            PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnActuals
        //        }.Some);

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        reportedActualRepositoryMock.Object,
        //        fspRepositoryMock.Object,
        //        Mock.Of<IBus>(),
        //        Mock.Of<ILogger>(),
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    // act
        //    handler.Handle(new ReportedActualsRoutingCommand
        //    {
        //        SummarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey
        //        {
        //            CollectionType = "APPS",
        //            CollectionReturnCode = "APPS01",
        //            OrganisationId = "ORG00001234",
        //            FundingStreamPeriodCode = "NONLEVY2019",
        //            UopCode = "123"
        //        }
        //    });

        //    // assert
        //    reportedActualRepositoryMock.Verify(m => m.GetRows(It.IsAny<string>()), Times.Never,
        //        "Azure Table Storage was used");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void
        //    ReportedActualsRoutingCommandHandler_ShouldSendReportedActualsLoadedCommandWithPopulatedPartitionKeys_WhenIncomingSummarisedActualStagingSourceIsAzureTableStorage()
        //{
        //    // arrange
        //    Mock<IAzureRepository<ReportedActual>> reportedActualRepositoryMock =
        //        new Mock<IAzureRepository<ReportedActual>>();
        //    reportedActualRepositoryMock.Setup(r => r.GetRows(It.IsAny<string>())).Returns(new List<ReportedActual>
        //    {
        //        new ReportedActual
        //        {
        //            CollectionType = "APPS",
        //            CollectionReturnCode = "APPS01",
        //            OrganisationId = "ORG00001234",
        //            FundingStreamPeriodCode = "NONLEVY2019",
        //            UoPCode = "123",
        //            ActualValue = 100
        //        }
        //    });

        //    Mock<IFundingStreamPeriodRepository> fundingStreamConfigurationStore =
        //        new Mock<IFundingStreamPeriodRepository>();
        //    fundingStreamConfigurationStore
        //        .Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod
        //        {
        //            PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnActuals
        //        }.Some);

        //    ReportedActualsLoadedCommand sentMessage = null;
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    busMock
        //        .Setup(b => b.Send(It.IsAny<object>()))
        //        .Callback((object m) => sentMessage = (ReportedActualsLoadedCommand) m);

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        reportedActualRepositoryMock.Object,
        //        fundingStreamConfigurationStore.Object,
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    // act
        //    handler.Handle(new ReportedActualsRoutingCommand
        //    {
        //        PartitionKey = "APPSAPPS01_ORG00001234NONLEVY2019123"
        //    });

        //    // assert
        //    Assert.IsNotNull(sentMessage.PartitionKeys, "PartitionKeys has not been set");
        //    Assert.AreEqual(1, sentMessage.PartitionKeys.Length, "PartitionKeys has unexpected collection size");
        //    Assert.AreEqual("APPSAPPS01_ORG00001234NONLEVY2019123", sentMessage.PartitionKeys.Single(),
        //        "PartitionKey incorrect");

        //    Assert.IsNotNull(sentMessage.SummarisedActualOrgFspGroupKeys,
        //        "SummarisedActualOrgFspGroupKeys has not been set");
        //    Assert.AreEqual(0, sentMessage.SummarisedActualOrgFspGroupKeys.Length,
        //        "SummarisedActualOrgFspGroupKeys has unexpected collection size");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void
        //    ReportedActualsRoutingCommandHandler_ShouldSendReportedActualsLoadedCommandWithPopulatedSummarisedActualOrgFspGroupKeys_WhenIncomingSummarisedActualStagingSourceIsAzureSql()
        //{
        //    // arrange
        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock
        //        .Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod
        //        {
        //            PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnActuals
        //        }.Some);

        //    ReportedActualsLoadedCommand sentMessage = null;
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    busMock
        //        .Setup(b => b.Send(It.IsAny<object>()))
        //        .Callback((object m) => sentMessage = (ReportedActualsLoadedCommand) m);

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        Mock.Of<IAzureRepository<ReportedActual>>(),
        //        fspRepositoryMock.Object,
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    // act
        //    handler.Handle(new ReportedActualsRoutingCommand
        //    {
        //        SummarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey
        //        {
        //            CollectionType = "APPS",
        //            CollectionReturnCode = "APPS01",
        //            OrganisationId = "ORG00001234",
        //            FundingStreamPeriodCode = "NONLEVY2019",
        //            UopCode = "123"
        //        }
        //    });

        //    // assert
        //    Assert.IsNotNull(sentMessage.PartitionKeys, "PartitionKeys has not been set");
        //    Assert.AreEqual(0, sentMessage.PartitionKeys.Length, "PartitionKeys has unexpected collection size");

        //    Assert.IsNotNull(sentMessage.SummarisedActualOrgFspGroupKeys,
        //        "SummarisedActualOrgFspGroupKeys has not been set");
        //    Assert.AreEqual(1, sentMessage.SummarisedActualOrgFspGroupKeys.Length,
        //        "SummarisedActualOrgFspGroupKeys has unexpected collection size");

        //    SummarisedActualOrgFspGroupKey summarisedActualOrgFspGroupKey =
        //        sentMessage.SummarisedActualOrgFspGroupKeys.Single();
        //    Assert.AreEqual("APPS", summarisedActualOrgFspGroupKey.CollectionType, "CollectionType incorrect");
        //    Assert.AreEqual("APPS01", summarisedActualOrgFspGroupKey.CollectionReturnCode,
        //        "CollectionReturnCode incorrect");
        //    Assert.AreEqual("ORG00001234", summarisedActualOrgFspGroupKey.OrganisationId, "OrganisationId incorrect");
        //    Assert.AreEqual("NONLEVY2019", summarisedActualOrgFspGroupKey.FundingStreamPeriodCode,
        //        "FundingStreamPeriodCode incorrect");
        //    Assert.AreEqual("123", summarisedActualOrgFspGroupKey.UopCode, "UopCode incorrect");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void
        //    ReportedActualsRoutingCommandHandler_ShouldSendReportedPaymentInstructionsLoadedCommandWithPopulatedPartitionKey_WhenIncomingSummarisedActualStagingSourceIsAzureTableStorage()
        //{
        //    // arrange
        //    Mock<IAzureRepository<ReportedActual>> reportedActualRepositoryMock =
        //        new Mock<IAzureRepository<ReportedActual>>();
        //    reportedActualRepositoryMock.Setup(r => r.GetRows(It.IsAny<string>())).Returns(new List<ReportedActual>
        //    {
        //        new ReportedActual
        //        {
        //            CollectionType = "APPS",
        //            CollectionReturnCode = "APPS01",
        //            OrganisationId = "ORG00001234",
        //            FundingStreamPeriodCode = "NONLEVY2019",
        //            UoPCode = "123",
        //            ActualValue = 100
        //        }
        //    });

        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock
        //        .Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod {PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnInstruction}
        //            .Some);

        //    ReportedPaymentInstructionsLoadedCommand sentMessage = null;
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    busMock
        //        .Setup(b => b.Send(It.IsAny<object>()))
        //        .Callback((object m) => sentMessage = (ReportedPaymentInstructionsLoadedCommand) m);

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        reportedActualRepositoryMock.Object,
        //        fspRepositoryMock.Object,
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    // act
        //    handler.Handle(new ReportedActualsRoutingCommand
        //    {
        //        PartitionKey = "APPSAPPS01_ORG00001234NONLEVY2019123"
        //    });

        //    // assert
        //    Assert.AreEqual("APPSAPPS01_ORG00001234NONLEVY2019123", sentMessage.PartitionKey,
        //        "PartitionKey is incorrect");
        //    Assert.IsNull(sentMessage.SummarisedActualOrgFspGroupKey,
        //        "SummarisedActualOrgFspGroupKey has been set unexpectedly");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void
        //    ReportedActualsRoutingCommandHandler_ShouldSendReportedPaymentInstructionsLoadedCommandWithPopulatedSummarisedActualOrgFspGroupKey_WhenIncomingSummarisedActualStagingSourceIsAzureSql()
        //{
        //    // arrange
        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock
        //        .Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod {PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnInstruction}
        //            .Some);

        //    ReportedPaymentInstructionsLoadedCommand sentMessage = null;
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    busMock
        //        .Setup(b => b.Send(It.IsAny<object>()))
        //        .Callback((object m) => sentMessage = (ReportedPaymentInstructionsLoadedCommand) m);

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        Mock.Of<IAzureRepository<ReportedActual>>(),
        //        fspRepositoryMock.Object,
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    // act
        //    handler.Handle(new ReportedActualsRoutingCommand
        //    {
        //        SummarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey
        //        {
        //            CollectionType = "APPS",
        //            CollectionReturnCode = "APPS01",
        //            OrganisationId = "ORG00001234",
        //            FundingStreamPeriodCode = "NONLEVY2019",
        //            UopCode = "123"
        //        }
        //    });

        //    // assert
        //    Assert.IsNull(sentMessage.PartitionKey, "PartitionKeys has been set unexpectedly");
        //    Assert.IsNotNull(sentMessage.SummarisedActualOrgFspGroupKey,
        //        "SummarisedActualOrgFspGroupKey has not been set");
        //    Assert.AreEqual("APPS", sentMessage.SummarisedActualOrgFspGroupKey.CollectionType,
        //        "CollectionType incorrect");
        //    Assert.AreEqual("APPS01", sentMessage.SummarisedActualOrgFspGroupKey.CollectionReturnCode,
        //        "CollectionReturnCode incorrect");
        //    Assert.AreEqual("ORG00001234", sentMessage.SummarisedActualOrgFspGroupKey.OrganisationId,
        //        "OrganisationId incorrect");
        //    Assert.AreEqual("NONLEVY2019", sentMessage.SummarisedActualOrgFspGroupKey.FundingStreamPeriodCode,
        //        "FundingStreamPeriodCode incorrect");
        //    Assert.AreEqual("123", sentMessage.SummarisedActualOrgFspGroupKey.UopCode, "UopCode incorrect");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsRoutingCommandHandler_ShouldNotErrorWhenFspNotFoundAndCollectionTypeIsLoans()
        //{
        //    // arrange
        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock
        //        .Setup(fscs => fscs.GetFundingStreamPeriod(It.IsAny<string>()))
        //        .Returns(new FundingStreamPeriod().None);

        //    ReportedPaymentInstructionsLoadedCommand sentMessage = null;
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    busMock
        //        .Setup(b => b.Send(It.IsAny<object>()))
        //        .Callback((object m) => sentMessage = (ReportedPaymentInstructionsLoadedCommand) m);

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        Mock.Of<IAzureRepository<ReportedActual>>(),
        //        fspRepositoryMock.Object,
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    try
        //    {
        //        // act
        //        handler.Handle(new ReportedActualsRoutingCommand
        //        {
        //            SummarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey
        //            {
        //                CollectionType = "ALLF",
        //                CollectionReturnCode = "APPS01",
        //                OrganisationId = "ORG00001234",
        //                FundingStreamPeriodCode = "ALLF22345",
        //                UopCode = "123"
        //            }
        //        });
        //    }
        //    catch (Exception)
        //    {
        //        // assert
        //        Assert.Fail("Collection Type ALLF should not cause an error when we have an unknown FSP");
        //    }
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsRoutingCommandHandler_ShouldErrorWhenFspNotFoundAndCollectionTypeIsNotLoans()
        //{
        //    // arrange
        //    const string unknownFspCode = "BlahFSP";
        //    Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
        //    fspRepositoryMock
        //        .Setup(fscs => fscs.GetFundingStreamPeriod(unknownFspCode))
        //        .Returns(new FundingStreamPeriod().None);

        //    ReportedPaymentInstructionsLoadedCommand sentMessage = null;
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    busMock
        //        .Setup(b => b.Send(It.IsAny<object>()))
        //        .Callback((object m) => sentMessage = (ReportedPaymentInstructionsLoadedCommand) m);

        //    ReportedActualsRoutingCommandHandler handler = new ReportedActualsRoutingCommandHandler(
        //        Mock.Of<IAzureRepository<ReportedActual>>(),
        //        fspRepositoryMock.Object,
        //        busMock.Object,
        //        Mock.Of<ILogger>(),
        //        Mock.Of<IHeldReportedActualGroupCommandRepository>());

        //    bool hasExceptionOccured = false;
        //    try
        //    {
        //        // act
        //        handler.Handle(new ReportedActualsRoutingCommand
        //        {
        //            SummarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey
        //            {
        //                CollectionType = "APPS",
        //                CollectionReturnCode = "APPS01",
        //                OrganisationId = "ORG00001234",
        //                FundingStreamPeriodCode = unknownFspCode,
        //                UopCode = "123"
        //            }
        //        });
        //    }
        //    catch (Exception)
        //    {
        //        hasExceptionOccured = true;
        //    }

        //    // assert
        //    Assert.IsTrue(hasExceptionOccured,
        //        "Collection Type APPS should cause an error when we have an unknown FSP");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ReportedActualsRoutingCommandHandler_ShouldResolve()
        //{
        //    // arrange
        //    IWindsorContainer container = new WindsorContainer().Install(new AllocationDeliveryDomain.Endpoint.IoC.WindsorInstaller(new LoggerFactory()));
        //    container.Register(Component.For<MonitoringDeliverablesDbContext>().LifestyleScoped().IsDefault());
        //    container.Register(Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().Named("SomeName").LifestyleScoped().IsDefault());
        //    container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped().IsDefault());

        //    container.Register(Component.For<IBus>().Instance(Mock.Of<IBus>()));

        //    container.Register(Component.For<ReportedActualsRoutingCommandHandler>());
        //    container.BeginScope();

        //    // act
        //    var handler = container.Resolve<ReportedActualsRoutingCommandHandler>();

        //    // assert
        //    Assert.IsNotNull(handler);
        //}
    }
}
