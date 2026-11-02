namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{
    using System;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using CrossDomain.Integration.Common.Storage;
    using DocumentGeneration.ContractDocumentMerger;
    using DocumentGeneration.DocumentDefiner;
    using DocumentGeneration.DocumentLocationResolver;
    using Framework.Logging.Interfaces;

    public class WindsorInstallerForDocumentMerge : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstallerForDocumentMerge(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            Type documentDefiner = typeof(DocumentDefiner);
            Type documentLocationResolver = typeof(DocumentLocationResolver);
            Type contractDocumentMergerType = typeof(ContractDocumentManager);

            container.Register(
                Component.For<IDocumentDefiner>().ImplementedBy(documentDefiner).LifestyleScoped(),
                Component.For<IDocumentLocationResolver>().ImplementedBy(documentLocationResolver).LifestyleScoped(),
                Component.For<IContractDocumentManager>().ImplementedBy(contractDocumentMergerType).LifestyleScoped(),
                Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleScoped(),
                Component.For<IDocumentPartFinder>().ImplementedBy<DocumentPartFinder>().LifestyleScoped(),
                Component.For<IPdfMerger>().ImplementedBy<PdfMerger>().LifestyleScoped(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("DocumentsDomain")));
        }
    }
}
