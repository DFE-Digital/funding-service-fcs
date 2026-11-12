
using Microsoft.Azure.Amqp.Sasl;
using NServiceBus;
using NServiceBus.Transport.AzureServiceBus;

public static class Test
{

    public static void Configure()
    { 
        var config = new EndpointConfiguration("Test");

        var asbTransport = new AzureServiceBusTransport(
            connectionString: "<your-connection-string>",
            topology: TopicTopology.Default);



        // ✅ transaction mode is set on the transport itself
        asbTransport.TransportTransactionMode =
            TransportTransactionMode.ReceiveOnly;

        // ✅ use transport AFTER configuring it
        var routing = config.UseTransport(asbTransport);



    }

}
