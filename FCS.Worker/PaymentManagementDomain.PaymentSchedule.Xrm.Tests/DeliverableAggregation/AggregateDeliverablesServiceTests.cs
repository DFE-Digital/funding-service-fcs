namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.DeliverableAggregation
{
    extern alias Entity;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.DeliverableAggregation;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;

    [TestClass]
    public class AggregateDeliverablesServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AggregateDeliverablesService_ShouldGetAggregatedDeliverablesForAllocation_NCS()
        {
            // arrange
            Mock<IDeliverablePaymentRepository> mockDeliverablePaymentRepository =
                new Mock<IDeliverablePaymentRepository>();
            mockDeliverablePaymentRepository
                .Setup(r => r.GetSummedActualsByDeliverableForAllocation(It.IsAny<string>(), It.IsAny<int>(),
                    It.IsAny<ConnectionInfo>())).Returns(
                    new List<DeliverableActual>
                    {
                        new DeliverableActual(1, 0M, 0),
                        new DeliverableActual(2, 67508.20M, 0),
                        new DeliverableActual(3, 0M, 0),
                        new DeliverableActual(4, 48320.82M, 2),
                        new DeliverableActual(5, 50991.49M, 2),
                        new DeliverableActual(6, 0, 2)
                    });

            Mock<IPayCalcPolicyQueryRepository> mockPayCalcPolicyQueryRepository =
                new Mock<IPayCalcPolicyQueryRepository>();
            mockPayCalcPolicyQueryRepository.Setup(r => r.GetFundingStreamPeriodDeliverables(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<PolicyDeliverable>
                {
                    new PolicyDeliverable
                    {
                        DeliverableCode = 1
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 2,
                        ParentDeliverableCode = 1
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 3,
                        ParentDeliverableCode = 1
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 4,
                        ParentDeliverableCode = 3
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 5,
                        ParentDeliverableCode = 3
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 6
                    }
                });

            AggregateDeliverablesService service =
                new AggregateDeliverablesService(mockDeliverablePaymentRepository.Object,
                    mockPayCalcPolicyQueryRepository.Object);

            // act
            IReadOnlyCollection<DeliverableActual> aggregatedDeliverables =
                service.GetAggregatedDeliverablesForAllocation("", 1, "", ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(6, aggregatedDeliverables.Count, "The number of aggregated deliverables is incorrect");
            Assert.AreEqual(48320.82M, aggregatedDeliverables.Single(a => a.DeliverableCode == 4).Value,
                "Deliverable code 4 is incorrect");
            Assert.AreEqual(99312.31M, aggregatedDeliverables.Single(a => a.DeliverableCode == 3).Value,
                "Deliverable code 3 is incorrect");
            Assert.AreEqual(67508.20M, aggregatedDeliverables.Single(a => a.DeliverableCode == 2).Value,
                "Deliverable code 2 is incorrect");
            Assert.AreEqual(0, aggregatedDeliverables.Single(a => a.DeliverableCode == 6).Value,
                "Deliverable code 6 is incorrect");
            Assert.AreEqual(50991.49M, aggregatedDeliverables.Single(a => a.DeliverableCode == 5).Value,
                "Deliverable code 5 is incorrect");
            Assert.AreEqual(166820.51M, aggregatedDeliverables.Single(a => a.DeliverableCode == 1).Value,
                "Deliverable code 1 is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AggregateDeliverablesService_ShouldGetAggregatedDeliverablesForAllocation_AEC()
        {
            // arrange
            Mock<IDeliverablePaymentRepository> mockDeliverablePaymentRepository =
                new Mock<IDeliverablePaymentRepository>();
            mockDeliverablePaymentRepository
                .Setup(r => r.GetSummedActualsByDeliverableForAllocation(It.IsAny<string>(), It.IsAny<int>(),
                    It.IsAny<ConnectionInfo>())).Returns(
                    new List<DeliverableActual>
                    {
                        new DeliverableActual(1, 0M, 0),
                        new DeliverableActual(2, 320M, 1),
                        new DeliverableActual(3, 420M, 1),
                        new DeliverableActual(4, 520M, 1),
                        new DeliverableActual(5, 622, 1),
                        new DeliverableActual(6, 720M, 0),
                        new DeliverableActual(13, 0M, 0),
                        new DeliverableActual(14, 0M, 0),
                    });

            Mock<IPayCalcPolicyQueryRepository> mockPayCalcPolicyQueryRepository =
                new Mock<IPayCalcPolicyQueryRepository>();
            mockPayCalcPolicyQueryRepository.Setup(r => r.GetFundingStreamPeriodDeliverables(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<PolicyDeliverable>
                {
                    new PolicyDeliverable
                    {
                        DeliverableCode = 1,

                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 2,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 3,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 4,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 5,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 6,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 13,
                        ParentDeliverableCode = 1
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 14,
                        ParentDeliverableCode = 1
                    }
                });

            AggregateDeliverablesService service =
                new AggregateDeliverablesService(mockDeliverablePaymentRepository.Object,
                    mockPayCalcPolicyQueryRepository.Object);

            // act
            IReadOnlyCollection<DeliverableActual> aggregatedDeliverables =
                service.GetAggregatedDeliverablesForAllocation("", 1, "", ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(8, aggregatedDeliverables.Count, "The number of aggregated deliverables is incorrect");
            Assert.AreEqual(520M, aggregatedDeliverables.Single(a => a.DeliverableCode == 4).Value,
                "Deliverable code 4 is incorrect");
            Assert.AreEqual(420M, aggregatedDeliverables.Single(a => a.DeliverableCode == 3).Value,
                "Deliverable code 3 is incorrect");
            Assert.AreEqual(320M, aggregatedDeliverables.Single(a => a.DeliverableCode == 2).Value,
                "Deliverable code 2 is incorrect");
            Assert.AreEqual(2602M, aggregatedDeliverables.Single(a => a.DeliverableCode == 1).Value,
                "Deliverable code 1 is incorrect");
            Assert.AreEqual(0M, aggregatedDeliverables.Single(a => a.DeliverableCode == 13).Value,
                "Deliverable code 13 is incorrect");
            Assert.AreEqual(2602M, aggregatedDeliverables.Single(a => a.DeliverableCode == 14).Value,
                "Deliverable code 14 is incorrect");
            Assert.AreEqual(720M, aggregatedDeliverables.Single(a => a.DeliverableCode == 6).Value,
                "Deliverable code 6 is incorrect");
            Assert.AreEqual(622M, aggregatedDeliverables.Single(a => a.DeliverableCode == 5).Value,
                "Deliverable code 5 is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AggregateDeliverablesService_ShouldNotAggregateChildDeliverableActualVolumesToParentDeliverable()
        {
            // arrange
            Mock<IDeliverablePaymentRepository> mockDeliverablePaymentRepository =
                new Mock<IDeliverablePaymentRepository>();
            mockDeliverablePaymentRepository
                .Setup(r => r.GetSummedActualsByDeliverableForAllocation(It.IsAny<string>(), It.IsAny<int>(),
                    It.IsAny<ConnectionInfo>())).Returns(
                    new List<DeliverableActual>
                    {
                        new DeliverableActual(1, 0M, 0),
                        new DeliverableActual(2, 320M, 1),
                        new DeliverableActual(3, 420M, 1),
                        new DeliverableActual(4, 520M, 1),
                        new DeliverableActual(5, 622, 1),
                        new DeliverableActual(6, 720M, 0),
                        new DeliverableActual(13, 0M, 0),
                        new DeliverableActual(14, 0M, 0),
                    });

            Mock<IPayCalcPolicyQueryRepository> mockPayCalcPolicyQueryRepository =
                new Mock<IPayCalcPolicyQueryRepository>();
            mockPayCalcPolicyQueryRepository.Setup(r => r.GetFundingStreamPeriodDeliverables(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<PolicyDeliverable>
                {
                    new PolicyDeliverable
                    {
                        DeliverableCode = 1,

                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 2,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 3,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 4,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 5,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 6,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 13,
                        ParentDeliverableCode = 1
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 14,
                        ParentDeliverableCode = 1
                    }
                });

            AggregateDeliverablesService service =
                new AggregateDeliverablesService(mockDeliverablePaymentRepository.Object,
                    mockPayCalcPolicyQueryRepository.Object);

            // act
            IReadOnlyCollection<DeliverableActual> aggregatedDeliverables =
                service.GetAggregatedDeliverablesForAllocation("", 1, "", ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(8, aggregatedDeliverables.Count, "The number of aggregated deliverables is incorrect");
            Assert.IsNull(aggregatedDeliverables.Single(a => a.DeliverableCode == 1).Volume,
                "Parent deliverable code 1 aggregated Actual Volume is not null");

            Assert.IsNull(aggregatedDeliverables.Single(a => a.DeliverableCode == 14).Volume,
                "Parent deliverable code 14 aggregated Actual Volume is not null");
        }


        [TestMethod, TestCategory("UnitTest")]
        public void AggregateDeliverablesService_ShouldAggregateChildDeliverableActualValuesToParentDeliverableActualValueToNullWhenAllChildDeliverableActualValuesAreNull()
        {
            // arrange
            Mock<IDeliverablePaymentRepository> mockDeliverablePaymentRepository =
                new Mock<IDeliverablePaymentRepository>();
            mockDeliverablePaymentRepository
                .Setup(r => r.GetSummedActualsByDeliverableForAllocation(It.IsAny<string>(), It.IsAny<int>(),
                    It.IsAny<ConnectionInfo>())).Returns(
                    new List<DeliverableActual>
                    {
                        new DeliverableActual(1, null, 1),
                        new DeliverableActual(2, null, 2),
                        new DeliverableActual(3, null, 3),
                        new DeliverableActual(4, null, 4),
                        new DeliverableActual(5, null, 5),
                        new DeliverableActual(6, null, 6),
                        new DeliverableActual(13, null, 13),
                        new DeliverableActual(14, null, 14),
                    });

            Mock<IPayCalcPolicyQueryRepository> mockPayCalcPolicyQueryRepository =
                new Mock<IPayCalcPolicyQueryRepository>();
            mockPayCalcPolicyQueryRepository.Setup(r => r.GetFundingStreamPeriodDeliverables(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<PolicyDeliverable>
                {
                    new PolicyDeliverable
                    {
                        DeliverableCode = 1,

                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 2,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 3,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 4,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 5,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 6,
                        ParentDeliverableCode = 14
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 13,
                        ParentDeliverableCode = 1
                    },
                    new PolicyDeliverable
                    {
                        DeliverableCode = 14,
                        ParentDeliverableCode = 1
                    }
                });

            AggregateDeliverablesService service =
                new AggregateDeliverablesService(mockDeliverablePaymentRepository.Object,
                    mockPayCalcPolicyQueryRepository.Object);

            // act
            IReadOnlyCollection<DeliverableActual> aggregatedDeliverables =
                service.GetAggregatedDeliverablesForAllocation("", 1, "", ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(8, aggregatedDeliverables.Count, "The number of aggregated deliverables is incorrect");
            Assert.IsNull(aggregatedDeliverables.Single(a => a.DeliverableCode == 1).Value,
                "Parent deliverable code 1 aggregated Actual Value is not null");

            Assert.IsNull(aggregatedDeliverables.Single(a => a.DeliverableCode == 14).Value,
                "Parent deliverable code 14 aggregated Actual Value is not null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AggregateDeliverablesHandler_ShouldResolve()
        {
            var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<IHandleMessages<AggregateDeliverablesCommand>>()
                .ImplementedBy<AggregateDeliverablesHandler>().LifestyleScoped());

            container.BeginScope();

            var handler = container.Resolve<IHandleMessages<AggregateDeliverablesCommand>>();

            Assert.IsNotNull(handler,
                "Handler did not resolve");
        }
    }
}
