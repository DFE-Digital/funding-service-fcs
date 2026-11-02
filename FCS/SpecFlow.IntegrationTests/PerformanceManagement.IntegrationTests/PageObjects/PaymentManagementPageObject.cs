namespace PerformanceManagement.IntegrationTests.PageObjects
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using System.Data.Entity;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers;
    using NUnit.Framework;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Services;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Handlers;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;
    using System.Globalization;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Services;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services;
    using PaymentManagement.Calculation;
    using PaymentManagement.Calculation.Repositories;
    using PaymentManagement.Calculation.Services;
    using PerformanceManagementDomain.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Repositories;
    using ISessionConnectionFactory = SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Infrastructure.ISessionConnectionFactory;

    public class PaymentManagementPageObject
    {
        private readonly IPayCalcPolicyQueryRepository _policyQueryRepository;
        private readonly Dictionary<string, AllocationInfo> _allocationInfos = new Dictionary<string, AllocationInfo>();

        public List<ExtendedAllocation> ContractAllocations { get; set; }

        public int ContractVersion { get; set; }

        public string ContractNumber { get; set; }
        
        public string Ukprn { get; set; }

        public PaymentManagementPageObject(IPayCalcPolicyQueryRepository policyQueryRepository)
        {
            _policyQueryRepository = policyQueryRepository;
        }

        public void SetDeliverablePayments(List<DeliverablePayment> delPayments)
        {
            AddPlannedDeliverablePayments(delPayments);
        }

        public void AddPlannedDeliverablePayments(List<DeliverablePayment> payments)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                ((DbSet<DeliverablePayment>)context.DeliverablePayments).AddRange(payments);
                context.SaveChanges();
            }
        }

        public void HandleFundingClaimReconciliationPublishedEvent(string allocationNumber)
        {
            var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();
            var paymentManagementPolicyContext = new PaymentManagementPolicyContext();
            Mock<ISessionConnectionFactory> sessionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(paymentManagementPolicyContext.Database.Connection));

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                new FcrPaymentValuesCalculationService(
                    new DateService(),
                    new PaymentTimetableRepository(),
                    new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository(),
                    new PolicyFundingStreamPeriodRepository(),
                    new OrganisationDetailsRepository()),
                new PaymentScheduleAllocationCommandRepository(),
                new PublishedPayableFcrAllocationRepository(),
                new SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.DeliverablePaymentRepository(),
                sessionFactoryMock.Object);

            AllocationInfo allocationInfo = _allocationInfos[allocationNumber];
            ExtendedAllocation extendedAllocation = ContractAllocations.Single(ca => ca.AllocationNumber == allocationNumber);

            var fundingClaimReconciliationPublishedEvent = new FundingClaimReconciliationPublishedEvent
            {
                ContractInfo = new ContractInfo
                {
                    ContractNumber = extendedAllocation.Allocation.ContractNumber,
                    ContractVersion = extendedAllocation.Allocation.ContractVersionNumber,
                    AllocationInfos = new List<AllocationInfo>
                    {
                        new AllocationInfo
                        {
                            AllocationNumber = allocationInfo.AllocationNumber,
                            ReconciliationValue = allocationInfo.ReconciliationValue,
                            FundingStreamPeriodCode = allocationInfo.FundingStreamPeriodCode,
                            StartDate = allocationInfo.StartDate,
                            EndDate = allocationInfo.EndDate
                        }
                    }
                },
                IsClaimCollectionPayable = true, 
                IsForManualPublication = false
            };

            handler.Handle(fundingClaimReconciliationPublishedEvent, new TestableInvokeHandlerContext()).Wait();
        }

        public void SetCalculationDate(DateTime calculationDate)
        {
            SetOverrideDate(calculationDate.ToString("dd/MM/yyyy"));
        }

        public void SetAllocationInfo(string allocationNumber, decimal reconciliationValue, string fundingStreamPeriodCode)
        {
            _allocationInfos.Add(allocationNumber, new AllocationInfo(allocationNumber, reconciliationValue, DateTime.Today.AddYears(-1), DateTime.Today, fundingStreamPeriodCode));
        }

        public void ApproveAmendedContract(List<DeliverableCodePayments> amendedPayments, bool incrementContractVersion=true)
        {
            if (incrementContractVersion)
            ContractVersion++;

            string allocationNumber = amendedPayments[0].Payments[0].AllocationNumber;
            var currentAllocation = ContractAllocations.Single(ca => ca.AllocationNumber == allocationNumber);

            AllocationDeliveryCommencedEvent allocationDeliveryMessage = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = allocationNumber,
                    startDate = currentAllocation.Allocation.AllocationStartDate.Value,
                    endDate = currentAllocation.Allocation.AllocationEndDate.Value,
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = currentAllocation.Allocation.FundingStreamPeriodCode,
                        startDate = currentAllocation.Allocation.AllocationStartDate.Value,
                        endDate = currentAllocation.Allocation.AllocationEndDate.Value,

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
                            new alternativeOrganisationIdentifierType{OrganisationIdentifier = Ukprn.ToString()}
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
                        plannedValue = payment.PlannedValue.Value
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

            var paymentScheduleDbContext = new PaymentSchedulePolicyContext();
            var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();
            var paymentManagementPolicyContext = new PaymentManagementPolicyContext();

            IAllocationRepository allocationRepository = new AllocationRepository();
            IProvisionIdentifierRepository provisionIdentifierRepository = new ProvisionIdentifierRepository();
            IOrganisationIdentifierRepository organisationIdentifierRepository = new OrganisationIdentifierRepository();
            SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.IDeliverablePaymentRepository deliverablePaymentRepository =
                new SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.DeliverablePaymentRepository();
            IPaymentScheduleService paymentScheduleService = new PaymentScheduleService(
                allocationRepository,
                provisionIdentifierRepository,
                organisationIdentifierRepository,
                deliverablePaymentRepository,
                Mock.Of<ILogger>()
                );
            IPreviousPaymentScheduleCopier previousPaymentScheduleCopier = new PreviousPaymentScheduleCopier(deliverablePaymentRepository);
            IPaymentScheduleCreator paymentScheduleCreator = new NonCalculationPaymentScheduleCreator(
                   previousPaymentScheduleCopier,
                   PayCalcPolicyQueryRepository.CreateInstance(),
                   deliverablePaymentRepository);
            IActualValueNullResetService actualValueNullResetService =
                new ActualValueNullResetService(allocationRepository, deliverablePaymentRepository);

            Mock<ISessionConnectionFactory> sessionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(paymentManagementPolicyContext.Database.Connection));

            AllocationDeliveryCommencedHandler handler = new AllocationDeliveryCommencedHandler
            (
                Mock.Of<ILogger>(),
                _policyQueryRepository,
                paymentScheduleService,
                paymentScheduleCreator,
                Mock.Of<IDate>(),
                actualValueNullResetService,
                Mock.Of<IActualVolumeService>(),
                new SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.DeliverablePaymentRepository(),
                new PaymentValuesCalculationService(
                    new PaymentValuesCalculator(
                        new PolicyFundingStreamPeriodRepository(),
                        new CensusDateService(new PaymentTimetableRepository(), new DateService(), new PolicyFundingStreamPeriodRepository()),
                        new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository(), Mock.Of<ILogger>(), new BehaviourFactory(new PolicyFundingStreamPeriodRepository())), new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository(),
                    new CalculationInputActualEnrichmentService(new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository(), 
                        new AllocationQueryRepository()),
                    new PolicyFundingStreamPeriodRepository(), Mock.Of<ILogger>(),
                    new FundingClaimReconciliationService(new AllocationQueryRepository(), new PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository()))
            , sessionFactoryMock.Object);

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            handler.Handle(allocationDeliveryMessage, context).Wait();
            var result = context.PublishedMessages.Single().Message;

            PaymentScheduleEvent CalculatedPaymentScheduleEvent = result as PaymentScheduleEvent;
            Assert.IsNotNull(CalculatedPaymentScheduleEvent, "PaymentScheduleEvent not received from handler");

            var sessionFactoryAggMock = new Mock<SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Infrastructure.ISessionConnectionFactory>();
            sessionFactoryAggMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(paymentManagementPolicyContext.Database.Connection));

            PaymentManagementPolicyContext paymentManagementPolicyDbContext = new PaymentManagementPolicyContext();

            var paymentAggregationService = new PaymentAggregationService(
                Mock.Of<ILogger>(),
                new DeliverableToSubnominalService(new PaymentManagementPolicyContext(), new MonitoringDeliverablesDbContext()),
                PayCalcPolicyQueryRepository.CreateInstance());

            var aggregationHandler = new PaymentScheduleHandler(
                Mock.Of<ILogger>(),
                paymentAggregationService,
                PayCalcPolicyQueryRepository.CreateInstance(),
                sessionFactoryAggMock.Object);

            aggregationHandler.Handle(CalculatedPaymentScheduleEvent, new TestableInvokeHandlerContext()).Wait();
        }

        public List<DeliverablePayment> GetDeliverablePayments(string allocationNumber, int versionNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                return context.DeliverablePayments.Where(x => x.AllocationNumber == allocationNumber && x.VersionNumber == versionNumber).ToList();
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

        public void AddOrganisationIdentifiers(List<ExtendedAllocation> allocations)
        {
            allocations.ForEach(a =>
            {
                using (var context = new PaymentSchedulePolicyContext())
                {
                    context.OrganisationIdentifiers.Add(new OrganisationIdentifer
                    {
                        AllocationNumber = a.AllocationNumber,
                        VersionNumber = a.Allocation.VersionNumber,
                        MainOrganisationIdentifier = $"ORG{Ukprn}",
                        OrganisationId = Ukprn
                    });
                    context.SaveChanges();
                }
            });
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

        public void ClearContractData(string contractNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Database.ExecuteSqlCommand(
                    $"DELETE p FROM PaymentSchedule.PublishedPayableFcrAllocation p INNER JOIN PaymentSchedule.Allocation a ON a.AllocationNumber = p.AllocationNumber WHERE a.ContractNumber = '{contractNumber}'");
                context.Database.ExecuteSqlCommand(
                    "TRUNCATE TABLE PaymentSchedule.OrganisationIdentifer");
                context.Database.ExecuteSqlCommand(
                       "Delete a from [PaymentSchedule].[DeliverablePayment] a inner join [PaymentSchedule].[Allocation] b on a.AllocationNumber = B.AllocationNumber where b.[ContractNumber] = '" + contractNumber + "'");
                context.Database.ExecuteSqlCommand("Delete from [PaymentSchedule].[Allocation] where [ContractNumber]='" + contractNumber + "'");
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.Database.ExecuteSqlCommand($"DELETE FROM [MonitoringDeliverables].[EsfAllocationData] WHERE [ContractNumber] = '{contractNumber}'");
            }
        }

        public void SetOverrideDate(string overrideDate)
        {
            using (OverrideDateDBContext dbContext = new OverrideDateDBContext())
            {
                ResetOverrideDate(dbContext);
                dbContext.OverrideDate.Add(new OverrideDate
                {
                    SystemOverrideDate = overrideDate.Length == 10 ? DateTime.ParseExact(overrideDate, "dd/MM/yyyy", CultureInfo.CurrentCulture) : DateTime.ParseExact(overrideDate, "dd/MM/yyyy HH:mm", CultureInfo.CurrentCulture)
                });
                dbContext.SaveChanges();
            }
        }

        private static void ResetOverrideDate(OverrideDateDBContext dbContext)
        {
            foreach (OverrideDate overrideDate in dbContext.OverrideDate)
            {
                dbContext.OverrideDate.Remove(overrideDate);
            }
            dbContext.SaveChanges();
        }

        public void ClearPaasDeliverablePeriodData(List<string> allocationNumbers)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                allocationNumbers.ForEach(x => ((DbSet<DeliverablePayment>) context.DeliverablePayments).RemoveRange(context.DeliverablePayments.Where(y => y.AllocationNumber == x)));
                context.SaveChanges();
            }
        }
    }
}
