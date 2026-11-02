namespace PaymentManagement.Calculation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Dtos;
    using Calculation.Repositories;
    using Calculation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    [TestClass]
    public class FundingClaimReconciliationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationService_ShouldCreatePaymentScheduleWithCurrentVersionPlannedValuesAndPrevPaymentValues()
        {
            // arrange
            Mock<IAllocationQueryRepository> allocationQueryRepositoryMock = new Mock<IAllocationQueryRepository>();
            allocationQueryRepositoryMock.Setup(r => r.GetPreviousVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(1.SomeWhen(n => true));

            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock = new Mock<IDeliverablePaymentRepository>();
            deliverablePaymentRepositoryMock
                .Setup(r => r.GetDeliverablePeriodPaymentInfos(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<DeliverablePeriodPaymentInfo>
                {
                    new DeliverablePeriodPaymentInfo(202008, 1, 10, 11, 12, 13, 14, null, null, balancingPaymentAmount:15, profilePaymentAmount:16 ),
                    new DeliverablePeriodPaymentInfo(202009, 1, 20, 21, 22, 23, 24, null, null, balancingPaymentAmount:25, profilePaymentAmount:26 ),
                });

            FundingClaimReconciliationService fundingClaimReconciliationService = new FundingClaimReconciliationService(allocationQueryRepositoryMock.Object, deliverablePaymentRepositoryMock.Object);
            allocationType allocationType = new allocationType
            {
                contractDeliverables = new List<contractDeliverableType>
                {
                    new contractDeliverableType
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                period = new periodType
                                {
                                    periodValue = "202008"
                                },
                                plannedValue = 44
                            },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                period = new periodType
                                {
                                    periodValue = "202009"
                                },
                                plannedValue = 45
                            }
                        }
                    }
                },
                contractorReference = new organisationReferenceType
                {
                    alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                    {
                        new alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = "01234567",
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                }
            };

            // act
            var paymentSchedule =
                fundingClaimReconciliationService.CreatePaymentScheduleFromPreviousVersion(allocationType, It.IsAny<ConnectionInfo>());

            // assert
            var resultDeliverable = paymentSchedule.AllocationDeliverables.Single(d => d.DeliverableCode == 1);
            Assert.AreEqual(44, resultDeliverable.ScheduledPayments.Single(p => p.Period == "202008").PlannedValue, "The planned value for 202008 is incorrect");
            Assert.AreEqual(45, resultDeliverable.ScheduledPayments.Single(p => p.Period == "202009").PlannedValue, "The planned value for 202008 is incorrect");
        }
    }
}
