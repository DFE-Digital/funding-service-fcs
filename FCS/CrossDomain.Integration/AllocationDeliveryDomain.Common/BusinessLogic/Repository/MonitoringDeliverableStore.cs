namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using DataStore;
    using DataStore.Model;
    using Framework.Logging.Interfaces;
    using MoreLinq;

    public class MonitoringDeliverableStore : IMonitoringDeliverableStore
    {
        public MonitoringDeliverableStore(ILogger logger)
        {
            Logger = logger;
        }

        public ILogger Logger { get; set; }

        public void RemoveAllocation(allocationType allocation, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                string allocationNumber = allocation.contractAllocationNumber;
                int deletedRecords =
                    context.Database.ExecuteSqlCommand(
                        "EXEC MonitoringDeliverables.DeleteAllDeliverablePeriodsForAllocation @p0",
                        allocationNumber);

                Logger.LogInformation(
                    AllocationDeliverDomainEventLoggingId.DeletingAllocationDeliverables,
                    "Deleted {0} deliverable periods for allocation with Allocation Reference: {1}",
                    deletedRecords,
                    allocationNumber);
            }
        }

        public void StoreAllocation(allocationType allocation, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                string uopCode = allocation.uopCode ?? string.Empty;
                string theUkPrn = allocation.contractorReference
                    .alternativeOrganisationIdentifiers.Single(
                        x => x.OrganisationIdentifierName == alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER)
                    .OrganisationIdentifier;

                var flattenedDeliverables = allocation.FlattenDeliverables(allocation.contractDeliverables);

                context.AllocationDeliverablePeriods.AddRange(flattenedDeliverables.SelectMany(
                    d => d.contractDeliverablePeriods,
                    (d, dp) => new AllocationDeliverablePeriod
                    {
                        OrganisationId = allocation.contractorReference.organisationIdentifier,
                        FundingStreamPeriodCode = allocation.fundingStreamPeriod.fundingStreamPeriodCode,
                        UopCode = uopCode,
                        DeliverableCode = d.deliverable.deliverableCode,
                        Period = dp.period.periodValue,
                        ContractAllocationNumber = allocation.contractAllocationNumber,
                        ContractNumber = allocation.contractReference.contractNumber,
                        ContractVersionNumber = allocation.contractReference.contractVersionNumber,
                        ContractSubVersionNumber = allocation.contractReference.contractSubVersionNumber,
                        AllocationStartDate = allocation.startDate,
                        AllocationEndDate = allocation.endDate,
                        Ukprn = theUkPrn
                    }));

                context.SaveChanges();

                Logger.LogInformation(
                    AllocationDeliverDomainEventLoggingId.InsertingAllocationDeliverables,
                    "Inserted {0} deliverable periods for allocation with OrganisationId: {1}, FundingStreamPeriodCode: {2}, UopCode: {3}",
                    flattenedDeliverables.Count,
                    allocation.contractorReference.organisationIdentifier,
                    allocation.fundingStreamPeriod.fundingStreamPeriodCode,
                    uopCode);
            }
        }

        public IReadOnlyCollection<AllocationDeliverablePeriod> GetActiveAllocationDeliverablePeriods(
            string organisationId, 
            string fundingStreamPeriodCode, 
            string uopCode,
            ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                uopCode = uopCode ?? string.Empty;

                return context.ActiveAllocationDeliverablePeriods.Where(
                    x => x.OrganisationId == organisationId
                         && x.FundingStreamPeriodCode == fundingStreamPeriodCode
                         && x.UopCode == uopCode).ToList();
            }
        }

        public IReadOnlyCollection<AllocationDeliverablePeriod> GetActiveAllocationDeliverablePeriods(List<string> allocationNumbers, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return context.ActiveAllocationDeliverablePeriods.Where(
                    x => allocationNumbers.Contains(x.ContractAllocationNumber)).ToList();
            }
        }

        public IReadOnlyCollection<CurrentViewActual> GetCurrentViewActualsForAllocations(IEnumerable<string> contractAllocationNumbers, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return context.CurrentViewActuals.Where(a => contractAllocationNumbers.Contains(a.ContractAllocationNumber)).ToList();
            }
        }

        public void StoreActualsAudit(IEnumerable<AllocationDeliverablePeriodActualAudit> actuals, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                context.AllocationDeliverablePeriodActualAudits.AddRange(actuals);
                context.SaveChanges();
            }
        }

        public void InsertCurrentViewActuals(IEnumerable<CurrentViewActual> currentViewActuals, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                context.CurrentViewActuals.AddRange(currentViewActuals);
                context.SaveChanges();
            }
        }

        public void StoreESFAllocation(contractAllocationsContractAllocation allocation, string contractNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                var entity = new EsfAllocationData
                {
                    ContractNumber = contractNumber,
                    ContractAllocationNumber = allocation.contractAllocationNumber,
                    ActivityDescription = allocation.ActivityDescription,
                    InvestmentPriority = allocation.InvestmentPriority,
                    AwardReference = allocation.tenderAwardReference,
                    LEPCode = allocation.LEPCode,
                    LEPName = allocation.LEPName,
                    LotReference = allocation.lotReference,
                    AgreementNumber = allocation.AgreementNumber,
                    LearningRatePremium = allocation.LearningRatePremium,
                    RegionType = allocation.RegionType,
                    SpecificationTitle = allocation.SpecificationTitle,
                    TenderSpecReference = allocation.tenderSpecificationReference
                };

                context.ESFAllocationData.AddOrUpdate(entity);
                context.SaveChanges();
            }
        }

        public EsfAllocationData FindEsfAllocation(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return context.ESFAllocationData
                    .FirstOrDefault(x => x.ContractAllocationNumber == allocationNumber);
            }

        }

        public IReadOnlyCollection<EsfAllocationData> GetEsfAllocationData(List<string> allocationNumbers, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return context.ESFAllocationData.Where(
                   x => allocationNumbers.Contains(x.ContractAllocationNumber)).ToList();
            }
        }

        public IReadOnlyCollection<AllocationDeliverablePeriod> GetAllocationDeliverablePeriodsForAllocationAndPeriodList(string contractAllocationNumber, IEnumerable<string> periods, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return context.AllocationDeliverablePeriods.Where(
                    allocDp => allocDp.ContractAllocationNumber == contractAllocationNumber
                               && periods.Contains(allocDp.Period))
                .ToList();
            }
        }

        public IReadOnlyCollection<AllocationDeliverablePeriod> GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(
            string contractAllocationNumber,
            string currentPeriod,
            ConnectionInfo connectionInfo)
        {
            return GetActiveAllocationDeliverablePeriods(new List<string> { contractAllocationNumber }, connectionInfo)
                .Where(dp => int.Parse(dp.Period) <= int.Parse(currentPeriod))
                .ToList();
        }

        public bool DoesFspDeliverableExist(string fundingStreamPeriodCode, int deliverableCode, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return context.FundingStreamPeriodDeliverables.Any(fspd =>
                    fspd.FundingStreamPeriodCode == fundingStreamPeriodCode
                    && fspd.DeliverableCode == deliverableCode
                    && fspd.IsAllowedToBeAdded);
            }
        }

        public void AddAllocationDeliverablePeriods(IReadOnlyCollection<AllocationDeliverablePeriod> allocationDeliverablePeriods, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                context.AllocationDeliverablePeriods.AddRange(allocationDeliverablePeriods);
                context.SaveChanges();
            }
        }

        public void Update(IEnumerable<CurrentViewActual> currentViewActuals, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                currentViewActuals.ForEach(entity => context.Entry(entity).State = EntityState.Modified);
                context.SaveChanges();
            }
        }
    }
}
