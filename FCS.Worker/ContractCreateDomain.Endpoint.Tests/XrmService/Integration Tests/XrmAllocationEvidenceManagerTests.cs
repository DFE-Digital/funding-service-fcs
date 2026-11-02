namespace ContractCreateDomain.Integration.XrmService.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.Tests.Infrastructure;
    using Endpoint.XrmService.DTOs;
    using Endpoint.XrmService.Repositories;
    using Endpoint.XrmService.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Client.Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class XrmAllocationEvidenceManagerTests 
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmAllocationEvidenceManager_AggregateDeliverablePeriodsIntoDeliverableInCrm_ShouldAggregateInCrmCorrectly()
        {
            // arrange
            const string testContractNumber = "TestXrmSfaNo";
            const string testAllocationNumber = "TestXrmAllocNumber";

            IOrganizationService xrmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            RemoveContract(testContractNumber);
            Guid contractId = CreateContract(testContractNumber);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = testAllocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };
            Guid allocationId = xrmConnection.Create(allocation);

            Guid deliverableId1 = xrmConnection.Create(new sfa_contractdeliverable
            {
                sfa_ActualVolume = 0,
                sfa_DeliverableCode = "1",
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
            });
            xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1),
                sfa_Period = 1,
                sfa_Year = 2017
            });
            xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1),
                sfa_Period = 2,
                sfa_Year = 2017
            });

            Guid deliverableId2 = xrmConnection.Create(new sfa_contractdeliverable
            {
                sfa_ActualVolume = 0,
                sfa_DeliverableCode = "2",
                sfa_ParentDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            });
            xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId2),
                sfa_Period = 1,
                sfa_Year = 2017
            });
            xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId2),
                sfa_Period = 2,
                sfa_Year = 2017
            });

            Guid deliverableId3 = xrmConnection.Create(new sfa_contractdeliverable
            {
                sfa_ActualVolume = 0,
                sfa_DeliverableCode = "3",
                sfa_ParentDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId2),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            });
            Guid period31Id = xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId3),
                sfa_Period = 1,
                sfa_Year = 2017
            });
            Guid period32Id = xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId3),
                sfa_Period = 2,
                sfa_Year = 2017
            });

            Guid deliverableId4 = xrmConnection.Create(new sfa_contractdeliverable
            {
                sfa_ActualVolume = 0,
                sfa_DeliverableCode = "4",
                sfa_ParentDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            });
            Guid period41Id = xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId4),
                sfa_Period = 1,
                sfa_Year = 2017
            });
            Guid period42Id = xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId4),
                sfa_Period = 1,
                sfa_Year = 2017
            });

            List<Deliverable> deliverables = GetDeliverablesAndPeriods(new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()), allocationId);

            Deliverable deliverable3 = deliverables.Single(d => d.DeliverableCode == "3");
            DeliverablePeriod period31 = deliverable3.DeliverablePeriods.Single(dp => dp.Id == period31Id);
            period31.ActualValue = 50;
            DeliverablePeriod period32 = deliverable3.DeliverablePeriods.Single(dp => dp.Id == period32Id);
            period32.ActualValue = 50;

            Deliverable deliverable4 = deliverables.Single(d => d.DeliverableCode == "4");
            DeliverablePeriod period41 = deliverable4.DeliverablePeriods.Single(dp => dp.Id == period41Id);
            period41.ActualValue = 35m;
            DeliverablePeriod period42 = deliverable4.DeliverablePeriods.Single(dp => dp.Id == period42Id);
            period42.ActualValue = 45m;

            AllocationDto allocationDto = new AllocationDto()
            {
                Deliverables = deliverables,
                CrmGuid = allocationId
            };

            // act
            new XrmAllocationEvidenceManager(new FundingStreamDeliverablePeriodRepository())
            {
                OrganizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService()
            }.AggregateDeliverablePeriodsIntoDeliverableInCrm(allocationDto);

            // assert
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                sfa_contractdeliverable del1 = crmContext.sfa_contractdeliverableSet.Single(d => d.Id == deliverableId1);
                sfa_contractdeliverable del2 = crmContext.sfa_contractdeliverableSet.Single(d => d.Id == deliverableId2);
                sfa_contractdeliverable del3 = crmContext.sfa_contractdeliverableSet.Single(d => d.Id == deliverableId3);
                sfa_contractdeliverable del4 = crmContext.sfa_contractdeliverableSet.Single(d => d.Id == deliverableId4);

                Assert.AreEqual(180m, del1.sfa_ActualValue.Value);
                Assert.AreEqual(100m, del2.sfa_ActualValue.Value);
                Assert.AreEqual(100m, del3.sfa_ActualValue.Value);
                Assert.AreEqual(80, del4.sfa_ActualValue.Value);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmAllocationEvidenceManager_AggregateDeliverablePeriodsIntoDeliverableInCrm_WhenSomeDeliverablesHaveNoActuals_ShouldAggregateCorrectly()
        {
            // arrange
            const string testContractNumber = "TestXrmSfaNo";
            const string testAllocationNumber = "TestXrmAllocNumber";

            IOrganizationService xrmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            RemoveContract(testContractNumber);
            Guid contractId = CreateContract(testContractNumber);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = testAllocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };

            Guid allocationId = xrmConnection.Create(allocation);

            Guid deliverableId1 = xrmConnection.Create(new sfa_contractdeliverable
            {
                sfa_ActualVolume = 0,
                sfa_DeliverableCode = "1",
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)

            });
            xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1),
                sfa_Period = 1,
                sfa_Year = 2017
            });
            xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1),
                sfa_Period = 2,
                sfa_Year = 2017
            });

            Guid deliverableId2 = xrmConnection.Create(new sfa_contractdeliverable
            {
                sfa_ActualVolume = 0,
                sfa_DeliverableCode = "2",
                sfa_ParentDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            });
            xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId2),
                sfa_Period = 1,
                sfa_Year = 2017
            });
            xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId2),
                sfa_Period = 2,
                sfa_Year = 2017
            });

            Guid deliverableId3 = xrmConnection.Create(new sfa_contractdeliverable
            {
                sfa_ActualVolume = 0,
                sfa_DeliverableCode = "3",
                sfa_ParentDeliverableId =
                    new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId2),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            });
            Guid period31Id = xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId3),
                sfa_Period = 1,
                sfa_Year = 2017
            });
            Guid period32Id = xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId3),
                sfa_Period = 2,
                sfa_Year = 2017
            });

            Guid deliverableId4 = xrmConnection.Create(new sfa_contractdeliverable
            {
                sfa_ActualVolume = 0,
                sfa_DeliverableCode = "4",
                sfa_ParentDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1),
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            });
            Guid period41Id = xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId4),
                sfa_Period = 1,
                sfa_Year = 2017
            });
            Guid period42Id = xrmConnection.Create(new sfa_contractdeliverableperiod()
            {
                sfa_ActualVolume = 1,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId4),
                sfa_Period = 2,
                sfa_Year = 2017
            });

            List<Deliverable> deliverables = GetDeliverablesAndPeriods(new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()), allocationId);

            Deliverable deliverable3 = deliverables.Single(d => d.DeliverableCode == "3");
            DeliverablePeriod period31 = deliverable3.DeliverablePeriods.Single(dp => dp.Id == period31Id);
            period31.ActualValue = null;
            DeliverablePeriod period32 = deliverable3.DeliverablePeriods.Single(dp => dp.Id == period32Id);
            period32.ActualValue = null;

            Deliverable deliverable4 = deliverables.Single(d => d.DeliverableCode == "4");
            DeliverablePeriod period41 = deliverable4.DeliverablePeriods.Single(dp => dp.Id == period41Id);
            period41.ActualValue = null;
            DeliverablePeriod period42 = deliverable4.DeliverablePeriods.Single(dp => dp.Id == period42Id);
            period42.ActualValue = 80m;

            AllocationDto allocationDto = new AllocationDto()
            {
                Deliverables = deliverables,
                CrmGuid = allocationId
            };

            // act
            new XrmAllocationEvidenceManager(new FundingStreamDeliverablePeriodRepository())
            {
                OrganizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService()
            }.AggregateDeliverablePeriodsIntoDeliverableInCrm(allocationDto);

            // assert
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                sfa_contractdeliverable del1 = crmContext.sfa_contractdeliverableSet.Single(d => d.Id == deliverableId1);
                sfa_contractdeliverable del2 = crmContext.sfa_contractdeliverableSet.Single(d => d.Id == deliverableId2);
                sfa_contractdeliverable del3 = crmContext.sfa_contractdeliverableSet.Single(d => d.Id == deliverableId3);
                sfa_contractdeliverable del4 = crmContext.sfa_contractdeliverableSet.Single(d => d.Id == deliverableId4);

                Assert.AreEqual(80m, del1.sfa_ActualValue.Value);
                Assert.IsNull(del2.sfa_ActualValue);
                Assert.IsNull(del3.sfa_ActualValue);
                Assert.AreEqual(80m, del4.sfa_ActualValue.Value);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmAllocationEvidenceManager_GetAllocationWithDeliverableAndPeriods_ShouldMapCorrectly()
        {
            // arrange
            IOrganizationService crmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            const string testContractNumber = "TestXrmSfaNo";
            const string testAllocationNumber = "TestXrmAllocNumber";

            const int expectedDeliverableCode = 1;
            const int expectedPeriod = 1;
            const int expectedPeriodYear = 2017;
            const decimal expectedActualValue = 105;
            const int expectedActualVolume = 10;
            const int expectedNetPaymentAmount = 99;
            const decimal expectedBalancingPaymentAmount = 103;
            const decimal expectedCappedPaymentAmount = 100;
            const decimal expectedProfilePaymentAmount = 102;
            const decimal expectedReconciliationPaymentAmount = 101;

            RemoveContract(testContractNumber);

            Guid contractId = CreateContract(testContractNumber);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = testAllocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };
            Guid allocationId = crmConnection.Create(allocation);

            sfa_contractdeliverable deliverableToCrm0 = new sfa_contractdeliverable
            {
                sfa_DeliverableCode = "0",
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
            };
            Guid deliverableId0 = crmConnection.Create(deliverableToCrm0);

            sfa_contractdeliverable deliverableToCrm1 = new sfa_contractdeliverable
            {
                sfa_DeliverableCode = "1",
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_ParentDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId0)
            };
            Guid deliverableId1 = crmConnection.Create(deliverableToCrm1);

            sfa_contractdeliverableperiod period11Crm = new sfa_contractdeliverableperiod()
            {
                sfa_Period = expectedPeriod,
                sfa_Year = expectedPeriodYear,
                sfa_ActualValue = expectedActualValue,
                sfa_ActualVolume = expectedActualVolume,
                sfa_NetPaymentAmount = expectedNetPaymentAmount,
                sfa_BalancingPaymentAmount = expectedBalancingPaymentAmount,
                sfa_CappedPaymentAmount = expectedCappedPaymentAmount,
                sfa_ProfilePaymentAmount = expectedProfilePaymentAmount,
                sfa_ReconciliationPaymentAmount = expectedReconciliationPaymentAmount,
                sfa_PaymentPosted = true,
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId1)
            };
            Guid period11Id = crmConnection.Create(period11Crm);

            contractDeliverableType deliverableType1 = CreateDeliverableType(expectedDeliverableCode);
            deliverableType1.deliverable.isLegal = true;
            deliverableType1.deliverable.isMonitoring = true;

            allocationType allocationType = new allocationType // bare minimum 
            {
                contractDeliverables = new List<contractDeliverableType>()
                {
                    deliverableType1
                }
            };

            // act
            AllocationDto allocationReturned = new XrmAllocationEvidenceManager(new FundingStreamDeliverablePeriodRepository())
            {
                OrganizationService = crmConnection
            }.GetDeliverablesAndPeriods(new XrmServiceContext(crmConnection), allocationId, allocationType);

            // assert
            Deliverable deliverable = allocationReturned.Deliverables[0];

            Assert.AreEqual(allocationId, allocationReturned.CrmGuid, "CrmGuid inside AllocationDto had an unexpected value");
            Assert.AreEqual(1, allocationReturned.Deliverables.Count, "AllocationDtohad an unexpected count of deliverable");

            Assert.AreEqual(expectedDeliverableCode.ToString(), deliverable.DeliverableCode, "DeliverableCode inside DeliverableDto had an unexpected value");
            Assert.AreEqual(deliverableId0, deliverable.ParentDeliverableId, "ParentDeliverableId inside DeliverableDto had an unexpected value");
            Assert.AreEqual(deliverableId1, deliverable.Id, "Id inside DeliverableDto had an unexpected value");
            Assert.AreEqual(true, deliverable.IsLegal, "IsLegal inside DeliverableDto had an unexpected value");
            Assert.AreEqual(true, deliverable.IsMonitoring, "IsMonitoring inside DeliverableDto had an unexpected value");
            Assert.AreEqual(1, deliverable.DeliverablePeriods.Count, "DeliverableDto had an unexpected count of deliverable periods");

            var deliverablePeriod = deliverable.DeliverablePeriods[0];
            Assert.AreEqual(period11Id, deliverablePeriod.Id, "Id inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedPeriodYear, deliverablePeriod.Year, "Year inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedPeriod, deliverablePeriod.PeriodNumber, "PeriodNumber inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedActualValue, deliverablePeriod.ActualValue, "ActualValue inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedActualVolume, deliverablePeriod.ActualVolume, "ActualVolume inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedNetPaymentAmount, deliverablePeriod.NetPaymentValue, "NetPaymentValue inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedBalancingPaymentAmount, deliverablePeriod.BalancingPaymentValue, "BalancingPaymentValue inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedCappedPaymentAmount, deliverablePeriod.CappedPaymentValue, "CappedPaymentValue inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedProfilePaymentAmount, deliverablePeriod.ProfilePaymentValue, "ProfilePaymentValue inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(expectedReconciliationPaymentAmount, deliverablePeriod.ReconciliationPaymentValue, "ReconciliationPaymentValue inside DeliverablePeriodDto has an unexpected value");
            Assert.AreEqual(true, deliverablePeriod.PaymentPosted, "PaymentPosted inside DeliverablePeriodDto has an unexpected value");

        }

        public List<Deliverable> GetDeliverablesAndPeriods(XrmServiceContext xrmContext, Guid allocationId)
        {
            var dataset = (
                from deliverable in xrmContext.sfa_contractdeliverableSet
                join deliverablePeriod in xrmContext.sfa_contractdeliverableperiodSet
                    on deliverable.Id equals deliverablePeriod.sfa_ContractDeliverableId.Id
                where deliverable.sfa_ContractAllocationId.Id.Equals(allocationId)
                select new
                {
                    deliverable,
                    deliverablePeriod
                }).ToList();

            // Group into the required heirarchy
            List<Deliverable> deliverables = new List<Deliverable>();

            foreach (var d in dataset)
            {
                var del = deliverables.FirstOrDefault(de => de.DeliverableCode.Equals(d.deliverable.sfa_DeliverableCode));

                var dp = new DeliverablePeriod
                {
                    Id = d.deliverablePeriod.sfa_contractdeliverableperiodId ?? Guid.Empty,
                    PeriodNumber = d.deliverablePeriod.sfa_Period,
                    Year = d.deliverablePeriod.sfa_Year,
                    ActualValue = d.deliverablePeriod.sfa_ActualValue,
                    ActualVolume = d.deliverablePeriod.sfa_ActualVolume,
                    BalancingPaymentValue = d.deliverablePeriod.sfa_BalancingPaymentAmount,
                    CappedPaymentValue = d.deliverablePeriod.sfa_CappedPaymentAmount,
                    NetPaymentValue = d.deliverablePeriod.sfa_NetPaymentAmount,
                    PaymentPosted = d.deliverablePeriod.sfa_PaymentPosted,
                    ProfilePaymentValue = d.deliverablePeriod.sfa_ProfilePaymentAmount,
                    ReconciliationPaymentValue = d.deliverablePeriod.sfa_ReconciliationPaymentAmount,
                    CappingSubnominalId = (d.deliverablePeriod.sfa_CappingSubnominal != null ? d.deliverablePeriod.sfa_CappingSubnominal.Id : Guid.Empty),
                    ProfileSubnominalId = (d.deliverablePeriod.sfa_profilesubnominal != null ? d.deliverablePeriod.sfa_profilesubnominal.Id : Guid.Empty),
                    ReconcilliationSubnominalId = (d.deliverablePeriod.sfa_reconciliationsubnominal != null ? d.deliverablePeriod.sfa_reconciliationsubnominal.Id : Guid.Empty),
                    Modified = false
                };

                if (del == null)
                {
                    del = new Deliverable
                    {
                        Id = d.deliverable.Id,
                        DeliverableCode = d.deliverable.sfa_DeliverableCode,
                        ParentDeliverableId = d.deliverable.sfa_ParentDeliverableId?.Id,
                        ActualValue = d.deliverable.sfa_ActualValue
                    };
                    deliverables.Add(del);
                }

                del.DeliverablePeriods.Add(dp);
            }

            return deliverables;
        }
        
        private static contractDeliverableType CreateDeliverableType(int deliverableCode)
        {
            return new contractDeliverableType
            {
                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                {
                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                    {
                        plannedValue = 0M,
                        plannedVolume = 0,
                        period = new periodType
                        {
                            periodType1 = new periodTypeType
                            {
                                periodTypeCode =
                                    SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation.periodTypeCodeType.CM,
                                periodTypeName = periodTypeNameType.CALENDARMONTH
                            },
                            periodValue = "201501",
                        }
                    },
                },

                deliverable = new deliverableType
                {
                    deliverableCode = deliverableCode,
                    deliverableName = "DelName",
                    isLegal = true,
                    isMonitoring = false
                },
                deliverableDescription = "delDescription",
                plannedValue = 100M,
                plannedVolume = 10,
            };
        }

        private static void RemoveContract(string contractNumber)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                List<Guid> contractIds = xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id).ToList();

                contractIds.ForEach(c => organizationSvc.Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private static Guid CreateContract(string contractNumber)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationSvc))
            {
                sfa_contract contract = new sfa_contract
                {
                    sfa_number = contractNumber,
                    sfa_Version = 1,
                    sfa_SubVersion = 0,
                    sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Draft),
                    sfa_SubStatus = GetSubstatus(xrmContext, "In Review"),
                    sfa_ProviderName = GetFirstProvider(xrmContext)
                };

                return organizationSvc.Create(contract);
            }
        }

        private static EntityReference GetSubstatus(XrmServiceContext crmContext, string subStatusName)
        {
            return crmContext.sfa_statusSet.Single(s => s.sfa_name == subStatusName).ToEntityReference();
        }

        private static EntityReference GetFirstProvider(XrmServiceContext crmContext)
        {
            Guid orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
            return new EntityReference(Account.EntityLogicalName, orgId);
        }
    }
}