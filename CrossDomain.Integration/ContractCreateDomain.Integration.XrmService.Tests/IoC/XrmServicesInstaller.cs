namespace ContractCreateDomain.Integration.XrmService.Tests.IoC
{
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using XrmTestModel;

    [ExcludeFromCodeCoverage]
    public class XrmServicesInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            var connectionStringDictionary =
                ConfigurationManager.ConnectionStrings.Cast<ConnectionStringSettings>()
                    .Where(connString => connString.Name.Contains("CrmConnectionString_"))
                    .ToDictionary(connString => connString.Name.Replace("CrmConnectionString_", string.Empty),
                        connString => connString.ConnectionString);

            var xrmConnectionString = new XrmConnectionString
            {
                ConnectionStringDictionary = connectionStringDictionary
            };

            container.Register(
                Types.FromAssembly(typeof(IUseXrmService).Assembly)
                    .BasedOn<IUseXrmService>().LifestyleTransient(),
                Component.For<IXrmServiceFactory>()
                    .ImplementedBy<XrmServiceFactory>().LifeStyle.Transient,
                Component.For<IXrmConnectionString>().Instance(xrmConnectionString));
        }
    }
}
