namespace AllocationDeliveryDomain.MonitoringDeliverablesEnrichment.BusinessLogic.Ioc
{
    using System.Diagnostics.CodeAnalysis;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;

    [ExcludeFromCodeCoverage]
    public class ComponentInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
        }
    }
}
