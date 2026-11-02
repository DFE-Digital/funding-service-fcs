namespace Datafix.Tests
{
    //using System.IO;
    //using Castle.MicroKernel.Lifestyle;
    //using Castle.MicroKernel.Registration;
    //using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    //using Moq;
    //using Newtonsoft.Json;
    //using NServiceBus;
    //using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    //using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint;
    //using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint.Ioc;
    //using SFA.FCT.CrossDomain.Integration.Events;
    //using SFA.FCT.Framework.Logging;
    //using UnitTests.Common;

    [TestClass]
    public class RecreateAllocationDeliveryCommencedEvent
    {
        // TODO: get commented code working
        //[TestMethod, TestCategory("Tooling")]
        //public void RecreateAllocationDeliveryCommencedEventForEsf2197()
        //{
        //    AllocationDeliveryCommencedEvent publishedMessage = null;

        //    // arrange
        //    Mock<IBus> busMock = new Mock<IBus>();
        //    busMock
        //        .Setup(m => m.Publish(It.IsAny<AllocationDeliveryCommencedEvent>()))
        //        .Callback<AllocationDeliveryCommencedEvent>(msg => publishedMessage = msg);

        //    IWindsorContainer container = new WindsorContainer()
        //        .Install(new ComponentInstaller(new LoggerFactory()))
        //        .Register(Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleScoped().IsDefault())
        //        .Register(Component.For<IBus>().Instance(busMock.Object))
        //        .Register(Component.For<ContractApprovedHandler>());

        //    container.BeginScope();

        //    ContractApprovedHandler handler = container.Resolve<ContractApprovedHandler>();

        //    ContractApprovedEvent message = TestResource.FromJson<ContractApprovedEvent>(
        //        "Datafix.Tests.Resources", "R61a.ContractApprovedEvent_ESIF-2193_v9.json");

        //    // act
        //    handler.Handle(message);

        //    // assert
        //    Assert.IsNotNull(publishedMessage);

        //    string serializedPublishedMessage = JsonConvert.SerializeObject(publishedMessage);

        //    using (StreamWriter file = new StreamWriter($"AllocationDeliveryCommencedEvent_ESF-2197_v9.json"))
        //    {
        //        file.WriteLine(serializedPublishedMessage);
        //    }
        //}
    }
}
