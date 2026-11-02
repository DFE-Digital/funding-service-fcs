namespace SFA.FCT.FundingStreamConfigDomain.BusinessLogic.IoC
{
    using System.Configuration;
    using System.Reflection;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;

    public class WindsorInstaller : IWindsorInstaller
    {
        private static readonly string TraceSourceName = Assembly.GetExecutingAssembly().GetName().Name;

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            var xrmConnection = CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);

            container.Register(
                Component.For<CrmConnection>().Instance(xrmConnection),
                Component.For<IOrganizationService>().ImplementedBy<OrganizationService>().LifestyleTransient());
        }
    }
}