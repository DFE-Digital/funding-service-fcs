namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;   
    using Extensions;

    public class CrmReplicatedRepository : CrmReplicaDbContext
    {       
        public static bool ContractExists(string contractNumber, int version)
        {        

            return ExecuteScalarSql<int>("dbo.sp_ContractExists @contractNumber,@version", new { contractNumber, version }) > 0;
        }

        public static void DeleteContract(Guid contractId)
        {
            ExecuteSql("dbo.sp_DeleteContract @contractId", new { contractId });
        }

        public static void DeleteFundingAllocationsForUkprn(int ukprn)
        {
            using (var _crmReplicaDbContext = new CrmReplicaDbContext())
            {
                string varUkprn = ukprn.ToString();
                _crmReplicaDbContext.sfa_fundingallocation.RemoveWhere(res => res.sfa_ukprn == varUkprn);
                _crmReplicaDbContext.SaveChanges();
            }
        }

        public static void DeleteFundingAllocationHistories(int ukprn)
        {
            ExecuteScalarSql<int>("dbo.sp_DeleteFundingAllocationHist @ukprn", new { ukprn });
        }

        public static void DeleteNotificationsForNotificationId(Guid notificationId)
        {
            ExecuteScalarSql<int>("dbo.sp_DeleteNotificationsForNotificationId @notificationId", new { notificationId });
        }

        public static void DeleteDeliverableForAllVersionsOfAllocation(string allocationNumber, int deliverableCode)
        {
            ExecuteScalarSql<int>("dbo.sp_DeleteDeliverableAllocation @allocationNumber,@deliverableCode", new { allocationNumber, deliverableCode });
        }

        public static void DeleteFundingClaimReconciliationsForUkprn(string ukprn)
        {
            using (var _crmReplicaDbContext = new CrmReplicaDbContext())
            {
                _crmReplicaDbContext.sfa_fundingclaimreconciliation.RemoveWhere(fcr =>
            fcr.sfa_ukprn == ukprn);
                _crmReplicaDbContext.SaveChanges();
            }
        }

        public static void DeleteMatchingWorkflowHistories(Guid contracttransitionhistoryId)
        {
            using (var _crmReplicaDbContext = new CrmReplicaDbContext())
            {
                _crmReplicaDbContext.sfa_contracttransitionhistory.RemoveWhere(ct =>
                 ct.Id == contracttransitionhistoryId);
                _crmReplicaDbContext.SaveChanges();
            }
        }

        public static void DeleteSubnominals(string allocationRef)
        {            
                ExecuteSql("dbo.sp_DeleteSubnominals @allocationRef", new { allocationRef });            
        }

        public static void DeleteSubmoninalsForCode(string subnominalCode)
        {
            using (var _crmReplicaDbContext = new CrmReplicaDbContext())
            {
                _crmReplicaDbContext.sfa_subnominalaggregation.RemoveWhere(sa =>
                sa.sfa_subnominalcode == subnominalCode);
                _crmReplicaDbContext.SaveChanges();
            }
        }

        public static void DeleteReleaseGroupAndFundingAllocationsByBusinessKey(string fundingTypeCode, string fundingPeriod, string fspGroupCode, string contractType)
        {
            List<Guid> releasegroupIds = GetReleaseGrouptIds(fundingTypeCode, fundingPeriod, fspGroupCode, contractType);

            if (releasegroupIds != null)
            {
                using (var _crmReplicaDbContext = new CrmReplicaDbContext())
                {
                    foreach (var item in releasegroupIds)
                        _crmReplicaDbContext.sfa_fundingallocation.RemoveWhere(sa =>
                        sa.sfa_releasegroup == item);
                    _crmReplicaDbContext.SaveChanges();

                    foreach (var item in releasegroupIds)
                        _crmReplicaDbContext.sfa_releasegroup.RemoveWhere(rg =>
                        rg.sfa_releasegroupid == item);
                    _crmReplicaDbContext.SaveChanges();
                }
            }


        }
        private static List<Guid> GetReleaseGrouptIds(string fundingTypeCode, string fundingPeriod, string fspGroupCode, string contractType)
        {
            return ExecuteScalarSql<List<Guid>>("sp_GetReleaseGrouptIds @fundingTypeCode,@fundingPeriod,@fspGroupCode,@contractType", new { fundingTypeCode, fundingPeriod, fspGroupCode, contractType });
        }

        public static void DeleteNotificationsByTypeForUkprn(string notificationType, string ukprn)
        {
            sfa_notificationtype notificationTypeEnum = ParseNotificationType(notificationType);
            int notificationTypeInt = (int)notificationTypeEnum;
            ExecuteScalarSql<int>("dbo.sp_DeleteNotifyByTypeForUkprn @notificationTypeInt,@ukprn", new { notificationTypeInt, ukprn });
        }
        public static sfa_notificationtype ParseNotificationType(string notificationType)
        {
            string noSpaceNotificationType = notificationType.Replace(" ", string.Empty).Replace("-", string.Empty);

            return (sfa_notificationtype)Enum.Parse(typeof(sfa_notificationtype), noSpaceNotificationType);
        }
        public static void DeleteCaseloadForUkrpn(string ukprn)
        {
            using (var _crmReplicaDbContext = new CrmReplicaDbContext())
            {
                _crmReplicaDbContext.sfa_caseload.RemoveWhere(cl =>
            cl.sfa_ukprn == ukprn);
                _crmReplicaDbContext.SaveChanges();
            }
        }

        public static void ClearNotificationsForType(string notificationType)
        {
            sfa_notificationtype enumValueNotificationType = (sfa_notificationtype)Enum.Parse(typeof(sfa_notificationtype),
                notificationType.Replace(" ", string.Empty).Replace("-", string.Empty), ignoreCase: true);

            int notificationTypeValue = (int)enumValueNotificationType;

            ExecuteScalarSql<int>("dbo.sp_ClearNotificationsForType @notificationTypeValue", new { notificationTypeValue });
        }


    }
}