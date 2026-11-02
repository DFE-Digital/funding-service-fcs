namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class CurrentViewActualComponentTaTests
    {
        const string ConnectionString =
               "";
        const string AllocationNumberEop = "EOP1-2020";
        const string CollectionReturnCode = "E15";
        const int ContractVersionNumber = 2;
        [TestMethod, TestCategory("PerformanceTest")]
        public void CurrentViewActualStore_ShouldProcessActualsInaReasonableTime()
        {
            // arrange
            List<EnrichedReportedActual> enrichedActuals = GetEnrichedActuals();

            // act
            DateTime start = DateTime.Now;
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.Database.Connection.ConnectionString = ConnectionString;
               
                MonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(context, new SimpleConsoleLogger());
                CurrentViewActualsComponent currentViewActualsComponent = new CurrentViewActualsComponent(monitoringDeliverableStore);
                List<EnrichedReportedActual> processedActuals = currentViewActualsComponent.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(enrichedActuals);
            }
            DateTime end = DateTime.Now;
            TimeSpan timeSpan = new TimeSpan(end.Ticks - start.Ticks);
            // assert
            Assert.IsTrue(timeSpan.TotalSeconds < 10, $"The time take is {timeSpan.TotalSeconds}");
        }

        private List<EnrichedReportedActual> GetEnrichedActuals()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.Database.Connection.ConnectionString = ConnectionString;
                return context.AllocationDeliverablePeriodActualAudits.Where(
                    aud => aud.ContractAllocationNumber == AllocationNumberEop && aud.ContractVersion == ContractVersionNumber &&
                    aud.CollectionReturnCode == CollectionReturnCode)
                    .Select(ToEnrichedActual).ToList();
            }
        }

        private EnrichedReportedActual ToEnrichedActual(AllocationDeliverablePeriodActualAudit actualAudit)
        {
            return new EnrichedReportedActual
            {
                ActualVolume = actualAudit.ActualVolume,
                ActualValue = actualAudit.ActualValue,
                AllocationEndDate = actualAudit.AllocationEndDate,
                AllocationStartDate = actualAudit.AllocationStartDate,
                CollectionReturnCode = actualAudit.CollectionReturnCode,
                CollectionType = actualAudit.CollectionType,
                ContractAllocationNumber = actualAudit.ContractAllocationNumber,
                ContractVersion = actualAudit.ContractVersion,
                Period = actualAudit.Period,
                ContractNumber = actualAudit.ContractNumber,
                FundingStreamPeriodCode = actualAudit.FundingStreamPeriodCode,
                OrganisationId = actualAudit.OrganisationId,
                Ukprn = actualAudit.Ukprn,
                UoPCode = actualAudit.UopCode,
                DeliverableCode = actualAudit.DeliverableCode.ToString()
            };
        }
    }
}
