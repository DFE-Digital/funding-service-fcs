using System;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Fakes;
using Microsoft.Xrm.Sdk.Workflow;
using Microsoft.Xrm.Sdk.Workflow.Fakes;

namespace Xrm.Framework.Test.Unit.Fakes
{
    /// <summary>
    ///     Base Class for all Dynamics CRM 2011 Custom Workflow Activities using Fakes
    /// </summary>
    public abstract class WFActivityUnitTest : Unit.WFActivityUnitTest
    {
        #region Constructors

        public WFActivityUnitTest()
        {
            Init();
        }

        #endregion

        #region Instance Variables

        private readonly Guid _stubBusinessUnitId = Guid.NewGuid();
        private readonly Guid _stubContextUserId = Guid.NewGuid();
        private readonly Guid _stubCorrelationId = Guid.NewGuid();
        private readonly Guid _stubInitiatingUserId = Guid.NewGuid();
        private readonly DateTime _stubOperationCreatedOn = DateTime.Now;
        private readonly Guid _stubOperationId = Guid.NewGuid();
        private readonly Guid _stubOrganizationId = Guid.NewGuid();
        private Guid _stubPrimaryEntityId = Guid.NewGuid();
        private readonly Guid _stubRequestId = Guid.NewGuid();

        #endregion

        #region Properties

        protected StubIWorkflowContext WorkflowContextStub { get; set; }

        protected StubIOrganizationService SystemOrganizationServiceStub { get; set; }

        protected StubIOrganizationService OrganizationServiceStub { get; set; }

        protected StubIOrganizationServiceFactory OrganizationServiceFactoryStub { get; set; }

        protected StubITracingService TracingServiceStub { get; set; }

        #endregion

        #region Setup Stubs

        protected void Init()
        {
            SystemOrganizationServiceStub = new StubIOrganizationService();
            OrganizationServiceStub = new StubIOrganizationService();

            InitWorkflowContextMock(WorkflowContextStub);

            OrganizationServiceStub.CreateEntity = entity => { return Guid.NewGuid(); };

            SystemOrganizationServiceStub.CreateEntity = entity => { return Guid.NewGuid(); };

            OrganizationServiceFactoryStub.CreateOrganizationServiceNullableOfGuid = id =>
            {
                if (id == WorkflowContextStub.UserIdGet())
                {
                    return OrganizationServiceStub;
                }
                if (id == null)
                    return SystemOrganizationServiceStub;
                return new StubIOrganizationService();
            };
        }

        private void InitWorkflowContextMock(StubIWorkflowContext mock)
        {
            mock.BusinessUnitIdGet = () => { return _stubBusinessUnitId; };
            mock.CorrelationIdGet = () => { return _stubCorrelationId; };
            mock.DepthGet = () => { return 0; };
            mock.InitiatingUserIdGet = () => { return _stubInitiatingUserId; };
            mock.InputParametersGet = () => { return new ParameterCollection(); };
            mock.IsExecutingOfflineGet = () => { return false; };
            mock.IsInTransactionGet = () => { return false; };
            mock.IsOfflinePlaybackGet = () => { return false; };
            mock.IsolationModeGet = () => { return (int) PluginAssembyIsolationMode.Sandbox; };
            mock.MessageNameGet = () => { return string.Empty; };
            mock.ModeGet = () => { return (int) PluginMode.Synchronous; };
            mock.OperationCreatedOnGet = () => { return _stubOperationCreatedOn; };
            mock.OperationIdGet = () => { return _stubOperationId; };
            mock.OrganizationIdGet = () => { return _stubOrganizationId; };
            mock.OrganizationNameGet = () => { return string.Empty; };
            mock.OutputParametersGet = () => { return new ParameterCollection(); };
            mock.OwningExtensionGet = () => { return new EntityReference(); };
            mock.PostEntityImagesGet = () => { return new EntityImageCollection(); };
            mock.PreEntityImagesGet = () => { return new EntityImageCollection(); };
            mock.PrimaryEntityIdGet = () => { return Guid.NewGuid(); };
            mock.PrimaryEntityNameGet = () => { return string.Empty; };
            mock.RequestIdGet = () => { return _stubRequestId; };
            mock.SecondaryEntityNameGet = () => { return string.Empty; };
            mock.SharedVariablesGet = () => { return new ParameterCollection(); };
            mock.UserIdGet = () => { return _stubContextUserId; };
            mock.StageNameGet = () => { return string.Empty; };
            mock.WorkflowCategoryGet = () => { return ((int) WorkflowCategory.Workflow); };
        }

        protected override IWorkflowContext CreateWorkflowContext()
        {
            if (WorkflowContextStub == null)
                WorkflowContextStub = new StubIWorkflowContext();
            return WorkflowContextStub;
        }

        protected override ITracingService CreateTracingService()
        {
            if (TracingServiceStub == null)
                TracingServiceStub = new StubITracingService();
            return TracingServiceStub;
        }

        protected override IOrganizationServiceFactory CreateOrganizationServiceFactory()
        {
            if (OrganizationServiceFactoryStub == null)
                OrganizationServiceFactoryStub = new StubIOrganizationServiceFactory();
            return OrganizationServiceFactoryStub;
        }

        #endregion
    }
}