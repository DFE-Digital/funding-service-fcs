using System;
using Microsoft.Crm.Sdk.Messages;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;

namespace Xrm.Framework.Test.Integration
{
    /// <summary>
    ///     Base Class for all Dynamics CRM Workflow Activities Integration Tests
    /// </summary>
    public abstract class WFActivityIntegrationTest : AsyncIntegrationTest
    {
        #region Abstract Methods

        protected abstract Guid SetupPrimaryEntity();

        #endregion

        #region Instance Variables

        private Guid workflowId;
        private Guid entityId;

        #endregion

        #region Properties

        protected override string AsyncOperationName
        {
            get { return GetType().Name; }
        }

        protected override int AsyncOperationType
        {
            get { return 10; }
        }

        #endregion

        #region Constructors

        public WFActivityIntegrationTest()
        {
        }

        public WFActivityIntegrationTest(IOrganizationService service)
            : base(service)
        {
        }

        #endregion

        #region Test Methods

        protected override void Setup()
        {
            entityId = SetupPrimaryEntity();
            if (entityId == null || entityId == Guid.Empty)
                throw new ArgumentNullException("Entity ID", "Record ID (GUID) cannot be null or Empty");

            var query = new QueryByAttribute("workflow");
            query.ColumnSet = new ColumnSet("workflowid", "type", "ondemand", "statecode");
            query.Attributes.AddRange("name", "type");
            query.Values.AddRange(AsyncOperationName, (int) ProcessType.Defition);

            var ec = OrganizationService.RetrieveMultiple(query);

            if (ec.Entities.Count == 0)
                throw new Exception(string.Format("A workflow with name '{0}' couldn't be found", AsyncOperationName));
            if (ec.Entities.Count > 1)
                throw new Exception(string.Format("Two or more workflows with name '{0}' were found", AsyncOperationName));
            var processRecord = ec[0];
            if (!processRecord.Contains("ondemand") || ((Boolean) processRecord["ondemand"]) != true)
                throw new Exception("Process must be configured to run On Demand");

            if (!processRecord.Contains("statecode") ||
                (((OptionSetValue) processRecord["statecode"]).Value) != (int) ProcessStatus.Activated)
                throw new Exception("Process must be activated");

            workflowId = processRecord.Id;
            base.Setup();
        }

        protected override OrganizationRequest SetupTriggerRequest()
        {
            return new ExecuteWorkflowRequest
            {
                EntityId = entityId,
                WorkflowId = workflowId
            };
        }

        #endregion
    }
}