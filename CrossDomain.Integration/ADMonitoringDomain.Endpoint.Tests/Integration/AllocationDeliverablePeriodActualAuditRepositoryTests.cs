namespace ADMonitoringDomain.Endpoint.Tests.Integration
{
    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ADMonitoringDomain.Endpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class AllocationDeliverablePeriodActualAuditRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliverablePeriodActualAuditRepository_GetLatestCollectionReturn_WhenActualsPresentForAllocation_ShouldReturnLatestCollectionReturnRecords()
        {
            const string allocationNumber = "ALLOC-1234";

            // arrange
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriodActualAudits.RemoveWhere(a => a.ContractAllocationNumber == allocationNumber);
                context.AllocationsUnderTermination.RemoveWhere(a => a.ContractAllocationNumber == allocationNumber);

                context.AllocationDeliverablePeriodActualAudits.AddRange(new[]
                {
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201802",
                        CollectionReturnPeriod = 201808,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R13"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201801",
                        CollectionReturnPeriod = 201808,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R13"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201802",
                        CollectionReturnPeriod = 201807,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R12"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201801",
                        CollectionReturnPeriod = 201807,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R12"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201802",
                        CollectionReturnPeriod = 201806,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R11"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201801",
                        CollectionReturnPeriod = 201806,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R11"
                    }
                });

                context.SaveChanges();
            }

            // act
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                AllocationDeliverablePeriodActualAuditRepository repository = new AllocationDeliverablePeriodActualAuditRepository();

                IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> latestCollectionReturnAuditRows =
                    repository.GetLatestCollectionReturn(allocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(2, latestCollectionReturnAuditRows.Count, "Unexpected number of rows returned");
                Assert.IsTrue(latestCollectionReturnAuditRows.All(a => a.CollectionReturnPeriod == 201808), "Unexpected CollectionReturnPeriod returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliverablePeriodActualAuditRepository_GetLatestCollectionReturn_WhenActualsAndTerminationDatePresentForAllocation_ShouldReturnLatestCollectionReturnRecordUpToTerminationPeriod()
        {
            const string contractNumber = "CONT-1234";
            const string allocationNumber = "ALLOC-1234";
            DateTime terminationDate = new DateTime(2018, 02, 15, 0, 0, 0, DateTimeKind.Utc);

            // arrange
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriodActualAudits.RemoveWhere(a => a.ContractAllocationNumber == allocationNumber);
                context.AllocationsUnderTermination.RemoveWhere(a => a.ContractAllocationNumber == allocationNumber);

                context.AllocationDeliverablePeriodActualAudits.AddRange(new[]
                {
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201803",
                        CollectionReturnPeriod = 201808,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R13"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201802",
                        CollectionReturnPeriod = 201808,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R13"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201801",
                        CollectionReturnPeriod = 201808,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R13"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201803",
                        CollectionReturnPeriod = 201807,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R12"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201802",
                        CollectionReturnPeriod = 201807,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R12"
                    },
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliverableCode = 1,
                        Period = "201801",
                        CollectionReturnPeriod = 201807,
                        OrganisationId = "ORG12345",
                        FundingStreamPeriodCode = "FSP-1",
                        UopCode = string.Empty,
                        CollectionReturnCode = "R12"
                    }
                });
                context.AllocationsUnderTermination.Add(new AllocationUnderTermination(contractNumber, allocationNumber, terminationDate));

                context.SaveChanges();
            }

            // act
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                AllocationDeliverablePeriodActualAuditRepository repository = new AllocationDeliverablePeriodActualAuditRepository();

                IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> latestCollectionReturnAuditRows =
                    repository.GetLatestCollectionReturn(allocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsFalse(latestCollectionReturnAuditRows.Any(a => a.Period == "201803"), "Actuals were returned for periods after the termination date period");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliverablePeriodActualAuditRepository_GetLatestCollectionReturn_WhenActualsNotPresentForAllocation_ShouldReturnEmptyEnumerable()
        {
            const string allocationNumber = "NOACTUALS-1234";

            // arrange
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriodActualAudits.RemoveWhere(a => a.ContractAllocationNumber == allocationNumber);
                context.AllocationsUnderTermination.RemoveWhere(a => a.ContractAllocationNumber == allocationNumber);

                context.SaveChanges();
            }

            // act
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                AllocationDeliverablePeriodActualAuditRepository repository = new AllocationDeliverablePeriodActualAuditRepository();

                IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> latestCollectionReturnAuditRows =
                    repository.GetLatestCollectionReturn(allocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsNotNull(latestCollectionReturnAuditRows, "Unexpected null result returned");
                Assert.AreEqual(0, latestCollectionReturnAuditRows.Count, "Unexpected number of rows returned");
            }
        }
    }
}
