namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher.IoC
{
    using System.Diagnostics.CodeAnalysis;
    using Castle.Windsor;
    using Framework.Logging.Interfaces;

    [ExcludeFromCodeCoverage]
    public static class Bootstrapper
    {
        private static IWindsorContainer _container = null;

        ////public static IWindsorContainer Container
        ////{
        ////    get
        ////    {
        ////        return CreateContainer();
        ////    }
        ////}

        public static IWindsorContainer CreateContainer(ILoggerFactory loggerFactory)
        {
            if (_container == null)
            {
                _container = new WindsorContainer().Install(new WindsorInstaller(loggerFactory));
            }

            return _container;
        }
    }
}
