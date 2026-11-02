using System;
using System.Fakes;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Fakes;

namespace Xrm.Framework.Test.Unit.Fakes
{
    /// <summary>
    ///     Base Class for all Dynamics CRM Plugin Unit Tests using Fakes
    /// </summary>
    public abstract class PluginUnitTest : Unit.PluginUnitTest
    {
        #region Constructors

        public PluginUnitTest()
        {
            Init();
        }

        #endregion

        #region Helper Methods

        protected override void SetPluginEvent(string primaryEntityName, string messageName,
            SdkMessageProcessingStepImage stage)
        {
            PluginExecutionContextStub.PrimaryEntityNameGet = () => { return primaryEntityName; };
            PluginExecutionContextStub.MessageNameGet = () => { return messageName; };
            PluginExecutionContextStub.StageGet = () => { return (int) stage; };
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
        private ParameterCollection inputParameters = new ParameterCollection();
        private ParameterCollection outputParameters = new ParameterCollection();

        #endregion

        #region Properties

        protected StubITracingService TracingServiceStub { get; set; }

        protected StubIOrganizationServiceFactory OrganizationServiceFactoryStub { get; set; }

        /// <summary>
        ///     Organisation Service using system account
        /// </summary>
        protected StubIOrganizationService SystemOrganizationServiceStub { get; set; }

        protected StubIOrganizationService OrganizationServiceStub { get; set; }

        protected StubIServiceProvider ServiceProviderStub { get; set; }

        protected StubIPluginExecutionContext PluginExecutionContextStub { get; set; }

        #endregion

        #region Setup Stubs

        protected void Init()
        {
            PluginExecutionContextStub = new StubIPluginExecutionContext();
            TracingServiceStub = new StubITracingService();
            OrganizationServiceFactoryStub = new StubIOrganizationServiceFactory();
            SystemOrganizationServiceStub = new StubIOrganizationService();
            OrganizationServiceStub = new StubIOrganizationService();

            InitPluginExecutionContextMock(PluginExecutionContextStub);

            OrganizationServiceStub.CreateEntity = entity => { return Guid.NewGuid(); };

            SystemOrganizationServiceStub.CreateEntity = entity => { return Guid.NewGuid(); };

            OrganizationServiceFactoryStub.CreateOrganizationServiceNullableOfGuid = id =>
            {
                if (id == PluginExecutionContextStub.UserIdGet())
                {
                    return OrganizationServiceStub;
                }
                if (id == null)
                    return SystemOrganizationServiceStub;
                return new StubIOrganizationService();
            };

            ServiceProviderStub.GetServiceType = type =>
            {
                if (type == typeof (ITracingService))
                    return TracingServiceStub;
                if (type == typeof (IOrganizationServiceFactory))
                    return OrganizationServiceFactoryStub;
                if (type == typeof (IPluginExecutionContext))
                    return PluginExecutionContextStub;
                return null;
            };
        }

        protected void InitPluginExecutionContextMock(StubIPluginExecutionContext stubIPluginExecutionContext)
        {
            stubIPluginExecutionContext.BusinessUnitIdGet = () => { return _stubBusinessUnitId; };
            stubIPluginExecutionContext.CorrelationIdGet = () => { return _stubCorrelationId; };
            stubIPluginExecutionContext.DepthGet = () => { return 0; };
            stubIPluginExecutionContext.InitiatingUserIdGet = () => { return _stubInitiatingUserId; };
            stubIPluginExecutionContext.InputParametersGet = () =>
            {
                if (inputParameters == null)
                    inputParameters = new ParameterCollection();

                return inputParameters;
            };
            stubIPluginExecutionContext.OutputParametersGet = () =>
            {
                if (outputParameters == null)
                    outputParameters = new ParameterCollection();

                return outputParameters;
            };
            stubIPluginExecutionContext.IsExecutingOfflineGet = () => { return false; };
            stubIPluginExecutionContext.IsInTransactionGet = () => { return false; };
            stubIPluginExecutionContext.IsOfflinePlaybackGet = () => { return false; };
            stubIPluginExecutionContext.IsolationModeGet = () => { return (int) PluginAssembyIsolationMode.Sandbox; };
            stubIPluginExecutionContext.MessageNameGet = () => { return string.Empty; };
            stubIPluginExecutionContext.ModeGet = () => { return (int) PluginMode.Synchronous; };
            stubIPluginExecutionContext.OperationCreatedOnGet = () => { return _stubOperationCreatedOn; };
            stubIPluginExecutionContext.OperationIdGet = () => { return _stubOperationId; };
            stubIPluginExecutionContext.OrganizationIdGet = () => { return _stubOrganizationId; };
            stubIPluginExecutionContext.OrganizationNameGet = () => { return string.Empty; };
            stubIPluginExecutionContext.OwningExtensionGet = () => { return new EntityReference(); };
            stubIPluginExecutionContext.PostEntityImagesGet = () => { return new EntityImageCollection(); };
            stubIPluginExecutionContext.PreEntityImagesGet = () => { return new EntityImageCollection(); };
            stubIPluginExecutionContext.PrimaryEntityIdGet = () => { return Guid.NewGuid(); };
            stubIPluginExecutionContext.PrimaryEntityNameGet = () => { return string.Empty; };
            stubIPluginExecutionContext.RequestIdGet = () => { return _stubRequestId; };
            stubIPluginExecutionContext.SecondaryEntityNameGet = () => { return string.Empty; };
            stubIPluginExecutionContext.SharedVariablesGet = () => { return new ParameterCollection(); };
            stubIPluginExecutionContext.UserIdGet = () => { return _stubContextUserId; };
            stubIPluginExecutionContext.StageGet = () => { return (int) SdkMessageProcessingStepImage.PreValidation; };
        }

        protected override IServiceProvider CreateServiceProvider()
        {
            if (ServiceProviderStub == null)
                ServiceProviderStub = new StubIServiceProvider();
            return ServiceProviderStub;
        }

        #endregion
    }
}