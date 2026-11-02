namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Services;

    public class CrmReplicatedDuplicateContractRepository : CrmReplicaDbContext
    {       
        private const int BaseTableVersionNumber = 2000;
        private const int DeleteLogTableVersionNumber = 3000;
        
        public static bool DuplicateContractExists(string contractNumber, int version, int subVersion)
        {
            return ExecuteScalarSql<int>("dbo.sp_DuplicateContractExists @contractNumber,@version,@subVersion", new { contractNumber, version, subVersion }) == 1;
        }
        public static bool NoDuplicateContractExists()
        {
            return ExecuteScalarSql<int>("dbo.sp_NoDuplicateContractExists", new { }) == 0;
        }
        public static void ClearDownSyncFailureContract(string contractNumber, int version, int subVersion)
        {
            if (ContractExists(contractNumber, version, subVersion))
            {
                ExecuteScalarSql<int>("dbo.sp_ClearDownSyncFailureContract @contractNumber,@version,@subVersion", new { contractNumber, version, subVersion });
            }
        }
        public static void SetupSyncFailureForContractAndChildren(string contractNumber, int version, int subVersion)
        {
            var contractId = Guid.NewGuid();
            var allocationId = Guid.NewGuid();
            var deliverableId = Guid.NewGuid();

            CreateSyncFailureContract(contractNumber, version, subVersion, contractId);

            CreateSyncFailureAllocation(contractId, allocationId);

            CreateSyncFailureDeliverable(allocationId, deliverableId);

            Enumerable.Range(0, 12).ToList().ForEach(i =>
            {
                CreateSyncFailureDeliverablePeriod(deliverableId);
            });
        }

        private static void CreateSyncFailureContract(string contractNumber, int version, int subVersion, Guid contractId)
        {
            if (ContractExists(contractNumber, version, subVersion))
            {
                Assert.Fail("Cannot setup contract for 'Deletion Synchronization Failure'. The contract already exists");
            }
            else
            {
                ExecuteScalarSql<int>("dbo.sp_CreateSyncFailureContract @contractId,@contractNumber,@version,@subVersion,@baseTableVersionNumber,@deleteLogTableVersionNumber", new { contractId, contractNumber, version, subVersion, BaseTableVersionNumber, DeleteLogTableVersionNumber });
            }
        }
        private static void CreateSyncFailureAllocation(Guid contractId, Guid allocationId)
        {
            ExecuteScalarSql<int>("dbo.sp_CreateSyncFailureAllocation @allocationId,@contractId,@baseTableVersionNumber,@deleteLogTableVersionNumber", new { allocationId, contractId, BaseTableVersionNumber, DeleteLogTableVersionNumber });
        }

        private static void CreateSyncFailureDeliverable(Guid allocationId, Guid deliverableId)
        {
            ExecuteScalarSql<int>("dbo.sp_CreateSyncFailureDeliverable @allocationId,@deliverableId,@baseTableVersionNumber,@deleteLogTableVersionNumber", new { allocationId, deliverableId, BaseTableVersionNumber, DeleteLogTableVersionNumber });
        }
        private static void CreateSyncFailureDeliverablePeriod(Guid deliverableId)
        {
            var deliverablePeriodId = Guid.NewGuid();
            ExecuteScalarSql<int>("dbo.sp_CreateSyncFailureDeliverablePeriod @deliverablePeriodId,@deliverableId,@baseTableVersionNumber,@deleteLogTableVersionNumber", new { deliverablePeriodId, deliverableId, BaseTableVersionNumber, DeleteLogTableVersionNumber });
        }
        private static bool ContractExists(string contractNumber, int version, int subVersion)
        {
            using (var _crmReplicaDbContext = new CrmReplicaDbContext())
            {
                int result = (from cr in _crmReplicaDbContext.sfa_contract
                              where cr.sfa_number == contractNumber && cr.sfa_version == version
                              && cr.sfa_subversion == subVersion
                              select cr).Count();
                return result > 0;
            }
        }


    }
}