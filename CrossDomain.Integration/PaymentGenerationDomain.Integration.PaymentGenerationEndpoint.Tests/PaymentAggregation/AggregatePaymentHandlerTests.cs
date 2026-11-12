namespace PaymentGenerationDomain.Integration.PaymentGeneration.PaymentAggregation
{

    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using BusinessLogic.Mappers;
    using DataStore;
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint;
    using SFA.FCT.CrossDomain.Integration.Events;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.Framework.Logging.NullObjects;
    using Allocation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation;
    using SubnominalAggregation = DataStore.Model.SubnominalAggregation;
    using DataStore.Repositories;
    using NServiceBus.Testing;
    using PaymentGenerationEndpoint.Infrastructure;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class AggregatePaymentHandlerTests
    {
        private const int Ukprn = 99999998;

        private PaymentGenerationDbContext _paymentDbContext;
        private const string AllocationNumber = "12345";

        [TestInitialize]
        public void SetupTests()
        {
            _paymentDbContext = new PaymentGenerationDbContext();
        }

        [TestCleanup]
        public void DisposeDbContext()
        {
            _paymentDbContext.SubnominalAggregations.RemoveRange(
                _paymentDbContext.SubnominalAggregations.Where(a => a.Ukprn == Ukprn));

            _paymentDbContext.SaveChanges();
            _paymentDbContext.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_IPaymentAggregatedEvent_ShouldCreateNewEntryInDatabase_IfRecordCurrentlyDoesNotExist()
        {
            // Arrange
            const string fspCode = "Test FSP1";
            const string subnominalCode = "2303000";

            DeleteSubnominalAggregationsForUkprn(Ukprn);
            CreateTestFspInNotPresent(fspCode);
            CreateSubnominalIfNotPresent(subnominalCode);

            PaymentAggregatedEvent aggregatedPaymentEvent = new PaymentAggregatedEvent();

            var allocation = new Allocation
            {
                AllocationNumber = AllocationNumber,
                VersionNumber = 1,
                FundingStreamPeriodCode = fspCode,
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                        Period = "08",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                SubnominalCode = subnominalCode,
                                PaymentType = AggregationPaymentType.PROFILE,
                                AggregatedValue = 60.50m,
                                PostedFlag = true,
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 1,
                                        DeliverableValue = 10.10m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 2,
                                        DeliverableValue = 20.25m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 3,
                                        DeliverableValue = 30.15m
                                    }
                                }
                            }
                        }
                    }
                },
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = "ORG0000001",
                    AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                    {
                        new OrgainsationIdentifier
                        {
                            OrganisationId = Ukprn.ToString(),
                            OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName
                                .UKPROVIDERREFERENCENUMBER
                        }
                    }
                }
            };

            aggregatedPaymentEvent.Allocation = allocation;

            var paymentGenerationDbContext = new PaymentGenerationDbContext();

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(paymentGenerationDbContext.Database.Connection));

            var handler = new AggregatePaymentHandler(
                new LoggerNullObject(),
                new OutstandingPaymentsChecker(
                    new PaymentTimetableRepository(),
                    new SubnominalAggregationRepository()),
                new UpSertSubmoninalAggregationService(new PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories.SubnominalAggregationRepository()), 
                new PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories.SubnominalAggregationRepository(),
                sessionConnectionFactoryMock.Object);

            // Act
            handler.Handle(aggregatedPaymentEvent, new TestableMessageHandlerContext()).Wait();

            var newPayments = _paymentDbContext.SubnominalAggregations.Where(a => a.Ukprn == Ukprn);

           
            // Assert
            Assert.AreEqual(1, newPayments.Count(), "Incorrect Number of Payments in Database");
            Assert.AreEqual(AllocationNumber,newPayments.First().AllocationNumber, "Incorrect AllocationNumber");
            Assert.AreEqual(60.50m,newPayments.First().AggregatedValue, "Incorrect AggregatedValue");


            DeleteSubnominalAggregationsForUkprn(Ukprn);
            DeleteFundingStreamPeiod(fspCode);
            DeleteFundingStream(fspCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Handle_IPaymentAggregatedEvent_ShouldUpdateInDatabase_IfRecordAlreadyExists()
        {
            // Arrange
            var aggregatedPayments = _paymentDbContext.SubnominalAggregations.Any(a => a.Ukprn == Ukprn);
            Assert.IsFalse(aggregatedPayments, $"A Subnominal Aggregation already exists for Ukprn {Ukprn}" );
            const int version = 2;
            const string fspCode = "Test FSP2";
            const string subnominalCode = "2303000";

            DeleteSubnominalAggregationsForUkprn(Ukprn);
            CreateTestFspInNotPresent(fspCode);
            CreateSubnominalIfNotPresent(subnominalCode);

            var payment = new SubnominalAggregation
            {
                AllocationNumber = AllocationNumber,
                FundingStreamPeriodCode = fspCode,
                Period = "10",
                PaymentType = Enum.GetName(typeof(AggregationPaymentType), AggregationPaymentType.RECONCILIATION),
                SubnominalCode = subnominalCode,
                PeriodTypeCode = "CM",
                AggregatedValue = 100,
                Ukprn = Ukprn,
                OrganisationId = "ORG0000001",
                AllocationVersionNumber = 1
            };

            _paymentDbContext.SubnominalAggregations.Add(payment);

            _paymentDbContext.SaveChanges();

            PaymentAggregatedEvent aggregatedPaymentEvent = new PaymentAggregatedEvent();
            var allocation = new Allocation
            {
                AllocationNumber = AllocationNumber,
                VersionNumber = version,
                FundingStreamPeriodCode = fspCode,
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                        Period = "10",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                SubnominalCode = subnominalCode,
                                PaymentType = AggregationPaymentType.RECONCILIATION,
                                AggregatedValue = 60.50m,
                                PostedFlag = true,
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 1,
                                        DeliverableValue = 10.10m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 2,
                                        DeliverableValue = 20.25m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 3,
                                        DeliverableValue = 30.15m
                                    }
                                }
                            }
                        }
                    }
                },
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = "ORG0000001",
                    AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                    {
                        new OrgainsationIdentifier
                        {
                            OrganisationId = Ukprn.ToString(),
                            OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName
                                .UKPROVIDERREFERENCENUMBER
                        }
                    }
                }
            };

            aggregatedPaymentEvent.Allocation = allocation;

            var paymentGenerationDbContext = new PaymentGenerationDbContext();

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(paymentGenerationDbContext.Database.Connection));

            var handler = new AggregatePaymentHandler(
                new LoggerNullObject(),
                new OutstandingPaymentsChecker(
                    new PaymentTimetableRepository(),
                    new SubnominalAggregationRepository()),
                new UpSertSubmoninalAggregationService(new PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories.SubnominalAggregationRepository()),
                new PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories.SubnominalAggregationRepository(),
                sessionConnectionFactoryMock.Object);

            // Act
            handler.Handle(aggregatedPaymentEvent, new TestableMessageHandlerContext()).Wait();

            using (var context = new PaymentGenerationDbContext())
            {
                var newPayments = context.SubnominalAggregations.Where(a => a.Ukprn == Ukprn);

                // Assert
                Assert.AreEqual(1,newPayments.Count(),"Incorrect Number of Payments in Database");
                Assert.AreEqual(AllocationNumber, newPayments.First().AllocationNumber, "Incorrect AllocationNumber");
                Assert.AreEqual(60.50m, newPayments.First().AggregatedValue,
                    "Incorrect AggregatedValue. The value was not updated to 60.50");
                Assert.AreEqual(version, newPayments.First().AllocationVersionNumber,
                    "Incorrect AllocationVersionNumber");
            }
            DeleteSubnominalAggregationsForUkprn(Ukprn);
            DeleteFundingStreamPeiod(fspCode);
            DeleteFundingStream(fspCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AggregatePaymentHandler_ShouldNotAddSubnominalAggregation_WhenThereIsAPostedRowForTheSameAllocationAndPeriod()
        {
            // arrange
            const string fspCode = "Test FSP3";
            const string subnominalCode = "2303000";
            const string otherSubnominalCode = "2010010";
            const string period = "201910";

            DeleteSubnominalAggregationsForUkprn(Ukprn);
            CreateTestFspInNotPresent(fspCode);
            CreateSubnominalIfNotPresent(subnominalCode);
            CreateSubnominalIfNotPresent(otherSubnominalCode);
            CreateSubnominalAggregationForAllocationNumberAndPeriod(period, subnominalCode:otherSubnominalCode, fspCode: fspCode, isPosted:true);

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(new PaymentGenerationDbContext().Database.Connection));

            PaymentAggregatedEvent aggregatedPaymentEvent = new PaymentAggregatedEvent
            {
                Allocation = new Allocation
                {
                    AllocationNumber = AllocationNumber,
                    VersionNumber = 1,
                    FundingStreamPeriodCode = fspCode,
                    AllocationPeriods = new List<AllocationPeriod>
                    {
                        new AllocationPeriod
                        {
                            PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                            Period = period,
                            Aggregations = new List<Aggregation>
                            {
                                new Aggregation
                                {
                                    SubnominalCode = subnominalCode,
                                    PaymentType = AggregationPaymentType.RECONCILIATION,
                                    AggregatedValue = 60.50m,
                                    PostedFlag = true,
                                    DeliverableDetails = new List<DeliverableDetail>
                                    {
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = 1,
                                            DeliverableValue = 10.10m
                                        },
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = 2,
                                            DeliverableValue = 20.25m
                                        },
                                        new DeliverableDetail
                                        {
                                            DeliverableCode = 3,
                                            DeliverableValue = 30.15m
                                        }
                                    }
                                }
                            }
                        }
                    },
                    Organisation = new Organisation
                    {
                        MainOrganisationIdentifier = "ORG0000001",
                        AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                        {
                            new OrgainsationIdentifier
                            {
                                OrganisationId = Ukprn.ToString(),
                                OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName
                                    .UKPROVIDERREFERENCENUMBER
                            }
                        }
                    }
                }
            };

            using (var context = new PaymentGenerationDbContext())
            {
                var handler = new AggregatePaymentHandler(
                    new LoggerNullObject(),
                    new OutstandingPaymentsChecker(
                        new PaymentTimetableRepository(),
                        new SubnominalAggregationRepository()),
                    new UpSertSubmoninalAggregationService(new PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories.SubnominalAggregationRepository()),
                    new PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories.SubnominalAggregationRepository(),
                    sessionConnectionFactoryMock.Object);

                // act
                handler.Handle(aggregatedPaymentEvent, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var newPayments = context.SubnominalAggregations.Where(a => a.Ukprn == Ukprn);
                Assert.AreEqual(1, newPayments.Count(), "Incorrect Number of Payments in Database");
            }
            DeleteSubnominalAggregationsForUkprn(Ukprn);
            DeleteFundingStreamPeiod(fspCode);
            DeleteFundingStream(fspCode);
            DeleteSubnominal(otherSubnominalCode);
        }

        private void DeleteSubnominalAggregationsForUkprn(int ukprn)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.SubnominalAggregations.Where(sa => sa.Ukprn == ukprn)
                    .ToList()
                    .ForEach(sa => context.SubnominalAggregations.Remove(sa));

                context.SaveChanges();
            }
        }

        private void DeleteFundingStreamPeiod(string fundingStreamPeriodCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreamPeriods.Where(fsp => fsp.Code == fundingStreamPeriodCode)
                    .ToList()
                    .ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }

        private void DeleteFundingStream(string fundingStreamPeriodCode)
        {
            string fundingStreamCode = "FS_" + fundingStreamPeriodCode;

            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreams.Where(fs => fs.Code == fundingStreamCode)
                    .ToList()
                    .ForEach(fs => context.FundingStreams.Remove(fs));

                context.SaveChanges();
            }
        }

        private void DeleteSubnominal(string subnominalCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.Subnominals.Where(sn => sn.Code == subnominalCode)
                    .ToList()
                    .ForEach(sn => context.Subnominals.Remove(sn));

                context.SaveChanges();
            }
        }

        private static void CreateSubnominalAggregationForAllocationNumberAndPeriod(
            string period,
            string subnominalCode,
            string fspCode,
            bool isPosted)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.SubnominalAggregations.Add(new SubnominalAggregation
                {
                    AllocationNumber = AllocationNumber,
                    Period = period,
                    SubnominalCode = subnominalCode,
                    PaymentType = "PROFILE",
                    FundingStreamPeriodCode = fspCode,
                    Ukprn = Ukprn,
                    PostedFlag = isPosted
                });

                context.SaveChanges();
            }
        }

        private static void CreateSubnominalIfNotPresent(string subnominalCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                if (context.Subnominals.Any(s => s.Code == subnominalCode) == false)
                {
                    context.Subnominals.Add(new Subnominal
                    {
                        Code = subnominalCode,
                        ShortDescription = "SD"
                    });
                }

                context.SaveChanges();
            }
        }

        private static void CreateTestFspInNotPresent(string fspCode)
        {
            string fundingStreamCode = "FS_" + fspCode;
            using (var context = new PaymentGenerationDbContext())
            {
                if (context.FundingStreamPeriods.Any(fsp => fsp.Code == fspCode) == false)
                {
                    context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);

                    context.FundingStreams.Where(fs => fs.Code == fundingStreamCode)
                        .ToList()
                        .ForEach(fs => context.FundingStreams.Remove(fs));

                    context.FundingStreamPeriods.Add(new FundingStreamPeriod
                    {
                        FundingStream = new FundingStream
                        {
                            Code = fundingStreamCode,
                            Name = "Test FS Name",
                            AgencyCode = "AC",
                            FinanceShortCode = "FSC"
                        },
                        Code = fspCode,
                        FundingStreamCode = fundingStreamCode,
                        Name = "FSP Name"
                    });
                }

                context.SaveChanges();
            }
        }
    }
}
