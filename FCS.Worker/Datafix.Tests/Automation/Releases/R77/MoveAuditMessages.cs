using Azure.Messaging.ServiceBus;
using Datafix.Tests.Automation;
using Datafix.Tests.Repositories;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

public class MoveAuditMessages : IApplyDataFix
{
    private static string TransportConnectionString =>
        ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;

    public string Release => "R77";
    public int StoryNumber => 27124;
    public string Name => "Move messages from the audit queue to a table in Operations";
    public int Order => 1;

    public void ApplyDataFix()
    {
        Run().GetAwaiter().GetResult();
    }

    private async Task Run()
    {
        var client = new ServiceBusClient(TransportConnectionString);

        var receiver = client.CreateReceiver("audit");

        const int batchSize = 100;

        while (true)
        {
            IReadOnlyList<ServiceBusReceivedMessage> batchMessages =
                await receiver.ReceiveMessagesAsync(batchSize);

            if (batchMessages == null || !batchMessages.Any())
            {
                break;
            }

            foreach (var message in batchMessages)
            {
                try
                {
                    WriteMessageToTable(message);

                    await receiver.CompleteMessageAsync(message);
                }
                catch (Exception)
                {
                    await receiver.AbandonMessageAsync(message);
                }
            }
        }
    }

    private void WriteMessageToTable(ServiceBusReceivedMessage message)
    {
        const int UniqueConstraintViolation = 2627;

    }
}