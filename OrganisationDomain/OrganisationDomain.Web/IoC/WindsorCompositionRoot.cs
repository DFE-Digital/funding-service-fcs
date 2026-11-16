namespace OrganisationDomain.Web.IoC
{
    using Castle.Windsor;

    public class WindsorCompositionRoot
    {
        private readonly IWindsorContainer _container;

        public WindsorCompositionRoot(IWindsorContainer container)
        {
            _container = container;
        }
    }
}