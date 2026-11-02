namespace CrossDomain.Integration.ReportRunnerEndpoint.Ioc
{
    using System.Diagnostics.CodeAnalysis;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging.Interfaces;

    [ExcludeFromCodeCoverage]
    public static class Bootstrapper
    {
        public static IWindsorContainer CreateContainer(ILoggerFactory factory)
        {
            //return new WindsorContainer().Install(new ComponentInstaller(factory));
            return null;
        }
    }
}
