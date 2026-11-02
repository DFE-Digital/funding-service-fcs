namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.NullObjects;

    [TestClass]
    public class CurrentViewActualsComponentTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CurrentViewActualsComponent_ShouldUpdateCurrentViewActualsWithValuesFromEnrichedReportedActualsWhenTheyMatch()
        {
            // arrange
            const string contractAllocationNumberForTest = "Test1";
            List<CurrentViewActual> currentViewActuals = new List<CurrentViewActual>
            {
                new CurrentViewActual
                {
                    ContractAllocationNumber = contractAllocationNumberForTest,
                    OrganisationId = "Org1",
                    FundingStreamPeriodCode = "FSP1",
                    Period = "201808",
                    DeliverableCode = 1,
                    UoPCode = "C",
                    ContractVersion = 1,
                    ContractSubVersion = 1,
                    AllocationEndDate = DateTime.Now,
                    AllocationStartDate = DateTime.Now
                }
            };

            RemoveRowsFromCurrentViewActuals(contractAllocationNumberForTest);

            InsertRowsIntoCurrentViewActuals(currentViewActuals);

            using (IMonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                
                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(new LoggerNullObject());

                CurrentViewActualsComponent currentViewActualsComponent = new CurrentViewActualsComponent(monitoringDeliverableStore);

                List<EnrichedReportedActual> enrichedReportedActuals =
                    GetEnrichedReportedActualsFromCurrentViewActuals(currentViewActuals: currentViewActuals, actualValue: 10D, actualVolume: 100L);

                // act
                currentViewActualsComponent.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(enrichedReportedActuals, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            var updatedCurrentViewActuals = GetCurrentViewActualsForAllocation(contractAllocationNumberForTest);

            // assert
            Assert.AreEqual(100L, updatedCurrentViewActuals.First().ActualVolume, "The ActualVolume has not been updated");
            Assert.AreEqual(10D, updatedCurrentViewActuals.First().ActualValue, "The ActualValue has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CurrentViewActualsComponent_UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals_ShouldHandleWhenNoActualsAreValid()
        {
            using (IMonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(new LoggerNullObject());

                CurrentViewActualsComponent currentViewActualsComponent = new CurrentViewActualsComponent(monitoringDeliverableStore);

                List<EnrichedReportedActual> enrichedReportedActuals = new List<EnrichedReportedActual>();

                // act
                List<EnrichedReportedActual> actual = 
                    currentViewActualsComponent.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(enrichedReportedActuals, ConnectionInfo.CreateFrom(context.Database.Connection));

                Assert.AreEqual(enrichedReportedActuals, actual, "CurrentViewActualsComponent should return the input collection in the case of it being empty");
            }
        }

        private List<EnrichedReportedActual> GetEnrichedReportedActualsFromCurrentViewActuals(List<CurrentViewActual> currentViewActuals, double actualValue, long actualVolume)
        {
            List<EnrichedReportedActual> enrichedReportedActuals = currentViewActuals.Select(TransformToEnrichedReportedActual).ToList();

            enrichedReportedActuals.ForEach(era =>
            {
                era.ActualValue = actualValue;
                era.ActualVolume = actualVolume;
            });

            return enrichedReportedActuals;
        }

        private EnrichedReportedActual TransformToEnrichedReportedActual(
           CurrentViewActual currentViewActual)
        {
            return new EnrichedReportedActual
            {
                Ukprn = currentViewActual.Ukprn,
                ActualValue = currentViewActual.ActualValue,
                ActualVolume = currentViewActual.ActualVolume,
                AllocationEndDate = currentViewActual.AllocationEndDate,
                AllocationStartDate = currentViewActual.AllocationStartDate,
                CollectionReturnCode = currentViewActual.CollectionReturnCode,
                CollectionType = currentViewActual.CollectionType,
                ContractAllocationNumber = currentViewActual.ContractAllocationNumber,
                ContractNumber = currentViewActual.ContractNumber,
                ContractSubVersion = currentViewActual.ContractSubVersion,
                ContractVersion = currentViewActual.ContractVersion,
                FundingStreamPeriodCode = currentViewActual.FundingStreamPeriodCode,
                OrganisationId = currentViewActual.OrganisationId,
                Period = currentViewActual.Period,
                UoPCode = currentViewActual.UoPCode,
                PeriodTypeCode = currentViewActual.PeriodTypeCode,
                DeliverableCode = currentViewActual.DeliverableCode.ToString()
            };
        }

        private void InsertRowsIntoCurrentViewActuals(IReadOnlyCollection<CurrentViewActual> currentViewActuals)
        {
            using (IMonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.CurrentViewActuals.AddRange(currentViewActuals);

                context.SaveChanges();
            }
        }

        private IReadOnlyCollection<CurrentViewActual> GetCurrentViewActualsForAllocation(string allocationNumber)
        {
            using (IMonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                return
                    context.CurrentViewActuals.Where(cva => cva.ContractAllocationNumber == allocationNumber).ToList();
            }
        }

        private void RemoveRowsFromCurrentViewActuals(string contractAllocationNumber)
        {
            using (IMonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.Database.ExecuteSqlCommand(
                    "Delete from [MonitoringDeliverables].[CurrentViewActual] where contractallocationnumber = contractallocationnumber",
                    new SqlParameter("contractallocationnumber", contractAllocationNumber));


                context.SaveChanges();
            }
        }
    }
}
