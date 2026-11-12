namespace PaymentGenerationDomain.Integration.PaymentGeneration.AggregatePayment
{

    extern alias Entities;
    using System.Collections.Generic;
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint.DTOs;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class UpSertSubmoninalAggregationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpSertSubmoninalAggregationService_ShouldUpdateWhenMatchFound()
        {
            // arrange
            const string subnominalCode = "123";
            const string period = "201909";
            const decimal existingAggregatedValue = 123456M;
            const decimal newAggregatedValue = 10M;
            const string allocationNumber = "Test AN";
            const AggregationPaymentType paymentType = AggregationPaymentType.PROFILE;

            Mock<ISubnominalAggregationRepository> repositoryMock = new Mock<ISubnominalAggregationRepository>();
            SimpleSubnominalAggregation simpleSubnominalAggregation =
                new SimpleSubnominalAggregation(allocationNumber, period, subnominalCode, paymentType.ToString(),
                    isPosted: false)
                {
                    AggregatedValue = existingAggregatedValue
                };

            List<AllocationPeriodWithExistingData> allocationPeriodsWithExisting =
                new List<AllocationPeriodWithExistingData>
                {
                    new AllocationPeriodWithExistingData(new AllocationPeriod
                    {
                        Period = period,
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                SubnominalCode = subnominalCode,
                                AggregatedValue = newAggregatedValue,
                                PaymentType = paymentType
                            }
                        }
                    }, new List<SimpleSubnominalAggregation>
                    {
                        simpleSubnominalAggregation
                    })
                };
            UpSertSubmoninalAggregationService service = new UpSertSubmoninalAggregationService(repositoryMock.Object);

            // act
            service.UpSert(allocationPeriodsWithExisting, new Allocation(), ConnectionInfo.CreateDefault());

            // assert
            repositoryMock.Verify(r => r.Update(simpleSubnominalAggregation, It.IsAny<ConnectionInfo>()), Times.Once, "We have not updated");
            Assert.AreEqual(newAggregatedValue, simpleSubnominalAggregation.AggregatedValue, "The aggregated value is not correct");
            repositoryMock.Verify(r => r.Insert(It.IsAny<SubnominalAggregation>(), It.IsAny<ConnectionInfo>()), Times.Never, "We have should not have inserted");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpSertSubmoninalAggregationService_ShouldInsertWhenMatchNotFound()
        {
            // arrange
            const string subnominalCode = "123";
            const string otherSubnominalCode = "1234";
            const string period = "201909";
            const decimal existingAggregatedValue = 123456M;
            const decimal newAggregatedValue = 10M;
            const string allocationNumber = "Test AN";
            const AggregationPaymentType paymentType = AggregationPaymentType.PROFILE;

            Mock<ISubnominalAggregationRepository> repositoryMock = new Mock<ISubnominalAggregationRepository>();
            SimpleSubnominalAggregation simpleSubnominalAggregation =
                new SimpleSubnominalAggregation(allocationNumber, period, subnominalCode, paymentType.ToString(),
                    isPosted: false)
                {
                    AggregatedValue = existingAggregatedValue
                };

            List<AllocationPeriodWithExistingData> allocationPeriodsWithExisting =
                new List<AllocationPeriodWithExistingData>
                {
                    new AllocationPeriodWithExistingData(new AllocationPeriod
                    {
                        Period = period,
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                SubnominalCode = otherSubnominalCode,
                                AggregatedValue = newAggregatedValue,
                                PaymentType = paymentType
                            }
                        }
                    }, new List<SimpleSubnominalAggregation>
                    {
                        simpleSubnominalAggregation
                    })
                };
            UpSertSubmoninalAggregationService service = new UpSertSubmoninalAggregationService(repositoryMock.Object);

            // act
            service.UpSert(allocationPeriodsWithExisting, new Allocation
            {
                Organisation = new Organisation
                {
                    AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                    {
                        new OrgainsationIdentifier
                        {
                            OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                            OrganisationId = "1"
                        }
                    }
                }
            }, It.IsAny<ConnectionInfo>());

            // assert
            repositoryMock.Verify(r => r.Update(simpleSubnominalAggregation, It.IsAny<ConnectionInfo>()), Times.Never, "We have updated");
            
            repositoryMock.Verify(r => r.Insert(It.IsAny<SubnominalAggregation>(), It.IsAny<ConnectionInfo>()), Times.Once, "We have should have inserted");
        }
    }
}
