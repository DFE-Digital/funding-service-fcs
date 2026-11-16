namespace PaymentGenerationDomain.BusinessLogic.Tests.Services
{
    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentGenerationDomain.BusinessLogic.Mappers;
    using PaymentGenerationDomain.BusinessLogic.Services;
    using PaymentGenerationDomain.Integration.DataStore.Dtos;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PaymentRunServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task PaymentRunService_ShouldPublishPaymentPeriod_WhenValidAndNotAlreadyInAtomFeed()
        {
            // arrange
            Mock<IDataAccessManager> dataAccessManagerMock = new Mock<IDataAccessManager>();
            dataAccessManagerMock.Setup(r => r.UpdateAndGetPaymentsForPaymentRun(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<SubnominalAggregationDto>
                {
                    new SubnominalAggregationDto()
                });
            Mock<IPaymentGenerationXmlValidator> paymentGenerationXmlValidatorMock = new Mock<IPaymentGenerationXmlValidator>();
            paymentGenerationXmlValidatorMock.Setup(v => v.Validate(It.IsAny<PaymentPeriod>())).Returns(true);
            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
            Mock<IPaymentBatchFeedItemCommandRepository> feedItemRepositoryMock = new Mock<IPaymentBatchFeedItemCommandRepository>();
            feedItemRepositoryMock.Setup(r => r.AddItem(It.IsAny<PaymentBatchFeedItem>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<PaymentBatchFeedItemAddResult>(PaymentBatchFeedItemAddResult.Added));

            Mock<IPaymentCorpSchemaMapper> mapperMock = new Mock<IPaymentCorpSchemaMapper>();
            mapperMock.Setup(m =>
                    m.MapSubnominalAggregationToCorpPaymentSchema(
                        It.IsAny<IReadOnlyCollection<SubnominalAggregationDto>>(), It.IsAny<PaymentTimetable>(),
                        It.IsAny<IReadOnlyCollection<EsfAllocationData>>(),
                        It.IsAny<string>(),
                        It.IsAny<DateTime>(),
                        It.IsAny<DateTime>(),
                        It.IsAny<string>()))
                .Returns(new PaymentPeriod
                {
                    PaymentDetails = new List<PaymentDetail>()
                });

            Mock<IFundingStreamPeriodQueryRepository> fundingStreamPeriodQueryRepositoryMock = new Mock<IFundingStreamPeriodQueryRepository>();
            fundingStreamPeriodQueryRepositoryMock
                .Setup(r => r.GetFundingStreamPeriodWithFundingStream(It.IsAny<string>()))
                .ReturnsAsync(new Integration.DataStore.Model.FundingStreamPeriod
                {
                    FundingStream = new FundingStream()
                });

            PaymentRunService paymentRunService = new PaymentRunService(mapperMock.Object,
                paymentGenerationXmlValidatorMock.Object,
                Mock.Of<ILogger>(),
                dataAccessManagerMock.Object,
                monitoringDeliverableStoreMock.Object,
                feedItemRepositoryMock.Object,
                fundingStreamPeriodQueryRepositoryMock.Object);
            
            bool hasPaymentBeenPublished = false;
            // act
            await paymentRunService.PublishPaymentPeriod(
                new PaymentTimetable(),
                (p, i) => 
                {
                    hasPaymentBeenPublished = true;
                    return Task.FromResult(0);
                },
                error => Task.FromResult(0),
                new ConnectionInfo(null, null));

            // assert
            Assert.IsTrue(hasPaymentBeenPublished, "The payment has not been published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task PaymentRunService_ShouldNotPublishPaymentPeriod_WhenValidAndAlreadyInAtomFeed()
        {
            // arrange
            Mock<IDataAccessManager> dataAccessManagerMock = new Mock<IDataAccessManager>();
            dataAccessManagerMock.Setup(r => r.UpdateAndGetPaymentsForPaymentRun(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<SubnominalAggregationDto>
                {
                    new SubnominalAggregationDto()
                });
            Mock<IPaymentGenerationXmlValidator> paymentGenerationXmlValidatorMock = new Mock<IPaymentGenerationXmlValidator>();
            paymentGenerationXmlValidatorMock.Setup(v => v.Validate(It.IsAny<PaymentPeriod>())).Returns(true);
            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
            Mock<IPaymentBatchFeedItemCommandRepository> feedItemRepositoryMock = new Mock<IPaymentBatchFeedItemCommandRepository>();
            feedItemRepositoryMock.Setup(r => r.AddItem(It.IsAny<PaymentBatchFeedItem>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<PaymentBatchFeedItemAddResult>(PaymentBatchFeedItemAddResult.AlreadyPresent));

            Mock<IPaymentCorpSchemaMapper> mapperMock = new Mock<IPaymentCorpSchemaMapper>();
            mapperMock.Setup(m =>
                    m.MapSubnominalAggregationToCorpPaymentSchema(
                        It.IsAny<IReadOnlyCollection<SubnominalAggregationDto>>(), It.IsAny<PaymentTimetable>(),
                        It.IsAny<IReadOnlyCollection<EsfAllocationData>>(), It.IsAny<string>(),
                        It.IsAny<DateTime>(),
                        It.IsAny<DateTime>(),
                        It.IsAny<string>()))
                .Returns(new PaymentPeriod
                {
                    PaymentDetails = new List<PaymentDetail>()
                });

            Mock<IFundingStreamPeriodQueryRepository> fundingStreamPeriodQueryRepositoryMock = new Mock<IFundingStreamPeriodQueryRepository>();
            fundingStreamPeriodQueryRepositoryMock
                .Setup(r => r.GetFundingStreamPeriodWithFundingStream(It.IsAny<string>()))
                .ReturnsAsync(new Integration.DataStore.Model.FundingStreamPeriod
                {
                    FundingStream = new FundingStream()
                });

            PaymentRunService paymentRunService = new PaymentRunService(mapperMock.Object,
                paymentGenerationXmlValidatorMock.Object,
                Mock.Of<ILogger>(), dataAccessManagerMock.Object,
                monitoringDeliverableStoreMock.Object,
                feedItemRepositoryMock.Object,
                fundingStreamPeriodQueryRepositoryMock.Object);

            bool hasPaymentBeenPublished = false;
            // act
            await paymentRunService.PublishPaymentPeriod(
                new PaymentTimetable(),
                (p, i) =>
                {
                    hasPaymentBeenPublished = true;
                    return Task.FromResult(0);
                },
                error => Task.FromResult(0),
                new ConnectionInfo(null, null));

            // assert
            Assert.IsFalse(hasPaymentBeenPublished, "The payment has been published");
        }


        [TestMethod, TestCategory("UnitTest")]
        public async Task PaymentRunService_ShouldPublishPaymentPeriod_WhenThereAreNoPayments()
        {
            // arrange
            Mock<IDataAccessManager> dataAccessManagerMock = new Mock<IDataAccessManager>();
            dataAccessManagerMock.Setup(r => r.UpdateAndGetPaymentsForPaymentRun(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<SubnominalAggregationDto>());
            Mock<IPaymentGenerationXmlValidator> paymentGenerationXmlValidatorMock = new Mock<IPaymentGenerationXmlValidator>();
            paymentGenerationXmlValidatorMock.Setup(v => v.Validate(It.IsAny<PaymentPeriod>())).Returns(true);
            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
            Mock<IPaymentBatchFeedItemCommandRepository> feedItemRepositoryMock = new Mock<IPaymentBatchFeedItemCommandRepository>();
            feedItemRepositoryMock.Setup(r => r.AddItem(It.IsAny<PaymentBatchFeedItem>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<PaymentBatchFeedItemAddResult>(PaymentBatchFeedItemAddResult.Added));

            Mock<IFundingStreamPeriodQueryRepository> fundingStreamPeriodQueryRepositoryMock = new Mock<IFundingStreamPeriodQueryRepository>();
            fundingStreamPeriodQueryRepositoryMock
                .Setup(r => r.GetFundingStreamPeriodWithFundingStream(It.IsAny<string>()))
                .ReturnsAsync(new Integration.DataStore.Model.FundingStreamPeriod
                {
                    FundingStream = new FundingStream
                    {
                        AgencyCode = "SFA",
                        FinanceShortCode = "F"
                    }
                });

            PaymentRunService paymentRunService = new PaymentRunService(new PaymentCorpSchemaMapper(), new PaymentGenerationXmlValidator
            {
                Logger = Mock.Of<ILogger>(),
                Mapper = new PaymentCorpSchemaMapper()
            }, Mock.Of<ILogger>(),
                dataAccessManagerMock.Object,
                monitoringDeliverableStoreMock.Object,
                feedItemRepositoryMock.Object,
                fundingStreamPeriodQueryRepositoryMock.Object);

            bool hasPaymentBeenPublished = false;
            // act
            await paymentRunService.PublishPaymentPeriod(
                new PaymentTimetable
                {
                    FinancialPeriod = "201807"
                },
                (p, i) =>
                {
                    hasPaymentBeenPublished = true;
                    return Task.FromResult(0);
                },
                error => Task.FromResult(0),
                new ConnectionInfo(null, null));

            // assert
            Assert.IsTrue(hasPaymentBeenPublished, "The payment has not been published");
        }
    }
}
