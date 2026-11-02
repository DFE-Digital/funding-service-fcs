

using System;

namespace SFA.FCT.DocumentsDomain.DocumentGeneration.IoC
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging.Interfaces;
    using DocumentLocationResolver;

    //public class WindsorInstallerForDocumentLocationResolver:IWindsorInstaller
    //{
    //    private readonly ILoggerFactory _loggerFactory;

    //    public WindsorInstallerForDocumentLocationResolver(ILoggerFactory loggerFactory)
    //    {
    //        _loggerFactory = loggerFactory;
    //    }

    //    public void Install(IWindsorContainer container, IConfigurationStore store)
    //    {
    //        Type documentLocationResolvertype = typeof (DocumentLocationResolver);
    //        container.Register(
    //            Component.For<IDocumentLocationResolver>().ImplementedBy(documentLocationResolvertype).LifestyleSingleton(),
    //            Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("DocumentsDomain")));
    //    }
    //}
}
