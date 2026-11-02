namespace PaymentManagement.Calculation.Tests
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using PaymentManagement.Calculation.Repositories;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using System.Linq;
    using Calculation.Dtos;
    using Calculation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using Allocation = SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    [TestClass]
    public class PaymentValuesCalculationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentValuesCalculationService_ProducePaymentScheduleOnActualsReceived_ShouldThrowArgumentExceptionIfBehaviourNotSupported()
        {
            // arrange
            const string fundingStreamPeriodCode = "FundingStreamPeriodCode";
            var expectedThrownExceptionMessage = $"ProducePaymentScheduleOnActualsReceived - There is no calculation behaviour for Allocation FSP code {fundingStreamPeriodCode}";

            var paymentValuesCalculatorMock = new Mock<IPaymentValuesCalculator>();
            paymentValuesCalculatorMock
                .Setup(c => c.ProducePaymentScheduleForCurrentPeriodOnActualsReceived(It.IsAny<CalculationAllocationInput>(), It.IsAny<ConnectionInfo>()))
                .Returns(new Option<Allocation>());

            var policyFundingStreamPeriodRepositoryMock = new Mock<IPolicyFundingStreamPeriodRepository>();
            policyFundingStreamPeriodRepositoryMock
                .Setup(fspr => fspr.GetFspDeliverableInfos(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<FspDeliverableInfo>());
            policyFundingStreamPeriodRepositoryMock
                .Setup(fspr => fspr.GetCappingGroups(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<CappingGroup>());

            var service = new PaymentValuesCalculationService(
                paymentValuesCalculatorMock.Object,
                Mock.Of<IDeliverablePaymentRepository>(),
                Mock.Of<IActualEnrichmentService>(),
                policyFundingStreamPeriodRepositoryMock.Object,
                Mock.Of<ILogger>(), Mock.Of<IFundingClaimReconciliationService>());

            var argumentExceptionThrown = false;
            var thrownErrorMessage = string.Empty;
    
            try
            {
                // act
                service.ProducePaymentScheduleOnActualsReceived(new ContractAllocationActualsType
                {
                    ActualsSummary = new List<ActualsSummaryType>(),
                    ContractReference = new ContractReferenceType(),
                    ContractorReference = new OrganisationReferenceType
                    {
                        AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                        {
                            new organisationIdentifiersOrganisationIdentifier
                            {
                                organisationIdentifierType =  organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                            }
                        }
                    },
                    FundingStreamPeriodCode = fundingStreamPeriodCode
                }, ConnectionInfo.CreateDefault());
            }
            catch (ArgumentException ex)
            {
                argumentExceptionThrown = true;
                thrownErrorMessage = ex.Message;
            }
            
            // assert
            Assert.IsTrue(argumentExceptionThrown, "Argument exception was not thrown"); 
            Assert.AreEqual(expectedThrownExceptionMessage, thrownErrorMessage, "Incorrect argument exception message");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentValuesCalculationService_ProducePaymentScheduleOnActualsReceived_ShouldUpdateActualsInDeliverablePaymentTable()
        {
            // arrange
            const decimal expectedActualValue = 1000003.03m;
            const int expectedActualVolume = 1100003;
            const string period = "202003";
            const int deliverableCode = 10;

            var paymentValuesCalculator = new Mock<IPaymentValuesCalculator>();
            paymentValuesCalculator
                .Setup(c => c.ProducePaymentScheduleForCurrentPeriodOnActualsReceived(It.IsAny<CalculationAllocationInput>(), It.IsAny<ConnectionInfo>()))
                .Returns(new Allocation().Some());

            var policyFundingStreamPeriodRepositoryMock = new Mock<IPolicyFundingStreamPeriodRepository>();
            policyFundingStreamPeriodRepositoryMock
                .Setup(fspr => fspr.GetFspDeliverableInfos(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<FspDeliverableInfo> { new FspDeliverableInfo(10, true, null, -1) });
            policyFundingStreamPeriodRepositoryMock
                .Setup(fspr => fspr.GetCappingGroups(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<CappingGroup>());

            const string allocationNumber = "AllocNo_PaymentValuesCalculationService";
            const int versionNumber = 99;

            ClearDownDeliverablePaymentsForAllocationNumberAndVersion(allocationNumber, versionNumber);
            CreateDeliverablePaymentWithActuals(allocationNumber, versionNumber, period, deliverableCode, 33.33m, 3);

            var contractAllocationActualsType = new ContractAllocationActualsType
            {
                ContractAllocationNumber = allocationNumber,
                ContractReference =
                {
                    ContractVersionNumber = versionNumber
                },
                ActualsSummary = new List<ActualsSummaryType>
                {
                    new ActualsSummaryType
                    {
                        DeliverableCode = deliverableCode,
                        Period = period,
                        ActualValue = expectedActualValue,
                        ActualVolume = expectedActualVolume
                    }
                },
                ContractorReference = new OrganisationReferenceType
                {
                    AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                    {
                        new organisationIdentifiersOrganisationIdentifier
                        {
                            organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                        }
                    }
                }
            };

            using (var context = new PaymentSchedulePolicyContext())
            {
                var deliverablePaymentRepository = new DeliverablePaymentRepository();
                var service = new PaymentValuesCalculationService(paymentValuesCalculator.Object,
                    deliverablePaymentRepository,
                    Mock.Of<IActualEnrichmentService>(),
                    policyFundingStreamPeriodRepositoryMock.Object, Mock.Of<ILogger>(), Mock.Of<IFundingClaimReconciliationService>());
                
                // act
                service.ProducePaymentScheduleOnActualsReceived(contractAllocationActualsType, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                var assertDeliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                // Assert
                Assert.AreEqual(1, assertDeliverablePayments.Count, "Incorrect number of delivery payment records in table");

                Assert.IsNotNull(assertDeliverablePayments.SingleOrDefault(adp =>
                    adp.Period == period && adp.DeliverableCode == deliverableCode && adp.ActualValue == expectedActualValue &&
                    adp.ActualVolume == expectedActualVolume), "DeliverablePayment was not updated");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentValuesCalculationService_ProducePaymentScheduleOnActualsReceived_ShouldPersistCalculatedValues()
        {
            // arrange
            Mock<IPaymentValuesCalculator> paymentValuesCalculatorMock = new Mock<IPaymentValuesCalculator>();
            paymentValuesCalculatorMock
                .Setup(c => c.ProducePaymentScheduleForCurrentPeriodOnActualsReceived(It.IsAny<CalculationAllocationInput>(), It.IsAny<ConnectionInfo>()))
                .Returns(new Allocation
                {
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable(),
                        new AllocationDeliverable(),
                        new AllocationDeliverable()
                    }
                }.Some());

            var policyFundingStreamPeriodRepositoryMock = new Mock<IPolicyFundingStreamPeriodRepository>();
            policyFundingStreamPeriodRepositoryMock
                .Setup(fspr => fspr.GetFspDeliverableInfos(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<FspDeliverableInfo>());
            policyFundingStreamPeriodRepositoryMock
                .Setup(fspr => fspr.GetCappingGroups(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<CappingGroup>());

            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock = new Mock<IDeliverablePaymentRepository>();

            PaymentValuesCalculationService service = new PaymentValuesCalculationService(
            paymentValuesCalculatorMock.Object,
            deliverablePaymentRepositoryMock.Object,
            Mock.Of<IActualEnrichmentService>(),
            policyFundingStreamPeriodRepositoryMock.Object, Mock.Of<ILogger>(), Mock.Of<IFundingClaimReconciliationService>());

            // act
            service.ProducePaymentScheduleOnActualsReceived(new ContractAllocationActualsType
            {
                ContractorReference = new OrganisationReferenceType
                {
                    AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                    {
                        new organisationIdentifiersOrganisationIdentifier { organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER }
                    }
                }
            }, ConnectionInfo.CreateDefault());

            // assert
            deliverablePaymentRepositoryMock.Verify(
                m => m.AddOrUpdateDeliverablePaymentsWithCalculatedValues(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<AllocationDeliverable>(), It.IsAny<ConnectionInfo>()),
                Times.Exactly(3),
                "Deliverable Payment Repository was not called expected number of times");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentValuesCalculationService_ProducePaymentScheduleOnApproval_ShouldThrowArgumentExceptionIfBehaviourNotSupported()
        {
            // arrange
            const string fundingStreamPeriodCode = "FundingStreamPeriodCode";
            var expectedThrownExceptionMessage = $"ProducePaymentScheduleOnApproval - There is no calculation behaviour for Allocation FSP code {fundingStreamPeriodCode}";
            
            var allocation = new allocationType {fundingStreamPeriod = new allocationTypeFundingStreamPeriod {fundingStreamPeriodCode = fundingStreamPeriodCode}};

            var paymentValuesCalculatorMock = new Mock<IPaymentValuesCalculator>();
            paymentValuesCalculatorMock
                .Setup(c => c.IsFspCalculatedWithOpaReplacement(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            var service = new PaymentValuesCalculationService(
                paymentValuesCalculatorMock.Object,
                Mock.Of<IDeliverablePaymentRepository>(),
                Mock.Of<IActualEnrichmentService>(),
                Mock.Of<IPolicyFundingStreamPeriodRepository>(),
                Mock.Of<ILogger>(), Mock.Of<IFundingClaimReconciliationService>());

            var argumentExceptionThrown = false;
            var thrownErrorMessage = string.Empty;

            try
            {
                // act
                service.ProducePaymentScheduleOnApproval(allocation, ConnectionInfo.CreateDefault());
            }
            catch (ArgumentException ex)
            {
                argumentExceptionThrown = true;
                thrownErrorMessage = ex.Message;
            }

            // assert
            Assert.IsTrue(argumentExceptionThrown, "Argument exception was not thrown");
            Assert.AreEqual(expectedThrownExceptionMessage, thrownErrorMessage, "Incorrect argument exception message");
        }

        private static void ClearDownDeliverablePaymentsForAllocationNumberAndVersion(string allocationNumber, int versionNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList()
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }
        }

        private static void CreateDeliverablePaymentWithActuals(string allocationNumber, int versionNumber, string period, int deliverableCode,
            decimal actualValue, int actualVolume)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(
                    new DeliverablePayment
                    {
                        AllocationNumber = allocationNumber,
                        VersionNumber = versionNumber,
                        Period = period,
                        DeliverableCode = deliverableCode,
                        ActualValue = actualValue,
                        ActualVolume = actualVolume
                    }
                );

                context.SaveChanges();
            }
        }
    }
}
