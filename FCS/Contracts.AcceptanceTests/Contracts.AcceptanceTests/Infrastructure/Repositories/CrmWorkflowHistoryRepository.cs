namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using DTO;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Services;
    using sfa_contracttransitionhistory = CrossDomain.Integration.Entities.Xrm.sfa_contracttransitionhistory;

    public static class CrmWorkflowHistoryRepository
    {
        public static IReadOnlyCollection<WorkflowHistory> GetWorkflowHistoryItemsForContract(string contractNumber, int version)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from c in context.sfa_contractSet
                 join wfh in context.sfa_contracttransitionhistorySet on c.Id equals wfh.sfa_Contract.Id
                 join t in context.sfa_transitionSet on wfh.sfa_Action.Id equals t.Id
                 join u in context.SystemUserSet on wfh.sfa_Actionby.Id equals u.Id
                 where c.sfa_number == contractNumber
                 && c.sfa_Version == version
                 select new WorkflowHistory{Action = t.sfa_name, UserName = u.FullName, Comment = wfh.sfa_Comments}).ToList();
            }
        }

        public static IReadOnlyCollection<sfa_contracttransitionhistory> GetWorkflowHistory(string contractNumber, int contractVersionNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<sfa_contracttransitionhistory> query =
                    from c in context.sfa_contractSet
                    join wfh in context.sfa_contracttransitionhistorySet on c.Id equals wfh.sfa_Contract.Id
                    join t in context.sfa_transitionSet on wfh.sfa_Action.Id equals t.Id
                    join u in context.SystemUserSet on wfh.sfa_Actionby.Id equals u.Id
                    where
                        c.sfa_number == contractNumber
                        && c.sfa_Version == contractVersionNumber
                    select wfh;

                return query.ToList();
            }
        }
        
        public static void DeleteMatchingWorkflowHistories(string contractNumber, int contractVersionNumber, string action, string completedBy, string comments)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                List<Guid?> workflowHistoryIdsToDelete = (
                    from c in context.sfa_contractSet
                    join wfh in context.sfa_contracttransitionhistorySet on c.Id equals wfh.sfa_Contract.Id
                    join t in context.sfa_transitionSet on wfh.sfa_Action.Id equals t.Id
                    join u in context.SystemUserSet on wfh.sfa_Actionby.Id equals u.Id
                    where
                        c.sfa_number == contractNumber
                        && c.sfa_Version == contractVersionNumber
                        && t.sfa_name == action
                        && u.FullName == completedBy
                        && wfh.sfa_Comments == comments
                    select wfh.sfa_contracttransitionhistoryId).ToList();

                workflowHistoryIdsToDelete.ForEach(id => organizationService.Delete("sfa_contracttransitionhistory", id.Value));

                workflowHistoryIdsToDelete.ForEach(id => CrmReplicatedRepository.DeleteMatchingWorkflowHistories(id.Value));                
            }
        }
    }
}
