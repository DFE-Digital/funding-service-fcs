namespace Datafix.Tests.Automation.Releases.R116b
{
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using Datafix.Tests.Repositories;
    using FluentAssertions;
    using Services;
    using NServiceBus;

    public class MonthEndCollectionReturnPeriodUpdate : IApplyDataFix
    {
        public string Release => "R116b";
        public int StoryNumber => 36672;
        public string Name => "Datafix for ALLF collection A78, wrong Collection Return Period (36672)";
        public int Order => 1;

        public void ApplyDataFix()
        {
            UpdateA78CollectionWithJanCollectionReturnPeriod();

            SendInFailedMessages();
        }

        private void SendInFailedMessages()
        {
            var commands =
                NsbMessagesDeserializer.DeserializeMessagesFromFile<ReportedActualsLoadedCommand>(
                    "Datafix.Tests.Resources.R116b.ReportedActualsLoadedCommands.json");
            commands.Count.Should().Be(903);

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<ReportedActualsLoadedCommand>();
            var sendTasks = commands.Select(c => endpoint.Send(destination: "AllocationDeliveryDomain.Validation", c));
            Task.WhenAll(sendTasks).Wait();
        }

        private void UpdateA78CollectionWithJanCollectionReturnPeriod()
        {
            AllocationDeliverablePeriodActualAuditRepository.UpdateCollectionReturnPeriod(collectionReturnCode:"A78", 202201);
        }
    }
}
