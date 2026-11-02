namespace SFA.FCT.Xrm.TestFramework.PageObject
{
    using Castle.Windsor;
    using Castle.Windsor.Installer;

    public static class Bootstrapper
    {
        public static IWindsorContainer CreateContainer()
        {
            return new WindsorContainer()
               .Install(FromAssembly.This());

                //perhaps pass other installers here if needed                          
        }
    }
}
