namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using PaymentManagementDomain.AllocationActualsVerified.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    
    [TestClass]
    public class AllocationActualsRepositoryTests
    {
        private const string AllocationNumber = "16AP-8888";
        private const string FundingStreamPeriodCode = "ASC1516";
        private const string Ukprn = "888888";
        private const string MasterContractNumber = "SFA-888888";
        private const string MasterContractNumber2 = "SFA-888889";
        private const string ContractNumber = "MAIN-88888";
        private const string PersistAllocationActualsInCrmOrg = "PersistActuals In Crm Org";
        
        private static readonly DateTime AllocationStartDateTest = new DateTime(2015, 1, 1);
        private static readonly DateTime AllocationEndDateTest = new DateTime(2015, 12, 31);

        [TestInitialize]
        public void SetupTests()
        {
            RemoveMasterAndChildContracts(MasterContractNumber);
            RemoveMasterAndChildContracts(MasterContractNumber2);
            RemoveContractsByNumber(ContractNumber);
        }

        private void DeleteContract(Guid guid)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            organizationSvc.Delete(sfa_contract.EntityLogicalName, guid);
        }

        private void DeleteOrg(Guid guid)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            organizationSvc.Delete(Account.EntityLogicalName, guid);
        }

        private void DeleteOrgsForUkprn(string ukprn)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(organizationSvc))
            {
                context.AccountSet.Where(a => a.sfa_UKPRN == ukprn)
                    .Select(a => a.AccountId.Value)
                    .ToList()
                    .ForEach(oId => organizationSvc.Delete(Account.EntityLogicalName, oId));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmAllocationEvidenceManager_PersistAllocationActualsInCrm_WhenMissingDeliverableCodes_ThrowMissingMonitoringDeliverablesException()
        {
            // Arrange
            DeleteOrgsForUkprn(Ukprn);
            Account account = new Account
            {
                sfa_UKPRN = Ukprn,
                Name = PersistAllocationActualsInCrmOrg + " " + Ukprn
            };
            Guid accountId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(account);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, accountId),
                sfa_organisationname = PersistAllocationActualsInCrmOrg + " " + Ukprn
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(caseload);

            SetUpContract(1);

            var actuals = new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    Period = "201508",
                    ActualValue = 100,
                    ActualVolume = 100
                },
                new ActualsSummaryType
                {
                    Period = "201509",
                    ActualValue = 200,
                    ActualVolume = 200
                }
            };

            var allocationActual = CreateAllocationActuals(ContractNumber, 1, "InvalidAllocationNumber", FundingStreamPeriodCode, actuals);

            IAllocationActualsRepository xrmAdapter = new AllocationActualsRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            try
            {
                // Act
                xrmAdapter.WriteAllocationActualsToCrm(allocationActual);
                Assert.Fail("Exception was not thrown");
            }
            catch (Exception)
            {
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmAllocationEvidenceManager_PersistAllocationActualsInCrm_WhenMatchingAllocationFound_UpdateAllDeliverablePeriods()
        {
            // Arrange
            DeleteOrgsForUkprn(Ukprn);
            Account account = new Account
            {
                sfa_UKPRN = Ukprn,
                Name = PersistAllocationActualsInCrmOrg + " " + Ukprn
            };
            Guid accountId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(account);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, accountId),
                sfa_organisationname = PersistAllocationActualsInCrmOrg + " " + Ukprn
            };

            SetUpContract(1);

            var actuals = new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    DeliverableCode = 1,
                    Period = "201508",
                    ActualValue = 100,
                    ActualVolume = 100
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 3,
                    Period = "201509",
                    ActualValue = 200,
                    ActualVolume = 200
                }
            };

            var allocationActual = CreateAllocationActuals(ContractNumber, 1, AllocationNumber, FundingStreamPeriodCode, actuals);

            // Act
            IAllocationActualsRepository xrmAdapter = new AllocationActualsRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            xrmAdapter.WriteAllocationActualsToCrm(allocationActual);

            // Assert
            var allocationDeliverables = GetDeliverablesForAllocation(AllocationNumber);
           

            var xrmDeliverable1 = allocationDeliverables.Single(d => d.DeliverableCode == 1);
            var xrmDeliverable2 = allocationDeliverables.Single(d => d.DeliverableCode == 2);
            var xrmDeliverable3 = allocationDeliverables.Single(d => d.DeliverableCode == 3);
            var xrmDeliverable4 = allocationDeliverables.Single(d => d.DeliverableCode == 4);

            var deliverable1Period201508 = xrmDeliverable1.DeliverablePeriods.Single(p => p.PeriodNumber == 8 && p.Year == 2015);
            var deliverable1Period201509 = xrmDeliverable1.DeliverablePeriods.Single(p => p.PeriodNumber == 9 && p.Year == 2015);
            var deliverable2Period201508 = xrmDeliverable2.DeliverablePeriods.Single(p => p.PeriodNumber == 8 && p.Year == 2015);
            var deliverable2Period201509 = xrmDeliverable2.DeliverablePeriods.Single(p => p.PeriodNumber == 9 && p.Year == 2015);
            var deliverable3Period201508 = xrmDeliverable3.DeliverablePeriods.Single(p => p.PeriodNumber == 8 && p.Year == 2015);
            var deliverable3Period201509 = xrmDeliverable3.DeliverablePeriods.Single(p => p.PeriodNumber == 9 && p.Year == 2015);
            var deliverable4Period201508 = xrmDeliverable4.DeliverablePeriods.Single(p => p.PeriodNumber == 8 && p.Year == 2015);

            Assert.AreEqual(100, deliverable1Period201508.ActualValue, "Actual Value is not set correctly");
            Assert.AreEqual(100, deliverable1Period201508.ActualVolume, "Actual Volume is not set correctly");
            Assert.AreEqual(null, deliverable1Period201509.ActualValue, "Actual Value is not set correctly");
            Assert.AreEqual(null, deliverable1Period201509.ActualVolume, "Actual Volume is not set correctly");

            Assert.AreEqual(null, deliverable2Period201508.ActualValue, "Actual Value is not set correctly");
            Assert.AreEqual(null, deliverable2Period201508.ActualVolume, "Actual Volume is not set correctly");
            Assert.AreEqual(null, deliverable2Period201509.ActualValue, "Actual Value is not set correctly");
            Assert.AreEqual(null, deliverable2Period201509.ActualVolume, "Actual Volume is not set correctly");

            Assert.AreEqual(null, deliverable3Period201508.ActualValue, "Actual Value is not set correctly");
            Assert.AreEqual(null, deliverable3Period201508.ActualVolume, "Actual Volume is not set correctly");
            Assert.AreEqual(200, deliverable3Period201509.ActualValue, "Actual Value is not set correctly");
            Assert.AreEqual(200, deliverable3Period201509.ActualVolume, "Actual Volume is not set correctly");

            Assert.AreEqual(null, deliverable4Period201508.ActualValue, "Actual Value is not set correctly");
            Assert.AreEqual(null, deliverable4Period201508.ActualVolume, "Actual Volume is not set correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmAllocationEvidenceManager_PersistAllocationActualsInCrm_UpdateAllocationSchedulesInCrm_ShouldThrowExceptionIfDeliverablesOnScheduleAreNotInSystem()
        {
            // Arrange
            DeleteOrgsForUkprn(Ukprn);
            Account account = new Account
            {
                sfa_UKPRN = Ukprn,
                Name = PersistAllocationActualsInCrmOrg + " " + Ukprn
            };
            Guid accountId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(account);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, accountId),
                sfa_organisationname = PersistAllocationActualsInCrmOrg + " " + Ukprn
            };

            SetUpContract(1);

            var actuals = new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    DeliverableCode = 4,
                    Period = "201508",
                    ActualValue = 100,
                    ActualVolume = 10
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 4,
                    Period = "201709",
                    ActualValue = 200,
                    ActualVolume = 20
                }
            };

            var allocationActual = CreateAllocationActuals(ContractNumber, 1, AllocationNumber, FundingStreamPeriodCode, actuals);
          

            // Act
            IAllocationActualsRepository xrmAdapter = new AllocationActualsRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            bool isExceptionThrown = false;
            try
            {
                // act
                xrmAdapter.WriteAllocationActualsToCrm(allocationActual);
            }
            catch (Exception)
            {
                isExceptionThrown = true;
            }

            Assert.IsTrue(isExceptionThrown, "Exception has not been thrown");
        }

        private void SetUpContract(int version)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                Account contractProvider = xrmContext.AccountSet.First();

                sfa_contract masterContract = new sfa_contract
                {
                    sfa_UKPRN = contractProvider.sfa_UKPRN,
                    sfa_number = MasterContractNumber,
                    sfa_HierarchyType = new OptionSetValue((int)sfa_contracthierarchytype.Master),
                    sfa_Version = 1,
                    sfa_SubVersion = 0,
                    sfa_ProviderName = contractProvider.ToEntityReference()
                };

                Guid masterContractId = organizationService.Create(masterContract);

                sfa_contract contract = new sfa_contract
                {
                    sfa_UKPRN = contractProvider.sfa_UKPRN,
                    sfa_number = ContractNumber,
                    sfa_HierarchyType = new OptionSetValue((int)sfa_contracthierarchytype.Contract),
                    sfa_Version = version,
                    sfa_SubVersion = 0,
                    sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, masterContractId),
                    sfa_ProviderName = contractProvider.ToEntityReference()
                };

                Guid contractId = organizationService.Create(contract);

                sfa_contractallocation allocation = new sfa_contractallocation
                {
                    sfa_contractallocationnumber = AllocationNumber,
                    sfa_FundingStreamPeriodId = GetFundingStreamPeriod(xrmContext, FundingStreamPeriodCode),
                    sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                    sfa_maximumcontractvalue = 100m,
                    sfa_FundingStreamId = GetFundingStream(xrmContext, "ASTO")
                };

                Guid allocationId = organizationService.Create(allocation);

                Guid deliverable1 = AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 1, deliverableName: "Total Adult Skills Funding", value: 1600, parent: null);
                Guid deliverable2 = AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 2, deliverableName: "Apprenticeships Total Funding", value: 900, parent: deliverable1);
                Guid deliverable3 = AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 3, deliverableName: "Other ASB Total Funding", value: 700, parent: deliverable1);

                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 4, deliverableName: "19-23 Apprenticeships Programme Funding", value: 100, parent: deliverable2);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 5, deliverableName: "19-23 Apprenticeships Learning Support", value: 100, parent: deliverable2);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 6, deliverableName: "19+ Apprenticeships Learner Support", value: 100, parent: deliverable2);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 7, deliverableName: "24+ Apprenticeships Programme Funding", value: 100, parent: deliverable2);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 8, deliverableName: "24+ Apprenticeships Learning Support", value: 100, parent: deliverable2);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 9, deliverableName: "19-23 Trailblazer Apprenticeships Programme Funding", value: 100, parent: deliverable2);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 10, deliverableName: "19-23 Trailblazer Apprenticeships Learning Support", value: 100, parent: deliverable2);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 11, deliverableName: "24+ Trailblazer Apprenticeships Programme Funding", value: 100, parent: deliverable2);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 12, deliverableName: "24+ Trailblazer Apprenticeships Learning Support", value: 100, parent: deliverable2);

                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 13, deliverableName: "Classroom Learning Programme Funding", value: 100, parent: deliverable3);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 14, deliverableName: "Classroom Learning - Learning Support", value: 100, parent: deliverable3);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 15, deliverableName: "19-24 Traineeships Programme Funding", value: 100, parent: deliverable3);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 16, deliverableName: "19-24 Traineeships Learning Support", value: 100, parent: deliverable3);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 17, deliverableName: "19-24 Traineeships Learner Support", value: 100, parent: deliverable3);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 18, deliverableName: "Workplace Learning Programme Funding", value: 100, parent: deliverable3);
                AddDeliverableToContractAllocation(organizationService, contractId, allocationId, deliverableCode: 19, deliverableName: "Workplace Learning - Learning Support", value: 100, parent: deliverable3);
            }
        }

        private IReadOnlyCollection<Deliverable> GetDeliverablesForAllocation(string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(SFA.FCS.Worker.Common.Crm.CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return (from a in xrmContext.sfa_contractallocationSet
                        join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d
                            .sfa_ContractAllocationId.Id
                        join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                        where a.sfa_contractallocationnumber == allocationNumber
                        select new { DeliverableActualValue = d.sfa_ActualValue, d.sfa_DeliverableCode, dp.sfa_ActualValue, dp.sfa_ActualVolume, dp.sfa_Period, dp.sfa_Year})
                    .ToList()
                    .GroupBy(dp => new {dp.sfa_DeliverableCode, dp.DeliverableActualValue})
                    .Select(d => new Deliverable(int.Parse(d.Key.sfa_DeliverableCode),
                            d.Key.DeliverableActualValue,
                            d.Select(dp => new DeliverablePeriod(
                                dp.sfa_Period.Value,
                                dp.sfa_Year.Value,
                                dp.sfa_ActualValue,
                                dp.sfa_ActualVolume)).ToList()))
                    .ToList();
            }
        }

        private class Deliverable
        {
            public Deliverable(int deliverableCode, decimal? actualValue, IReadOnlyCollection<DeliverablePeriod> deliverablePeriods)
            {
                DeliverableCode = deliverableCode;
                ActualValue = actualValue;
                DeliverablePeriods = deliverablePeriods;
            }

            public int DeliverableCode { get; }

            public decimal? ActualValue { get; }

            public IReadOnlyCollection<DeliverablePeriod> DeliverablePeriods { get; }
        }

        private class DeliverablePeriod
        {
            public DeliverablePeriod(int periodNumber, int year, decimal? actualValue, int? actualVolume)
            {
                PeriodNumber = periodNumber;
                Year = year;
                ActualValue = actualValue;
                ActualVolume = actualVolume;
            }

            public int PeriodNumber { get; }

            public int Year { get; }

            public decimal? ActualValue { get; }

            public int? ActualVolume { get; }
        }

        private Guid AddDeliverableToContractAllocation(IOrganizationService orgService, Guid contractId,
           Guid allocationId, int deliverableCode, string deliverableName, decimal value, Guid? parent)
        {
            EntityReference parentDeliverable = parent != null
                ? new EntityReference(sfa_contractdeliverable.EntityLogicalName, parent.Value)
                : null;

            var deliverable = new sfa_contractdeliverable
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_DeliverableCode = deliverableCode.ToString(),
                sfa_deliverablename = deliverableName,
                sfa_DeliverableDescription = deliverableName,
                sfa_PlannedValue = value,
                sfa_PlannedVolume = 0,
                sfa_ParentDeliverableId = parentDeliverable
            };

            Guid deliverableId = orgService.Create(deliverable);

            string[] periodNames =
            {
                "AUG-15", "SEP-15", "OCT-15", "NOV-15", "DEC-15", "JAN-16", "FEB-16", "MAR-16", "APR-16",
                "MAY-16", "JUN-16", "JUL-16"
            };
            int[] periodNumbers = { 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7 };

            List<sfa_contractdeliverableperiod> delPeriods =
                Enumerable.Range(1, 12)
                    .Select(i => new sfa_contractdeliverableperiod
                    {
                        sfa_ContractDeliverableId =
                            new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId),
                        sfa_Period = periodNumbers[i - 1],
                        sfa_PeriodName = periodNames[i - 1],
                        sfa_Year = i <= 5 ? 2015 : 2016,
                        sfa_PaymentPosted = false
                    }).ToList();

            delPeriods.ForEach(dp => orgService.Create(dp));

            return deliverableId;
        }

        private EntityReference GetFundingStreamPeriod(XrmServiceContext context, string fspCode)
        {
            return context.sfa_fundingstreamperiodSet
                .Single(fsp => fsp.sfa_fundingstreamperiodcode == fspCode)
                .ToEntityReference();
        }

        private EntityReference GetFundingStream(XrmServiceContext context, string fundingStreamCode)
        {
            return context.sfa_fundingstreamSet
                .Single(fsp => fsp.sfa_fundingstreamcode == fundingStreamCode)
                .ToEntityReference();
        }

        private static Allocation CreatePaymentScheduleAllocation(string contractNumber, int contractVersionNumber, string allocationNumber, string fundingStreamPeriodCode)
        {
            var newAllocation = new Allocation
            {
                AllocationNumber = allocationNumber,
                VersionNumber = contractVersionNumber,
                ContractNumber = contractNumber,
                ContractVersionNumber = contractVersionNumber,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                Organisation = new SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Organisation
                {
                    MainOrganisationIdentifier = "ordID",
                    OrganisationIdentifiers = new List<OrganisationIdentifier>
                    {
                        new OrganisationIdentifier
                        {
                            OrganisationId = "altOrgID", OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }
                    }
                },
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    CreatePaymentScheduleDeliverableType(1),
                    CreatePaymentScheduleDeliverableType(2),
                    CreatePaymentScheduleDeliverableType(3),
                    CreatePaymentScheduleDeliverableType(4)
                }
            };

            return newAllocation;
        }

        private static AllocationDeliverable CreatePaymentScheduleDeliverableType(int deliverableCode)
        {
            return new AllocationDeliverable
            {
                DeliverableCode = deliverableCode,
                ScheduledPayments = new List<ScheduledPayment>
                {
                    #region 'Create scheduled payments'
                    new ScheduledPayment
                    {
                        ActualValue = 2323423.00m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201508",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 5000m,
                        ReconciliationPaymentAmount = 5000m,
                        CappedPaymentAmount = -10m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 2323423.00m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201509",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 10000m,
                        ReconciliationPaymentAmount = 10000m,
                        CappedPaymentAmount = -150m
                    }
                    ,
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201510",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201511",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201512",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201601",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201602",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201603",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201604",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201605",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201606",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201607",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    }
                    #endregion
                }
            };
        }

        private static ContractAllocationActualsType CreateAllocationActuals(string contractNumber, int contractVersionNumber, string allocationNumber, string fundingStreamPeriodCode, List<ActualsSummaryType> actualsSummary)
        {
            var allocation = new ContractAllocationActualsType
            {
                ContractAllocationNumber = allocationNumber,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                ContractReference = new ContractReferenceType
                {
                    ContractNumber = contractNumber,
                    ContractVersionNumber = contractVersionNumber,
                    ContractSubVersionNumber = 0
                },
                ActualsSummary = actualsSummary
            };

            return allocation;
        }

        private void RemoveMasterAndChildContracts(string masterContractNumber)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                List<Guid> masterContracts = xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == masterContractNumber)
                    .Select(c => c.sfa_contractId.Value).ToList();

                List<Guid> childContracts = new List<Guid>();

                masterContracts.ForEach(masterContract =>
                    childContracts.AddRange(
                        from c in xrmContext.sfa_contractSet
                        join mc in xrmContext.sfa_contractSet
                            on c.sfa_ParentContractId.Id equals mc.sfa_contractId
                        where mc.sfa_contractId == masterContract
                        select c.sfa_contractId.Value));

                childContracts.ForEach(DeleteContract);
                masterContracts.ForEach(DeleteContract);
            }
        }

        private static void RemoveContractsByNumber(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => organizationService.Delete("sfa_contract", id));
            }
        }
    }
}