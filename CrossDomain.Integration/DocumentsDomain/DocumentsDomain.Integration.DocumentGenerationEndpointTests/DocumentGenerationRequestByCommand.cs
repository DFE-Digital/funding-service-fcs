namespace DocumentsDomain.Integration.DocumentGenerationEndpointTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;
    using NServiceBusAcceptanceTestingAdditions;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.DocumentsDomain.DocumentGeneration;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentSaver;

    [TestClass]
    public class DocumentGenerationRequestByCommand
    {
        private const string CompleteReceived = "CompleteReceived";
        private const string DocumentsPublishedReceived = "PublishReceived";

        [TestMethod, TestCategory("IntegrationTest1")]
        public void DocumentGenerationRequestByCommand_ShouldResultInAnEventAndAReply()
        {
            using (var ctx = GetInitialContext())
            {
                contract corporateContract = GetRichContractWithVolumeDeliverable();

                Scenario
                    .Define(ctx.Data)

                    .WithEndpoint<DocumentGenerationEndpointFullyMocked>(b => b
                        .CustomConfig(DocumentGenerationEndpointFullyMocked.Configure(ctx)))

                    .WithEndpoint<AnotherEndpointSendingACommand>(b => b
                        .CustomConfig(StandardConventions.Configure())
                        .When(
                            context => ctx.IsReadyToStart,
                            (bus, context) => bus.Send<DocumentGenerationCommand>(c =>
                            {
                                c.CorrelationId = Guid.NewGuid().ToString();
                                c.CorporateContract = corporateContract;
                            })))

                    .Done(context => ctx.IsAllDone)
                    .Run(new TimeSpan(0, 0, 30));

                ctx.GetMockOf<IDocumentGenerator>().Verify(generator => generator.GenerateDocument(It.IsAny<string>(), It.IsAny<contract>()), Times.Once);
                ctx.GetMockOf<IDocumentSaver>().Verify(saver => saver.SaveDocument(It.IsAny<DocumentSaveCommand>()), Times.Once);
            }
        }

        public Context GetInitialContext()
        {
            return new Context
            {
                ReadyToStart = contextData => contextData.EndpointsStarted
                                              && contextData.EndpointsSubscribed.Contains(typeof(AnotherEndpointSendingACommand).Name + " - " + typeof(IDocumentsPublishedEvent).AssemblyQualifiedName),

                AllDone = contextData => contextData.Flags.ContainsKey(CompleteReceived) && contextData.Flags[CompleteReceived]
                                         && contextData.Flags.ContainsKey(DocumentsPublishedReceived) && contextData.Flags[DocumentsPublishedReceived]
            };
        }

        
        private contract GetRichContractWithVolumeDeliverable()
        {
            contract c = GetRichContract();
            var deliverablesList = c.contracts.First().contractAllocations.First().contractDeliverables;
            deliverablesList.Clear();
            deliverablesList.Add(new contractDeliverablesTypeContractDeliverable
            {
                deliverable = new deliverableType
                {
                    deliverableCode = 3
                },
                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                {
                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                    {
                        period = 8,
                        year = 2015,
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        },
                        plannedVolume = 1234
                    },
                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                    {
                        period = 9,
                        year = 2015,
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        },
                        plannedVolume = 2345
                    }
                }
            });

            return c;
        }

        private contract GetRichContract()
        {
            return new contract
            {
                fundingType = new fundingType {fundingTypeCode = "ESF"},
                contractNumber = "MASTER-001",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = "ALLOCATION-001",
                                startDate = new DateTime(2015, 08, 01),
                                endDate = new DateTime(2016, 07, 31),
                                description = "Allocation One",
                                fundingStream = new fundingStream
                                {
                                    fundingStreamCode = "ESF 201420"
                                },
                                period = new period
                                {
                                    periodType = new periodTypeType {periodTypeCode = periodTypeCodeType.ESF},
                                    period1 = "1420"
                                },
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverableDescription = "Use This One",
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 8,
                                                year = 2015,
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeCode = periodTypeCodeType.AY
                                                },
                                                plannedValue = 1234
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 9,
                                                year = 2015,
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeCode = periodTypeCodeType.AY
                                                },
                                                plannedValue = 4321
                                            },
                                        }

                                    }
                                }
                            }
                        },
                        startDate = new DateTime(2015, 08, 01),
                        contractNumber = "CONTRACT-001",
                        contractVersionNumber = 1
                    }
                },
                contractor = new contractor
                {
                    ukprn = 12345678,
                    legalName = "Provider Name"
                }
            };
        }
    

        public class AnotherEndpointSendingACommand : EndpointConfigurationBuilder
        {
            public AnotherEndpointSendingACommand()
            {
                EndpointSetup<DefaultServer>()
                    .AddMapping<DocumentGenerationCommand>(typeof(DocumentGenerationEndpointFullyMocked))
                    .AddMapping<IDocumentsPublishedEvent>(typeof(DocumentGenerationEndpointFullyMocked))
                    .IncludeType<Handlers>()
                    .IncludeType<DocumentGenerationCommand>()
                    .IncludeType<DocumentGenerationComplete>()
                    .IncludeType<IDocumentsPublishedEvent>();
            }

            public class Handlers : IHandleMessages<DocumentGenerationComplete>, IHandleMessages<IDocumentsPublishedEvent>
            {
                public Context.ContextData ContextData { get; set; }

                public void Handle(DocumentGenerationComplete message)
                {
                    new Context(ContextData).AddOrUpdateFlag(CompleteReceived, true);
                }

                public void Handle(IDocumentsPublishedEvent message)
                {
                    new Context(ContextData).AddOrUpdateFlag(DocumentsPublishedReceived, true);
                }
            }
        }
    }
}
