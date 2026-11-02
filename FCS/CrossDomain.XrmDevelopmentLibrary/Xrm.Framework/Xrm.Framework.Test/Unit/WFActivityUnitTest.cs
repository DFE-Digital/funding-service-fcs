using System.Activities;
using System.Collections.Generic;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Workflow;

namespace Xrm.Framework.Test.Unit
{

    #region enums

    public enum WorkflowCategory
    {
        Workflow = 0,
        Dialog = 1
    }

    #endregion

    /// <summary>
    ///     Base Class for all Dynamics CRM Custom Workflow Activity Unit Tests
    /// </summary>
    public abstract class WFActivityUnitTest : XrmUnitTest
    {
        #region Constructors

        public WFActivityUnitTest()
        {
            WorkflowContext = CreateWorkflowContext();
            TracingService = CreateTracingService();
            OrganizationServiceFactory = CreateOrganizationServiceFactory();
        }

        #endregion

        #region Properties

        protected IWorkflowContext WorkflowContext { get; private set; }

        protected ITracingService TracingService { get; private set; }

        protected IOrganizationServiceFactory OrganizationServiceFactory { get; private set; }

        protected WorkflowInvoker WFInvoker { get; private set; }

        protected Activity WFActivity { get; private set; }

        protected IDictionary<string, object> Outputs { get; set; }

        protected IDictionary<string, object> Inputs { get; set; }

        #endregion

        #region Test Methods

        protected override void Setup()
        {
            Inputs = new Dictionary<string, object>();

            WFActivity = SetupActivity();

            WFInvoker = new WorkflowInvoker(WFActivity);

            WFInvoker.Extensions.Add(TracingService);
            WFInvoker.Extensions.Add(WorkflowContext);
            WFInvoker.Extensions.Add(OrganizationServiceFactory);
        }

        protected override void Do()
        {
            if (Inputs.Count > 0)
            {
                Outputs = WFInvoker.Invoke(Inputs);
            }
            else
            {
                Outputs = WFInvoker.Invoke();
            }
        }

        #endregion

        #region Abstract Methods

        protected abstract Activity SetupActivity();
        protected abstract IWorkflowContext CreateWorkflowContext();
        protected abstract ITracingService CreateTracingService();
        protected abstract IOrganizationServiceFactory CreateOrganizationServiceFactory();

        #endregion
    }
}