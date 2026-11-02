namespace PaymentManagement.Calculation.Tests
{
    using System;
    using System.Collections.Generic;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Calculation.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Optional;
    using PaymentManagement.Calculation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class PaymentValuesCalculatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentValuesCalculator_ProducePaymentScheduleForCurrentPeriod_ShouldReturnPaymentScheduleIfConfigSupports()
        {
            // arrange
            Mock<IPolicyFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IPolicyFundingStreamPeriodRepository>();
            fspRepositoryMock
                .Setup(r => r.GetFspCalcConfigInfo("ESF1420", It.IsAny<Period>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FspCalcConfigInfo(PaymentMethod.PayOnActuals, PaymentCappingPeriodType.ContractDuration, PaymentCappingLevelType.DeliverableLine, false, null, null, null));

            fspRepositoryMock
                .Setup(r => r.GetPaymentMethod("ESF1420", It.IsAny<ConnectionInfo>()))
                .Returns(PaymentMethod.PayOnActuals);

            fspRepositoryMock
                .Setup(fspr => fspr.GetFspDeliverableInfos(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<FspDeliverableInfo>());

            Mock<IPaymentTimetableRepository> paymentTimetableRepositoryMock = new Mock<IPaymentTimetableRepository>();
            paymentTimetableRepositoryMock.Setup(r => r.GetCensusPeriodInfo(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()))
                .Returns(new CensusPeriodInfo(It.IsAny<DateTime>(), It.IsAny<int>(), It.IsAny<int>()));

            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock =
                new Mock<IDeliverablePaymentRepository>();

            deliverablePaymentRepositoryMock.Setup(r => r.GetDeliverablePeriodPaymentInfos(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                    .Returns(new List<DeliverablePeriodPaymentInfo>());

            Mock<IBehaviourFactory> behaviourFactoryMock = new Mock<IBehaviourFactory>();
            behaviourFactoryMock.Setup(f => f.GetBehaviour("ESF1420", It.IsAny<Period>(), It.IsAny<ConnectionInfo>()))
                .Returns(new Behaviour(AllocationDurationDeliverableLineBehaviour.Calculate, null, PaymentMethod.PayOnActuals).Some());

            PaymentValuesCalculator calculator = new PaymentValuesCalculator(
                fspRepositoryMock.Object,
                new CensusDateService(paymentTimetableRepositoryMock.Object, Mock.Of<IDateService>(), fspRepositoryMock.Object),
                deliverablePaymentRepositoryMock.Object, Mock.Of<ILogger>(), behaviourFactoryMock.Object);
            
            // act
            var paymentScheduleOption = calculator.ProducePaymentScheduleForCurrentPeriodOnActualsReceived(new CalculationAllocationInput(
                null, 1,
                "ESF1420",
                new List<CalculationDeliverableInput>(),
                string.Empty,
                string.Empty,
                "CN1",
                new List<Calculation.Dtos.CappingGroup>()), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsTrue(paymentScheduleOption.HasValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentValuesCalculator_ProducePaymentScheduleForCurrentPeriod_ShouldReturnNoneIfWeDontSupport()
        {
            // arrange
            Mock<IPolicyFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IPolicyFundingStreamPeriodRepository>();
            fspRepositoryMock
                .Setup(r => r.GetFspCalcConfigInfo("NCS-C1920", It.IsAny<Period>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FspCalcConfigInfo(PaymentMethod.PayOnActuals, PaymentCappingPeriodType.ContractDuration, PaymentCappingLevelType.Group, false, null, null, null));

            fspRepositoryMock.Setup(r => r.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnActuals);

            Mock<IBehaviourFactory> behaviourFactoryMock = new Mock<IBehaviourFactory>();
            behaviourFactoryMock.Setup(f => f.GetBehaviour("NCS-C1920", It.IsAny<Period>(), It.IsAny<ConnectionInfo>()))
                .Returns(new Option<Behaviour>());

            Mock<IPaymentTimetableRepository> paymentTimetableRepositoryMock = new Mock<IPaymentTimetableRepository>();
            paymentTimetableRepositoryMock.Setup(r => r.GetCensusPeriodInfo(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()))
                .Returns(new CensusPeriodInfo(It.IsAny<DateTime>(), It.IsAny<int>(), It.IsAny<int>()));

            PaymentValuesCalculator calculator = new PaymentValuesCalculator(
                fspRepositoryMock.Object,
                new CensusDateService(paymentTimetableRepositoryMock.Object, Mock.Of<IDateService>(), fspRepositoryMock.Object),
                Mock.Of<IDeliverablePaymentRepository>(),
                Mock.Of<ILogger>(), behaviourFactoryMock.Object);

            // act
            var paymentScheduleOption = calculator.ProducePaymentScheduleForCurrentPeriodOnActualsReceived(new CalculationAllocationInput(
                null, 1,
                "NCS-C1920",
                new List<CalculationDeliverableInput>(),
                string.Empty,
                string.Empty,
                "CN1",
                new List<Calculation.Dtos.CappingGroup>()), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsFalse(paymentScheduleOption.HasValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentValuesCalculator_IsFspCalculatedWithOpaReplacement_ShouldReturnTrueWhenBehaviourIsSupported()
        {
            // arrange
            const string fsp = "NCS-C1920";
            Mock<IPolicyFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IPolicyFundingStreamPeriodRepository>();
            fspRepositoryMock
                .Setup(r => r.GetFspCalcConfigInfo(fsp, It.IsAny<Period>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FspCalcConfigInfo(PaymentMethod.PayOnActuals,PaymentCappingPeriodType.FinancialYear, PaymentCappingLevelType.ContractAllocation, isPrioritisedApportionment: true, null, null, null));

            fspRepositoryMock.Setup(r => r.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnActuals);

            Mock<IBehaviourFactory> behaviourFactoryMock = new Mock<IBehaviourFactory>();
            behaviourFactoryMock.Setup(f => f.GetBehaviour("NCS-C1920", It.IsAny<Period>(), It.IsAny<ConnectionInfo>()))
                .Returns(new Behaviour(FinancialYearAllocationLevelBehaviour.Calculate, null, PaymentMethod.PayOnActuals).Some);

            Mock<IPaymentTimetableRepository> paymentTimetableRepositoryMock = new Mock<IPaymentTimetableRepository>();
            paymentTimetableRepositoryMock.Setup(r => r.GetCensusPeriodInfo(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()))
                .Returns(new CensusPeriodInfo(It.IsAny<DateTime>(), It.IsAny<int>(), It.IsAny<int>()));

            PaymentValuesCalculator calculator = new PaymentValuesCalculator(
                fspRepositoryMock.Object,
                new CensusDateService(paymentTimetableRepositoryMock.Object, Mock.Of<IDateService>(), fspRepositoryMock.Object),
                Mock.Of<IDeliverablePaymentRepository>(),
                 Mock.Of<ILogger>(), behaviourFactoryMock.Object);

            // act
            var isSupported = calculator.IsFspCalculatedWithOpaReplacement(fsp, ConnectionInfo.CreateDefault());

            // assert
            Assert.IsTrue(isSupported);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentValuesCalculator_ProducePaymentScheduleForCurrentPeriodOnActualsReceived_ShouldReturnNoneIfFspIsNoPay()
        {
            // arrange
            Mock<IPolicyFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IPolicyFundingStreamPeriodRepository>();
            fspRepositoryMock
                .Setup(r => r.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(PaymentMethod.NoPay);

            PaymentValuesCalculator calculator = new PaymentValuesCalculator(
                fspRepositoryMock.Object,
                 Mock.Of<ICensusDateService>(),
                Mock.Of<IDeliverablePaymentRepository>(), 
                Mock.Of<ILogger>(), Mock.Of<IBehaviourFactory>());

            // act
            var paymentScheduleOption = calculator.ProducePaymentScheduleForCurrentPeriodOnActualsReceived(new CalculationAllocationInput(
                null, 1,
                "ALLF",
                new List<CalculationDeliverableInput>(),
                string.Empty,
                string.Empty,
                "CN1",
                new List<Calculation.Dtos.CappingGroup>()), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsFalse(paymentScheduleOption.HasValue);
        }
    }
}
