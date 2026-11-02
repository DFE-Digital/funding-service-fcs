namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.IoC;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public abstract class EndpointIntegrationTestBase
    {
        private const string OrganisationId = "TT";
        private const string FundingStreamPeriodCode = "FS";
        private readonly string _uoPCode = string.Empty;

        protected EndpointIntegrationTestBase()
        {
            SetupIoC();
        }

        protected IWindsorContainer Container { get; private set; }

        protected void AddReportedActualToStub(string collectionType, string collectionReturnCode, int rowKey)
        {
            ReportedActual reportedActual = new ReportedActual
            {
                CollectionType = collectionType,
                CollectionReturnCode = collectionReturnCode,
                OrganisationId = OrganisationId,
                FundingStreamPeriodCode = FundingStreamPeriodCode,
                UoPCode = _uoPCode,
                ActualValue = 10.01,
                ActualVolume = 11,
                DeliverableCode = rowKey.ToString()
            };
            
            IReportedActualStubRepository repository = Container.Resolve<IReportedActualStubRepository>();
            repository.AddRow(reportedActual, rowKey);
        }

        protected string GetTestReportedActualsPartitionKey(string collectionType, string collectionReturnCode)
        {
            return new ReportedActual
            {
                CollectionType = collectionType,
                CollectionReturnCode = collectionReturnCode,
                OrganisationId = OrganisationId,
                FundingStreamPeriodCode = FundingStreamPeriodCode,
                UoPCode = _uoPCode
            }.EntityPartitionKey;
        }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();

            Container = new WindsorContainer().Install(new WindsorInstaller(factory));
            Container.Register(
                Component.For<IReportedActualStubRepository>().ImplementedBy<ReportedActualStubRepository>());
        }
    }
}
