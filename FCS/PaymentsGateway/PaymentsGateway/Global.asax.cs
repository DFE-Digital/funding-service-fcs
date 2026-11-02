namespace PaymentsGateway
{
    using System;
    using System.Web;
    using BusinessLogic;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common;
    using Framework;
    using Castle.Facilities.WcfIntegration;

    public class Global : HttpApplication
    {
        public static WindsorContainer Container { get; set; }

        protected void Application_Start(object sender, EventArgs e)
        {
            BuildContainer();
        }

        protected void Session_Start(object sender, EventArgs e)
        {
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {
        }

        protected void Application_Error(object sender, EventArgs e)
        {
        }

        protected void Session_End(object sender, EventArgs e)
        {
        }

        protected void Application_End(object sender, EventArgs e)
        {
        }

        private void BuildContainer()
        {
            Container = new WindsorContainer();
            Container.Kernel.AddFacility<WcfFacility>();
            Container.Kernel.Register(
                                    Component.For<IPaymentsGateway>().ImplementedBy<PaymentsGateway>().Named("PaymentsGateway.PaymentsGateway").LifestyleTransient(),
                                    Component.For<IPaymentFilesGenerator>().ImplementedBy<PaymentFilesGenerator>().LifestyleTransient(),
                                    Component.For<IFileManager>().ImplementedBy<FileManager>().LifestyleTransient(),
                                    Component.For<ILogger>().ImplementedBy<EntLibLogger>().LifestyleTransient(),
                                    Component.For<ICsvSerializer>().ImplementedBy<CsvSerializer>().LifestyleTransient());
        }
    }
}