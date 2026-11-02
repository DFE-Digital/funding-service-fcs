namespace Datafix.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class AggregateDeliverablesCommandDatafixes
    {
        [TestMethod, TestCategory("Datafix_R61a")]
        public void AggregateDeliverablesCommand_R61a_SendMessages()
        {
            AllocationInfo[] allocations =
            {
                new AllocationInfo("ESF-2006", 8, 0, "ESF1420"),
                new AllocationInfo("ESF-2170", 8, 0, "ESF1420"),
                new AllocationInfo("ESF-2178", 8, 0, "ESF1420"),
                new AllocationInfo("ESF-2197", 9, 0, "ESF1420"),
                new AllocationInfo("ESF-2198", 7, 0, "ESF1420"),
                new AllocationInfo("ESF-2257", 7, 0, "ESF1420")
            };

            allocations.ForEach(a =>
            {
                using (ISendOnlyBus bus = CreateBus())
                {
                    bus.Send("Xrm.DeliverableAggregation", new AggregateDeliverablesCommand
                    {
                        AllocationNumber = a.AllocationNumber,
                        ContractVersionNumber = a.ContractVersionNumber,
                        SubVersionNumber = a.SubVersionNumber,
                        FundingStreamPeriodCode = a.FundingStreamPeriodCode
                    });
                }
            });
        }

        private static ISendOnlyBus CreateBus()
        {
            BusConfiguration configuration = new BusConfiguration();
            configuration.AssembliesToScan(
                AllAssemblies
                    .Matching("CrossDomain.Integration.Messages.dll")
                    .And("Microsoft.WindowsAzure.Configuration.dll")
                    .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll"));

            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.Conventions().DefiningCommandsAs(t => t == typeof(AggregateDeliverablesCommand));

            return Bus.CreateSendOnly(configuration);
        }

        private class AllocationInfo
        {
            public AllocationInfo(string allocationNumber, int contractVersionNumber, int subVersionNumber, string fundingStreamPeriodCode)
            {
                AllocationNumber = allocationNumber;
                ContractVersionNumber = contractVersionNumber;
                SubVersionNumber = subVersionNumber;
                FundingStreamPeriodCode = fundingStreamPeriodCode;
            }

            public string AllocationNumber { get; }

            public int ContractVersionNumber { get; }

            public int SubVersionNumber { get; }

            public string FundingStreamPeriodCode { get; }
        }
    }
}
