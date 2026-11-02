namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using DataStore.Model;

    public interface IMonitoringDeliverableStore
    {
        void RemoveAllocation(allocationType allocation, ConnectionInfo connectionInfo);

        void StoreAllocation(allocationType allocation, ConnectionInfo connectionInfo);

        IReadOnlyCollection<AllocationDeliverablePeriod> GetActiveAllocationDeliverablePeriods(
            string organisationId,
            string fundingStreamPeriodCode,
            string uopCode, 
            ConnectionInfo connectionInfo);

        IReadOnlyCollection<AllocationDeliverablePeriod> GetActiveAllocationDeliverablePeriods(List<string> allocationNumbers, ConnectionInfo connectionInfo);

        void StoreActualsAudit(IEnumerable<AllocationDeliverablePeriodActualAudit> actuals, ConnectionInfo connectionInfo);

        IReadOnlyCollection<CurrentViewActual> GetCurrentViewActualsForAllocations(IEnumerable<string> contractAllocationNumbers, ConnectionInfo connectionInfo);

        void StoreESFAllocation(contractAllocationsContractAllocation allocation, string contractNumber, ConnectionInfo connectionInfo);

        EsfAllocationData FindEsfAllocation(string allocationNumber, ConnectionInfo connectionInfo);

        IReadOnlyCollection<EsfAllocationData> GetEsfAllocationData(List<string> allocationNumbers, ConnectionInfo connectionInfo);

        IReadOnlyCollection<AllocationDeliverablePeriod> GetAllocationDeliverablePeriodsForAllocationAndPeriodList(
             string contractAllocationNumber, IEnumerable<string> periods, ConnectionInfo connectionInfo);

        IReadOnlyCollection<AllocationDeliverablePeriod> GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(
            string contractAllocationNumber,
            string currentPeriod,
            ConnectionInfo connectionInfo);

        void InsertCurrentViewActuals(IEnumerable<CurrentViewActual> currentViewActuals, ConnectionInfo connectionInfo);

        bool DoesFspDeliverableExist(string fundingStreamPeriodCode, int deliverableCode, ConnectionInfo connectionInfo);

        void AddAllocationDeliverablePeriods(IReadOnlyCollection<AllocationDeliverablePeriod> allocationDeliverablePeriods, ConnectionInfo connectionInfo);

        void Update(IEnumerable<CurrentViewActual> currentViewActuals, ConnectionInfo connectionInfo);
    }
}
