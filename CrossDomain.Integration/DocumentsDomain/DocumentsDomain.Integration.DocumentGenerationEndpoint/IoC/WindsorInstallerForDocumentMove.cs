namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{
    using System.Diagnostics.CodeAnalysis;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore;
    using DocumentGeneration;
    using DocumentGeneration.DocumentDefiner;
    using DocumentGeneration.DocumentLocationResolver;
    using Framework.Logging.Interfaces;

    [ExcludeFromCodeCoverage]
    public class WindsorInstallerForDocumentMove : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstallerForDocumentMove(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger(Constants.DocumentsDomain)));
            container.Register(Component.For<IDocumentMover>().ImplementedBy<DocumentGeneration.DocumentMover.DocumentMover>().LifestyleScoped());
            container.Register(Component.For<IDocumentLocationResolver>().ImplementedBy<DocumentLocationResolver>().LifestyleScoped());
            container.Register(Component.For<IDocumentDefiner>().ImplementedBy<DocumentDefiner>().LifestyleScoped());
            container.Register(
                Component.For<IDocumentPartFinder>().ImplementedBy<DocumentPartFinder>().LifestyleScoped());
            container.Register(Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleScoped());
            container.Register(Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped());
            container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped());
        }
    }
}
