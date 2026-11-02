namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using Newtonsoft.Json;
    using NServiceBus.Testing;
    using PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PaymentScheduleEventXrmDatafixes
    {
        [TestMethod, TestCategory("Datafix_R54c")]
        public void PaymentScheduleEvent_R54c_ProcessFailedMessagesIntoCrm()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.IoC.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PaymentScheduleEventHandler>().LifestyleScoped());

            ValidateCurrentContractStateAndProcessMessageIntoHandler("R54c.PaymentScheduleEvent_ALLC-4061_v3.json", "ALLC-4061", 3, container);
            ValidateCurrentContractStateAndProcessMessageIntoHandler("R54c.PaymentScheduleEvent_ALLF-5124_v3.json", "ALLF-5124", 3, container);
            ValidateCurrentContractStateAndProcessMessageIntoHandler("R54c.PaymentScheduleEvent_ALLF-5542_v3.json", "ALLF-5542", 3, container);
        }

        [TestMethod, TestCategory("Datafix_R54e")]
        public void PaymentScheduleEvent_R54e_ProcessFailedMessagesIntoCrm()
        {
            IReadOnlyCollection<SimpleAllocation> allocations = new List<SimpleAllocation>
            {
                new SimpleAllocation("ALLB-4068", 3),
                new SimpleAllocation("ALLB-4094", 3),
                new SimpleAllocation("ALLC-4052", 3),
                new SimpleAllocation("ALLC-4204", 4),
                new SimpleAllocation("ALLC-4236", 3),
                new SimpleAllocation("ALLC-4277", 3),
                new SimpleAllocation("ALLF-5057", 3),
                new SimpleAllocation("ALLF-5246", 3),
                new SimpleAllocation("ALLF-5298", 3),
                new SimpleAllocation("ALLF-5461", 3),
                new SimpleAllocation("ALLF-5470", 3),
                new SimpleAllocation("ALLF-5484", 3),
                new SimpleAllocation("ALLF-5486", 3),
                new SimpleAllocation("ALLF-5599", 3)
            };

            IWindsorContainer container = new WindsorContainer()
                .Install(new SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.IoC.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PaymentScheduleEventHandler>().LifestyleScoped());

            allocations.ForEach(allocation => ValidateCurrentContractStateAndProcessMessageIntoHandler(
                messageResourceName: $"R54e_PaymentSchedule.{allocation.Number.Replace("-", "_")}.json",
                allocationNumber: allocation.Number,
                expectedVersion: allocation.Version,
                container: container));
        }

        [TestMethod, TestCategory("Datafix_R60a")]
        public void PaymentScheduleEvent_R60a_ProcessFailedMessagesIntoCrm()
        {
            IReadOnlyCollection<SimpleAllocation> allocations = new List<SimpleAllocation>
            {
                new SimpleAllocation("16LR-2808", 2),
                new SimpleAllocation("ALLC-4274", 5),
                new SimpleAllocation("ALLF-5439", 5)
            };

            IWindsorContainer container = new WindsorContainer()
                .Install(new SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.IoC.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PaymentScheduleEventHandler>().LifestyleScoped());

            allocations.ForEach(allocation => ValidateCurrentContractStateAndProcessMessageIntoHandler(
                messageResourceName: $"R60a.ps_{allocation.Number.Replace("-", "_")}.json",
                allocationNumber: allocation.Number,
                expectedVersion: allocation.Version,
                container: container));
        }

        [TestMethod, TestCategory("Datafix_R61a")]
        public void PaymentScheduleEvent_R61a_ProcessMessagesIntoCrm()
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
                .Install(new SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.IoC.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PaymentScheduleEventHandler>().LifestyleScoped())
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());

            allocations.ForEach(allocation => ValidateCurrentContractStateAndProcessMessageIntoHandler(
                messageResourceName: $"R61a.PaymentScheduleEvent_{allocation.Number}_v{allocation.Version}.json",
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
                PaymentScheduleEvent message = FromJson<PaymentScheduleEvent>("Datafix.Tests.Resources", messageResourceName);
                Assert.IsNotNull(message, $"The message has not deserialized for {allocationNumber}");

                int currentVersion = GetLatestVersionNumberForAllocation(allocationNumber);
                Assert.AreEqual(expectedVersion, currentVersion, $"The version has changed for {allocationNumber}");

                using (container.BeginScope())
                {
                    PaymentScheduleEventHandler handler = container.Resolve<PaymentScheduleEventHandler>();
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
