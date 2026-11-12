namespace PerformanceManagementDomain.Tests.ReconciliationPublication
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using PerformanceManagementDomain.ReconciliationPublication;
    using PerformanceManagementDomain.ReconciliationPublication.Repositories;
    using PerformanceManagementDomain.ReconciliationPublication.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Repositories;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using ClaimType = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ClaimType;

    [TestClass]
    public class InitiatePublishOfFundingClaimReconciliationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiatePublishOfFundingClaimReconciliationHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<InitiatePublishOfFundingClaimReconciliationHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<InitiatePublishOfFundingClaimReconciliationHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiatePublishOfFundingClaimReconciliationHandler_ShouldPublishManuallyWhenPublicationException()
        {
            // arrange
            FundingClaimReconciliation fcr = new FundingClaimReconciliation
            {
                Period = new Period { PeriodTypeCode = PeriodTypeCode.AY, PeriodTypeName = PeriodTypeName.ACADEMICYEAR, PeriodYear = "1718" },
                ClaimType = new ClaimType { ClaimTypeCode = "", ClaimTypeName = "" }
            };

            Mock<IFcrPublisher> fcrPublisherMock = new Mock<IFcrPublisher>();
            fcrPublisherMock
                .Setup(x => x.PublishManually(It.IsAny<ConnectionInfo>(), It.IsAny<FundingClaimReconciliation>()))
                .Returns(new FcrPublishResult(false, new DateTime(), new ContractInfo()));
            Mock<IClaimReconciliationBehaviourRepository> claimReconciliationBehaviourRepositoryMock = new Mock<IClaimReconciliationBehaviourRepository>();
            claimReconciliationBehaviourRepositoryMock
                .Setup(x => x.IsAfterPublicationCloseDate(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                .Returns(Task.FromResult(false));
            Mock<IFundingClaimReconciliationQueryRepository> fundingClaimReconciliationQueryRepositoryMock = new Mock<IFundingClaimReconciliationQueryRepository>();
            fundingClaimReconciliationQueryRepositoryMock
                .Setup(x => x.GetFundingClaimReconciliation(It.IsAny<Guid>()))
                .Returns(fcr);
            Mock<IClaimReconciliationPublicationExceptionRepository> claimReconciliationPublicationExceptionRepositoryMock = new Mock<IClaimReconciliationPublicationExceptionRepository>();
            claimReconciliationPublicationExceptionRepositoryMock
                .Setup(x => x.IsForManualPublication(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<int>()))
                .Returns(Task.FromResult(true));

            InitiatePublishOfFundingClaimReconciliationHandler handler = new InitiatePublishOfFundingClaimReconciliationHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<IDateProvider>(),
                fcrPublisherMock.Object,
                claimReconciliationBehaviourRepositoryMock.Object,
                fundingClaimReconciliationQueryRepositoryMock.Object,
                claimReconciliationPublicationExceptionRepositoryMock.Object,
                Mock.Of<IClaimReconciliationReferenceDataReconProfilingRepository>()
                );

            // act
            handler.Handle(new InitiatePublishOfFundingClaimReconciliationCommand
            {
                FundingClaimReconciliationId = Guid.NewGuid()
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            fcrPublisherMock.Verify(x => x.PublishManually(It.IsAny<ConnectionInfo>(), It.IsAny<FundingClaimReconciliation>()), Times.Once, "PublishManually was not called");
            fcrPublisherMock.Verify(x => x.PublishToFeed(It.IsAny<ConnectionInfo>(), It.IsAny<FundingClaimReconciliation>()), Times.Never, "PublishToFeed was called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiatePublishOfFundingClaimReconciliationHandler_ShouldPublishToFeedWhenNotPublicationException()
        {
            // arrange
            FundingClaimReconciliation fcr = new FundingClaimReconciliation
            {
                Period = new Period { PeriodTypeCode = PeriodTypeCode.AY, PeriodTypeName = PeriodTypeName.ACADEMICYEAR, PeriodYear = "1718" },
                ClaimType = new ClaimType { ClaimTypeCode = "", ClaimTypeName = "" }
            };

            Mock<IFcrPublisher> fcrPublisherMock = new Mock<IFcrPublisher>();
            fcrPublisherMock
                .Setup(x => x.PublishToFeed(It.IsAny<ConnectionInfo>(), It.IsAny<FundingClaimReconciliation>())).
                Returns(Task.FromResult(new FcrPublishResult(true, new DateTime(), new ContractInfo())));
            Mock<IClaimReconciliationBehaviourRepository> claimReconciliationBehaviourRepositoryMock = new Mock<IClaimReconciliationBehaviourRepository>();
            claimReconciliationBehaviourRepositoryMock
                .Setup(x => x.IsAfterPublicationCloseDate(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                .Returns(Task.FromResult(false));
            Mock<IFundingClaimReconciliationQueryRepository> fundingClaimReconciliationQueryRepositoryMock = new Mock<IFundingClaimReconciliationQueryRepository>();
            fundingClaimReconciliationQueryRepositoryMock
                .Setup(x => x.GetFundingClaimReconciliation(It.IsAny<Guid>()))
                .Returns(fcr);
            Mock<IClaimReconciliationPublicationExceptionRepository> claimReconciliationPublicationExceptionRepositoryMock = new Mock<IClaimReconciliationPublicationExceptionRepository>();
            claimReconciliationPublicationExceptionRepositoryMock
                .Setup(x => x.IsForManualPublication(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<int>()))
                .Returns(Task.FromResult(false));

            InitiatePublishOfFundingClaimReconciliationHandler handler = new InitiatePublishOfFundingClaimReconciliationHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<IDateProvider>(),
                fcrPublisherMock.Object,
                claimReconciliationBehaviourRepositoryMock.Object,
                fundingClaimReconciliationQueryRepositoryMock.Object,
                claimReconciliationPublicationExceptionRepositoryMock.Object, 
                Mock.Of<IClaimReconciliationReferenceDataReconProfilingRepository>()
                );

            // act
            handler.Handle(new InitiatePublishOfFundingClaimReconciliationCommand
            {
                FundingClaimReconciliationId = Guid.NewGuid()
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            fcrPublisherMock.Verify(x => x.PublishManually(It.IsAny<ConnectionInfo>(), It.IsAny<FundingClaimReconciliation>()), Times.Never, "PublishManually  was called");
            fcrPublisherMock.Verify(x => x.PublishToFeed(It.IsAny<ConnectionInfo>(), It.IsAny<FundingClaimReconciliation>()), Times.Once, "PublishToFeed was not called");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiatePublishOfFundingClaimReconciliationHandler_ShouldNotWriteToAtomFeedWhenPublicationException()
        {
            // arrange
            FundingClaimReconciliation fcr = GetFundingClaimReconciliationToPersist();

            ClearAtomFeedItem(fcr);

            using (PerformanceManagementDbContext performanceManagementDbContext = new PerformanceManagementDbContext())
            {
                IAtomFeedItemRepository atomFeedItemCommandRepository = new AtomFeedItemRepository();

                ConfigurationManager.AppSettings["UseRealDate"] = true.ToString();
                IDateProvider dateProvider = new DateProvider();

                IFcrPublisher fcrPublisher = new FcrPublisher(atomFeedItemCommandRepository, dateProvider);

                Mock<IClaimReconciliationBehaviourRepository> claimReconciliationBehaviourRepositoryMock = new Mock<IClaimReconciliationBehaviourRepository>();
                claimReconciliationBehaviourRepositoryMock
                    .Setup(x => x.IsAfterPublicationCloseDate(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                    .Returns(Task.FromResult(false));
                Mock<IFundingClaimReconciliationQueryRepository> fundingClaimReconciliationQueryRepositoryMock = new Mock<IFundingClaimReconciliationQueryRepository>();
                fundingClaimReconciliationQueryRepositoryMock
                    .Setup(x => x.GetFundingClaimReconciliation(It.IsAny<Guid>()))
                    .Returns(fcr);
                Mock<IClaimReconciliationPublicationExceptionRepository> claimReconciliationPublicationExceptionRepositoryMock = new Mock<IClaimReconciliationPublicationExceptionRepository>();
                claimReconciliationPublicationExceptionRepositoryMock
                    .Setup(x => x.IsForManualPublication(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<int>()))
                    .Returns(Task.FromResult(true));

                InitiatePublishOfFundingClaimReconciliationHandler handler = new InitiatePublishOfFundingClaimReconciliationHandler(
                    Mock.Of<ILogger>(),
                    Mock.Of<ISessionConnectionFactory>(),
                    dateProvider,
                    fcrPublisher,
                    claimReconciliationBehaviourRepositoryMock.Object,
                    fundingClaimReconciliationQueryRepositoryMock.Object,
                    claimReconciliationPublicationExceptionRepositoryMock.Object, 
                    Mock.Of<IClaimReconciliationReferenceDataReconProfilingRepository>()
                    );

                // act
                handler.Handle(new InitiatePublishOfFundingClaimReconciliationCommand
                {
                    FundingClaimReconciliationId = Guid.NewGuid()
                }, new TestableMessageHandlerContext()).Wait();
            }

            using (PerformanceManagementDbContext performanceManagementDbContext = new PerformanceManagementDbContext())
            {
                AtomFeedItem atomFeedItem = performanceManagementDbContext.AtomFeedItems.SingleOrDefault(atomItem =>
                    atomItem.Ukprn == fcr.Contractor.UKPRN &&
                    atomItem.ClaimTypeName == fcr.ClaimType.ClaimTypeName &&
                    atomItem.AllocationGroupName == fcr.AllocationGroup.AllocationGroupName &&
                    atomItem.Period == fcr.Period.PeriodYear);

                // assert
                Assert.IsNull(atomFeedItem, "FundingClaimReconciliation published written to atom feed when PublicationException");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiatePublishOfFundingClaimReconciliationHandler_ShouldWriteToAtomFeedWhenNotPublicationException()
        {
            // arrange
            FundingClaimReconciliation fcr = GetFundingClaimReconciliationToPersist();

            ClearAtomFeedItem(fcr);

            using (PerformanceManagementDbContext performanceManagementDbContext = new PerformanceManagementDbContext())
            {
                IAtomFeedItemRepository atomFeedItemCommandRepository = new AtomFeedItemRepository();

                ConfigurationManager.AppSettings["UseRealDate"] = true.ToString();
                IDateProvider dateProvider = new DateProvider();

                IFcrPublisher fcrPublisher = new FcrPublisher(atomFeedItemCommandRepository, dateProvider);

                Mock<IClaimReconciliationBehaviourRepository> claimReconciliationBehaviourRepositoryMock = new Mock<IClaimReconciliationBehaviourRepository>();
                claimReconciliationBehaviourRepositoryMock
                    .Setup(x => x.IsAfterPublicationCloseDate(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                    .Returns(Task.FromResult(false));
                Mock<IFundingClaimReconciliationQueryRepository> fundingClaimReconciliationQueryRepositoryMock = new Mock<IFundingClaimReconciliationQueryRepository>();
                fundingClaimReconciliationQueryRepositoryMock
                    .Setup(x => x.GetFundingClaimReconciliation(It.IsAny<Guid>()))
                    .Returns(fcr);
                Mock<IClaimReconciliationPublicationExceptionRepository> claimReconciliationPublicationExceptionRepositoryMock = new Mock<IClaimReconciliationPublicationExceptionRepository>();
                claimReconciliationPublicationExceptionRepositoryMock
                    .Setup(x => x.IsForManualPublication(It.IsAny<ConnectionInfo>(), It.IsAny<string>(), It.IsAny<int>()))
                    .Returns(Task.FromResult(false));

                Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
                sessionConnectionFactoryMock
                    .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, performanceManagementDbContext.Database.Connection));

                InitiatePublishOfFundingClaimReconciliationHandler handler = new InitiatePublishOfFundingClaimReconciliationHandler(
                    Mock.Of<ILogger>(),
                    sessionConnectionFactoryMock.Object,
                    dateProvider,
                    fcrPublisher,
                    claimReconciliationBehaviourRepositoryMock.Object,
                    fundingClaimReconciliationQueryRepositoryMock.Object,
                    claimReconciliationPublicationExceptionRepositoryMock.Object,
                    Mock.Of<IClaimReconciliationReferenceDataReconProfilingRepository>()
                    );

                // act
                handler.Handle(new InitiatePublishOfFundingClaimReconciliationCommand
                {
                    FundingClaimReconciliationId = Guid.NewGuid()
                }, new TestableMessageHandlerContext()).Wait();
            }

            using (PerformanceManagementDbContext performanceManagementDbContext = new PerformanceManagementDbContext())
            {
                AtomFeedItem atomFeedItem = performanceManagementDbContext.AtomFeedItems.SingleOrDefault(atomItem =>
                    atomItem.Ukprn == fcr.Contractor.UKPRN &&
                    atomItem.ClaimTypeName == fcr.ClaimType.ClaimTypeName &&
                    atomItem.AllocationGroupName == fcr.AllocationGroup.AllocationGroupName &&
                    atomItem.Period == fcr.Period.PeriodYear);

                // assert
                Assert.IsNotNull(atomFeedItem, "FundingClaimReconciliation published not written to atom feed when not PublicationException");
            }
        }

        private static void ClearAtomFeedItem(FundingClaimReconciliation fcr)
        {
            using (PerformanceManagementDbContext performanceManagementDbContext = new PerformanceManagementDbContext())
            {
                AtomFeedItem atomFeedItem = performanceManagementDbContext.AtomFeedItems.SingleOrDefault(atomItem =>
                    atomItem.Ukprn == fcr.Contractor.UKPRN &&
                    atomItem.ClaimTypeName == fcr.ClaimType.ClaimTypeName &&
                    atomItem.AllocationGroupName == fcr.AllocationGroup.AllocationGroupName &&
                    atomItem.Period == fcr.Period.PeriodYear);

                if (atomFeedItem != null)
                {
                    performanceManagementDbContext.AtomFeedItems.Remove(atomFeedItem);
                    performanceManagementDbContext.SaveChanges();
                }
            }
        }

        private static FundingClaimReconciliation GetFundingClaimReconciliationToPersist()
        {
            const string allocationNumber = "ASC-9994";
            const string allocationStartDate = "2015-08-01";
            const string allocationEndDate = "2016-07-31";
            const string contractApprovalDate = "2015-06-01";
            const string statusLastUpdatedDate = "2016-08-11";
            const string fundingStreamPeriodCode = "ASC1516";
            const string fundingTypeCode = "MAIN";
            const string fundingTypeName = "Mainstream";
            const int ukprn = 999994;
            const string contractNumber = "MAIN-9994";
            const int contractVersionNumber = 1;
            const int contractSubVersionNumber = 2;
            const string organisationId = "ORG0099994";

            return new FundingClaimReconciliation
            {
                AllocationGroup = new AllocationGroup
                {
                    AllocationGroupCode = "ASC1516",
                    AllocationGroupName = "Adult Skills 15/16"
                },
                Amounts = new AmountSummary
                {
                    CappedClaimedValue = 100m,
                    ClaimedValue = 200m,
                    PlannedValue = 300m,
                    ProposedReconciliationValue = 400m,
                    ReconciliationValue = 500m
                },
                ClaimType = new ClaimType
                {
                    ClaimTypeCode = "YE",
                    ClaimTypeName = "Year End"
                },
                ClaimVersionNumber = 1,
                ContractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        AllocationStartDate = DateTime.Parse(allocationStartDate),
                        AllocationEndDate = DateTime.Parse(allocationEndDate),
                        ContractAllocationNumber = allocationNumber,
                        FundingstreamPeriodCode = fundingStreamPeriodCode,
                        Contract = new Contract
                        {
                            FundingType = new FundingType
                            {
                                FundingTypeCode = fundingTypeCode,
                                FundingTypeName = fundingTypeName
                            },
                            ContractNumber = contractNumber,
                            ContractVersionNumber = contractVersionNumber,
                            ContractSubVersionNumber = contractSubVersionNumber,
                            ContractApprovalDate = DateTime.Parse(contractApprovalDate)
                        },
                        Amounts = new AmountSummary
                        {
                            CappedClaimedValue = 100m,
                            ClaimedValue = 200m,
                            PlannedValue = 300m,
                            ProposedReconciliationValue = 400m,
                            ReconciliationValue = 500m
                        },
                        ContractDeliverables = new List<ContractDeliverable>
                        {
                            new ContractDeliverable
                            {
                                Amounts = new AmountSummary
                                {
                                    ClaimedValue = 100m,
                                    PlannedValue = 200m
                                },
                                Deliverable = new Deliverable
                                {
                                    DeliverableCode = 5,
                                    DeliverableName = "19-23 Apprenticeships Learning Support"
                                }
                            },
                            new ContractDeliverable
                            {
                                Amounts = new AmountSummary
                                {
                                    ClaimedValue = 100m,
                                    PlannedValue = 200m
                                },
                                Deliverable = new Deliverable
                                {
                                    DeliverableCode = 6,
                                    DeliverableName = "19+ Apprenticeships Learner Support"
                                }
                            }
                        }
                    }
                },
                Contractor = new Contractor
                {
                    LegalName = "Some Org",
                    OrganisationIdentifier = organisationId,
                    UKPRN = ukprn
                },
                Period = new Period
                {
                    PeriodTypeCode = PeriodTypeCode.AY,
                    PeriodTypeName = PeriodTypeName.ACADEMICYEAR,
                    PeriodYear = "1516"
                },
                Status = ReconciliationStatus.Draft,
                StatusLastUpdatedDate = DateTime.Parse(statusLastUpdatedDate)
            };
        }
    }
}
