namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Common
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;

    internal class XrmWorkflowActivityHelpers
    {
        private const string Team = "team";
        private const string TeamName = "name";
        private const string Status = "statecode";
        private const string Owner = "ownerid";
        private const string Task = "task";
        private const string Regarding = "regardingobjectid";
        private readonly OrganizationServiceContext _xrmContext;
        private readonly OptionSetValue _activeValue = new OptionSetValue(0);

        internal XrmWorkflowActivityHelpers(OrganizationServiceContext serviceContext)
        {
            _xrmContext = serviceContext;
        }

        internal List<Guid> GetChildGuids(
            string childEntityName,
            string parentLookupFieldName,
            EntityReference parentEntity,
            Dictionary<string, object> filterList)
        {
            var childGuids = _xrmContext.CreateQuery(childEntityName)
                .Where(c => ((EntityReference)c[parentLookupFieldName]).Id == parentEntity.Id);
            childGuids = filterList.Aggregate(childGuids, (current, f) => current.Where(c => c[f.Key] == f.Value));

            return childGuids.Select(c => c.Id).ToList();
        }

        internal List<Entity> GetChildEntityRecords(
            string childEntityName,
            string parentLookupFieldName,
            EntityReference parentEntity,
            Dictionary<string, object> filterList)
        {
            var childGuids = _xrmContext.CreateQuery(childEntityName)
                .Where(c => ((EntityReference)c[parentLookupFieldName]).Id == parentEntity.Id);
            childGuids = filterList.Aggregate(childGuids, (current, f) => current.Where(c => c[f.Key] == f.Value));

            return childGuids.ToList();
        }

        internal List<Guid> GetFilteredChildGuids(
            string childEntityName,
            string parentLookupFieldName,
            string skipCaseloadFieldName,
            string ContractStatus,
            EntityReference parentEntity,
            Dictionary<string, object> filterList)
        {
            //where Skip Caseload Assignment Flag is not set 
            //contract status is Approved/Draft
            var childGuids = _xrmContext.CreateQuery(childEntityName).Where(c => ((EntityReference)c[parentLookupFieldName]).Id == parentEntity.Id)
                .Where(c => (bool)c[skipCaseloadFieldName] == false || c[skipCaseloadFieldName] == null)
                .Where(c => ((OptionSetValue)c[ContractStatus]).Value == 229660000 || ((OptionSetValue)c[ContractStatus]).Value == 229660001);

            childGuids = filterList.Aggregate(childGuids, (current, f) => current.Where(c => c[f.Key] == f.Value));

            return childGuids.Select(c => c.Id).ToList();
        }

        internal EntityReference GetTeamReference(string teamName)
        {
            var team = _xrmContext.CreateQuery(Team).Where(t => (string)t[TeamName] == teamName).Select(t => t.Id);
            if (team.ToList().Count() != 1)
            {
                throw new ArgumentNullException("teamName", "The required team is not present in Dynamics CRM");
            }

            return new EntityReference(Team, team.First());
        }

        internal void ReAssignTasks(EntityReference assignee, EntityReference teamRef, EntityReference parentRef)
        {
            var filterList = new Dictionary<string, object>()
            {
                { Status, _activeValue }
            };

            if (teamRef != null)
            {
                filterList.Add(Owner, teamRef);
            }

            var taskList = GetChildEntityRecords(Task, Regarding, parentRef, filterList);

            foreach (var t in taskList)
            {
                // Update Task Owner - via context.Execute()
                var reassignTaskRequest = new UpdateRequest()
                {
                    Target = t
                };
                reassignTaskRequest[Owner] = assignee;
                _xrmContext.Execute(reassignTaskRequest);
            }
        }
    }
}