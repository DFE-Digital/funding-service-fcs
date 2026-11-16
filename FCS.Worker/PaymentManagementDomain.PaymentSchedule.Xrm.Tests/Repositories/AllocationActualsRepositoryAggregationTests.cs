namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Repositories
{
    extern alias Entity;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using PaymentManagementDomain.AllocationActualsVerified.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class AllocationActualsRepositoryAggregationTests
    {
        private const string AllocationNumber = "ASTO-9999";
        private const string FundingStreamPeriodCode = "ASTO1516";
        private const string MasterContractNumber = "SFA-9999";
        private const string ContractNumber = "MAIN-9999";
        private const int ContractVersionNumber = 1;
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationActualsRepository_WriteAllocationActualsToCrm_ShouldCorrectlyAggregateReceivedActuals()
        {
            // arrange
            ClearContractAndMasterContractForContractNumber(ContractNumber);
            SetUpContract();

            // act
            WriteAllocationActualsToCrmWithRetry(CreateAllocationActualsType(new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    DeliverableCode = 4,
                    Period = "201509",
                    ActualValue = 100
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 5,
                    Period = "201509",
                    ActualValue = 100
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 13,
                    Period = "201509",
                    ActualValue = 100
                }
            }));

            var deliverables = GetDeliverablesForAllocation(AllocationNumber);

            var storedDeliverable1 = deliverables.Single(d => d.DeliverableCode == 1);
            var storedDeliverable2 = deliverables.Single(d => d.DeliverableCode == 2);
            var storedDeliverable3 = deliverables.Single(d => d.DeliverableCode == 3);
            var storedDeliverable4 = deliverables.Single(d => d.DeliverableCode == 4);
            var storedDeliverable5 = deliverables.Single(d => d.DeliverableCode == 5);
            var storedDeliverable13 = deliverables.Single(d => d.DeliverableCode == 13);

            Assert.AreEqual(300, storedDeliverable1.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(200, storedDeliverable2.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(100, storedDeliverable3.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(100, storedDeliverable4.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(100, storedDeliverable5.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(100, storedDeliverable13.ActualValue, "Actual Value has not been aggregated correctly");
        }

        private IReadOnlyCollection<Deliverable> GetDeliverablesForAllocation(string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(SFA.FCS.Worker.Common.Crm.CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return (from a in xrmContext.sfa_contractallocationSet
                        join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d
                            .sfa_ContractAllocationId.Id
                        where a.sfa_contractallocationnumber == allocationNumber
                        select new {d.sfa_ActualValue, d.sfa_DeliverableCode})
                    .ToList()
                    .Select(d => new Deliverable(int.Parse(d.sfa_DeliverableCode), d.sfa_ActualValue))
                    .ToList();
            }
        }

        private class Deliverable
        {
            public Deliverable(int deliverableCode, decimal? actualValue)
            {
                DeliverableCode = deliverableCode;
                ActualValue = actualValue;
            }

            public int DeliverableCode { get; }

            public decimal? ActualValue { get; }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationActualsRepository_WriteAllocationActualsToCrm_ShouldCorrectlyAggregateReceivedActualsOver2CollectionReturns()
        {
            // arrange

            ClearContractAndMasterContractForContractNumber(ContractNumber);
            SetUpContract();

            // act
            WriteAllocationActualsToCrmWithRetry(CreateAllocationActualsType(new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    DeliverableCode = 4,
                    Period = "201509",
                    ActualValue = 100
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 5,
                    Period = "201509",
                    ActualValue = 100
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 13,
                    Period = "201509",
                    ActualValue = 100
                }
            }));

            WriteAllocationActualsToCrmWithRetry(CreateAllocationActualsType(new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    DeliverableCode = 4,
                    Period = "201509",
                    ActualValue = 200,
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 5,
                    Period = "201509",
                    ActualValue = 200
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 13,
                    Period = "201509",
                    ActualValue = 200
                }
            }));

            var deliverables = GetDeliverablesForAllocation(AllocationNumber);

            var storedDeliverable1 = deliverables.Single(d => d.DeliverableCode == 1);
            var storedDeliverable2 = deliverables.Single(d => d.DeliverableCode == 2);
            var storedDeliverable3 = deliverables.Single(d => d.DeliverableCode == 3);
            var storedDeliverable4 = deliverables.Single(d => d.DeliverableCode == 4);
            var storedDeliverable5 = deliverables.Single(d => d.DeliverableCode == 5);
            var storedDeliverable13 = deliverables.Single(d => d.DeliverableCode == 13);

            Assert.AreEqual(600, storedDeliverable1.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(400, storedDeliverable2.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(200, storedDeliverable3.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(200, storedDeliverable4.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(200, storedDeliverable5.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(200, storedDeliverable13.ActualValue, "Actual Value has not been aggregated correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationActualsRepository_WriteAllocationActualsToCrm_ShouldCorrectlyAggregateReceivedActualsOver3CollectionReturns()
        {
            // arrange
            ClearContractAndMasterContractForContractNumber(ContractNumber);
            SetUpContract();

            // act
            WriteAllocationActualsToCrmWithRetry(CreateAllocationActualsType(new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    DeliverableCode = 4,
                    Period = "201509",
                    ActualValue = 100
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 5,
                    Period = "201509",
                    ActualValue = 100
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 13,
                    Period = "201509",
                    ActualValue = 100
                }
            }));

            WriteAllocationActualsToCrmWithRetry(CreateAllocationActualsType(new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    DeliverableCode = 4,
                    Period = "201509",
                    ActualValue = 200,
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 5,
                    Period = "201509",
                    ActualValue = 200
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 13,
                    Period = "201509",
                    ActualValue = 200
                }
            }));

            WriteAllocationActualsToCrmWithRetry(CreateAllocationActualsType(new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    DeliverableCode = 4,
                    Period = "201509",
                    ActualValue = 300,
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 5,
                    Period = "201509",
                    ActualValue = 300
                },
                new ActualsSummaryType
                {
                    DeliverableCode = 13,
                    Period = "201509",
                    ActualValue = 300
                }
            }));

            var deliverables = GetDeliverablesForAllocation(AllocationNumber);

            var storedDeliverable1 = deliverables.Single(d => d.DeliverableCode == 1);
            var storedDeliverable2 = deliverables.Single(d => d.DeliverableCode == 2);
            var storedDeliverable3 = deliverables.Single(d => d.DeliverableCode == 3);
            var storedDeliverable4 = deliverables.Single(d => d.DeliverableCode == 4);
            var storedDeliverable5 = deliverables.Single(d => d.DeliverableCode == 5);
            var storedDeliverable13 = deliverables.Single(d => d.DeliverableCode == 13);

            Assert.AreEqual(900, storedDeliverable1.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(600, storedDeliverable2.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(300, storedDeliverable3.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(300, storedDeliverable4.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(300, storedDeliverable5.ActualValue, "Actual Value has not been aggregated correctly");
            Assert.AreEqual(300, storedDeliverable13.ActualValue, "Actual Value has not been aggregated correctly");
        }

        private void WriteAllocationActualsToCrmWithRetry(ContractAllocationActualsType allocationActualsType)
        {
            IAllocationActualsRepository xrmAllocationEvidenceManager = new AllocationActualsRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            xrmAllocationEvidenceManager.WriteAllocationActualsToCrm(allocationActualsType);
        }

        private static ContractAllocationActualsType CreateAllocationActualsType(List<ActualsSummaryType> actualsSummary)
        {
            return new ContractAllocationActualsType
            {
                ContractAllocationNumber = AllocationNumber,
                FundingStreamPeriodCode = FundingStreamPeriodCode,
                ContractReference = new ContractReferenceType
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = 0
                },
                ActualsSummary = actualsSummary
            };
        }

        private void ClearContractAndMasterContractForContractNumber(string contractNumber)
        {
            IOrganizationService organizationService =
                SFA.FCS.Worker.Common.Crm.CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => new { MasterId = c.sfa_ParentContractId.Id, ContractId = c.sfa_contractId })
                    .ToList()
                    .ForEach(c =>
                    {
                        organizationService.Delete(sfa_contract.EntityLogicalName, c.ContractId.Value);
                        organizationService.Delete(sfa_contract.EntityLogicalName, c.MasterId);
                    });
            }
        }

        private void SetUpContract()
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
                    sfa_Version = ContractVersionNumber,
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

        private EntityReference GetFundingStreamPeriod(XrmServiceContext context, string fspCode)
        {
            return context.sfa_fundingstreamperiodSet
                .Single(fsp => fsp.sfa_fundingstreamperiodcode == fspCode)
                .ToEntityReference();
        }

        private EntityReference GetFundingStream(XrmServiceContext context, string fundingStreamCode)
        {
            return context.sfa_fundingstreamSet
                .Single(fsp => fsp.sfa_fundingstreamcode== fundingStreamCode)
                .ToEntityReference();
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

        private static Dictionary<string, string> GetConnectionStringDictionary()
        {
            return new Dictionary<string, string>()
            {
                { "CRMIntegration", ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString }
            };
        }
    }
}