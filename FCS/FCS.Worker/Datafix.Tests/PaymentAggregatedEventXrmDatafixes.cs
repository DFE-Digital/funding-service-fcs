namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Datafix.Tests.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using Newtonsoft.Json;
    using NServiceBus.Testing;
    using PaymentManagementDomain.PaymentSchedule.PaymentAggregated;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PaymentAggregatedEventXrmDatafixes
    {
        [TestMethod, TestCategory("Datafix_R61a")]
        public void PaymentAggregatedEvent_R61a_ProcessMessagesIntoCrm()
        {
            IReadOnlyCollection<SimpleAllocation> allocations = new List<SimpleAllocation>
            {
                new SimpleAllocation("ESF-2006", 8),
                new SimpleAllocation("ESF-2170", 8),
                new SimpleAllocation("ESF-2178", 8),
                new SimpleAllocation("ESF-2197", 9),
                new SimpleAllocation("ESF-2198", 7),
                new SimpleAllocation("ESF-2257", 7)
            };

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PaymentAggregatedHandler>().LifestyleScoped())
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());

            allocations.ForEach(allocation => ValidateCurrentContractStateAndProcessMessageIntoHandler(
                messageResourceName: $"R61a.PaymentAggregatedEvent_{allocation.Number}_v{allocation.Version}.json",
                allocationNumber: allocation.Number,
                expectedVersion: allocation.Version,
                container: container));
        }

        private static void ValidateCurrentContractStateAndProcessMessageIntoHandler(
            string messageResourceName, string allocationNumber, int expectedVersion, IWindsorContainer container)
        {
            ActionRetrier.RetryWhenExceptionThrown(Process);

            void Process()
            {
                AllocationPaymentsChangedOnAggregationEvent message = FromJson<AllocationPaymentsChangedOnAggregationEvent>("Datafix.Tests.Resources", messageResourceName);
                Assert.IsNotNull(message, $"The message has not deserialized for {allocationNumber}");

                int currentVersion = GetLatestVersionNumberForAllocation(allocationNumber);
                Assert.AreEqual(expectedVersion, currentVersion, $"The version has changed for {allocationNumber}");

                using (container.BeginScope())
                {
                    PaymentAggregatedHandler handler = container.Resolve<PaymentAggregatedHandler>();
                    handler.Handle(message, new TestableMessageHandlerContext()).Wait();
                }
            }
        }

        private static int GetLatestVersionNumberForAllocation(string allocationNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return (
                    from c in context.sfa_contractSet
                    join a in context.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                    where
                        c.sfa_LatestVersion.Value
                        && a.sfa_contractallocationnumber == allocationNumber
                    select c.sfa_Version.Value
                    ).Single();
            }
        }

        public static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }

        public class SimpleAllocation
        {
            public SimpleAllocation(string number, int version)
            {
                Number = number;
                Version = version;
            }

            public string Number { get; }

            public int Version { get; }
        }
    }
}
