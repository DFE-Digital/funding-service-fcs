namespace PMD.IntegrationTests.PageObjects
{
    extern alias Entity;
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Globalization;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    // using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NUnit.Framework;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using PaymentManagement.Calculation;
    using PaymentManagement.Calculation.Repositories;
    using PaymentManagement.Calculation.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Exlog=Microsoft.Extensions.Logging;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Services;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Handlers;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Infrastructure;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Services;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using TechTalk.SpecFlow;
    using Aggregation=Entity::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using DeliverablePaymentRepository = SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.DeliverablePaymentRepository;
    using IDeliverablePaymentRepository = SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.IDeliverablePaymentRepository;

    public class PaymentCalculationPageObject
    {
        private readonly Random _rng = new Random();

        public string ContractNumber { get; set; }

        public int ContractVersion { get; set; }

        private List<ExtendedAllocation> ContractAllocations { get; set; }

        public List<ContractAllocationActualsType> ContractAllocationActuals { get; set; }

        public string CollectionReturnCode { get; set; }

        public string CollectionType { get; set; }

        public PaymentScheduleEvent CalculatedPaymentScheduleEvent { get; private set; }

        public PaymentAggregatedEvent CalculatedPaymentAggregatedEvent { get; private set; }

        public int UkPrn { get; set; }

        public PaymentCalculationPageObject(string contractNumber, int version)
        {
            ContractNumber = contractNumber;
            ContractVersion = version;
            UkPrn = _rng.Next(1000000);
        }

        public void ClearContractData()
        {
            // using Direct SQL as th EF code is not performant to do delete ..

            //var allocations = paymentScheduleDbContext.Allocations.Where(a => a.ContractNumber == ContractNumber);
            //var distinctAllocationRefs = allocations.Select(a => a.AllocationNumber).Distinct();

            //var p = paymentScheduleDbContext.DeliverablePayments.Where(dp => distinctAllocationRefs.Contains(dp.AllocationNumber)).ToList();
            //((DbSet<DeliverablePayment>)paymentScheduleDbContext.DeliverablePayments).RemoveRange(paymentScheduleDbContext.DeliverablePayments.Where(dp => distinctAllocationRefs.Contains(dp.AllocationNumber)));
            //((DbSet<Allocation>)paymentScheduleDbContext.Allocations).RemoveRange(allocations);
            //paymentScheduleDbContext.SaveChanges();
            using (PaymentSchedulePolicyContext paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
            {
                (paymentSchedulePolicyContext as DbContext).Database.ExecuteSqlCommand(
                    "Delete a from [PaymentSchedule].[DeliverablePayment] a inner join [PaymentSchedule].[Allocation] b on a.AllocationNumber = B.AllocationNumber where b.[ContractNumber] = '" + ContractNumber + "'");
                (paymentSchedulePolicyContext as DbContext).Database.ExecuteSqlCommand(
                    "Delete from [PaymentSchedule].[Allocation] where [ContractNumber]='" + ContractNumber + "'");
            }

            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.Database.ExecuteSqlCommand($"DELETE FROM [MonitoringDeliverables].[EsfAllocationData] WHERE [ContractNumber] = '{ContractNumber}'");
            }
        }

        public void AddContractAllocations(List<ExtendedAllocation> allocations)
        {
            ContractAllocations = allocations;
            using (var context = new PaymentSchedulePolicyContext())
            {
                ((DbSet<Allocation>)context.Allocations).AddRange(allocations.Select(a => a.Allocation));
                context.SaveChanges();
            }

            InsertEsfAllocationDataIntoStorage(allocations);
        }

        public void SetContractAllocations(List<ExtendedAllocation> allocations)
        {
            ContractAllocations = allocations;
        }

        private static void InsertEsfAllocationDataIntoStorage(IEnumerable<ExtendedAllocation> allocations)
        {
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.ESFAllocationData.AddRange(
                    allocations
                        .Where(a => a.EsfData != null)
                        .Select(a => new EsfAllocationData
                        {
                            ContractNumber = a.Allocation.ContractNumber,
                            ContractAllocationNumber = a.Allocation.AllocationNumber,
                            RegionType = a.EsfData.RegionType,
                            InvestmentPriority = a.EsfData.InvestmentPriority
                        }));
                context.SaveChanges();
            }
        }

        public void AddPlannedDeliverablePayments(List<DeliverableCodePayments> payments)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                List<DeliverablePayment> deliverablePayments = new List<DeliverablePayment>();
                foreach (var payment in payments)
                {
                    deliverablePayments.AddRange(payment.Payments);
                }

                ((DbSet<DeliverablePayment>)context.DeliverablePayments).AddRange(deliverablePayments);
                context.SaveChanges();
            }
        }

        public void SetupContractAllocationActualsType(Table summarisedActuals)
        {
            ContractAllocationActuals = new List<ContractAllocationActualsType>();
            var groups = summarisedActuals.Rows.GroupBy(r => r["AllocationRef"]);
            foreach (var group in groups)
            {
                var allocation = new ContractAllocationActualsType
                {
                    ContractAllocationNumber = group.Key,
                    CollectionReturnCode = CollectionReturnCode,
                    CollectionType = CollectionType,
                    ContractReference = new ContractReferenceType()
                    {
                        ContractNumber = ContractNumber,
                        ContractVersionNumber = ContractVersion
                    },
                    ContractorReference = new OrganisationReferenceType()
                    {
                        OrganisationIdentifier = "blah",
                        AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>()
                        {
                            new organisationIdentifiersOrganisationIdentifier()
                            {
                                organisationIdentifier = UkPrn.ToString(),
                                organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER,
                                effectiveDateRange = new effectiveDateRange()
                            }
                        }
                    },
                    ActualsSummary = new List<ActualsSummaryType>(),
                    FundingStreamPeriodCode = ContractAllocations.First(c => c.Allocation.AllocationNumber == group.Key).Allocation.FundingStreamPeriodCode
                };

                foreach (TableRow row in group)
                {
                    string[] ar = row.Keys.ToArray();
                    for (int i = 3; i < row.Keys.Count; i++)
                    {
                        DateTime dt;
                        if (DateTime.TryParse("01-" + ar[i], out dt) && row[i] != "?")
                        {
                            ActualsSummaryType actualsSummaryType = new ActualsSummaryType()
                            {
                                Period = dt.ToString("yyyyMM"),
                                PeriodType = new PeriodTypeType()
                                {
                                    PeriodTypeCode =
                                        ContractAllocations.First(c => c.AllocationNumber == group.Key).FundingStreamPeriodTypeCode.ToString(),
                                    PeriodTypeName =
                                        ContractAllocations.First(c => c.AllocationNumber == group.Key).FundingStreamPeriodTypeName.ToString(),

                                },
                                DeliverableCode = int.Parse(row["DeliverableCode"]),
                                ActualValue = decimal.Parse(row[i]),
                                ActualVolume = 0
                            };

                            allocation.ActualsSummary.Add(actualsSummaryType);
                        }

                    }
                }
                ContractAllocationActuals.Add(allocation);
            }
        }

        public void CalculatePayments(bool calculateAggregation = true)
        {
            using (PaymentManagementPolicyContext paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var paymentScheduleDbContext = new PaymentSchedulePolicyContext())
            {
                PayCalcPolicyQueryRepository payCalcPolicyQueryRepository = PayCalcPolicyQueryRepository.CreateInstance();

                IAllocationRepository allocationRepository = new AllocationRepository();
                IProvisionIdentifierRepository provisionIdentifierRepository =
                    new ProvisionIdentifierRepository();
                IOrganisationIdentifierRepository organisationIdentifierRepository =
                    new OrganisationIdentifierRepository();
                IDeliverablePaymentRepository deliverablePaymentRepository =
                    new DeliverablePaymentRepository();
                var paymentScheduleService = new PaymentScheduleService(
                    allocationRepository,
                    provisionIdentifierRepository,
                    organisationIdentifierRepository,
                    deliverablePaymentRepository,
                    Mock.Of<ILogger>()
                );

                IPaymentScheduleCreator paymentScheduleCreator = new NonCalculationPaymentScheduleCreator(
                    new PreviousPaymentScheduleCopier(deliverablePaymentRepository),
                    payCalcPolicyQueryRepository,
                    deliverablePaymentRepository);

                var calculationDeliverablePaymentRepository =
                    new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository();

                var sessionFactoryMock = new Mock<SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Infrastructure.ISessionConnectionFactory>();
                sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(ConnectionInfo.CreateFrom(paymentManagementPolicyContext.Database.Connection));

                var handler = new AllocationActualsVerifiedHandler
                (
                    Mock.Of<ILogger>(),
                    paymentScheduleService,
                    payCalcPolicyQueryRepository,
                    paymentScheduleCreator,
                    Mock.Of<IDate>(),
                    Mock.Of<IActualVolumeApplicator>(),
                    Mock.Of<IActualValueNullResetService>(),
                    deliverablePaymentRepository,
                    new PaymentValuesCalculationService(
                        new PaymentValuesCalculator(
                            new PolicyFundingStreamPeriodRepository(),
                            new CensusDateService(new PaymentTimetableRepository(), new DateService(), new PolicyFundingStreamPeriodRepository()),
                            calculationDeliverablePaymentRepository, 
                            Mock.Of<ILogger>(), new BehaviourFactory(new PolicyFundingStreamPeriodRepository())),
                        calculationDeliverablePaymentRepository,
                        new CalculationInputActualEnrichmentService(calculationDeliverablePaymentRepository, new AllocationQueryRepository()),
                        new PolicyFundingStreamPeriodRepository(), Mock.Of<ILogger>(),
                        new FundingClaimReconciliationService(new AllocationQueryRepository(), calculationDeliverablePaymentRepository )),
                    sessionFactoryMock.Object);

                TestableMessageHandlerContext context = new TestableMessageHandlerContext();
                // There should really only ever be 1 allocation
                foreach (var allocation in ContractAllocationActuals)
                {
                    var actualsMessage = new AllocationActualsVerified
                    {
                        AllocationActuals = allocation
                    };

                    handler.Handle(actualsMessage, context).Wait();
                }

                var result = context.PublishedMessages.First().Message;

                CalculatedPaymentScheduleEvent = result as PaymentScheduleEvent;
                Assert.IsNotNull(CalculatedPaymentScheduleEvent, "PaymentScheduleEvent not received from handler");
            }

            using (PaymentManagementPolicyContext paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            {
                var sessionFactoryMock = new Mock<SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Infrastructure.ISessionConnectionFactory>();
                sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(ConnectionInfo.CreateFrom(paymentManagementPolicyContext.Database.Connection));

                // Do aggregations
                if (calculateAggregation)
                {
                    var paymentAggregationService = new PaymentAggregationService(
                        Mock.Of<ILogger>(),
                        new DeliverableToSubnominalService(paymentManagementPolicyContext, new MonitoringDeliverablesDbContext()),
                        PayCalcPolicyQueryRepository.CreateInstance());

                    var aggregationHandler = new PaymentScheduleHandler(
                        Mock.Of<ILogger>(),
                        paymentAggregationService,
                        PayCalcPolicyQueryRepository.CreateInstance(),
                        sessionFactoryMock.Object);

                    TestableMessageHandlerContext context = new TestableMessageHandlerContext();

                    aggregationHandler.Handle(CalculatedPaymentScheduleEvent, context).Wait();

                    CalculatedPaymentAggregatedEvent = context.PublishedMessages.First().Message as PaymentAggregatedEvent;
                    Assert.IsNotNull(CalculatedPaymentAggregatedEvent);
                }
            }
        }

        public void HandleAllocationDeliveryCommencedEvent(allocationType deliveryCommencedAllocation)
        {
            var sessionFactoryMock = new Mock<SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Infrastructure.ISessionConnectionFactory>();
            sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(new PaymentManagementPolicyContext().Database.Connection));

            IWindsorContainer container = new WindsorContainer()
                .Install(new SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new Exlog.LoggerFactory()))
                .Register(Component.For<IDate>().ImplementedBy<StaticDate>().Named("IDateImplementation").LifestyleScoped().IsDefault())
                .Register(Component.For<SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Infrastructure.ISessionConnectionFactory>()
                    .Instance(sessionFactoryMock.Object).IsDefault())
                .Register(Component.For<AllocationDeliveryCommencedHandler>().LifestyleScoped());

            container.BeginScope();

            AllocationDeliveryCommencedHandler handler = container.Resolve<AllocationDeliveryCommencedHandler>();
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            handler.Handle(new AllocationDeliveryCommencedEvent
            {
                Allocation = deliveryCommencedAllocation
            }, context).Wait();

            CalculatedPaymentScheduleEvent = context.PublishedMessages.First().Message as PaymentScheduleEvent;
        }

        public void ApproveAmendedContract(List<DeliverableCodePayments> amendedPayments)
        {
            ContractVersion++;
            AllocationDeliveryCommencedEvent allocationDeliveryMessage = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = amendedPayments[0].Payments[0].AllocationNumber,
                    startDate = ContractAllocations[0].Allocation.AllocationStartDate.Value,
                    endDate = ContractAllocations[0].Allocation.AllocationEndDate.Value,
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = ContractAllocations[0].Allocation.FundingStreamPeriodCode,
                        startDate = ContractAllocations[0].Allocation.AllocationStartDate.Value,
                        endDate = ContractAllocations[0].Allocation.AllocationEndDate.Value,

                    },
                    contractReference = new contractReferenceType
                    {
                        contractNumber = ContractNumber,
                        contractVersionNumber = ContractVersion,

                    },
                    contractorReference = new organisationReferenceType
                    {
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType{OrganisationIdentifier = UkPrn.ToString()}
                        },
                        organisationIdentifier = "blah"
                    },

                    contractDeliverables = new List<contractDeliverableType>()
                }
            };

            // var groupedPayments = amendedPayments.GroupBy(a => a.Payment.DeliverableCode);

            foreach (var deliverable in amendedPayments)
            {
                var contractDeliverable = new contractDeliverableType
                {
                    deliverable = new deliverableType { deliverableCode = deliverable.DeliverableCode, isLegal = true },
                    contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>(),
                    contractDeliverables = new List<contractDeliverableType>(),
                    //plannedValue = payment.PlannedValue.Value
                };

                foreach (var payment in deliverable.Payments)
                {
                    contractDeliverable.contractDeliverablePeriods.Add(new contractDeliverablePeriodsTypeContractDeliverablePeriod
                    {
                        period = new periodType { periodValue = payment.Period },
                        plannedValue = payment.PlannedValue ?? 0
                    });
                }

                if (deliverable.ParentDeliverableCode.HasValue)
                {
                    var parent = allocationDeliveryMessage.Allocation.contractDeliverables.FirstOrDefault(c => c.deliverable.deliverableCode == deliverable.ParentDeliverableCode);
                    if (parent != null)
                    {
                        parent.contractDeliverables.Add(contractDeliverable);
                    }
                    else
                    {
                        allocationDeliveryMessage.Allocation.contractDeliverables.Add(contractDeliverable);
                    }
                }
                else
                {
                    allocationDeliveryMessage.Allocation.contractDeliverables.Add(contractDeliverable);
                }
            }

            using (PaymentManagementPolicyContext paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            {
                IAllocationRepository allocationRepository = new AllocationRepository();
                IProvisionIdentifierRepository provisionIdentifierRepository = new ProvisionIdentifierRepository();
                IOrganisationIdentifierRepository organisationIdentifierRepository = new OrganisationIdentifierRepository();
                IDeliverablePaymentRepository deliverablePaymentRepository = new DeliverablePaymentRepository();
                var paymentScheduleService = new PaymentScheduleService(
                    allocationRepository,
                    provisionIdentifierRepository,
                    organisationIdentifierRepository,
                    deliverablePaymentRepository,
                    Mock.Of<ILogger>());
                IPreviousPaymentScheduleCopier prevPaymentScheduleCopier = new PreviousPaymentScheduleCopier(deliverablePaymentRepository);
                IPaymentScheduleCreator paymentScheduleCreator = new NonCalculationPaymentScheduleCreator(
                    prevPaymentScheduleCopier,
                    PayCalcPolicyQueryRepository.CreateInstance(),
                    deliverablePaymentRepository);
                IActualValueNullResetService actualValueNullResetService =
                    new ActualValueNullResetService(allocationRepository, deliverablePaymentRepository);

                var sessionFactoryMock = new Mock<SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Infrastructure.ISessionConnectionFactory>();
                sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(ConnectionInfo.CreateFrom(paymentManagementPolicyContext.Database.Connection));

                var handler = new AllocationDeliveryCommencedHandler
                (
                    Mock.Of<ILogger>(),
                    PayCalcPolicyQueryRepository.CreateInstance(),
                    paymentScheduleService,
                    paymentScheduleCreator,
                    Mock.Of<IDate>(),
                    actualValueNullResetService,
                    Mock.Of<IActualVolumeService>(),
                    new DeliverablePaymentRepository(),
                    new PaymentValuesCalculationService(
                        new PaymentValuesCalculator(
                            new PolicyFundingStreamPeriodRepository(),
                            new CensusDateService(new PaymentTimetableRepository(), new DateService(), new PolicyFundingStreamPeriodRepository()),
                            new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository(),
                            Mock.Of<ILogger>(), new BehaviourFactory(new PolicyFundingStreamPeriodRepository())),
                        new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository(),
                        new CalculationInputActualEnrichmentService(new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository(),
                            new AllocationQueryRepository()),
                        new PolicyFundingStreamPeriodRepository(), Mock.Of<ILogger>(),
                        new FundingClaimReconciliationService(new AllocationQueryRepository(),
                            new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository())),
                    sessionFactoryMock.Object
                );

                TestableMessageHandlerContext context = new TestableMessageHandlerContext();
                handler.Handle(allocationDeliveryMessage, context).Wait();
                var result = context.PublishedMessages.First().Message;

                CalculatedPaymentScheduleEvent = result as PaymentScheduleEvent;
                Assert.IsNotNull(CalculatedPaymentScheduleEvent, "PaymentScheduleEvent not received from handler");
            }

            using (PaymentManagementPolicyContext paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            {
                var paymentAggregationService = new PaymentAggregationService(
                    Mock.Of<ILogger>(),
                    new DeliverableToSubnominalService(paymentManagementPolicyContext, new MonitoringDeliverablesDbContext()),
                    PayCalcPolicyQueryRepository.CreateInstance());
                var sessionFactoryMock = new Mock<SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Infrastructure.ISessionConnectionFactory>();
                sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(ConnectionInfo.CreateFrom(paymentManagementPolicyContext.Database.Connection));

                var aggregationHandler = new PaymentScheduleHandler(
                    Mock.Of<ILogger>(),
                    paymentAggregationService,
                    PayCalcPolicyQueryRepository.CreateInstance(), sessionFactoryMock.Object);

                TestableMessageHandlerContext context = new TestableMessageHandlerContext();
                aggregationHandler.Handle(CalculatedPaymentScheduleEvent, context).Wait();
                if (context.PublishedMessages.Length > 0)
                {
                    CalculatedPaymentAggregatedEvent = context.PublishedMessages.First().Message as PaymentAggregatedEvent;
                }
                else
                {
                    CalculatedPaymentAggregatedEvent = null;
                }
            }
        }

        public void UpdatePaymentSchedule(CalculationType calculationType, List<CalculatedAmount> deliverableAmounts)
        {
            using (PaymentSchedulePolicyContext paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
            {
                Dictionary<string, List<DeliverablePayment>> deliverablePaymentsByAllocation = new Dictionary<string, List<DeliverablePayment>>();
                foreach (var deliverableAmount in deliverableAmounts)
                {
                    List<DeliverablePayment> deliverablepayments;
                    if (!deliverablePaymentsByAllocation.TryGetValue(deliverableAmount.AllocationNumber, out deliverablepayments))
                    {
                        deliverablepayments = paymentSchedulePolicyContext.DeliverablePayments.Where(dp => dp.AllocationNumber == deliverableAmount.AllocationNumber).ToList();
                        deliverablePaymentsByAllocation.Add(deliverableAmount.AllocationNumber, deliverablepayments);
                    }

                    foreach (var amount in deliverableAmount.Amounts)
                    {
                        var existingDeliverablePayment = deliverablepayments.FirstOrDefault(d => d.DeliverableCode == deliverableAmount.DeliverableOrSubnominalCode && d.Period == amount.Period);
                        if (existingDeliverablePayment == null)
                        {
                            existingDeliverablePayment = new DeliverablePayment
                            {
                                AllocationNumber = deliverableAmount.AllocationNumber,
                                DeliverableCode = deliverableAmount.DeliverableOrSubnominalCode,
                                VersionNumber = this.ContractVersion,
                                Period = amount.Period,
                                PeriodTypeCode = PeriodTypeCode.CM
                            };

                            paymentSchedulePolicyContext.DeliverablePayments.Add(existingDeliverablePayment);
                            deliverablepayments.Add(existingDeliverablePayment);
                        }

                        switch (calculationType)
                        {
                            case CalculationType.Net:
                                existingDeliverablePayment.NetPaymentAmount = amount.Amount.Value;
                                break;
                            case CalculationType.Reconcilliation:
                                existingDeliverablePayment.ReconciliationPaymentAmount = amount.Amount.Value;
                                break;
                            case CalculationType.Capping:
                                existingDeliverablePayment.CappedPaymentAmount = amount.Amount.Value;
                                break;
                        }

                    }
                }

                paymentSchedulePolicyContext.SaveChanges();
            }

        }

        public void CheckCalculations(CalculationType calculationType, List<CalculatedAmount> expectedAmounts)
        {
            foreach(var expectedAmount in expectedAmounts)
            {
                var deliverablePayment = this.CalculatedPaymentScheduleEvent.PaymentScheduleAllocation.AllocationDeliverables.FirstOrDefault(a => a.DeliverableCode == expectedAmount.DeliverableOrSubnominalCode);
                Assert.IsNotNull(deliverablePayment, "deliverable payment is null for deliverable code " + expectedAmount.DeliverableOrSubnominalCode);

                foreach(var amount in expectedAmount.Amounts)
                {
                    var scheduledPayment = deliverablePayment.ScheduledPayments.FirstOrDefault(sp => sp.Period == amount.Period);

                    switch(calculationType)
                    {
                        case CalculationType.Capping:
                            Assert.AreEqual(amount.Amount.GetValueOrDefault(0), scheduledPayment.CappedPaymentAmount.GetValueOrDefault(0), string.Format("Capped payment amount is not expected value for deliverable code {0} and period {1}", expectedAmount.DeliverableOrSubnominalCode, amount.Period));
                            break;
                        case CalculationType.Net:
                            Assert.AreEqual(amount.Amount.GetValueOrDefault(0), scheduledPayment.NetPaymentAmount, string.Format("Net payment amount is not expected value for deliverable code {0} and period {1}", expectedAmount.DeliverableOrSubnominalCode, amount.Period));
                            break;
                        case CalculationType.Reconcilliation:
                            Assert.AreEqual(amount.Amount.GetValueOrDefault(0), scheduledPayment.ReconciliationPaymentAmount.GetValueOrDefault(0), string.Format("Reconciliation amount is not expected value for deliverable code {0} and period {1}", expectedAmount.DeliverableOrSubnominalCode, amount.Period));
                            break;
                        case CalculationType.Profile:
                            Assert.AreEqual(amount.Amount.GetValueOrDefault(0), scheduledPayment.ProfilePaymentAmount.GetValueOrDefault(0), string.Format("Profile payment amount is not expected value for deliverable code {0} and period {1}", expectedAmount.DeliverableOrSubnominalCode, amount.Period));
                            break;
                        case CalculationType.Balancing:
                            Assert.AreEqual(amount.Amount.GetValueOrDefault(0), scheduledPayment.BalancingPaymentAmount.GetValueOrDefault(0), string.Format("Balancing payment amount is not expected value for deliverable code {0} and period {1}", expectedAmount.DeliverableOrSubnominalCode, amount.Period));
                            break;
                    }
                }
            }

        }

        public void CheckAggregations(Aggregation.AggregationPaymentType aggregationType, List<CalculatedAmount> expectedAmounts)
        {
            foreach (var expectedAmount in expectedAmounts)
            {

                foreach (var amount in expectedAmount.Amounts)
                {
                    var aggregatedPeriod = CalculatedPaymentAggregatedEvent.Allocation.AllocationPeriods.FirstOrDefault(p => p.Period == amount.Period);
                    if(amount.Amount.HasValue)
                    {
                        Assert.IsNotNull(aggregatedPeriod, "No aggregation found for period " + amount.Period);
                    }
                    else if(aggregatedPeriod == null )
                    {
                        break;
                    }

                    var aggregation = aggregatedPeriod.Aggregations.FirstOrDefault(a => a.SubnominalCode == expectedAmount.DeliverableOrSubnominalCode.ToString() && a.PaymentType == aggregationType);

                    Assert.IsNotNull(aggregation, string.Format("No aggregation found for period {0} and subnominal code {1}", amount.Period, expectedAmount.DeliverableOrSubnominalCode));
                    Assert.AreEqual(amount.Amount.GetValueOrDefault(0), aggregation.AggregatedValue, string.Format("Aggregated amount does not match for period {0} and subnominal code {1}", amount.Period, expectedAmount.DeliverableOrSubnominalCode));
                }
            }
        }

        public void SetOverrideDate(string overrideDate)
        {
            using (OverrideDateDBContext dbContext = new OverrideDateDBContext())
            {
                ResetOverrideDate(dbContext);
                dbContext.OverrideDate.Add(new OverrideDate()
                {
                    SystemOverrideDate = overrideDate.Length == 10 ? DateTime.ParseExact(overrideDate, "dd/MM/yyyy", CultureInfo.CurrentCulture) : DateTime.ParseExact(overrideDate, "dd/MM/yyyy HH:mm", CultureInfo.CurrentCulture)
                });
                dbContext.SaveChanges();
            }
        }

        public void ResetOverrideDate()
        {
            using (OverrideDateDBContext dbContext = new OverrideDateDBContext())
            {
                ResetOverrideDate(dbContext);
            }
        }
        
        public void SetPayCalcConfigSettings(Table payCalcConfigSettings)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                payCalcConfigSettings.Rows.ToList().ForEach(row =>
                {
                    var fundingStreamPeriodCode = row["FundingStreamPeriodCode"];
                    var policyFundingStreamPeriod =
                        context.PolicyFundingStreamPeriods
                            .SingleOrDefault(pfsp => pfsp.FundingStreamPeriod == fundingStreamPeriodCode);

                    if (policyFundingStreamPeriod != null)
                    {
                        var paymentMethod = (PaymentMethod)Enum.Parse(typeof(PaymentMethod),
                            RemoveSpaces(row["PaymentMethod"]), ignoreCase: true);

                        var paymentCappingPeriod = (PaymentCappingPeriodType)Enum.Parse(typeof(PaymentCappingPeriodType),
                            TransformPaymentCappingPeriod(row["PaymentCappingPeriod"]), true);

                        var paymentCappingLevelType = (PaymentCappingLevelType)Enum.Parse(typeof(PaymentCappingLevelType),
                            RemoveSpaces(row["PaymentCappingLevel"]), true);

                        policyFundingStreamPeriod.PaymentMethod = paymentMethod;
                        policyFundingStreamPeriod.PaymentCappingPeriod = paymentCappingPeriod;
                        policyFundingStreamPeriod.PaymentCappingLevel = paymentCappingLevelType;
                    }
                });

                context.SaveChanges();
            }
        }

        private static string TransformPaymentCappingPeriod(string paymentCappingPeriod)
        {
            paymentCappingPeriod = RemoveSpaces(paymentCappingPeriod);

            if (paymentCappingPeriod == "ContractAllocationDuration")
            {
                paymentCappingPeriod = "ContractDuration";
            }

            return paymentCappingPeriod;
        }

        private static string RemoveSpaces(string text)
        {
            return text.Replace(" ", string.Empty);
        }

        private void ResetOverrideDate(OverrideDateDBContext dbContext)
        {
            foreach (OverrideDate overrideDate in dbContext.OverrideDate)
            {
                dbContext.OverrideDate.Remove(overrideDate);
            }
            dbContext.SaveChanges();
        }
    }
}
