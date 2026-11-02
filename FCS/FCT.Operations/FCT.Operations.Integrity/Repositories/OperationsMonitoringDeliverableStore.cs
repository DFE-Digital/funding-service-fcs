namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using Dapper;
    using Framework.Logging.Interfaces;
    using System.Data;

    public class OperationsMonitoringDeliverableStore : IMonitoringDeliverableStore
    {
        private static readonly int CommandTimeoutFiveMinutes = 60 * 5;
        private readonly ILogger _logger;

        public OperationsMonitoringDeliverableStore(ILogger logger)
        {
            _logger = logger;
        }

        public void RemoveAllocation(allocationType allocation, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public void StoreAllocation(allocationType allocation, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }
     
        public IReadOnlyCollection<AllocationDeliverablePeriod> GetActiveAllocationDeliverablePeriods(string organisationId, string fundingStreamPeriodCode,
            string uopCode, ConnectionInfo connectionInfo)
        {  
            return connectionInfo.Connection.Query<AllocationDeliverablePeriod>("sp_Operation_GetActiveAllocationDeliverablePeriods @organisationId,@fundingStreamPeriodCode,@uopCode", param: new
            {
                organisationId,
                fundingStreamPeriodCode,
                uopCode
            },
                commandTimeout: CommandTimeoutFiveMinutes).ToList();
        }
       
        public IReadOnlyCollection<AllocationDeliverablePeriod> GetActiveAllocationDeliverablePeriods(List<string> allocationNumbers, ConnectionInfo connectionInfo)
        {            
            var param = new DynamicParameters();
            param.Add("AllocationNumbers", getAllocationNumbers(allocationNumbers).AsTableValuedParameter("AllocationNumbersUDT")); 
            return connectionInfo.Connection.Query<AllocationDeliverablePeriod>("sp_Operations_GetActiveAllocationDeliverablePeriodsbyAllocation @allocationNumbers",
            param,
            commandTimeout: CommandTimeoutFiveMinutes).ToList();
        }

        private static DataTable getAllocationNumbers(IReadOnlyCollection<string> allocationNumbers)
        {
            var allocationDT = new DataTable();
            allocationDT.Columns.Add("AllocationNumbers");
            foreach (var allocationNumber in allocationNumbers)
            {
                allocationDT.Rows.Add(allocationNumber);
            }
            return allocationDT;
        }

        public void StoreActualsAudit(IEnumerable<AllocationDeliverablePeriodActualAudit> actuals, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public IReadOnlyCollection<CurrentViewActual> GetCurrentViewActualsForAllocations(IEnumerable<string> contractAllocationNumbers,
            ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public void StoreESFAllocation(contractAllocationsContractAllocation allocation, string contractNumber,
            ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public EsfAllocationData FindEsfAllocation(string allocationNumber, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public IReadOnlyCollection<EsfAllocationData> GetEsfAllocationData(List<string> allocationNumbers, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public IReadOnlyCollection<AllocationDeliverablePeriod> GetAllocationDeliverablePeriodsForAllocationAndPeriodList(string contractAllocationNumber,
            IEnumerable<string> periods, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public IReadOnlyCollection<AllocationDeliverablePeriod> GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(string contractAllocationNumber,
            string currentPeriod, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public void InsertCurrentViewActuals(IEnumerable<CurrentViewActual> currentViewActuals, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public bool DoesFspDeliverableExist(string fundingStreamPeriodCode, int deliverableCode, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public void AddAllocationDeliverablePeriods(IReadOnlyCollection<AllocationDeliverablePeriod> allocationDeliverablePeriods, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }

        public void Update(IEnumerable<CurrentViewActual> currentViewActuals, ConnectionInfo connectionInfo)
        {
            throw new System.NotImplementedException();
        }
    }
}
