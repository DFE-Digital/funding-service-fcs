namespace PaymentGenerationDomain.Endpoint.Tests
{
    extern alias Entity;
    using System;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.BusinessLogic.Mappers;
    using PaymentGenerationDomain.BusinessLogic.Services;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;

    [TestClass]
    public class PaymentRunServiceIntegrationTests
    {
        //[TestMethod, TestCategory("TechnicalExploration")]
        //public async Task PaymentRunServiceIntegration_PublishPaymentPeriod()
        //{
        //    // arrange
        //    using (var monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext())
        //    using (var context = new PaymentGenerationDbContext())
        //    {
        //        PaymentRunService service = new PaymentRunService(new PaymentCorpSchemaMapper(), new PaymentGenerationXmlValidator
        //            {
        //                Logger = Mock.Of<ILogger>(),
        //                Mapper = new PaymentCorpSchemaMapper()
        //            }, new LoggerNullObject(), new DataAccessManager(new SubnominalAggregationRepository(context), context, Mock.Of<ILogger>()),
        //            new MonitoringDeliverableStore(monitoringDeliverablesDbContext, Mock.Of<ILogger>()),
        //            new PaymentBatchFeedItemRepository(context), new FundingStreamPeriodQueryRepository(context));

        //        await service.PublishPaymentPeriod(new PaymentTimetable
        //        {
        //            FundingStreamPeriodCode = "ESF1420",
        //            CalendarPeriod = "201604",
        //            FinancialPeriod = "201601",
        //            LinkCodeSuffix = "A",
        //            CensusEndDate = DateTime.Parse("2016-05-09T22:00:00"),
        //            PeriodStartDate = DateTime.Parse("2014-08-01T00:00:00"),
        //            PeriodEndDate = DateTime.Parse("2014-08-01T00:00:00")

        //        }, null, null, new ConnectionInfo(null, context.Database.Connection));
        //    }
        //}
    }
}
