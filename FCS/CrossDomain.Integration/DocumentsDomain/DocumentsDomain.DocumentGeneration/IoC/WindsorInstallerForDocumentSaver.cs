namespace SFA.FCT.DocumentsDomain.DocumentGeneration.IoC
{
    using System;
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using CrossDomain.Integration.Common.Storage;
    using DataStore;
    using DataStore.Repositories;
    using DocumentSaver;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using Integration;
    using AzureStorageWrapper = Integration.AzureStorageWrapper;

    //public class WindsorInstallerForDocumentSaver : IWindsorInstaller
    //{
    //    private readonly ILoggerFactory _loggerFactory;

    //    public WindsorInstallerForDocumentSaver(ILoggerFactory loggerFactory)
    //    {
    //        _loggerFactory = loggerFactory;
    //    }

    //    public void Install(IWindsorContainer container, IConfigurationStore store)
    //    {
    //        Type documentSaverType = typeof(DocumentSaver);

    //        string documentSaverTypeConfigSetting = ConfigurationManager.AppSettings["DocumentGeneration.DocumentSaverType"];
    //        if (!string.IsNullOrEmpty(documentSaverTypeConfigSetting))
    //        {
    //            if (documentSaverTypeConfigSetting == "AzureBlobStorage")
    //            {
    //                documentSaverType = typeof(DocumentSaverToAzureBlobStorage);
    //            }
    //        }

    //        container.Register(
    //            Component.For<IDocumentSaver>().ImplementedBy(documentSaverType).LifestyleSingleton(),
    //            Component.For<IDocumentRepository>().ImplementedBy<DocumentRepository>().LifestyleSingleton(),
    //            Component.For<IAzureStorageWrapper>().ImplementedBy<AzureStorageWrapper>().LifestyleSingleton(),
    //            Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleSingleton(),
    //            Component.For<IProcessedMessageRepository>().ImplementedBy<ProcessedMessageRepository>().LifestyleScoped(),
    //            Component.For<DocumentsDomainDbContext>().ImplementedBy<DocumentsDomainDbContext>().LifestyleScoped(),
    //            Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
    //            Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("DocumentsDomain")));
    //    }
    //}
}
