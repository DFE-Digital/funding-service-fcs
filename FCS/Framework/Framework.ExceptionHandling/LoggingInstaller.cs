using Castle.MicroKernel.Registration;
using Castle.MicroKernel.SubSystems.Configuration;
using Castle.Windsor;
using SFA.FCT.Framework.ExceptionHandling.Interfaces;

namespace SFA.FCT.Framework.ExceptionHandling
{
    

    public class ExceptionHandlingInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<IExceptionManager>()
                         .ImplementedBy<EntLibExceptionManager>()
                         .LifestyleSingleton()
                );
        }
    }
}