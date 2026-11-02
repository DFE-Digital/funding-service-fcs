using System;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Workflow;
using Moq;

namespace Xrm.Framework.Test.Unit.Moq
{
    /// <summary>
    ///     Base Class for all Dynamics CRM 2011 Custom Workflow Activities using Moq
    /// </summary>
    public abstract class WFActivityUnitTest : Unit.WFActivityUnitTest
    {
        #region Constructors

        public WFActivityUnitTest()
        {
            Init();
        }

        #endregion

        #region Properties

        protected Mock<IWorkflowContext> WorkflowContextMock { get; set; }

        protected Mock<IOrganizationService> SystemOrganizationServiceMock { get; set; }

        protected Mock<IOrganizationService> OrganizationServiceMock { get; set; }

        protected Mock<IOrganizationServiceFactory> OrganizationServiceFactoryMock { get; set; }

        protected Mock<ITracingService> TracingServiceMock { get; set; }

        #endregion

        #region Setup Stubs

        protected void Init()
        {
            SystemOrganizationServiceMock = new Mock<IOrganizationService>();
            OrganizationServiceMock = new Mock<IOrganizationService>();

            InitWorkflowContextMock(WorkflowContextMock);

            OrganizationServiceFactoryMock.Setup(factory => factory.CreateOrganizationService(WorkflowContext.UserId))
                .Returns(OrganizationServiceMock.Object);
            OrganizationServiceFactoryMock.Setup(factory => factory.CreateOrganizationService(null))
                .Returns(SystemOrganizationServiceMock.Object);

            CommonMoqHelper.InitOrganizationServiceMock(OrganizationServiceMock);
            CommonMoqHelper.InitOrganizationServiceMock(SystemOrganizationServiceMock);
        }

        private void InitOrganizationServiceMock(Mock<IOrganizationService> mock)
        {
            mock.Setup(
                service =>
                    service.Associate(It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<Relationship>(),
                        It.IsAny<EntityReferenceCollection>()));
            mock.Setup(
                service =>
                    service.Disassociate(It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<Relationship>(),
                        It.IsAny<EntityReferenceCollection>()));
            mock.Setup(service => service.Create(It.IsAny<Entity>())).Returns(() => Guid.NewGuid());
            mock.Setup(service => service.Update(It.IsAny<Entity>()));
            mock.Setup(service => service.Delete(It.IsAny<string>(), It.IsAny<Guid>()));
        }

        private void InitWorkflowContextMock(Mock<IWorkflowContext> mock)
        {
            mock.Setup(context => context.BusinessUnitId).Returns(Guid.NewGuid());
            mock.Setup(context => context.CorrelationId).Returns(Guid.NewGuid());
            mock.Setup(context => context.Depth).Returns(0);
            mock.Setup(context => context.InitiatingUserId).Returns(Guid.NewGuid());
            mock.Setup(context => context.InputParameters).Returns(new ParameterCollection());
            mock.Setup(context => context.IsExecutingOffline).Returns(false);
            mock.Setup(context => context.IsInTransaction).Returns(false);
            mock.Setup(context => context.IsOfflinePlayback).Returns(false);
            mock.Setup(context => context.MessageName).Returns(string.Empty);
            mock.Setup(context => context.OperationCreatedOn).Returns(DateTime.Now);
            mock.Setup(context => context.OperationId).Returns(Guid.NewGuid());
            mock.Setup(context => context.OrganizationId).Returns(Guid.NewGuid());
            mock.Setup(context => context.OrganizationName).Returns(string.Empty);
            mock.Setup(context => context.OutputParameters).Returns(new ParameterCollection());
            mock.Setup(context => context.OwningExtension).Returns(new EntityReference());
            mock.Setup(context => context.PostEntityImages).Returns(new EntityImageCollection());
            mock.Setup(context => context.PreEntityImages).Returns(new EntityImageCollection());
            mock.Setup(context => context.PrimaryEntityId).Returns(Guid.NewGuid());
            mock.Setup(context => context.PrimaryEntityName).Returns(string.Empty);
            mock.Setup(context => context.RequestId).Returns(Guid.NewGuid());
            mock.Setup(context => context.SecondaryEntityName).Returns(string.Empty);
            mock.Setup(context => context.SharedVariables).Returns(new ParameterCollection());
            mock.Setup(context => context.UserId).Returns(Guid.NewGuid());
            mock.Setup(context => context.StageName).Returns(string.Empty);
            mock.Setup(context => context.WorkflowCategory).Returns((int) WorkflowCategory.Workflow);
        }

        protected override IWorkflowContext CreateWorkflowContext()
        {
            if (WorkflowContextMock == null)
                WorkflowContextMock = new Mock<IWorkflowContext>();
            return WorkflowContextMock.Object;
        }

        protected override ITracingService CreateTracingService()
        {
            if (TracingServiceMock == null)
                TracingServiceMock = new Mock<ITracingService>();
            return TracingServiceMock.Object;
        }

        protected override IOrganizationServiceFactory CreateOrganizationServiceFactory()
        {
            if (OrganizationServiceFactoryMock == null)
                OrganizationServiceFactoryMock = new Mock<IOrganizationServiceFactory>();
            return OrganizationServiceFactoryMock.Object;
        }

        #endregion
    }
}