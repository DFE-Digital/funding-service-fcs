namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;

    [TestClass]
    public class ActualEnricherTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ActualEnricher_ShouldEnrichInAReasonableTime()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.Database.Connection.ConnectionString =
                    ""; 

                ILogger logger = new LoggerNullObject();

                ActualEnricher actualEnricher = new ActualEnricher(
                    new MonitoringDeliverableStore(context, logger),
                    logger);

                IEnumerable<ReportedActual> reportedActuals = GetReportedActualsFromAudit(context, "R08", "16AP-3112");

                DateTime startTime = DateTime.Now;
                actualEnricher.Enrich(reportedActuals);
                DateTime endTime = DateTime.Now;

                TimeSpan timeSpan = endTime.Subtract(startTime);

                Assert.IsTrue(timeSpan.TotalSeconds < 1D, $"The time taken is - { timeSpan}");
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ActualEnricher_ShouldEnrichESFInAReasonableTime()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.Database.Connection.ConnectionString =
                    "";
                ILogger logger = new LoggerNullObject();

                ActualEnricher actualEnricher = new ActualEnricher(
                    new MonitoringDeliverableStore(context, logger),
                    logger);

                IEnumerable<ReportedActual> reportedActuals = GetReportedActualsFromAudit(context, "R08", "16AP-3112");
                reportedActuals.ForEach(ra => ra.FundingStreamPeriodCode = "ESF");

                DateTime startTime = DateTime.Now;
                actualEnricher.Enrich(reportedActuals);
                DateTime endTime = DateTime.Now;

                TimeSpan timeSpan = endTime.Subtract(startTime);

                Assert.IsTrue(timeSpan.TotalSeconds < 0.5D, $"The time taken is - { timeSpan}");
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ActualEnricher_ShouldEnrichESFInAReasonableTime2()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {

                ILogger logger = new LoggerNullObject();

                ActualEnricher actualEnricher = new ActualEnricher(
                    new MonitoringDeliverableStore(context, logger),
                    logger);

                var reportedActuals = new AzureRepository<ReportedActual>(new SFA.FCT.CrossDomain.Integration.Common.Storage.AzureTableStore(), new EnvironmentContext()).GetRows("ILR1819R04_ORG0017885ANLAP2018");
                actualEnricher.Enrich(reportedActuals);
            }
        }

        private IList<ReportedActual> GetReportedActualsFromAudit(MonitoringDeliverablesDbContext context, string collectionReturnCode,
            string contractAllocationNumber)
        {
            return
                context.AllocationDeliverablePeriodActualAudits.Where(
                    audit => audit.CollectionReturnCode == collectionReturnCode &&
                             audit.ContractAllocationNumber == contractAllocationNumber)
                    .Select(audit => new ReportedActual
                    {
                        CollectionReturnCode = collectionReturnCode,
                        ActualValue = audit.ActualValue,
                        ActualVolume = audit.ActualVolume,
                        ContractAllocationNumber = audit.ContractAllocationNumber,
                        DeliverableCode = audit.DeliverableCode.ToString(),
                        UoPCode = audit.UopCode,
                        OrganisationId = audit.OrganisationId,
                        FundingStreamPeriodCode = audit.FundingStreamPeriodCode,
                        Period = audit.Period,
                        PeriodTypeCode = audit.PeriodTypeCode
                    }).ToList();
        }
    }
}
