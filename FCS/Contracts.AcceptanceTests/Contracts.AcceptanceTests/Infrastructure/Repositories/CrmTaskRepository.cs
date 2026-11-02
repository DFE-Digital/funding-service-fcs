namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;
    using Services;

    public static class CrmTaskRepository
    {
        public static Guid CreateTask(string subject, string description, EntityReference regarding, string owner, string assignedTeam)
        {
            EntityReference ownerReference = new EntityReference(SystemUser.EntityLogicalName, CrmUserRepository.GetUserId(owner));
            EntityReference teamReference = CrmTeamRepository.GetTeamEntityReference(assignedTeam);

            Task task = new Task
            {
                Subject = subject,
                Description = description,
                RegardingObjectId = regarding,
                OwnerId = ownerReference,
                sfa_AssignedTeam = teamReference
            };

            return CrmConnectionFactory.GetConnection().Create(task);
        }

        public static void UpdateTaskToCompleteForUser(Guid taskId, string userName)
        {
            const int stateCodeCompleted = 1;
            const int statusCodeCompleted = 5;

            Task task = new Task
            {
                Id = taskId,
                ["statuscode"] = new OptionSetValue(statusCodeCompleted),
                ["statecode"] = new OptionSetValue(stateCodeCompleted)
            };

            CrmConnectionFactory.GetConnectionForSpecificUser(userName).Update(task);
        }

        public static string GetTaskName(Guid taskId)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {    
                return context.TaskSet.Single(t => t.Id == taskId).Subject;
            }
        }
    }
}
