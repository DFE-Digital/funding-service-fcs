namespace ContractCreateDomain.Integration.XrmService.Tests.IoC
{
    using Castle.Windsor;
    using Castle.Windsor.Installer;

    public static class Bootstrapper
    {
        public static IWindsorContainer CreateContainer()
        {
            return new WindsorContainer()
               .Install(FromAssembly.This());                      
        }
    }
}
