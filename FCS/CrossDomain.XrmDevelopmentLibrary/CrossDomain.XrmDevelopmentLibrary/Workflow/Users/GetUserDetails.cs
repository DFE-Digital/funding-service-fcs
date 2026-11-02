using System;
using System.Activities;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Workflow;
using Microsoft.Xrm.Sdk.Query;
using System.Linq;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Users
{
    public class GetUserDetails : CodeActivity
    {

        [Input("Check Admin")]
        [Default("False")]
        public InArgument<bool> CheckAdmin { get; set; }

        [Output("Current User")]
        [ReferenceTarget("systemuser")]
        public OutArgument<EntityReference> CurrentUser { get; set; }

        [Output("Admin User")]
        public OutArgument<string> AdminUser { get; set; }

        protected override void Execute(CodeActivityContext executionContext)
        {
            const string adminRole = "System Administrator";

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();
            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }
            IOrganizationServiceFactory serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            IWorkflowContext workflowContext = executionContext.GetExtension<IWorkflowContext>();
            CurrentUser.Set(executionContext, new EntityReference("systemuser", workflowContext.InitiatingUserId));

            if (CheckAdmin.Get(executionContext))
            {
                string adminSetting = "No";
                Guid adminRoleId = GetRoleId(service, adminRole);
                if (adminRoleId != Guid.Empty)
                {
                    adminSetting = UserHasRole(service, workflowContext.InitiatingUserId, adminRoleId);                   
                }
                AdminUser.Set(executionContext, adminSetting);
            }

        }

        private Guid GetRoleId(IOrganizationService service, string roleName)
        {
            Guid roleId= new Guid();
            QueryExpression query = new QueryExpression("role");
            query.ColumnSet = new ColumnSet("roleid");
            query.Criteria.AddCondition(new ConditionExpression("name", ConditionOperator.Equal, roleName));
            Entity role = service.RetrieveMultiple(query).Entities.FirstOrDefault();
            if (role != null)
            {
                roleId = role.GetAttributeValue<Guid>("roleid");
            }
            
            return roleId;
        }

        private string UserHasRole(IOrganizationService service, Guid userId, Guid roleId)
        {

            QueryExpression query = new QueryExpression("systemuser");
            query.ColumnSet = new ColumnSet("systemuserid");
            query.Criteria.AddCondition(new ConditionExpression("systemuserid", ConditionOperator.Equal, userId));
            LinkEntity link = query.AddLink("systemuserroles", "systemuserid", "systemuserid");
            link.LinkCriteria.AddCondition(new ConditionExpression("roleid", ConditionOperator.Equal, roleId));
            var results = service.RetrieveMultiple(query);

            if (results.Entities.Count > 0)
            {
                return "Yes";
            }
            else
            {
                return "No";
            }
        }

    }

}
