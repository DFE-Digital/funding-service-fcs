namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common;

    [TestClass]
    public class CreateDatabusMessageTests 
    {
        
        //[TestMethod, TestCategory("TechnicalExploration_Databus")]
        //public void Databus_ShouldHaveAFile()
        //{
        //    using (var bus = CreateBus())
        //    {
        //        DatabusCommand command = new DatabusCommand()
        //        {
        //            Key = Guid.NewGuid(),
        //            FieldDatabus = new byte[102400]
        //        };

        //        bus.Send(command);
        //    }
        //}
        
        //private static ISendOnlyBus CreateBus()
        //{
        //    var configuration = new BusConfiguration();

        //    configuration.AssembliesToScan(
        //        AllAssemblies.Matching("AllocationDeliveryDomain.Endpoint.Tests.dll")
        //        .And("Microsoft.WindowsAzure.Configuration.dll")
        //        .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll")
        //        .And("NServiceBus.Azure.dll"));
          
        //    configuration.UseTransport<AzureServiceBusTransport>();
        //    //configuration.UseTransport<MsmqTransport>();
        //    configuration.UseDataBus<AzureDataBus>();

        //    configuration.UseSerialization<JsonSerializer>();
        //    configuration.UsePersistence<InMemoryPersistence>();

            
        //    configuration.DiscardFailedMessagesInsteadOfSendingToErrorQueue();
        //    configuration.Conventions()
        //        .DefiningCommandsAs(t => t.Namespace != null && t.Name.EndsWith("Command"))
        //        .DefiningDataBusPropertiesAs (p=>p.Name.EndsWith("Databus"));
        //   configuration.CustomConfigurationSource(new CustomConfigurationProvider(new Dictionary<Type, string>
        //    {
        //        { typeof(DatabusCommand), "DrDomain.DatabusTest" }
        //    }));


        //    return Bus.CreateSendOnly(configuration);
        //}
    }
    public class DatabusCommand
    {
        public Guid Key { get; set; }

        public byte[] FieldDatabus { get; set; }
    }
}
