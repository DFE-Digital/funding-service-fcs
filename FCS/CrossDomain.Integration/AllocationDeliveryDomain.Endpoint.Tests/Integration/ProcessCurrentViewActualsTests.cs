namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using Castle.MicroKernel.Registration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Events;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Extensions;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;
    using SFA.FCT.AllocationDelivery.DataStore;
    using UnitTests.Common;

    //[TestClass]
    //public abstract class ProcessCurrentViewActualsTests : ActualsVerificationTestBase
    //{
    //    [TestInitialize]
    //    public override void Initialize()
    //    {
    //        base.Initialize();
    //        CleanUpCurrentViewActuals();
    //    }

    //    [TestCleanup]
    //    public override void Cleanup()
    //    {
    //        base.Cleanup();
    //        CleanUpCurrentViewActuals();
    //    }

    //    protected override void AddAllocationDeliverablePeriods()
    //    {
    //        var monitoringDeliverableStore = _container.Resolve<IMonitoringDeliverableStore>();

    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 1,
    //            Period = "201508",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });
    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 2,
    //            Period = "201508",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });
    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 3,
    //            Period = "201508",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });

    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 1,
    //            Period = "201509",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });
    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 2,
    //            Period = "201509",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });
    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 3,
    //            Period = "201509",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });

    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 1,
    //            Period = "201510",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });
    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 2,
    //            Period = "201510",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });
    //        monitoringDeliverableStore.Context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
    //        {
    //            OrganisationId = "ORG150915",
    //            FundingStreamPeriodCode = "EOP1517",
    //            UopCode = "UOP1",
    //            DeliverableCode = 3,
    //            Period = "201510",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "CONTRACT-001",
    //            ContractVersionNumber = 2,
    //            ContractSubVersionNumber = 0,
    //            AllocationStartDate = DateTime.Parse("1 Aug 2015"),
    //            AllocationEndDate = DateTime.Parse("31 Jul 2016"),
    //            Ukprn = "50522500"
    //        });
            
    //        monitoringDeliverableStore.Context.SaveChanges();
    //    }

    //    protected void SetOverrideDate(DateTime dateTime)
    //    {
    //        using (var context = new OverrideDateDBContext())
    //        {
    //            context.OverrideDate.ForEach(od => context.OverrideDate.Remove(od));
    //            context.OverrideDate.Add(new OverrideDate {SystemOverrideDate = dateTime});
    //            context.SaveChanges();
    //        }
    //    }

    //    private void CleanUpCurrentViewActuals()
    //    {
    //        var monitoringDeliverableStore = _container.Resolve<IMonitoringDeliverableStore>();
    //        using (var context = monitoringDeliverableStore.Context)
    //        {
    //            var itemsToDelete = context.CurrentViewActuals.Where(x => x.OrganisationId == "ORG150915");
    //            itemsToDelete.ToList().ForEach(x => context.CurrentViewActuals.Remove(x));
    //            context.SaveChanges();
    //        }
    //    }

    //    protected void CleanupProcessedMessage(string messageId)
    //    {
    //        using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext())
    //        {
    //            allocationDeliveryDbContext.ProcessedMessages.RemoveWhere(m => m.MessageId == messageId);
    //            allocationDeliveryDbContext.SaveChanges();
    //        }
    //    }
    //}

    //[TestClass]
    //public class ProcessCurrentViewActualsScenario1 : ProcessCurrentViewActualsTests
    //{
    //    protected override List<ReportedActual> CreateReportedActuals()
    //    {
    //        return new List<ReportedActual>
    //        {
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 80,
    //                ActualVolume = 160,
    //                Period = "201508",
    //                DeliverableCode = "1",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R01",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 50,
    //                ActualVolume = 150,
    //                Period = "201508",
    //                DeliverableCode = "2",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R01",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 50,
    //                ActualVolume = 150,
    //                Period = "201508",
    //                DeliverableCode = "3",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R01",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            }
    //        };
    //    }

    //    protected override void SetStaticDate()
    //    {
    //        var overrideDateDbContext = _container.Resolve<IOverrideDateDBContext>();
    //        overrideDateDbContext.SetOverrideDate("04/10/2015");
    //    }

    //    [TestMethod, TestCategory("IntegrationTest")]
    //    public void ProcessCurrentViewActualsForAllocation_NewImportedActualsWithNoPreviousCurrentViewActuals()
    //    {
    //        var messageId = "ProcessCurrentViewActualsTests";
    //        CleanupProcessedMessage(messageId);

    //        var busMock = new Mock<IBus>();
    //        busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>()))
    //            .Callback<IAllocationActualsVerified>(a =>
    //            {
    //                Assert.IsNotNull(a);
    //                Assert.IsNotNull(a.AllocationActuals);
    //                Assert.AreEqual(3, a.AllocationActuals.ActualsSummary.Count());
    //                Assert.AreEqual(180, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201508").Sum(x => x.ActualValue));
    //            })
    //            .Verifiable();

    //        var messageContextMock = new Mock<IMessageContext>();
    //        messageContextMock.SetupGet(x => x.Id).Returns(messageId);
    //        busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

    //        var container = CreateContainer();
    //        container.Register(Component.For<IBus>().Instance(busMock.Object));
            
    //        this.SetOverrideDate(new DateTime(2015, 9, 1, 0, 0, 0, 0, DateTimeKind.Utc));

    //        var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();

    //        var message = new ReportedActualsLoadedCommand
    //        {
    //            PartitionKeys = new[] { _reportedActuals.First().EntityPartitionKey },
    //            FundingStreamPeriodCode = _reportedActuals.First().FundingStreamPeriodCode
    //        };
    //        handler.Handle(message);

    //        busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Once);
    //        busMock.VerifyAll();
    //    }
    //}

    //[TestClass]
    //public class ProcessCurrentViewActualsScenario2 : ProcessCurrentViewActualsTests
    //{
    //    protected override List<ReportedActual> CreateReportedActuals()
    //    {
    //        return new List<ReportedActual>
    //        {
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 100,
    //                ActualVolume = 160,
    //                Period = "201508",
    //                DeliverableCode = "1",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 0,
    //                ActualVolume = 150,
    //                Period = "201508",
    //                DeliverableCode = "2",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 1109,
    //                ActualVolume = 1000,
    //                Period = "201508",
    //                DeliverableCode = "3",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },

    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 100,
    //                ActualVolume = 160,
    //                Period = "201509",
    //                DeliverableCode = "1",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 0,
    //                ActualVolume = 150,
    //                Period = "201509",
    //                DeliverableCode = "2",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 120,
    //                ActualVolume = 150,
    //                Period = "201509",
    //                DeliverableCode = "3",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            }
    //        };
    //    }

    //    protected override void SetStaticDate()
    //    {
    //        var overrideDateDbContext = _container.Resolve<IOverrideDateDBContext>();
    //        overrideDateDbContext.SetOverrideDate("04/10/2015");
    //    }
        
    //    [TestMethod, TestCategory("IntegrationTest")]
    //    public void ProcessCurrentViewActualsForAllocation_NewAndRestatedImportedActualsWithPreviousCurrentViewActuals()
    //    {
    //        #region CurrentViewActuals

    //        var monitoringDeliverableStore = _container.Resolve<IMonitoringDeliverableStore>();

    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 100,
    //            ActualVolume = 1000,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 1
    //        });
    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 200,
    //            ActualVolume = 1100,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 2
    //        });
    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 400,
    //            ActualVolume = 1200,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 3
    //        });

    //        monitoringDeliverableStore.Context.SaveChanges();

    //        #endregion

    //        var messageId = "ProcessCurrentViewActualsTests";
    //        CleanupProcessedMessage(messageId);

    //        var busMock = new Mock<IBus>();
    //        busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>()))
    //            .Callback<IAllocationActualsVerified>(a =>
    //            {
    //                Assert.IsNotNull(a);
    //                Assert.IsNotNull(a.AllocationActuals);
    //                Assert.AreEqual(6, a.AllocationActuals.ActualsSummary.Count());
    //                Assert.AreEqual(1209, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201508").Sum(x => x.ActualValue));
    //                Assert.AreEqual(220, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201509").Sum(x => x.ActualValue));
    //            })
    //            .Verifiable();

    //        var messageContextMock = new Mock<IMessageContext>();
    //        messageContextMock.SetupGet(x => x.Id).Returns(messageId);
    //        busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

    //        var container = CreateContainer();
    //        container.Register(Component.For<IBus>().Instance(busMock.Object));

    //        var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();

    //        var message = new ReportedActualsLoadedCommand
    //        {
    //            PartitionKeys = new[] { _reportedActuals.First().EntityPartitionKey },
    //            FundingStreamPeriodCode = _reportedActuals.First().FundingStreamPeriodCode
    //        };
    //        handler.Handle(message);

    //        busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Once);
    //        busMock.VerifyAll();
    //    }
    //}

    //[TestClass]
    //public class ProcessCurrentViewActualsScenario3 : ProcessCurrentViewActualsTests
    //{
    //    protected override List<ReportedActual> CreateReportedActuals()
    //    {
    //        return new List<ReportedActual>
    //        {
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 500,
    //                ActualVolume = 160,
    //                Period = "201510",
    //                DeliverableCode = "1",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R03",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 1,
    //                ActualVolume = 150,
    //                Period = "201510",
    //                DeliverableCode = "2",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R03",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 99,
    //                ActualVolume = 1000,
    //                Period = "201510",
    //                DeliverableCode = "3",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R03",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            }
    //        };
    //    }

    //    protected override void SetStaticDate()
    //    {
    //        var overrideDateDbContext = _container.Resolve<IOverrideDateDBContext>();
    //        overrideDateDbContext.SetOverrideDate("04/11/2015");
    //    }

    //    [TestMethod, TestCategory("IntegrationTest")]
    //    public void ProcessCurrentViewActualsForAllocation_NewImportedActualsWithPreviousCurrentViewActuals()
    //    {
    //        #region CurrentViewActuals

    //        var monitoringDeliverableStore = _container.Resolve<IMonitoringDeliverableStore>();

    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 100,
    //            ActualVolume = 1000,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R02",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201509",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 1
    //        });
    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 900,
    //            ActualVolume = 1100,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R02",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201509",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 2
    //        });
    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 3,
    //            ActualVolume = 1200,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R02",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201509",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 3
    //        });

    //        monitoringDeliverableStore.Context.SaveChanges();

    //        #endregion

    //        var messageId = "ProcessCurrentViewActualsTests";
    //        CleanupProcessedMessage(messageId);

    //        var busMock = new Mock<IBus>();
    //        busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>()))
    //            .Callback<IAllocationActualsVerified>(a =>
    //            {
    //                Assert.IsNotNull(a);
    //                Assert.IsNotNull(a.AllocationActuals);
    //                Assert.AreEqual(6, a.AllocationActuals.ActualsSummary.Count());
    //                Assert.AreEqual(1003, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201509").Sum(x => x.ActualValue));
    //                Assert.AreEqual(600, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201510").Sum(x => x.ActualValue));
    //                Assert.AreEqual(1603, a.AllocationActuals.ActualsSummary.Sum(x => x.ActualValue));
    //            })
    //            .Verifiable();

    //        var messageContextMock = new Mock<IMessageContext>();
    //        messageContextMock.SetupGet(x => x.Id).Returns(messageId);
    //        busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

    //        var container = CreateContainer();
    //        container.Register(Component.For<IBus>().Instance(busMock.Object));

    //        var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();

    //        var message = new ReportedActualsLoadedCommand
    //        {
    //            PartitionKeys = new[] { _reportedActuals.First().EntityPartitionKey },
    //            FundingStreamPeriodCode = _reportedActuals.First().FundingStreamPeriodCode
    //        };
    //        handler.Handle(message);

    //        busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Once);
    //        busMock.VerifyAll();
    //    }
    //}

    //[TestClass]
    //public class ProcessCurrentViewActualsScenario4 : ProcessCurrentViewActualsTests
    //{
    //    protected override List<ReportedActual> CreateReportedActuals()
    //    {
    //        return new List<ReportedActual>
    //        {
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 250,
    //                ActualVolume = 160,
    //                Period = "201508",
    //                DeliverableCode = "1",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 750,
    //                ActualVolume = 150,
    //                Period = "201508",
    //                DeliverableCode = "2",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 5,
    //                ActualVolume = 160,
    //                Period = "201509",
    //                DeliverableCode = "1",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 1,
    //                ActualVolume = 150,
    //                Period = "201509",
    //                DeliverableCode = "2",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 6,
    //                ActualVolume = 160,
    //                Period = "201509",
    //                DeliverableCode = "3",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            }
    //        };
    //    }

    //    protected override void SetStaticDate()
    //    {
    //        var overrideDateDbContext = _container.Resolve<IOverrideDateDBContext>();
    //        overrideDateDbContext.SetOverrideDate("04/10/2015");
    //    }

    //    [TestMethod, TestCategory("IntegrationTest")]
    //    public void ProcessCurrentViewActualsForAllocation_NewAndPartiallyRestatedActualsWithPreviousCurrentViewActuals()
    //    {
    //        #region CurrentViewActuals

    //        var monitoringDeliverableStore = _container.Resolve<IMonitoringDeliverableStore>();

    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 200,
    //            ActualVolume = 1000,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 1
    //        });
    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 9,
    //            ActualVolume = 1100,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 2
    //        });
    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 1,
    //            ActualVolume = 1200,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 3
    //        });

    //        monitoringDeliverableStore.Context.SaveChanges();

    //        #endregion

    //        var messageId = "ProcessCurrentViewActualsTests";
    //        CleanupProcessedMessage(messageId);

    //        var busMock = new Mock<IBus>();
    //        busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>()))
    //            .Callback<IAllocationActualsVerified>(a =>
    //            {
    //                Assert.IsNotNull(a);
    //                Assert.IsNotNull(a.AllocationActuals);
    //                Assert.AreEqual(6, a.AllocationActuals.ActualsSummary.Count());
    //                Assert.AreEqual(1000, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201508").Sum(x => x.ActualValue));
    //                Assert.AreEqual(12, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201509").Sum(x => x.ActualValue));
    //                Assert.AreEqual(1012, a.AllocationActuals.ActualsSummary.Sum(x => x.ActualValue));
    //            })
    //            .Verifiable();

    //        var messageContextMock = new Mock<IMessageContext>();
    //        messageContextMock.SetupGet(x => x.Id).Returns(messageId);
    //        busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

    //        var container = CreateContainer();
    //        container.Register(Component.For<IBus>().Instance(busMock.Object));

    //        var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();

    //        var message = new ReportedActualsLoadedCommand
    //        {
    //            PartitionKeys = new[] { _reportedActuals.First().EntityPartitionKey },
    //            FundingStreamPeriodCode = _reportedActuals.First().FundingStreamPeriodCode
    //        };
    //        handler.Handle(message);

    //        busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Once);
    //        busMock.VerifyAll();
    //    }
    //}

    //[TestClass]
    //public class ProcessCurrentViewActualsScenario5 : ProcessCurrentViewActualsTests
    //{
    //    protected override List<ReportedActual> CreateReportedActuals()
    //    {
    //        return new List<ReportedActual>
    //        {
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 250,
    //                ActualVolume = 160,
    //                Period = "201508",
    //                DeliverableCode = "1",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 750,
    //                ActualVolume = 150,
    //                Period = "201508",
    //                DeliverableCode = "2",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 0,
    //                ActualVolume = 150,
    //                Period = "201508",
    //                DeliverableCode = "3",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 5,
    //                ActualVolume = 160,
    //                Period = "201509",
    //                DeliverableCode = "1",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 1,
    //                ActualVolume = 150,
    //                Period = "201509",
    //                DeliverableCode = "2",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            },
    //            new ReportedActual
    //            {
    //                CollectionType = "EOP1",
    //                OrganisationId = "ORG150915",
    //                ActualValue = 6,
    //                ActualVolume = 160,
    //                Period = "201509",
    //                DeliverableCode = "3",
    //                UoPCode = "UOP1",
    //                CollectionReturnCode = "R02",
    //                FundingStreamPeriodCode = "EOP1517",
    //                ContractAllocationNumber = "CA1"
    //            }
    //        };
    //    }

    //    protected override void SetStaticDate()
    //    {
    //        var overrideDateDbContext = _container.Resolve<IOverrideDateDBContext>();
    //        overrideDateDbContext.SetOverrideDate("04/10/2015");
    //    }

    //    [TestMethod, TestCategory("IntegrationTest")]
    //    public void ProcessCurrentViewActualsForAllocation_NewAndRestatedActualsWithZeroActualAndPreviousCurrentViewActuals()
    //    {
    //        #region CurrentViewActuals

    //        var monitoringDeliverableStore = _container.Resolve<IMonitoringDeliverableStore>();

    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 200,
    //            ActualVolume = 1000,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 1
    //        });
    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 9,
    //            ActualVolume = 1100,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 2
    //        });
    //        monitoringDeliverableStore.Context.CurrentViewActuals.Add(new CurrentViewActual
    //        {
    //            Ukprn = "50522500",
    //            ActualValue = 1,
    //            ActualVolume = 1200,
    //            AllocationEndDate = new DateTime(2015, 7, 31),
    //            AllocationStartDate = new DateTime(2015, 8, 1),
    //            CollectionReturnCode = "R01",
    //            CollectionType = "EOP1",
    //            ContractAllocationNumber = "CA1",
    //            ContractNumber = "1111",
    //            ContractSubVersion = 0,
    //            ContractVersion = 1,
    //            FundingStreamPeriodCode = "EOP1517",
    //            OrganisationId = "ORG150915",
    //            Period = "201508",
    //            UoPCode = "UOP1",
    //            PeriodTypeCode = "CM",
    //            DeliverableCode = 3
    //        });

    //        monitoringDeliverableStore.Context.SaveChanges();

    //        #endregion

    //        var messageId = "ProcessCurrentViewActualsTests";
    //        CleanupProcessedMessage(messageId);

    //        var busMock = new Mock<IBus>();
    //        busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>()))
    //            .Callback<IAllocationActualsVerified>(a =>
    //            {
    //                Assert.IsNotNull(a);
    //                Assert.IsNotNull(a.AllocationActuals);
    //                Assert.AreEqual(6, a.AllocationActuals.ActualsSummary.Count());
    //                Assert.AreEqual(1000, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201508").Sum(x => x.ActualValue));
    //                Assert.AreEqual(12, a.AllocationActuals.ActualsSummary.Where(x => x.Period == "201509").Sum(x => x.ActualValue));
    //                Assert.AreEqual(1012, a.AllocationActuals.ActualsSummary.Sum(x => x.ActualValue));
    //            })
    //            .Verifiable();

    //        var messageContextMock = new Mock<IMessageContext>();
    //        messageContextMock.SetupGet(x => x.Id).Returns(messageId);
    //        busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

    //        var container = CreateContainer();
    //        container.Register(Component.For<IBus>().Instance(busMock.Object));

    //        var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();

    //        var message = new ReportedActualsLoadedCommand
    //        {
    //            PartitionKeys = new[] { _reportedActuals.First().EntityPartitionKey },
    //            FundingStreamPeriodCode = _reportedActuals.First().FundingStreamPeriodCode
    //        };
    //        handler.Handle(message);

    //        busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Once);
    //        busMock.VerifyAll();
    //    }
    //}
}
