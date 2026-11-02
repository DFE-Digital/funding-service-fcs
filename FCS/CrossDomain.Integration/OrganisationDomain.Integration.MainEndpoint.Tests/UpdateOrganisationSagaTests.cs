namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using System.Linq;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Logging;
    using OrganisationDomain.Integration.Messages.Commands;
    using OrganisationDomain.Integration.Entities;
    using System.Xml.Linq;
    using Extensions;
    using NServiceBus.Testing;
    using OrganisationDomain.Implementation.Converters;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class UpdateOrganisationSagaTests
    {
        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        #region ConfigureHowToFindSaga Tests
        #endregion

        #region Handle InitOrganisationUpdate Tests

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_InitOrganisationUpdate_ShouldInitializeState()
        {
            var saga = new UpdateOrganisationSaga();
            var converterMock = new Mock<IOrganisationStateConverter>();

            saga.Data = new UpdateOrganisationSagaData()
            {
                IsTimeoutAlreadyScheduled = true
            };

            var message = new InitOrganisationUpdate()
            {
                ProcessId = "1"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            saga.Handle(message, context).Wait();
            Assert.IsTrue(saga.Data.ProcessId == "1" && saga.Data.State == (int)UpdateOrganisationState.Started,
                "Handle_InitOrganisationUpdate didn't set the initial state");

        }

        //[TestMethod, TestCategory("UnitTest")]
        public void Handle_InitOrganisationUpdate_ShouldSetTheTimeOut()
        {
            //currently not testable as RequestTimout generic call cannot be mocked by Moq
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_InitOrganisationUpdate_ShouldSendGetProviderSummaryCommand()
        {
            var saga = new UpdateOrganisationSaga();
            var converterMock = new Mock<IOrganisationStateConverter>();
            
            saga.Data = new UpdateOrganisationSagaData()
            {
                IsTimeoutAlreadyScheduled = true
            };
            var message = new InitOrganisationUpdate()
            {
                ProcessId = "1"
            };
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            // act
            saga.Handle(message, context).Wait();

            // assert
            var getProviderSummaryCommands = context.SentMessages.Select(sm => sm.Message)
                .Where(sm => sm.GetType() == typeof(GetProviderSummary)).Cast<GetProviderSummary>();

            Assert.AreEqual(1, getProviderSummaryCommands.Count(c => c.ProcessId == "1"), "Handle_InitOrganisationUpdate didn't send the correct command");
            //busMock.Verify(x => x.Send(It.Is<GetProviderSummary>(y => y.ProcessId == "1")), Times.Once(), "Handle_InitOrganisationUpdate didn't send the correct command");
        }
        #endregion

        #region Handle ProcessProviderSummary Tests

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessProviderSummary_ShouldSetStatusToSummaryLoaded()
        {
            var saga = new UpdateOrganisationSaga();
            
            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true
            };

            var message = new ProcessProviderSummary()
            {
                ProcessId = "1"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            saga.Handle(message, context).Wait();
            Assert.IsTrue(saga.Data.ProcessId == "1" && saga.Data.State == (int)UpdateOrganisationState.CpdsSummaryLoaded,
                "Handle_ProcessProviderSummary didn't set the CpdsSummaryLoaded state");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessProviderSummary_ShouldSendGetUpdatedOrganisationsCommand()
        {
            var saga = new UpdateOrganisationSaga();
         
            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true
            };

            var summaryBlob = new byte[0];
            var message = new ProcessProviderSummary()
            {
                ProcessId = "1",
                ProviderSummaryDatabus = summaryBlob
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            saga.Handle(message, context).Wait();
            var getUpdatedOrganisationsCommands = context.SentMessages.Select(sm => sm.Message)
                .Where(sm => sm.GetType() == typeof(GetUpdatedOrganisations)).Cast<GetUpdatedOrganisations>();
            Assert.AreEqual(1, getUpdatedOrganisationsCommands.Count(c => c.ProcessId == "1" && c.ProviderSummaryDatabus == summaryBlob),
                "Handle_ProcessProviderSummary didn't send the correct ProcessProviderSummary command");
        }

        #endregion

        #region Handle ProcessUpdatedOrganisations Tests

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessUpdatedOrganisations_ShouldSetStatusToOrgUpdatesProcessed()
        {
            var saga = new UpdateOrganisationSaga();
            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true
            };

            var message = new ProcessUpdatedOrganisations()
            {
                ProcessId = "1",
                ChangedProviderUkprnList = new List<ProviderSequence>()

            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            // act
            saga.Handle(message, context).Wait();
            Assert.IsTrue(saga.Data.ProcessId == "1" && saga.Data.State == (int)UpdateOrganisationState.OrgUpdatesProcessed,
                "Handle_ProcessUpdatedOrganisations didn't set the OrgUpdatesProcessed state");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessUpdatedOrganisations_ShouldSendAGetOrganisationDetailsCommand_ForEachUkprn()
        {
            var saga = new UpdateOrganisationSaga();
            var converterMock = new Mock<IOrganisationStateConverter>();
            converterMock.Setup(x => x.ConvertJsonToOrganisationStateList(It.IsAny<string>())).Returns(
                new List<OrganisationState>());

            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true,
                OrganisationStatus = new Dictionary<int, bool>()
            };

            var message = new ProcessUpdatedOrganisations()
            {
                ProcessId = "1",
                ChangedProviderUkprnList = new List<ProviderSequence>
                {
                    new ProviderSequence
                    {
                        Ukprn = 1,
                        Upin = 10
                    },
                    new ProviderSequence
                    {
                        Ukprn = 2,
                        Upin = 20
                    },
                    new ProviderSequence
                    {
                        Ukprn = 3,
                        Upin = 30
                    }
                }
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            saga.Handle(message, context).Wait();
            var getUpdatedOrganisationsCommands = context.SentMessages.Select(sm => sm.Message)
                .CastWhere<GetOrganisationDetails>();

            Assert.AreEqual(1, getUpdatedOrganisationsCommands.Count(c => c.ProcessId == "1" && c.Ukprn == 1 && c.Upin == 10), "Wrong number of commands for ukprn 1");
            Assert.AreEqual(1, getUpdatedOrganisationsCommands.Count(c => c.ProcessId == "1" && c.Ukprn == 2 && c.Upin == 20), "Wrong number of commands for ukprn 2");
            Assert.AreEqual(1, getUpdatedOrganisationsCommands.Count(c => c.ProcessId == "1" && c.Ukprn == 3 && c.Upin == 30), "Wrong number of commands for ukprn 3");
        }

        #endregion

        #region Handle ProcessOrganisationDetails Tests
        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessOrganisationDetails_ShouldSetStatusToOrgDetailsReceived()
        {
            var saga = new UpdateOrganisationSaga();
            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true
            };

            var message = new ProcessOrganisationDetails
            {
                ProcessId = "1",
                ChangedProvider = new XDocument()
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            saga.Handle(message, context).Wait();
            Assert.IsTrue(saga.Data.ProcessId == "1" && saga.Data.State == (int)UpdateOrganisationState.OrgDetailsReceived,
                "Handle_ProcessOrganisationDetails didn't set the OrgDetailsReceived state");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessOrganisationDetails_ShouldSendSaveUpdatedOrganisationCommand()
        {
            var saga = new UpdateOrganisationSaga();
            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true
            };
            var org = new organisation();
            var prov = new XDocument();
            var message = new ProcessOrganisationDetails
            {
                ProcessId = "1",
                ChangedProvider = prov
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            // act
            saga.Handle(message, context).Wait();

            var count = context.SentMessages.Select(sm => sm.Message)
                .CastWhere<SaveUpdatedOrganisation>().Count(m => m.ProcessId == "1" && m.ChangedProvider == prov);

            Assert.AreEqual(1, count, "Handle_ProcessOrganisationDetails didn't send the correct SaveUpdatedOrganisation command");

            //busMock.Verify(x => x.Send(It.Is<SaveUpdatedOrganisation>(y => y.ProcessId == "1"
            //    && y.ChangedProvider == prov)),
            //    Times.Once(),
            //    "Handle_ProcessOrganisationDetails didn't send the correct SaveUpdatedOrganisation command");
        }
        #endregion

        #region Handle ProcessSavedOrganisation Tests

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessSavedOrganisation_ShouldSetStatusToOrgDetailsProcessed()
        {
            var loggerMock = new Mock<ILog>();
            var saga = new UpdateOrganisationSaga();
            
            var converterMock = new Mock<IOrganisationStateConverter>();
            converterMock.Setup(x => x.ConvertJsonToOrganisationStateList(It.IsAny<string>())).Returns(
                new List<OrganisationState>()
                {
                    new OrganisationState()
                    {
                        Processed=false,
                        Ukprn=1
                    },

                });

            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true,
                OrganisationStatus = new Dictionary<int, bool>()

            };
            var org = new organisation()
            {
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>()
                    {
                        new organisationIdentifiersOrganisationIdentifier()
                        {
                            organisationIdentifierType=organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                            ,organisationIdentifier="1"
                        }
                    }
            };
            var message = new ProcessSavedOrganisation()
            {
                ProcessId = "1",
                ChangedOrganisation = org,

            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            // act
            saga.Handle(message, context).Wait();

            Assert.IsTrue(saga.Data.ProcessId == "1" && saga.Data.State == (int)UpdateOrganisationState.OrgDetailsProcessed,
                "Handle_ProcessSavedOrganisation didn't set the OrgDetailsProcessed state");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessSavedOrganisation_ShouldPublishIOrganisationDetailsChangedEvent()
        {
            var loggerMock = new Mock<ILog>();
            var saga = new UpdateOrganisationSaga();
            
            var converterMock = new Mock<IOrganisationStateConverter>();
            converterMock.Setup(x => x.ConvertJsonToOrganisationStateList(It.IsAny<string>())).Returns(
                new List<OrganisationState>()
                {
                    new OrganisationState()
                    {
                        Processed=false,
                        Ukprn=1
                    },

                });
            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true,
                OrganisationStatus = new Dictionary<int, bool>()
            };
            var org = new organisation()
            {
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>()
                    {
                        new organisationIdentifiersOrganisationIdentifier()
                        {
                            organisationIdentifierType=organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                            ,organisationIdentifier="1"
                        }
                    }
            }; var prov = new XDocument();
            var message = new ProcessSavedOrganisation()
            {
                ProcessId = "1",
                ChangedOrganisation = org,
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            // act
            saga.Handle(message, context).Wait();
            

            Assert.AreEqual(1, context.PublishedMessages.Select(m => m.Message).OfType<OrganisationDetailsChanged>().Count(), 
                "Handle_ProcessSavedOrganisation didn't publish the correct OrganisationDetailsChanged event");
            //busMock.Verify(x => x.Publish(It.IsAny<Action<OrganisationDetailsChanged>>()),
            //    Times.Once(),
            //    "Handle_ProcessSavedOrganisation didn't publish the correct OrganisationDetailsChanged event");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ProcessSavedOrganisation_ShouldSetOrganisationToProcessed()
        {
            var loggerMock = new Mock<ILog>();
            var saga = new UpdateOrganisationSaga();

            var orgs = new Dictionary<int, bool>
            {
                { 1,false },
                { 2,false }
            };

            saga.Data = new UpdateOrganisationSagaData()
            {
                ProcessId = "1",
                IsTimeoutAlreadyScheduled = true,
                OrganisationStatus = orgs
            };
            var org = new organisation()
            {
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>()
                    {
                        new organisationIdentifiersOrganisationIdentifier()
                        {
                            organisationIdentifierType=organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                            ,organisationIdentifier="1"
                        }
                    }
            };
            var message = new ProcessSavedOrganisation()
            {
                ProcessId = "1",
                ChangedOrganisation = org,
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            saga.Handle(message, context).Wait();

            Assert.IsTrue(orgs.Single(x => x.Key == 1).Value, "Handle_ProcessSavedOrganisation didn't set the organisation to processed");
        }

        //[TestMethod, TestCategory("UnitTest")]
        //public void Handle_ProcessSavedOrganisation_ShouldLogInfo_EventPublished()
        //{
        //    // Arrange
        //    var busMock = new Mock<IBus>();
        //    var loggerMock = new Mock<ILog>();
        //    var saga = new UpdateOrganisationSaga
        //    {
        //        Bus = busMock.Object
        //    };
        //    var converterMock = new Mock<IOrganisationStateConverter>();
        //    converterMock.Setup(x => x.ConvertJsonToOrganisationStateList(It.IsAny<string>())).Returns(
        //        new List<OrganisationState>
        //        {
        //            new OrganisationState
        //            {
        //                Processed = false,
        //                Ukprn = 1
        //            }
        //        }
        //    );
        //    saga.OrgStateConverter = converterMock.Object;
        //    saga.Data = new UpdateOrganisationSagaData
        //    {
        //        ProcessId = "1",
        //        IsTimeoutAlreadyScheduled = true,
        //        Organisations = @"[]"

        //    };
        //    var org = new organisation
        //    {
        //        organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
        //            {
        //                new organisationIdentifiersOrganisationIdentifier
        //                {
        //                    organisationIdentifierType=organisationIdentifierType.UKPROVIDERREFERENCENUMBER,
        //                    organisationIdentifier = "1"
        //                }
        //            }
        //    };
        //    var message = new ProcessSavedOrganisation
        //    {
        //        ProcessId = "1",
        //        ChangedOrganisation = org
        //    };

        //    // Act
        //    saga.Handle(message);

        //    // Assert
        //    loggerMock.Verify(x => x.Info(It.Is<String>(y => y.Contains("event was published"))));
        //}

        #endregion



        #region Timeout tests
        //[TestMethod,TestCategory("UnitTest")]
        //public void Timeout_ShouldLogInfo_CurrentState()
        //{
        //    var loggerMock = new Mock<ILog>();
        //    var saga = new UpdateOrganisationSaga()
        //        {
        //            Data=new UpdateOrganisationSagaData()
        //            {
        //                Id=Guid.NewGuid(),
        //                OriginalMessageId="MessageID",
        //                Originator="caller",
        //                ProcessId="ProcessID",
        //                State=(int)UpdateOrganisationState.OrgUpdatesProcessed,
        //                Organisations = @"[]"
        //            },
        //            Logger=loggerMock.Object
        //        };
        //    var converterMock = new Mock<IOrganisationStateConverter>();
        //    converterMock.Setup(x => x.ConvertJsonToOrganisationStateList(It.IsAny<string>())).Returns(
        //        new List<OrganisationState>()
        //        );
        //    saga.OrgStateConverter = converterMock.Object;
        //    var state = new UpdateOrganisationTimeout();

        //    saga.Timeout(state);

        //    loggerMock.Verify(x=>x.Info(
        //        It.Is<string>(y=>y.Contains(saga.Data.State.ToString())
        //            && y.Contains(saga.Data.Id.ToString())
        //          && y.Contains(saga.Data.OriginalMessageId)
        //         && y.Contains(saga.Data.Originator)
        //          && y.Contains(saga.Data.ProcessId))
        //        ),Times.Once(),"Logger wasn't called with state data.");

        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void Timeout_ShouldLogInfo_OrganisationsNotProcessed()
        //{
        //    var loggerMock = new Mock<ILog>();
        //    var saga = new UpdateOrganisationSaga
        //    {
        //        Data = new UpdateOrganisationSagaData { Organisations = @"[]" },
        //        Logger = loggerMock.Object
        //    };
        //    var converterMock = new Mock<IOrganisationStateConverter>();
        //    converterMock.Setup(x => x.ConvertJsonToOrganisationStateList(It.IsAny<string>())).Returns(
        //        new List<OrganisationState>
        //        {
        //            new OrganisationState
        //            {
        //                Processed=true,
        //                Ukprn=1
        //            },
        //            new OrganisationState
        //            {
        //                Processed=false,
        //                Ukprn=2
        //            }
        //        });
        //    saga.OrgStateConverter = converterMock.Object;
        //    var state = new UpdateOrganisationTimeout();

        //    saga.Timeout(state);

        //    loggerMock.Verify(x => x.Info(It.Is<string>(y=>
        //        y.Contains("1"))), Times.Never(),
        //        "Logger was called with first Organisation which was processed. Only log not processed.");
        //    loggerMock.Verify(x => x.Info(It.Is<string>(y=>
        //        y.Contains("2"))), Times.Once(),
        //        "Logger was not called with second Organisation which was not processed.");
        //}

        #endregion
    }
}
