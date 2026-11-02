namespace FundingAllocation.Endpoints.BulkUpload
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILogger _logger;

        public WindsorInstaller(ILogger logger)
        {
            _logger = logger;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_logger),
                Component.For<IBulkUploadStatusRepository>().ImplementedBy<BulkUploadStatusRepository>().LifestyleTransient()
            );
        }
    }
}
