namespace SFA.FCT.PMD.Integration.EvidenceEndpoint.AllocationActualsVerified.Ioc
{
    using System.Diagnostics.CodeAnalysis;
    using Castle.Windsor;
    using Framework.Logging.Interfaces;

    [ExcludeFromCodeCoverage]
    public static class Bootstrapper
    {
        public static IWindsorContainer CreateContainer(ILoggerFactory factory)
        {
            return new WindsorContainer().Install(new ComponentInstaller(factory));
        }
    }
}
