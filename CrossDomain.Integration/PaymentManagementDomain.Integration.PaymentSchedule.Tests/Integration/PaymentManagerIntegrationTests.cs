namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using BusinessLogic;
    using BusinessLogic.Services;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.AllocationActuals;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.PaymentSchedule.DataStore;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PolicyCache.DataStore;
    using PolicyCache.DataStore.Repositories;
    using RulesEngine;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    [TestClass]
    public class PaymentManagerIntegrationTests
    {
        private const string AllocationNumber = "16AP-1234";
        private const int VersionNumber = 1;
        private Mock<IDate> _dateMock;
        private PaymentManager _paymentManager;
        private PaymentSchedulePolicyContext _paymentSchedulePolicyContext;
        private PaymentScheduleService _paymentScheduleService;

        [TestInitialize]
        public void Initialize()
        {
            _dateMock = new Mock<IDate>();
            _paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();

            
            _paymentManager = new PaymentManager
            {
                DateManager = _dateMock.Object,
                RulesEngine = new RulesEngine { StorageWrapper = Mock.Of<IStorageWrapper>() },
                PaymentSchedulePolicyContext = _paymentSchedulePolicyContext,
                Logger = Mock.Of<ILogger>(),
                AllocationRepository = new AllocationRepository(_paymentSchedulePolicyContext),
                PayCalcPolicyQueryRepository = PayCalcPolicyQueryRepository.CreateInstance(new PaymentManagementPolicyContext()),
                PublishedPayableFcrAllocationRepository = new PublishedPayableFcrAllocationRepository(_paymentSchedulePolicyContext),
                DeliverablePaymentRepository = new DeliverablePaymentRepository(_paymentSchedulePolicyContext)
            };

            _paymentScheduleService = new PaymentScheduleService(
                new AllocationRepository(_paymentSchedulePolicyContext),
                Mock.Of<IProvisionIdentifierRepository>(),
                Mock.Of<IOrganisationIdentifierRepository>(),
                new DeliverablePaymentRepository(_paymentSchedulePolicyContext),
                Mock.Of<ILogger>());

            CleanUp();
        }

        [TestCleanup]
        public void CleanUp()
        {
            _paymentSchedulePolicyContext.Database.ExecuteSqlCommand(
                @"DELETE FROM PaymentSchedule.DeliverablePayment WHERE AllocationNumber = @allocationNumber",
                new SqlParameter("allocationNumber", AllocationNumber));

            _paymentSchedulePolicyContext.Database.ExecuteSqlCommand(
                @"DELETE FROM PaymentSchedule.Allocation WHERE AllocationNumber = @allocationNumber",
                new SqlParameter("allocationNumber", AllocationNumber));

            _paymentSchedulePolicyContext.Database.ExecuteSqlCommand(
                @"DELETE FROM PaymentSchedule.PublishedPayableFcrAllocation WHERE AllocationNumber = @allocationNumber",
                new SqlParameter("allocationNumber", AllocationNumber));
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void PaymentManager_CalculatePaymentScheduleOnApproval_ShouldPreservePlannedVolumeWhenOpaRulesEngineIsInvoked()
        {
            // Arrange
            _dateMock.Setup(m => m.GetCalculationDateWithKey(It.IsAny<string>())).Returns(new DateTime(2016, 7, 1));

            // Act
            Allocation paymentSchedule =_paymentManager.CalculatePaymentScheduleOnApproval(new allocationType
            {
                contractAllocationNumber = AllocationNumber,
                fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                {
                    fundingStreamPeriodCode = "ALLBC1617"
                },
                contractReference = new contractReferenceType
                {
                    contractNumber = "MONTY-110",
                    contractVersionNumber = VersionNumber
                },
                contractorReference = new organisationReferenceType
                {
                    alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                    {
                        new alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = "12345678",
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                contractDeliverables = new List<contractDeliverableType>
                {
                    new contractDeliverableType
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 9
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    period = new periodType
                                    {
                                        periodValue = "201608"
                                    },
                                    plannedValue = 100M,
                                    plannedVolume = 123,
                                }
                            }
                        }
                    }
                });

            // Assert
            ScheduledPayment scheduledPayment =
                paymentSchedule.AllocationDeliverables.Single(ad => ad.DeliverableCode == 9)
                .ScheduledPayments.Single(sp => sp.Period == "201608");

            Assert.IsNotNull(scheduledPayment.PlannedVolume, "Planned volume is null in calculated payment schedule.");
            Assert.AreEqual(123, scheduledPayment.PlannedVolume, "Planned volume is incorrect in calculated payment schedule.");
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void PaymentManager_CalculatePaymentScheduleOnActualsReceived_ShouldPreservePlannedVolume()
        {
            // Arrange
            _dateMock.Setup(m => m.GetCalculationDateWithKey(It.IsAny<string>())).Returns(new DateTime(2016, 9, 1));

            _paymentSchedulePolicyContext.Allocations.Add(new PaymentManagementDomain.PaymentSchedule.DataStore.Model.Allocation
            {
                AllocationNumber = AllocationNumber,
                ContractNumber = "MONTY-110",
                ContractVersionNumber = VersionNumber,
                VersionNumber = 1,
                FundingStreamPeriodCode = "16-18APPS1617"
            });
            _paymentSchedulePolicyContext.DeliverablePayments.Add(new DeliverablePayment
            {
                VersionNumber = VersionNumber,
                AllocationNumber = AllocationNumber,
                DeliverableCode = 2,
                BalancingPaymentAmount = 0.1M,
                NetPaymentAmount = 0.1M,
                Period = "201608",
                ProfilePaymentAmount = 0.1M,
                PlannedValue = 100M,
                PlannedVolume = 123
            });
            _paymentSchedulePolicyContext.SaveChanges();

            // Act 
            Allocation paymentSchedule = _paymentManager.CalculatePaymentScheduleOnActualsReceived(new ContractAllocationActualsType
            {
                ContractAllocationNumber = AllocationNumber,
                FundingStreamPeriodCode = "16-18APPS1617",
                ContractReference =
                    new ContractReferenceType { ContractNumber = "MONTY-110", ContractVersionNumber = VersionNumber },
                ActualsSummary = new List<ActualsSummaryType>
                {
                    new ActualsSummaryType
                    {
                        DeliverableCode = 2,
                        Period = "201608",
                        ActualValue = 333,
                        PeriodType = new PeriodTypeType {PeriodTypeCode = "AY"}
                    },
                    new ActualsSummaryType
                    {
                        DeliverableCode = 3,
                        Period = "201608",
                        ActualValue = 444,
                        PeriodType = new PeriodTypeType {PeriodTypeCode = "AY"}
                    }
                },
                ContractorReference = new OrganisationReferenceType
                {
                    OrganisationIdentifier = "OrgId",
                    AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                    {
                        new organisationIdentifiersOrganisationIdentifier
                        {
                            organisationIdentifier = "12345678",
                            organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                        }
                    }
                }
            });

            _paymentScheduleService.SavePaymentSchedule(
                paymentScheduleForAllocation: paymentSchedule,
                deliverablePayments: _paymentManager.UpdatedDeliverablePayments,
                processingMode: ProcessingMode.ActualsReceived,
                allocationStartDate: null,
                allocationEndDate: null);

            // Assert
            ScheduledPayment scheduledPayment =
                paymentSchedule.AllocationDeliverables.Single(ad => ad.DeliverableCode == 2)
                .ScheduledPayments.Single(sp => sp.Period == "201608");

            // validate published schedule
            Assert.IsNotNull(scheduledPayment.PlannedVolume, "Published planned volume is null.");
            Assert.AreEqual(123, scheduledPayment.PlannedVolume, "Published planned volume is incorrect.");

            // validate stored schedule
            DeliverablePayment storedDeliverablePayment = new PaymentSchedulePolicyContext().DeliverablePayments.First(dp =>
                dp.AllocationNumber == AllocationNumber &&
                dp.VersionNumber == VersionNumber &&
                dp.DeliverableCode == 2 &&
                dp.Period == "201608");

            Assert.IsNotNull(storedDeliverablePayment.PlannedVolume, "Stored planned volume is null.");
            Assert.AreEqual(123, storedDeliverablePayment.PlannedVolume, "Stored planned volume is incorrect.");
        }
    }
}