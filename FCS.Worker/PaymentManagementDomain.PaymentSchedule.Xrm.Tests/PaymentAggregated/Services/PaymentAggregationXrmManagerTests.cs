namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated.Services
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;
    using MoreLinq;
    using Newtonsoft.Json;
    using PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Services;
    using PaymentSchedule.PaymentAggregated.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.DTOs;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Repositories;

    [TestClass]
    public class PaymentAggregationXrmManagerTests
    {
        private const string UkprnTest = "123_Test";
        private const string ContractNumber = "XXXX-Contract-Test";
        private const string FundingStreamPeriodCode = "24+ALLBC1516";


        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationXrmManager_ShouldResolveFromContainer()
        {
            IPaymentAggregationXrmManager paymentAggregationXrmManager =
                GetXrmEndpointContainer().Resolve<IPaymentAggregationXrmManager>();

            Assert.IsNotNull(paymentAggregationXrmManager);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationXrmManager_ShouldNotCreateSubnominalWhenDeliverablePeriodIsNotPresent()
        {
            // arrange
            const string allocationNumber = "XXXX-Alloc-Test";
            const string subnominalCode = "XXXX-SC-Test";

            DeleteSubnominalsForCode(subnominalCode);
            DeleteTestContract(ContractNumber);

            IPaymentAggregationXrmManager xrmManager = GetXrmEndpointContainer().Resolve<IPaymentAggregationXrmManager>();

            var allocation = CreateAllocation(allocationNumber, subnominalCode, UkprnTest);
            bool exceptionThrown = false;

            // act
            try
            {
                xrmManager.SavePaymentAggregation(allocation, new List<ContractDeliverablePeriodInfo>());
            }
            catch
            {
                exceptionThrown = true;
            }

            // assert
            int numSubnominals = GetSubnominalsForCode(subnominalCode).Count;
            Assert.AreEqual(0, numSubnominals, "Subnominal(s) have been created");
            Assert.AreEqual(true, exceptionThrown, "Exception has not been thrown");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationXrmManager_ShouldCreateSubnominalWhenAllDeliverablePeriodsArePresent()
        {
            // arrange
            const string allocationNumber = "XXXX-Alloc-Test";
            const string subnominalCode = "XXXX-SC-Test";

            DeleteSubnominalsForCode(subnominalCode);
            DeleteTestContract(ContractNumber);
            DeleteTestAllocation(allocationNumber);
            Guid contractGuid = CreateTestContract(ContractNumber, UkprnTest);
            Guid allocationId = CreateTestAllocation(contractGuid, allocationNumber);
            Guid deliverableId = CreateTestDeliverable(allocationId, 1);
            Guid deliverablePeriodId = CreateTestDeliverablePeriods(deliverableId);

            IReadOnlyCollection<ContractDeliverablePeriodInfo> cdpsAlreadyInCRM = new List<ContractDeliverablePeriodInfo>()
            {
                new ContractDeliverablePeriodInfo(GetContractAllocationByGuid(allocationId), GetContractDeliverablePeriodByCdpGuid(deliverablePeriodId), "Aug-15", "1")
            };

            IPaymentAggregationXrmManager xrmManager = GetXrmEndpointContainer().Resolve<IPaymentAggregationXrmManager>();

            var allocation = CreateAllocation(allocationNumber, subnominalCode, UkprnTest);
            bool exceptionThrown = false;

            // act
            try
            {
                xrmManager.SavePaymentAggregation(allocation, cdpsAlreadyInCRM);
            }
            catch
            {
                exceptionThrown = true;
            }

            // assert
            IReadOnlyCollection<sfa_subnominalaggregation> subnominals = GetSubnominalsForCode(subnominalCode);
            Assert.AreEqual(1, subnominals.Count, "Subnominal has not been created");
            sfa_subnominalaggregation subnominalaggregation = subnominals.First();
            string fspCode = GetFundingStreamPeriodCodeForFspGuid(subnominalaggregation.sfa_fundingstreamperiod.Id);
            Assert.AreEqual(FundingStreamPeriodCode, fspCode, "The FSP associated with this subnominal aggregation is incorrect");
            var deliverables = GeRelatedDeliverablePeriods(subnominalCode);
            Assert.AreEqual(1, deliverables.Count, "The deliverables have not been related");
            Assert.AreEqual(false, exceptionThrown, "Exception has been thrown");
            Assert.AreEqual(GetOrg(UkprnTest).Id, subnominalaggregation.sfa_provider.Id, "The provider has not been set on the subnominal aggregation");

            sfa_contractdeliverableperiod cdp = GetContractDeliverablePeriod(deliverableId);
            Assert.IsNotNull(cdp.sfa_profilesubnominal, "The profile is null");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationXrmManager_ShouldCreateSubnominalAllocationAssociationWhenSubnominalAggHasBeenCreatedAndAssociationsArentPresent()
        {
            // arrange
            const string allocationNumber = "Alloc-Test";
            const string subnominalCode = "XXXX-SC-Test";
            string subnominalAggKey = subnominalCode + "_" + allocationNumber + "_Aug-15";

            DeleteTestAllocation(allocationNumber);
            DeleteSubnominalsForAggregationKey(subnominalAggKey);
            DeleteTestContract(ContractNumber);

            Guid subnominalAggId = CreateSubnominalAggregation(subnominalAggKey, sfa_paymenttype.Profile, subnominalCode);

            Guid contractGuid = CreateTestContract(ContractNumber, UkprnTest);
            Guid allocationId = CreateTestAllocation(contractGuid, allocationNumber);
            Guid deliverableId = CreateTestDeliverable(allocationId, 1);
            Guid deliverablePeriodId = CreateTestDeliverablePeriods(deliverableId);

            var allocation = CreateAllocation(allocationNumber, subnominalCode, UkprnTest);

            IReadOnlyCollection<ContractDeliverablePeriodInfo> cdpsAlreadyInCRM = new List<ContractDeliverablePeriodInfo>()
            {
                new ContractDeliverablePeriodInfo(GetContractAllocationByGuid(allocationId), GetContractDeliverablePeriodByCdpGuid(deliverablePeriodId), "Aug-15", "1")
            };

            IPaymentAggregationXrmManager xrmManager =
                GetXrmEndpointContainer().Resolve<IPaymentAggregationXrmManager>();

            // act
            xrmManager.SavePaymentAggregation(allocation, cdpsAlreadyInCRM);

            // assert
            var relatedRecords = GetRelatedRecords(allocationNumber);
            sfa_subnominalaggregation relatedSubnominalAggegation = relatedRecords.Entities.FirstOrDefault() as sfa_subnominalaggregation;
            Assert.IsNotNull(relatedSubnominalAggegation, "We have not related this allocation to a subnominal");
            Assert.AreEqual(subnominalAggId, relatedSubnominalAggegation.Id, "The subnominal aggregation that is related to the allocation is not the correct one");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationXrmManager_ShouldCreateSubnominalLinkedToDeliveryOrganisationWhenDeliveryOrgPresent()
        {
            // arrange
            const string allocationNumber = "XXXX-Alloc-Test";
            const string subnominalCode = "XXXX-SC-Test";
            const string contractingOrgUkprn = "123-Contracting-Org";
            const string deliveryOrgUkprn = "456-Delivery-Org";

            DeleteSubnominalsForCode(subnominalCode);
            DeleteTestContract(ContractNumber);
            DeleteTestAllocation(allocationNumber);
            Guid contractGuid = CreateTestContract(ContractNumber, contractingOrgUkprn);
            Guid allocationId = CreateTestAllocation(contractGuid, allocationNumber, deliveryOrgUkprn);
            Guid deliverableId = CreateTestDeliverable(allocationId, 1);
            Guid deliverablePeriodId = CreateTestDeliverablePeriods(deliverableId);

            IReadOnlyCollection<ContractDeliverablePeriodInfo> cdpsAlreadyInCrm = new List<ContractDeliverablePeriodInfo>()
            {
                new ContractDeliverablePeriodInfo(GetContractAllocationByGuid(allocationId), GetContractDeliverablePeriodByCdpGuid(deliverablePeriodId), "Aug-15", "1")
            };

            IPaymentAggregationXrmManager xrmManager = GetXrmEndpointContainer().Resolve<IPaymentAggregationXrmManager>();

            Allocation allocation = CreateAllocation(allocationNumber, subnominalCode, deliveryOrgUkprn);

            // act
            xrmManager.SavePaymentAggregation(allocation, cdpsAlreadyInCrm);

            // assert
            sfa_subnominalaggregation subnominalaggregation = GetSubnominalsForCode(subnominalCode).First();
            Assert.AreEqual(GetOrg(deliveryOrgUkprn).Id, subnominalaggregation.sfa_provider.Id, "The Subnominal Aggregation has not been linked to the Delivery Organisation in CRM");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationXrmManager_ShouldInsertAggregatedValues()
        {
            // arrange
            const string allocationNumber = "AEC-551";
            const string contractingOrgUkprn = "123-Contracting-Org";
            const string deliveryOrgUkprn = "456-Delivery-Org";

            DeleteTestContract(ContractNumber);
            DeleteTestAllocation(allocationNumber);
            Allocation allocation =
                FromJson<AllocationPaymentsChangedOnAggregationEvent>(
                    "Resources.AllocationPaymentsChangedOnAggregationEvent_AEC_551.json").Allocation;
            allocation.AllocationPeriods.ForEach(ap =>
            {
                ap.Aggregations.ForEach(agg =>
                {
                    int monthNumber = int.Parse(ap.Period.Substring(4, 2));
                    string monthName = new DateTime(2010, monthNumber, 1).ToString("MMM",
                        CultureInfo.InvariantCulture);
                    string paymentPeriod = monthName + "-" + ap.Period.Substring(2, 2);
                    var aggregrateKey = $"{agg.SubnominalCode}_{allocation.AllocationNumber}_{paymentPeriod}";
                    DeleteSubnominalsForKey(aggregrateKey);
                });
            });
            CreateProviderIfNotPresent(allocation.Organisation.GetUkprn());
            Guid contractGuid = CreateTestContract(ContractNumber, contractingOrgUkprn);
            Guid allocationId = CreateTestAllocation(contractGuid, allocationNumber, deliveryOrgUkprn);
            Guid deliverable13Id = CreateTestDeliverable(allocationId, 13);
            Guid deliverable14Id = CreateTestDeliverable(allocationId, 14);
            var periodNames = allocation.AllocationPeriods.Select(ap => ToPeriodName(ap.Period));
            CreateTestDeliverablePeriods(deliverable13Id, periodNames);
            CreateTestDeliverablePeriods(deliverable14Id, periodNames);

            ContractDeliverablePeriodRepository contractDeliverablePeriodRepository = new ContractDeliverablePeriodRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            var cdpsAlreadyInCrm =
                contractDeliverablePeriodRepository.GetContractDeliverablePeriodsForAllocation(allocationNumber);

             IPaymentAggregationXrmManager xrmManager = GetXrmEndpointContainer().Resolve<IPaymentAggregationXrmManager>();

            // act
            xrmManager.SavePaymentAggregation(allocation, cdpsAlreadyInCrm);

            // assert
            SubnominalAggregationRepository subnominalAggregationRepository = new SubnominalAggregationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            IReadOnlyCollection<sfa_subnominalaggregation> relatedSubnominalAggregations = subnominalAggregationRepository.GetSubnominalsRelatedToSubnominalCodesAndAggregateKeys(
                subnominalCodes: allocation.GetDistinctSubnominalCodes(),
                aggregateKeys: allocation.GetDistinctAggregateKeys());

            allocation.AllocationPeriods.ForEach(ap =>
            {
                ap.Aggregations.ForEach(agg =>
                {
                    int monthNumber = int.Parse(ap.Period.Substring(4, 2));
                    string monthName = new DateTime(2010, monthNumber, 1).ToString("MMM",
                        CultureInfo.InvariantCulture);
                    string paymentPeriod = monthName + "-" + ap.Period.Substring(2, 2);
                    var aggregrateKey = $"{agg.SubnominalCode}_{allocation.AllocationNumber}_{paymentPeriod}";
                    var subnominalaggregation = relatedSubnominalAggregations.Single(sa => sa.sfa_SubnominalAggregateKey == aggregrateKey);
                    Assert.AreEqual(agg.AggregatedValue, subnominalaggregation.sfa_AggregatedValue.Value, $"The agg value is not set: {aggregrateKey}");
                });
            });
        }

        private static T FromJson<T>(string resourceName)
        {
            const string nameSpace = "PaymentManagementDomain.PaymentSchedule.Xrm.Tests";
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }

        private static string ToPeriodName(string period)
        {
            return DateTime.ParseExact(
                period, "yyyyMM", null).ToString("MMM-yy");
        }

        private static IWindsorContainer GetXrmEndpointContainer()
        {
            ILoggerFactory factory = new LoggerFactory();
            var container = new WindsorContainer();
            container.Install(new PaymentSchedule.PaymentAggregated.WindsorInstaller(factory));
            container.Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
            container.BeginScope();

            return container;
        }

        private string GetFundingStreamPeriodCodeForFspGuid(Guid fspGuid)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.sfa_fundingstreamperiodSet.Single(fsp => fsp.Id == fspGuid).sfa_fundingstreamperiodcode;
            }
        }

        private sfa_contractallocation GetContractAllocationByGuid(Guid contractAllocationId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.sfa_contractallocationSet.Single(ca => ca.Id == contractAllocationId);
            }
        }

        private void DeleteSubnominalsForAggregationKey(string subnominalAggKey)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                xrmContext.sfa_subnominalaggregationSet.Where(sa => sa.sfa_SubnominalAggregateKey == subnominalAggKey)
               .ForEach(sa => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_subnominalaggregation.EntityLogicalName, sa.Id));
            }
        }

        private static void CreateProviderIfNotPresent(string ukprnStr)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                if (xrmContext.AccountSet.Where(o => o.sfa_UKPRN == ukprnStr).Select(o => o.Id).ToList().Count == 0)
                {
                    Account account = new Account
                    {
                        sfa_UKPRN = ukprnStr,
                        sfa_OrganisationID = ukprnStr,
                        Name = ukprnStr
                    };

                    CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(account);
                }
            }
        }

        private EntityCollection GetRelatedRecords(string allocationNumber)
        {
            string contractallocationidColumn = "sfa_contractallocationid";
            string entity1PF = "sfa_subnominalaggregationid";
            const string RelationshipEntityName = "sfa_sfa_subnominalaggregation_sfa_contracta";

            QueryExpression query = new QueryExpression(sfa_subnominalaggregation.EntityLogicalName)
            {
                ColumnSet = new ColumnSet(true)
            };
            LinkEntity linkEntity1 = new LinkEntity(sfa_subnominalaggregation.EntityLogicalName, RelationshipEntityName,
                entity1PF, entity1PF, JoinOperator.Inner);
            LinkEntity linkEntity2 = new LinkEntity(RelationshipEntityName, sfa_contractallocation.EntityLogicalName,
                contractallocationidColumn, contractallocationidColumn, JoinOperator.Inner);
            linkEntity1.LinkEntities.Add(linkEntity2);
            query.LinkEntities.Add(linkEntity1);

            linkEntity2.LinkCriteria = new FilterExpression();
            linkEntity2.LinkCriteria.AddCondition(new ConditionExpression("sfa_contractallocationnumber",
                ConditionOperator.Equal, allocationNumber));

            EntityCollection recordcollection = CrmConnectionFactory.GetRetryOnErrorOrganizationService().RetrieveMultiple(query);
            return recordcollection;
        }

        private Guid CreateSubnominalAggregation(string subnominalAggKey, sfa_paymenttype paymentType, string subnominalCode)
        {
            sfa_subnominalaggregation subnominalaggregation = new sfa_subnominalaggregation
            {
                sfa_SubnominalAggregateKey = subnominalAggKey,
                sfa_PaymentTypeEnum = paymentType,
                sfa_name = subnominalCode,
                sfa_SubnominalCode = subnominalCode
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(subnominalaggregation);
        }

        private sfa_contractdeliverableperiod GetContractDeliverablePeriod(Guid deliverableId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.sfa_contractdeliverableperiodSet.First(cdp => cdp.sfa_ContractDeliverableId.Id == deliverableId);
            }
        }

        private sfa_contractdeliverableperiod GetContractDeliverablePeriodByCdpGuid(Guid deliverablePeriodId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.sfa_contractdeliverableperiodSet.Single(cdp => cdp.Id == deliverablePeriodId);
            }
        }

        private List<sfa_contractdeliverableperiod> GeRelatedDeliverablePeriods(string subnominalCode)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return (from sa in xrmContext.sfa_subnominalaggregationSet
                        join dp in xrmContext.sfa_contractdeliverableperiodSet on sa.Id equals
                            dp.sfa_sfa_subnominalaggregation_sfa_contractdeliverableperiod_Profile.Id into joined
                        from dp in joined.DefaultIfEmpty()
                        where sa.sfa_SubnominalCode == subnominalCode
                        select dp).ToList();
            }
        }

        private Guid CreateTestDeliverablePeriods(Guid deliverableId)
        {
            sfa_contractdeliverableperiod deliverablePeriod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId),
                sfa_PeriodName = "Aug-15"
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(deliverablePeriod);
        }

        private void CreateTestDeliverablePeriods(Guid deliverableId, IEnumerable<string> periods)
        {
            periods.ToList().ForEach(period =>
            {
                sfa_contractdeliverableperiod deliverablePeriod = new sfa_contractdeliverableperiod
                {
                    sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId),
                    sfa_PeriodName = period
                };
                CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(deliverablePeriod);
            });
        }

        private Guid CreateTestDeliverable(Guid allocationId, int deliverableCode)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_DeliverableCode = deliverableCode.ToString()
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(deliverable);
        }

        private Guid CreateTestContract(string contractNumber, string ukprn)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_LastApprovedVersion = true,
                sfa_ProviderName = GetOrCreateOrgEntityReference(ukprn)
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contract);
        }

        private EntityReference GetOrCreateOrgEntityReference(string ukprn)
        {
            Account org = GetOrg(ukprn);

            if (org == null)
            {
                Account acc = new Account
                {
                    sfa_UKPRN = ukprn
                };

                CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(acc);

                org = GetOrg(ukprn);
            }

            return org.ToEntityReference();
        }

        private Account GetOrg(string ukprn)
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.AccountSet.FirstOrDefault(a => a.sfa_UKPRN == ukprn);
            }
        }

        private Guid CreateTestAllocation(Guid contractId, string allocationNumber, string deliveryOrgUkprn = null)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_deliveryorganisationukprn = deliveryOrgUkprn,
                sfa_deliveryorganisationprovider = deliveryOrgUkprn != null ? GetOrCreateOrgEntityReference(deliveryOrgUkprn) : null
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(allocation);
        }

        private void DeleteTestAllocation(string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                xrmContext.sfa_contractallocationSet.Where(a => a.sfa_contractallocationnumber == allocationNumber)
               .ForEach(a => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_contractallocation.EntityLogicalName, a.Id));
            }
        }

        private void DeleteTestContract(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                xrmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
               .ForEach(a => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_contract.EntityLogicalName, a.Id));
            }
        }

        private void DeleteSubnominalsForCode(string subnominalCode)
        {
            using (var xrmserivce = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                xrmserivce.sfa_subnominalaggregationSet.Where(sa => sa.sfa_SubnominalCode == subnominalCode)
                .ForEach(sa => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_subnominalaggregation.EntityLogicalName, sa.Id));
            }
        }

        private void DeleteSubnominalsForKey(string subnominalAggKey)
        {
            using (var xrmserivce = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                xrmserivce.sfa_subnominalaggregationSet.Where(sa => sa.sfa_SubnominalAggregateKey == subnominalAggKey)
                    .ForEach(sa => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_subnominalaggregation.EntityLogicalName, sa.Id));
            }
        }

        private IReadOnlyCollection<sfa_subnominalaggregation> GetSubnominalsForCode(string subnominalCode)
        {
            using (var xrmserivce = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return
                    xrmserivce.sfa_subnominalaggregationSet.Where(sa => sa.sfa_SubnominalCode == subnominalCode)
                        .ToList();
            }
        }

        private static Allocation CreateAllocation(string allocationNumber, string subnominalCode, string ukprn)
        {
            return new Allocation()
            {

                AllocationNumber = allocationNumber,
                AllocationPeriods = new List<AllocationPeriod>()
                {
                    new AllocationPeriod()
                    {
                        Period = "201508",
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.AY,
                        Aggregations = new List<Aggregation>()
                        {
                            new Aggregation
                            {
                                AggregatedValue = 5000.0M,
                                DeliverableDetails = new List<DeliverableDetail>()
                                {
                                    new DeliverableDetail()
                                    {
                                        DeliverableCode = 1,

                                    }
                                },
                                PaymentType = AggregationPaymentType.PROFILE,
                                PostedFlag = true,
                                SubnominalCode = subnominalCode
                            }
                        }
                    }
                },
                FundingStreamPeriodCode = FundingStreamPeriodCode,
                Organisation = new Organisation()
                {
                    MainOrganisationIdentifier = "OrgID",
                    AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                    {
                        new OrgainsationIdentifier
                        {
                            OrganisationId = ukprn,
                            OrganisationIdentifierName =
                                OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                schemaVersion = 1.0M,
                VersionNumber = 1
            };
        }
    }
}
