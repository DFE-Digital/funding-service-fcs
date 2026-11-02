namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Services;

    public static class CrmWorkflowRepository
    {
        public static Guid GetWorkFlowId(string workflowName)
        {
            QueryExpression objQueryExpression = new QueryExpression("workflow")
            {
                ColumnSet = new ColumnSet(allColumns: true)
            };

            objQueryExpression.Criteria.AddCondition(new ConditionExpression("name", ConditionOperator.Equal, workflowName));
            objQueryExpression.Criteria.AddCondition(new ConditionExpression("parentworkflowid", ConditionOperator.Null));
            EntityCollection workflowCollection = CrmConnectionFactory.GetConnection().RetrieveMultiple(objQueryExpression);

            return workflowCollection.Entities.Single().Id;
        }

        public static Guid GetWorkFlowIdFromBeginsWith(string workflowNameBeginsWith)
        {
            QueryExpression objQueryExpression = new QueryExpression("workflow")
            {
                ColumnSet = new ColumnSet(allColumns: true)
            };

            objQueryExpression.Criteria.AddCondition(new ConditionExpression("name", ConditionOperator.BeginsWith, workflowNameBeginsWith));
            objQueryExpression.Criteria.AddCondition(new ConditionExpression("parentworkflowid", ConditionOperator.Null));
            EntityCollection workflowCollection = CrmConnectionFactory.GetConnection().RetrieveMultiple(objQueryExpression);

            return workflowCollection.Entities.Single().Id;
        }

        public static void ExecuteWorkFlow(Guid workflowId, Guid entityId, string userName)
        {
            CrmConnectionFactory.GetConnectionForSpecificUser(userName).Execute(new ExecuteWorkflowRequest
            {
                WorkflowId = workflowId,
                EntityId = entityId
            });
        }
    }
}
