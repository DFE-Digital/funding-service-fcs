namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using Castle.MicroKernel.Registration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using UnitTests.Common;

    [TestClass]
    public class Plus24ActualVerificationTest : ActualsVerificationTestBase
    {
        private const string MessageId = "Plus24ActualVerificationTest";

        [TestInitialize()]
        public override void Initialize()
        {
            base.Initialize();
            CleanupCurrentViewActuals();
            SetUpCurrentViewActuals();

            // Need to setup override date as the actuals validation processing uses today's date
            using (var overrideDateDB = new OverrideDateDBContext())
            {
                foreach (OverrideDate overrideDate in overrideDateDB.OverrideDate)
                {
                    overrideDateDB.OverrideDate.Remove(overrideDate);
                }
                overrideDateDB.SaveChanges();
                overrideDateDB.OverrideDate.Add(new OverrideDate()
                {
                    SystemOverrideDate = new DateTime(2015, 12, 01)
                });
                overrideDateDB.SaveChanges();
            }
        }

        [TestCleanup()]
        public override void Cleanup()
        {
            base.Cleanup();
            CleanupCurrentViewActuals();
            using (var overrideDateDB = new OverrideDateDBContext())
            {
                foreach (OverrideDate overrideDate in overrideDateDB.OverrideDate)
                {
                    overrideDateDB.OverrideDate.Remove(overrideDate);
                }
                overrideDateDB.SaveChanges();
            }
        }

        private void SetUpCurrentViewActuals()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.CurrentViewActuals.Add(new CurrentViewActual
                {
                    Ukprn = "50522500",
                    ActualValue = 100,
                    ActualVolume = 1000,
                    AllocationEndDate = new DateTime(2015, 7, 31),
                    AllocationStartDate = new DateTime(2015, 8, 1),
                    CollectionReturnCode = "EOPR1",
                    CollectionType = "24ALLF",
                    ContractAllocationNumber = "CA1",
                    ContractNumber = "1111",
                    ContractSubVersion = 0,
                    ContractVersion = 1,
                    FundingStreamPeriodCode = "24+ALLBC1516",
                    OrganisationId = "ORG1",
                    Period = "201511",
                    UoPCode = "UOP1",
                    PeriodTypeCode = "CM",
                    DeliverableCode = 1
                });

                context.SaveChanges();
            }
        }

        private void CleanupCurrentViewActuals()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var itemsToDelete = context.CurrentViewActuals.Where(x => x.OrganisationId == "ORG1");
                itemsToDelete.ToList().ForEach(x => context.CurrentViewActuals.Remove(x));
                context.SaveChanges();
            }
        }

        protected override List<ReportedActual> CreateReportedActuals()
        {
            var reportedActuals = new List<ReportedActual>
            {
                new ReportedActual()
                {
                    CollectionType = "24ALLF",
                    OrganisationId = "ORG1",
                    ActualValue = 80,
                    ActualVolume = 160,
                    Period = "201511",
                    DeliverableCode = "1",
                    UoPCode = "UOP1",
                    CollectionReturnCode = "EOPR1",
                    FundingStreamPeriodCode = "24+ALLBC1516",
                    ContractAllocationNumber = "CA1",
                }
            };



            return reportedActuals;
        }

        protected override void AddAllocationDeliverablePeriods()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriods.Add(new AllocationDeliverablePeriod()
                {
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "24+ALLBC1516",
                    UopCode = "UOP1",
                    DeliverableCode = 1,
                    Period = "201511",
                    ContractAllocationNumber = "CA1",
                    ContractNumber = "CONTRACT-001",
                    ContractVersionNumber = 2,
                    ContractSubVersionNumber = 0,
                    AllocationStartDate = DateTime.Parse("1 Jan 2000"),
                    AllocationEndDate = DateTime.Parse("1 Dec 2015"),
                    Ukprn = "50522500"
                });

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CanLoadAndVerify24PlusLoansFutureActuals()
        {
            //CleanupProcessedMessage(MessageId);

            //_container.Register(Component.For<ILogger>().ImplementedBy<SimpleConsoleLogger>().IsDefault());

            //var primaryReportedActualItem = _reportedActuals.First();

            //var busMock = new Mock<IBus>();
            //busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>()))
            //    .Callback<IAllocationActualsVerified>(x =>
            //    {
            //        var dataItem = x;
            //        AssertPublishedActual(dataItem);
            //    })
            //    .Verifiable();

            //var messageContextMock = new Mock<IMessageContext>();
            //messageContextMock.SetupGet(x => x.Id).Returns(MessageId);
            //busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

            //var container = CreateContainer();
            //container.Register(Component.For<IBus>().Instance(busMock.Object));

            //var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();

            //var msg = new ReportedActualsLoadedCommand
            //{
            //    PartitionKeys = new[] { primaryReportedActualItem.EntityPartitionKey },
            //    FundingStreamPeriodCode = primaryReportedActualItem.FundingStreamPeriodCode
            //};
            //handler.Handle(msg);

            //busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Once);
        }
    }
}
