namespace PaymentGenerationDomain.Endpoint.Tests.PaymentPostedEndpoint
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using BusinessLogic.Exceptions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.Framework.Logging;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class XrmAllocationManagerTests
    {
        private const string AllocationNumber = "16AP-9999";
        private const string FundingStreamPeriodCode = "16-18APPS1516";
        private const string MainOrganisationIdentifier = "ORG0000001";
        private const string Ukprn = "999999";
        private const string UpdatePaymentTransmissionOrg = "Update Payment Transmission Org";
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void UpdatePaymentTransmissionStatus_WhenNoMatchingAllocationFound_ThrowAllocationNotFoundException()
        {
            // Arrange
            var periods = new List<AllocationPeriod>
            {
                new AllocationPeriod
                {
                    Period = "201508",
                    PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                    Aggregations = new List<Aggregation>
                    {
                        new Aggregation
                        {
                            AggregatedValue = 1000,
                            SubnominalCode = "C00001",
                            PostedFlag = true
                        }
                    }
                },
                new AllocationPeriod
                {
                    Period = "201509",
                    PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                    Aggregations = new List<Aggregation>
                    {
                        new Aggregation
                        {
                            AggregatedValue = 1000,
                            SubnominalCode = "C00002",
                            PostedFlag = true
                        }
                    }
                }
            };

            Allocation allocation = CreateAllocation("InvalidAllocationNumber", FundingStreamPeriodCode, MainOrganisationIdentifier, Ukprn, periods);

            IXrmAllocationManager allocationManager = new XrmAllocationManager
            {
                OrgService = CrmConnectionFactory.GetRetryOnErrorOrganizationService(),
                Logger = Mock.Of<ILogger>()
            };

            try
            {
                // Act
                allocationManager.UpdatePaymentTransmissionStatus(allocation, true);
                Assert.Fail("We have not thrown a ContractAllocationNotFoundException");
            }

            catch (ContractAllocationNotFoundException)
            { 
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UpdatePaymentTransmissionStatus_WhenMatchingAllocationFound_UpdateAllDeliverablePeriods()
        {
            // Arrange
            const string subnominalCode1 = "C00001";
            const string subnominalCode2 = "C00002";
            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 1;
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            DateTime initialContractStartDateTime = new DateTime(2019, 11, 01);
            const string mayPeriodName = "May 20";
            const string junePeriodName = "Jun 20";
            RemoveContract(contractNumberToTest, versionToTest);
            DeleteOrgsForUkprn(Ukprn);
            DeleteSubnominalAggregationsForCode(subnominalCode1);
            DeleteSubnominalAggregationsForCode(subnominalCode2);

            Account org = new Account { sfa_UKPRN = Ukprn, Name = UpdatePaymentTransmissionOrg + " " + Ukprn };

            Guid accountId = connection.Create(org);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, accountId),
                sfa_organisationname = UpdatePaymentTransmissionOrg + " " + Ukprn
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(caseload);
            Guid subnominalAggregation1Id = CreateSubnominalAggregation(subnominalCode1);
            Guid subnominalAggregation2Id = CreateSubnominalAggregation(subnominalCode2);

            Guid fundingType = GetFundingType("LEVY");
            Guid period = GetPeriod("LEVY1799");

            Guid contractId = CreateTestContract(contractNumberToTest, fundingType, period, lastApprovedVersion: true, version: versionToTest, startDateTime: initialContractStartDateTime);
            Guid allocationId = CreateContractAllocation(contractId: contractId, setupDateTime: initialContractStartDateTime, allocationNumber: AllocationNumber);
            Guid deliverableId = CreateDeliverable(allocationId);
            var cappingSubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName, subnominalAggregation1Id);
            var reconciliationSubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName, subnominalAggregation2Id);
            Guid mayDeliverablePeriodId = CreateDeliverablePeriod(
                contractDeliverableId: deliverableId,
                periodNumber: 5,
                year:2020,
                periodName: mayPeriodName,
                cappingSubnominalAgg: cappingSubnominal,
                reconciliationSubnominalAgg: reconciliationSubnominal);

            Guid juneDeliverablePeriodId = CreateDeliverablePeriod(
                contractDeliverableId: deliverableId,
                periodNumber: 6,
                year: 2020,
                periodName: junePeriodName,
                cappingSubnominalAgg: cappingSubnominal,
                reconciliationSubnominalAgg: reconciliationSubnominal);

            Guid julyDeliverablePeriodId = CreateDeliverablePeriod(
                contractDeliverableId: deliverableId,
                periodNumber: 7,
                year: 2020,
                periodName: "Jul 20",
                cappingSubnominalAgg: null, 
                reconciliationSubnominalAgg: null);

            var periods = new List<AllocationPeriod>
            {
                new AllocationPeriod
                {
                    Period = "202005",
                    PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                    Aggregations = new List<Aggregation>
                    {
                        new Aggregation
                        {
                            AggregatedValue = 1000,
                            SubnominalCode = subnominalCode1,
                            PostedFlag = true
                        }
                    }
                },
                new AllocationPeriod
                {
                    Period = "202006",
                    PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                    Aggregations = new List<Aggregation>
                    {
                        new Aggregation
                        {
                            AggregatedValue = 1000,
                            SubnominalCode = subnominalCode2,
                            PostedFlag = true
                        }
                    }
                }
            };

            Allocation allocation = CreateAllocation(AllocationNumber, FundingStreamPeriodCode,
                MainOrganisationIdentifier, Ukprn, periods);

            ILoggerFactory factory = new LoggerFactory();

            IXrmAllocationManager allocationManager = new XrmAllocationManager
            {
                OrgService = CrmConnectionFactory.GetRetryOnErrorOrganizationService(),
                Logger = Mock.Of<ILogger>()
            };

            // Act
            allocationManager.UpdatePaymentTransmissionStatus(allocation, true);

            // Assert
            sfa_contractdeliverableperiod dpMay = GetContractDeliverablePeriod(mayDeliverablePeriodId);
            sfa_contractdeliverableperiod dpJune = GetContractDeliverablePeriod(juneDeliverablePeriodId);
            sfa_contractdeliverableperiod dpJul = GetContractDeliverablePeriod(julyDeliverablePeriodId);

            Assert.IsTrue(dpMay.sfa_PaymentPosted.GetValueOrDefault(), "Payment Posted Flag is set incorrectly May");
            Assert.IsTrue(dpJune.sfa_PaymentPosted.GetValueOrDefault(), "Payment Posted Flag is set incorrectly June");
            Assert.IsFalse(dpJul.sfa_PaymentPosted.GetValueOrDefault(), "Payment Posted Flag is set incorrectly July");
        }

        private static Allocation CreateAllocation(string allocationNumber, string fundingStreamPeriodCode,
            string mainOrganisationIdentifier, string organisationId, List<AllocationPeriod> allocationPeriods)
        {
            var allocation = new Allocation
            {
                AllocationNumber = allocationNumber,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = mainOrganisationIdentifier,
                    AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                    {
                        new OrgainsationIdentifier
                        {
                            OrganisationId = organisationId,
                            OrganisationIdentifierName =
                                OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                VersionNumber = 1,
                AllocationPeriods = allocationPeriods
            };

            return allocation;
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

        private void DeleteSubnominalAggregationsForCode(string subnominalCode)
        {
            IOrganizationService organizationSvc = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(organizationSvc))
            {
                context.sfa_subnominalaggregationSet.Where(sa => sa.sfa_SubnominalCode == subnominalCode)
                    .Select(sa => sa.sfa_subnominalaggregationId.Value)
                    .ToList()
                    .ForEach(id => organizationSvc.Delete(sfa_subnominalaggregation.EntityLogicalName, id));
            }
        }

        private Guid CreateSubnominalAggregation(string subnominalCode)
        {
            sfa_subnominalaggregation subnominalAggregation = new sfa_subnominalaggregation
            {
                sfa_SubnominalCode = subnominalCode,
                sfa_name = subnominalCode
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(subnominalAggregation);
        }

        private static Guid CreateTestContract(string contractNumber, Guid fundingType, Guid period, bool lastApprovedVersion, int version, DateTime startDateTime)
        {
            IOrganizationService orgService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = lastApprovedVersion,
                sfa_ProviderName = GetProvider(),
                sfa_FundingType = new EntityReference(sfa_fundingtype.EntityLogicalName, fundingType),
                sfa_PeriodId = new EntityReference(sfa_period.EntityLogicalName, period),
                sfa_StartDate = startDateTime
            };
            return orgService.Create(contract);
        }

        private static EntityReference GetProvider()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                var orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null)
                    .Select(o => o.Id)
                    .First();

               return new EntityReference(Account.EntityLogicalName, orgId);
            }
        }

        private static Guid CreateContractAllocation(Guid contractId, DateTime setupDateTime, string allocationNumber)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_startdate = new DateTime(year: setupDateTime.Year,
                                             month: setupDateTime.Month,
                                             day: setupDateTime.Day,
                                             hour: setupDateTime.Hour,
                                             minute: setupDateTime.Minute,
                                             second: setupDateTime.Second),
                sfa_contractallocationnumber = allocationNumber
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(allocation);
        }

        private static Guid CreateDeliverable(Guid allocationId)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contract.EntityLogicalName, allocationId),
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(deliverable);
        }

        private Guid CreateDeliverablePeriod(
            Guid contractDeliverableId,
            int periodNumber,
            int year,
            string periodName,
            EntityReference cappingSubnominalAgg,
            EntityReference reconciliationSubnominalAgg)
        {
            sfa_contractdeliverableperiod deliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contract.EntityLogicalName, contractDeliverableId),
                sfa_Period = periodNumber,
                sfa_Year = year,
                sfa_PeriodName = periodName,
                sfa_CappingSubnominal = cappingSubnominalAgg,
                sfa_reconciliationsubnominal = reconciliationSubnominalAgg,
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(deliverableperiod);
        }

        private static void RemoveContract(string contractNumber, int verion)
        {
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var context = new XrmServiceContext(connection))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber && c.sfa_Version == verion)
                    .ToList().ForEach(c => connection.Delete(sfa_contract.EntityLogicalName, c.Id));
            }
        }

        private static Guid GetFundingType(string fundingTypeCode)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return serviceContext.sfa_fundingtypeSet.First(f => f.sfa_fundingtypecode == fundingTypeCode).Id;
            }
        }

        private static Guid GetPeriod(string periodName)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return serviceContext.sfa_periodSet.First(p => p.sfa_periodname == periodName).Id;
            }
        }

        private sfa_contractdeliverableperiod GetContractDeliverablePeriod(Guid id)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return serviceContext.sfa_contractdeliverableperiodSet.First(p => p.Id == id);
            }
        }
    }
}
