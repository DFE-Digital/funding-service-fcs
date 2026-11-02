namespace FCS.Worker.Common.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class DynamicTypeBuilderTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DynamicTypeBuilder_ShouldCreateDynamicCommandWithProps()
        {
            // arrange
            ITestEvent testEvent = new TestEventImpl
            {
                StringProp = "TestString",
                IntProp = 1,
                CollectionProp = new List<string> { "One", "Two", "Three" },
                ComplexProp = new ComplexMessageType
                {
                    MessageInteger = 2,
                    MessageString = "MessageString"
                },
                TimesMessageDeferred = 0
            };


            var dynamicCommand = DynamicTypeBuilder.BuildCommandFrom(testEvent);

            Assert.IsNotNull(dynamicCommand);
            Assert.IsTrue(dynamicCommand.GetType().GetInterfaces().Contains(typeof(ICommand)));

            var asTestEvent = (ITestEvent) dynamicCommand;
            Assert.IsNotNull(asTestEvent);
            Assert.AreEqual(testEvent.StringProp, asTestEvent.StringProp);
            Assert.AreEqual(testEvent.IntProp, asTestEvent.IntProp);
            Assert.AreEqual(testEvent.CollectionProp.Count(), asTestEvent.CollectionProp.Count());
            Assert.AreEqual(testEvent.ComplexProp, asTestEvent.ComplexProp);
            Assert.AreEqual(testEvent.TimesMessageDeferred, asTestEvent.TimesMessageDeferred);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DynamicTypeBuilder_ShouldCreateDynamicCommandWithProps_UsingRealEvent()
        {
            // arrange
            IDeferrableEvent testEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = 1,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    ActualValue = 1m,
                                    Period = "1"
                                }
                            }
                        }
                    },
                    AllocationNumber = "ABC123",
                    ContractNumber = "CTR1",
                    ContractVersionNumber = 1,
                    FundingStreamPeriodCode = "FSP",
                    Organisation = new Organisation
                    {
                        MainOrganisationIdentifier = "ORG01",
                        OrganisationIdentifiers = new List<OrganisationIdentifier>
                        {
                            new OrganisationIdentifier
                            {
                                OrganisationId = "12345678",
                                OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                            }
                        }
                    },
                    ProvisionIdentifiers = new List<ProvisionIdentifier>(),
                    schemaVersion = 10.04m,
                    VersionNumber = 2
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationActualsVerified,
                TimesMessageDeferred = 0
            };

            var dynamicCommand = DynamicTypeBuilder.BuildCommandFrom(testEvent);

            Assert.IsNotNull(dynamicCommand);
            Assert.IsTrue(dynamicCommand.GetType().GetInterfaces().Contains(typeof(ICommand)));

            var asTestEvent = (PaymentScheduleEvent)dynamicCommand;
            Assert.IsNotNull(asTestEvent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DynamicTypeBuilder_ShouldCreateDynamicCommandWithProps_WithConcreteClass()
        {
            // arrange
            TestConcreteType testConcreteType = new TestConcreteType
            {
                ConcreteStringProp = "TestString",
                ConcreteIntProp = 1,
                ConcreteCollectionProp = new List<string> { "One", "Two", "Three" },
                ConcreteComplexProp = new ComplexMessageType
                {
                    MessageInteger = 2,
                    MessageString = "MessageString"
                },
                TimesMessageDeferred = 0
            };

            var dynamicCommand = DynamicTypeBuilder.BuildCommandFrom(testConcreteType);

            Assert.IsNotNull(dynamicCommand);
            Assert.IsTrue(dynamicCommand.GetType().GetInterfaces().Contains(typeof(ICommand)));

            var asBaseType = (TestConcreteType)dynamicCommand;
            Assert.IsNotNull(asBaseType);
            Assert.AreEqual(testConcreteType.ConcreteStringProp, asBaseType.ConcreteStringProp);
            Assert.AreEqual(testConcreteType.ConcreteIntProp, asBaseType.ConcreteIntProp);
            Assert.AreEqual(testConcreteType.ConcreteCollectionProp.Count(), asBaseType.ConcreteCollectionProp.Count());
            Assert.AreEqual(testConcreteType.ConcreteComplexProp, asBaseType.ConcreteComplexProp);
            Assert.AreEqual(testConcreteType.TimesMessageDeferred, asBaseType.TimesMessageDeferred);
        }

        public interface ITestEvent : IDeferrableEvent
        {
            string StringProp { get; set; }

            int IntProp { get; set; }

            IEnumerable<string> CollectionProp { get; set; }

            ComplexMessageType ComplexProp { get; set; }
        }

        public class TestEventImpl : ITestEvent
        {
            public int TimesMessageDeferred { get; set; }
            public string StringProp { get; set; }
            public int IntProp { get; set; }
            public IEnumerable<string> CollectionProp { get; set; }
            public ComplexMessageType ComplexProp { get; set; }
        }

        public class TestConcreteType : IDeferrableEvent
        {
            public int TimesMessageDeferred { get; set; }
            public string ConcreteStringProp { get; set; }
            public int ConcreteIntProp { get; set; }
            public IEnumerable<string> ConcreteCollectionProp { get; set; }
            public ComplexMessageType ConcreteComplexProp { get; set; }
        }

        public class ComplexMessageType
        {
            public int MessageInteger { get; set; }

            public string MessageString { get; set; }

            protected bool Equals(ComplexMessageType other)
            {
                return MessageInteger == other.MessageInteger && string.Equals(MessageString, other.MessageString);
            }

            public override bool Equals(object obj)
            {
                if (ReferenceEquals(null, obj)) return false;
                if (ReferenceEquals(this, obj)) return true;
                if (obj.GetType() != this.GetType()) return false;
                return Equals((ComplexMessageType) obj);
            }

            public override int GetHashCode()
            {
                unchecked
                {
                    return (MessageInteger*397) ^ (MessageString?.GetHashCode() ?? 0);
                }
            }
        }
    }
}
