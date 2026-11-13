namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using PerformanceManagementDomain.DataStore;
    using Model = PerformanceManagementDomain.DataStore.Models;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0;
    using CrossDomain.Integration.OverrideDate;
    using DTO;
    using Extensions;
    using global::PerformanceManagementDomain.PullFundingClaim.DTOs;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;
    using Utilities;
    using ContractAllocation = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractAllocation;
    using Allocation = SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using NUnit.Framework.Legacy;

    public class PerformanceManagementPageObject
    {
        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0.FundingClaimReconciliation.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:FCReconciliation";
        private readonly IOrganizationService _crmService;
        private readonly List<FundingClaim> _fundingClaimsUnderTest;
        private PerformanceManagementDbContext _performanceManagementDbContext;

        public PerformanceManagementPageObject()
        {
            _crmService = CrmConnectionFactory.GetConnection();
            _fundingClaimsUnderTest = new List<FundingClaim>();
        }

        public void RemoveAllFundingClaimClaimReconciliationData()
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_crmService))
            {
                ExecuteMultipleRequest executeMultipleRequest = new ExecuteMultipleRequest
                {
                    Settings = new ExecuteMultipleSettings
                    {
                        ContinueOnError = true,
                        ReturnResponses = false
                    },
                    Requests = new OrganizationRequestCollection()
                };

                xrmContext.sfa_fundingclaimreconciliationSet
                    .Select(fcr => fcr.Id)
                    .ToList()
                    .ForEach(id => executeMultipleRequest.Requests.Add(new DeleteRequest
                    {
                        Target = new EntityReference("sfa_fundingclaimreconciliation", id)
                    }));

                _crmService.Execute(executeMultipleRequest);
            }
        }

        public sfa_fundingclaimreconciliation RetrieveFundingClaimReconciliationFromCrm(string fundingPeriod, string fundingClaimType, string allocationGroupCode, sfa_fundingclaimreconciliation sfa_fcr)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                IReadOnlyCollection<sfa_fundingclaimreconciliation> fundingclaimreconciliations = (from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                    join fp in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals fp.sfa_periodId
                    join fc in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals fc.sfa_claimtypeId
                    join cra in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals cra.Id
                    where fp.sfa_Period == fundingPeriod
                          && fc.sfa_name == fundingClaimType
                          && cra.sfa_AllocationGroupCode == allocationGroupCode
                          && fcr.sfa_ClaimVersionNumber.Value == sfa_fcr.sfa_ClaimVersionNumber &&
                          fcr.sfa_StatusCode.Value == (int) sfa_fcr.sfa_StatusCodeEnum.Value
                    select fcr).ToList();

                fundingclaimreconciliations =
                    fundingclaimreconciliations.Where(fcr => fcr.sfa_ukprn == (sfa_fcr.sfa_ukprn ?? fcr.sfa_ukprn)).ToList();
                var fundingclaimreconciliation = fundingclaimreconciliations.SingleOrDefault();
                return fundingclaimreconciliation;
            }
        }

        public sfa_fcrallocation RetrieveFundingClaimReconciliationAllocationFromCrm(string fundingPeriod, string fundingClaimType, string allocationGroupCode, string allocationRef, sfa_fcrallocation sfa_fcra)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                var fundingclaimreconciliation = (from fcra in xrmContext.sfa_fcrallocationSet
                    join fcr in xrmContext.sfa_fundingclaimreconciliationSet on fcra.sfa_FundingClaimReconciliationId.Id equals fcr.Id
                    join fp in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals fp.sfa_periodId
                    join fc in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals fc.sfa_claimtypeId
                    //join ca in xrmContext.sfa_contractallocationSet on fcra.sfa_ContractAllocationId.Id equals ca.Id
                    join cra in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals cra.Id
                    where fp.sfa_Period == fundingPeriod
                          && fc.sfa_name == fundingClaimType
                          && cra.sfa_AllocationGroupCode == allocationGroupCode
                          && fcra.sfa_name == allocationRef
                    select fcra).SingleOrDefault();




                return fundingclaimreconciliation;
            }
        }

        public void ClearFundingClaimDataFromPaasTables(string claimType, string period)
        {
            using (_performanceManagementDbContext = new PerformanceManagementDbContext())
            {
                string periodClaimType = $"{period}-{claimType.Replace(" ", "")}";
                _performanceManagementDbContext.FundingClaimCollectionImportInfos
                    .RemoveWhere(c => c.PeriodClaimType == periodClaimType);

                _performanceManagementDbContext.FundingClaims
                    .RemoveWhere(fc => fc.Period == period);
                
                _performanceManagementDbContext.AtomFeedItems
                    .RemoveWhere(a => a.Period == period && a.ClaimTypeName == claimType);

                _performanceManagementDbContext.SaveChanges();
            }
        }

        public void CreateFundingClaim(string organisationId, int ukprn, int claimVersionNumber, string claimTypeName, string periodTypeCode, string period, bool hasBeenSigned)
        {
            _fundingClaimsUnderTest.Add(new FundingClaim()
            {
                FundingClaimAllAttrs = new List<FundingClaimAllAttrsCT>()
                {
                    new FundingClaimAllAttrsCT()
                    {
                        FundingClaimPKeyAttrs = new FundingClaimPKeyAttrsCT()
                        {
                            Contractor = new ContractorAllAttrsCT()
                            {
                                ContractorPKeyAttrs = new ContractorPKeyAttrsCT()
                                {
                                    OrganisationIdentifier = organisationId
                                },
                                ContractorNonPKeyAttrs = new ContractorNonPKeyAttrsCT()
                                {
                                    Ukprn = ukprn
                                }
                            },
                            VersionNumber = claimVersionNumber,
                            ClaimTypeNameEnum = (ClaimTypeNameST) Enum.Parse(typeof (ClaimTypeNameST), claimTypeName.Replace(" ", "").ToUpper()),
                            ClaimTypeName = claimTypeName.ToUpper(),
                            Period = new PeriodPKeyAttrsCT()
                            {
                                PeriodTypePKeyAttrs = new PeriodTypePKeyAttrsCT()
                                {
                                    PeriodTypeCode = (PeriodTypeCodeST) Enum.Parse(typeof (PeriodTypeCodeST), periodTypeCode)
                                },
                                Period = period
                            }
                        },
                        FundingClaimNonPKeyAttrs = new FundingClaimNonPKeyAttrsCT()
                        {
                            HasBeenSigned = hasBeenSigned
                        },
                        ContractAllocations = new List<ContractAllocationAllAttrsCT>()
                    }
                }
            });
        }

        public void CreateFundingClaimAllocation(FundingClaimAllocationNaturalKey allocationNaturalKey, string fundingStreamPeriodCode)
        {
            FundingClaim fundingClaim = GetFundingClaimByNaturalKey(allocationNaturalKey.FundingClaimNaturalKey);

            fundingClaim.FundingClaimAllAttrs.First().ContractAllocations.Add(new ContractAllocationAllAttrsCT()
            {
                ContractAllocationPKeyAttrs = new ContractAllocationPKeyAttrsCT()
                {
                    ContractAllocationNumber = allocationNaturalKey.ContractAllocationNumber
                },
                ContractAllocationNonPKeyAttrs = new ContractAllocationNonPKeyAttrsCT()
                {
                    FundingStreamPeriodCode = fundingStreamPeriodCode
                },
                DeliverableLines = new List<DeliverableLineAllAttrsCT>()
            });
        }

        public void CreateFundingClaimDeliverable(FundingClaimAllocationNaturalKey allocationNaturalKey, int deliverableCode, decimal actualValue, decimal forecastValue, decimal adjustmentValue, decimal totalDelivery)
        {
            FundingClaim fundingClaim = GetFundingClaimByNaturalKey(allocationNaturalKey.FundingClaimNaturalKey);

            ContractAllocationAllAttrsCT contractAllocationAllAttrsCT =
                fundingClaim.FundingClaimAllAttrs.First()
                            .ContractAllocations.Single(
                                x => x.ContractAllocationPKeyAttrs.ContractAllocationNumber == allocationNaturalKey.ContractAllocationNumber);

            contractAllocationAllAttrsCT.DeliverableLines.Add(new DeliverableLineAllAttrsCT()
            {
                DeliverableLinePKeyAttrs = new DeliverableLinePKeyAttrsCT()
                {
                    DeliverableCode = deliverableCode
                },
                DeliverableLineNonPKeyAttrs = new DeliverableLineNonPKeyAttrsCT()
                {
                    ActualValue = actualValue,
                    AdjustmentValue = adjustmentValue,
                    ForecastValue = forecastValue,
                    TotalDelivery = totalDelivery
                }
            });
        }

        public void CreateFundingClaimUnderTestInAzureTableStorage()
        {
            foreach (FundingClaim fundingClaim in _fundingClaimsUnderTest)
            {
                string xml = fundingClaim.SerializeToXml();
                FundingClaimStubRepository.Add(fundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Period.Period, fundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.ClaimTypeNameEnum.ToString(), xml);
                FundingClaimApiStubRepository.Add(fundingClaim.ToApiDto());
            }
        }

        public sfa_fcrallocationdeliverable GetFundingClaimReconciliationAllocationDeliverable(string fundingPeriod, string fundingClaimType, string allocationRef, int deliverableCode)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                return (from fcd in xrmContext.sfa_fcrallocationdeliverableSet
                    join d in xrmContext.sfa_deliverableSet on fcd.sfa_DeliverableId.Id equals d.Id
                    join a in xrmContext.sfa_fcrallocationSet on fcd.sfa_FCRAllocationId.Id equals a.Id
                    join fcr in xrmContext.sfa_fundingclaimreconciliationSet on a.sfa_FundingClaimReconciliationId.Id equals fcr.Id
                    join fp in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals fp.Id
                    join ct in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.Id
                    where fp.sfa_Period == fundingPeriod
                          && ct.sfa_name == fundingClaimType
                          && a.sfa_name == allocationRef
                          && d.sfa_DeliverableCode == deliverableCode
                    select fcd).Single();
            }
        }

        public sfa_claimreconallocgroup GetAllocationGroupFromCrm(string allocationGroupCode)
        {
            using (var xrmServiceContext = new XrmServiceContext(_crmService))
            {
                return xrmServiceContext.sfa_claimreconallocgroupSet
                    .Single(ag => ag.sfa_AllocationGroupCode == allocationGroupCode);
            }
        }

        public sfa_period GetFundingPeriodFromCrm(string periodTypeCode, string periodYear)
        {
            using (var xrmServiceContext = new XrmServiceContext(_crmService))
            {
                return xrmServiceContext.sfa_periodSet
                    .Single(p => p.sfa_periodname == $"{periodTypeCode}{periodYear}");
            }
        }

        public Account GetOrgFromCrm(string ukprn)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                return xrmContext.AccountSet.Single(a => a.sfa_UKPRN == ukprn);
            }
        }

        public sfa_claimtype GetClaimTypeFromCrm(string claimTypeName)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                return xrmContext.sfa_claimtypeSet.Single(ct => ct.sfa_name == claimTypeName);
            }
        }

        public void CreateFundingClaimReconciliationInCrm(FundingClaimReconciliation fundingclaimreconciliation)
        {
            sfa_fundingclaimreconciliation crmFundingclaimreconciliation = CreateCrmFcrFromFcr(fundingclaimreconciliation);

            List<sfa_fcrallocation> fcrAllocations = new List<sfa_fcrallocation>();
            fundingclaimreconciliation.ContractAllocations.ForEach(a =>
            {
                fcrAllocations.Add(CreateFcrAllocationFromContractAllocation(a, crmFundingclaimreconciliation));
            });

            crmFundingclaimreconciliation.sfa_sfa_fundingclaimreconciliation_sfa_fcrall = fcrAllocations;

            _crmService.Create(crmFundingclaimreconciliation);
        }

        private sfa_fundingclaimreconciliation CreateCrmFcrFromFcr(FundingClaimReconciliation fundingClaimReconciliation)
        {
            sfa_period fundingPeriod = GetFundingPeriodFromCrm(fundingClaimReconciliation.Period.PeriodTypeCode.ToString(), fundingClaimReconciliation.Period.PeriodYear);
            sfa_claimtype claimType = GetClaimTypeFromCrm(fundingClaimReconciliation.ClaimType.ClaimTypeName);
            sfa_claimreconallocgroup claimReconAllocGroup = GetAllocationGroupFromCrm(fundingClaimReconciliation.AllocationGroup.AllocationGroupCode);
            Account provider = GetOrgFromCrm(fundingClaimReconciliation.Contractor.UKPRN.ToString());

            return new sfa_fundingclaimreconciliation
            {
                Id = Guid.NewGuid(),
                sfa_name = $"{fundingPeriod.sfa_Period}_{claimType.sfa_name}_{claimReconAllocGroup.sfa_name}_{provider.sfa_UKPRN}",
                sfa_AllocationGroupId = claimReconAllocGroup.ToEntityReference(),
                sfa_ClaimTypeId = claimType.ToEntityReference(),
                sfa_FundingPeriodId = fundingPeriod.ToEntityReference(),
                sfa_ProviderId = provider.ToEntityReference(),
                sfa_PlannedValue = fundingClaimReconciliation.Amounts.PlannedValue,
                sfa_CappedClaimedValue = fundingClaimReconciliation.Amounts.CappedClaimedValue,
                sfa_ClaimedValue = fundingClaimReconciliation.Amounts.ClaimedValue,
                sfa_ProposedReconciliationValue = fundingClaimReconciliation.Amounts.ProposedReconciliationValue,
                sfa_ReconciliationValue = fundingClaimReconciliation.Amounts.ReconciliationValue,
                sfa_ClaimVersionNumber = fundingClaimReconciliation.ClaimVersionNumber,
                sfa_StatusCodeEnum = (sfa_sfastatuscode) Enum.Parse(typeof (sfa_sfastatuscode), fundingClaimReconciliation.Status.ToString()),
                sfa_StatusLastUpdatedDate = DateTime.UtcNow
            };
        }

        private sfa_fcrallocation CreateFcrAllocationFromContractAllocation(ContractAllocation allocation, sfa_fundingclaimreconciliation fundingClaimReconciliation)
        {
            return new sfa_fcrallocation
            {
                sfa_PlannedValue = allocation.Amounts.PlannedValue,
                sfa_CappedClaimedValue = allocation.Amounts.CappedClaimedValue,
                sfa_ClaimedValue = allocation.Amounts.ClaimedValue,
                sfa_ContractAllocationId = GetContractAllocation(allocation),
                sfa_fcrallocationId = Guid.NewGuid(),
                sfa_FundingClaimReconciliationId = fundingClaimReconciliation.ToEntityReference(),
                sfa_name = allocation.ContractAllocationNumber,
                sfa_ProposedReconciliationValue = allocation.Amounts.ProposedReconciliationValue,
                sfa_ReconciliationValue = allocation.Amounts.ProposedReconciliationValue
            };
        }

        private EntityReference GetContractAllocation(ContractAllocation allocation)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                return (from alloc in xrmContext.sfa_contractallocationSet
                    join contract in xrmContext.sfa_contractSet
                        on alloc.sfa_ContractId.Id equals contract.Id
                    where alloc.sfa_contractallocationnumber == allocation.ContractAllocationNumber
                          && contract.sfa_Version == allocation.Contract.ContractVersionNumber
                          && contract.sfa_SubVersion == allocation.Contract.ContractSubVersionNumber
                    select alloc).Single().ToEntityReference();
            }
        }

        public Guid GetFundingClaimReconciliationIdByNaturalKey(FundingClaimReconciliationNaturalKey key)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                return (from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                        join p in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals p.Id
                        join a in xrmContext.AccountSet on fcr.sfa_ProviderId.Id equals a.Id
                        join ct in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.Id
                        join ag in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals ag.Id
                        where a.sfa_UKPRN == key.Ukprn
                              && p.sfa_Period == key.FundingPeriod
                              && ct.sfa_name == key.ClaimTypeName
                              && ag.sfa_AllocationGroupCode == key.AllocationGroupCode
                              && fcr.sfa_ClaimVersionNumber == key.ClaimVersionNumber
                        select fcr.Id).Single();
            }
        }

        public sfa_sfastatuscode? GetFundingClaimReconcilationStatusCodeByNaturalKey(FundingClaimReconciliationNaturalKey key)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                return (from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                        join p in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals p.Id
                        join a in xrmContext.AccountSet on fcr.sfa_ProviderId.Id equals a.Id
                        join ct in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.Id
                        join ag in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals ag.Id
                        where a.sfa_UKPRN == key.Ukprn
                              && p.sfa_Period == key.FundingPeriod
                              && ct.sfa_name == key.ClaimTypeName
                              && ag.sfa_AllocationGroupCode == key.AllocationGroupCode
                              && fcr.sfa_ClaimVersionNumber == key.ClaimVersionNumber
                        select fcr.sfa_StatusCodeEnum).Single();
            }
        }

        public sfa_fundingclaimreconciliation GetFundingClaimReconcilationByNaturalKey(FundingClaimReconciliationNaturalKey key)
        {
            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                return (from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                        join p in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals p.Id
                        join a in xrmContext.AccountSet on fcr.sfa_ProviderId.Id equals a.Id
                        join ct in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.Id
                        join ag in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals ag.Id
                        where a.sfa_UKPRN == key.Ukprn
                              && p.sfa_Period == key.FundingPeriod
                              && ct.sfa_name == key.ClaimTypeName
                              && ag.sfa_AllocationGroupCode == key.AllocationGroupCode
                              && fcr.sfa_ClaimVersionNumber == key.ClaimVersionNumber
                        select fcr).SingleOrDefault();
            }
        }

        public bool AreAllGivenFundingClaimReconciliationsInGivenStatus(
            IEnumerable<FundingClaimReconciliationNaturalKey> fundingClaimReconciliationNaturalKeys, string expectedStatus)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    sfa_sfastatuscode expectedStatusCodeEnum = (sfa_sfastatuscode)Enum.Parse(typeof(sfa_sfastatuscode), expectedStatus);

                    return
                        fundingClaimReconciliationNaturalKeys
                        .Select(GetFundingClaimReconcilationStatusCodeByNaturalKey)
                        .All(s => s == expectedStatusCodeEnum);
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 5);

            return checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
        }

        public bool AreAllFundingClaimReconciliationsValidOnTheFeed(
            IReadOnlyCollection<PerformanceManagementAtomFeedItemBusinessKey> performanceManagementAtomFeedItemBusinessKeys)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () => performanceManagementAtomFeedItemBusinessKeys.All(IsAtomFeedItemPresentAndValid),
                maxNumChecks: 50,
                waitIntervalSeconds: 2);

            return checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
        }

        public bool AreAllFundingClaimReconciliationsNotOnTheFeed(
           IReadOnlyCollection<PerformanceManagementAtomFeedItemBusinessKey> performanceManagementAtomFeedItemBusinessKeys)
        {
            return performanceManagementAtomFeedItemBusinessKeys.Select(IsAtomFeedItemPresent)
                .All(isPresent => isPresent == false);
        }

        private bool IsAtomFeedItemPresent(PerformanceManagementAtomFeedItemBusinessKey key)
        {
            return GetAtomFeedItem(key) != null;
        }

        private bool IsAtomFeedItemPresentAndValid(PerformanceManagementAtomFeedItemBusinessKey key)
        {
            bool isPresentAndValid = false;
            Model.AtomFeedItem atomFeedItem = GetAtomFeedItem(key);
            if (atomFeedItem != null)
            {
                isPresentAndValid = IsFundingClaimReconciliationValid(atomFeedItem.AtomFeedItemXml);
            }

            return isPresentAndValid;
        }

        private Model.AtomFeedItem GetAtomFeedItem(PerformanceManagementAtomFeedItemBusinessKey key)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                return (from a in context.AtomFeedItems
                join grp in context.ClaimReconciliationAllocationGroups on a.AllocationGroupName equals grp.GroupName
                where a.Ukprn == key.Ukprn &&
                      grp.ClaimReconciliationAllocationGroupCode == key.AllocationGroupCode &&
                      a.ClaimTypeName == key.ClaimTypeName &&
                      a.ItemType == (Model.AtomItemType) key.ItemType &&
                      a.Period == key.Period
                select a).SingleOrDefault();
            }
        }

        private bool IsFundingClaimReconciliationValid(string xmlFcr)
        {
            XmlSchemaSet schemas = new XmlSchemaSet();
            List<string> validationErrors = new List<string>();
            using (Stream stream = Assembly.LoadFrom(AssemblyName).GetManifestResourceStream(EmbeddedResourceName))
            {
                if (stream == null)
                {
                    ClassicAssert.Fail("Could not load FundingClaimReconciliation schema resource.");
                }

                schemas.Add(SchemaNamespace, new XmlTextReader(stream));
            }

            XDocument
                .Parse(xmlFcr, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo)
                .Validate(schemas, (sender, e) => validationErrors.Add($"Error: {e.Exception.Message} at line {e.Exception.LineNumber}"));


            return !validationErrors.Any();
        }

        private Guid GetCrmWorkflowIdByName(string workflowName)
        {
            QueryExpression objQueryExpression = new QueryExpression("workflow")
            {
                ColumnSet = new ColumnSet(allColumns: true)
            };

            objQueryExpression.Criteria.AddCondition(new ConditionExpression("name", ConditionOperator.Equal, workflowName));
            objQueryExpression.Criteria.AddCondition(new ConditionExpression("parentworkflowid", ConditionOperator.Null));
            EntityCollection workflowCollection = _crmService.RetrieveMultiple(objQueryExpression);

            return workflowCollection.Entities.Single().Id;
        }

        public void RunWorkflow22InitiatePublishForFundingClaimReconciliation(FundingClaimReconciliationNaturalKey fundingClaimReconciliationKey)
        {
            const string workflow22Name = "WF22 : Initiate Publish For Funding Claim Reconciliation";

            Guid workflowId = GetCrmWorkflowIdByName(workflow22Name);
            Guid entityId = GetFundingClaimReconciliationIdByNaturalKey(fundingClaimReconciliationKey);

            _crmService.Execute(new ExecuteWorkflowRequest
            {
                WorkflowId = workflowId,
                EntityId = entityId
            });
        }

        public void ClearNotificationsForType(string notificationType)
        {
            sfa_notificationtype enumValueNotificationType = (sfa_notificationtype) Enum.Parse(typeof(sfa_notificationtype),
                notificationType.Replace(" ", string.Empty).Replace("-", string.Empty), ignoreCase: true);

            using (var xrmContext = new XrmServiceContext(_crmService))
            {
                xrmContext.sfa_notificationSet
                    .Where(n => n.sfa_NotificationType.Value == (int)enumValueNotificationType)
                    .ToList()
                    .ForEach(n =>
                    {
                        _crmService.Delete("sfa_notification", n.Id);
                    });
            }            
        }

        public void CreateContractAllocationInStorage(Allocation.ContractAllocation contractAllocation)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ContractAllocations.Add(contractAllocation);
                context.SaveChanges();
            }
        }

        public void DeleteAllocationFromPaaS(string allocationNumber)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var allocationToDelete = context.ContractAllocations.Find(allocationNumber);

                if (allocationToDelete != null)
                {
                    context.ContractAllocations.Remove(allocationToDelete);
                    context.SaveChanges();
                }
            }
        }

        public bool IsOverrideDateBeforePublicationCloseDateForClaimReconciliationAndAllocGroup
            (string claimReconciliationCode, string allocationGroupCode)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                using (var overrideDateContext = new OverrideDateDBContext())
                {
                    var overrideDate = overrideDateContext.OverrideDate.First().SystemOverrideDate;
                    var publicationCloseDate =
                        context.ClaimReconciliationBehaviours.Single(
                            crb =>
                                crb.ClaimCollectionCode == claimReconciliationCode &&
                                crb.ClaimReconciliationAllocationGroupCode == allocationGroupCode).PublicationCloseDate;

                    if (publicationCloseDate.HasValue)
                    {
                        return overrideDate < publicationCloseDate.Value;
                    }

                    return true;
                }
            }
        }

        private FundingClaim GetFundingClaimByNaturalKey(FundingClaimNaturalKey naturalKey)
        {
            return
                _fundingClaimsUnderTest.Single(
                    x =>
                        x.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Contractor.ContractorPKeyAttrs.OrganisationIdentifier == naturalKey.OrganisationIdentifier &&
                        x.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.VersionNumber == naturalKey.VersionNumber &&
                        x.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.ClaimTypeName == naturalKey.ClaimTypeName.ToUpper() &&
                        x.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Period.PeriodTypePKeyAttrs.PeriodTypeCode == GetPeriodTypeCodeFromString(naturalKey.PeriodTypeCode) &&
                        x.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Period.Period == naturalKey.Period);
        }

        private ClaimTypeNameST GetClaimTypeNameFromString(string claimTypeName)
        {
            return (ClaimTypeNameST) Enum.Parse(typeof (ClaimTypeNameST), claimTypeName.Replace(" ", "").ToUpper());
        }

        private PeriodTypeCodeST GetPeriodTypeCodeFromString(string periodTypeCode)
        {
            return (PeriodTypeCodeST) Enum.Parse(typeof(PeriodTypeCodeST), periodTypeCode.Replace(" ", "").ToUpper());
        }
    }

    public class FundingClaimNaturalKey : IEquatable<FundingClaimNaturalKey>
    {
        public string OrganisationIdentifier { get; set; }
        public int VersionNumber { get; set; }
        public string ClaimTypeName { get; set; }
        public string PeriodTypeCode { get; set; }
        public string Period { get; set; }

        public bool Equals(FundingClaimNaturalKey other)
        {
            if (other == null)
                return false;

            return (object.ReferenceEquals(this.OrganisationIdentifier, other.OrganisationIdentifier) || this.OrganisationIdentifier != null && this.OrganisationIdentifier.Equals(other.OrganisationIdentifier)) &&
                this.VersionNumber.Equals(other.VersionNumber) &&
                (object.ReferenceEquals(this.ClaimTypeName, other.ClaimTypeName) || this.ClaimTypeName != null && this.ClaimTypeName.Equals(other.ClaimTypeName)) &&
                (object.ReferenceEquals(this.PeriodTypeCode, other.PeriodTypeCode) || this.PeriodTypeCode != null && this.PeriodTypeCode.Equals(other.PeriodTypeCode)) &&
                (object.ReferenceEquals(this.Period, other.Period) || this.Period != null && this.Period.Equals(other.Period));
        }

        public override int GetHashCode()
        {
            return this.OrganisationIdentifier.GetHashCode() ^ this.VersionNumber.GetHashCode() ^ this.ClaimTypeName.GetHashCode() ^ this.PeriodTypeCode.GetHashCode() ^ this.Period.GetHashCode();
        }
    }

    public class FundingClaimAllocationNaturalKey : IEquatable<FundingClaimAllocationNaturalKey>
    {
        public FundingClaimNaturalKey FundingClaimNaturalKey { get; set; }
        public string ContractAllocationNumber { get; set; }

        public bool Equals(FundingClaimAllocationNaturalKey other)
        {
            if (other == null)
                return false;

            return (object.ReferenceEquals(this.FundingClaimNaturalKey, other.FundingClaimNaturalKey) || this.FundingClaimNaturalKey != null && this.FundingClaimNaturalKey.Equals(other.FundingClaimNaturalKey)) &&
                (object.ReferenceEquals(this.ContractAllocationNumber, other.ContractAllocationNumber) || this.ContractAllocationNumber != null && this.ContractAllocationNumber.Equals(other.ContractAllocationNumber));
        }
        public override int GetHashCode()
        {
            return this.FundingClaimNaturalKey.GetHashCode() ^ this.ContractAllocationNumber.GetHashCode();
        }
    }

    public class FundingClaimReconciliationNaturalKey
    {
        public FundingClaimReconciliationNaturalKey(string ukprn, string fundingPeriod, string claimTypeName, string allocationGroupCode, int claimVersionNumber)
        {
            Ukprn = ukprn;
            FundingPeriod = fundingPeriod;
            ClaimTypeName = claimTypeName;
            AllocationGroupCode = allocationGroupCode;
            ClaimVersionNumber = claimVersionNumber;
        }

        public string Ukprn { get; }

        public string FundingPeriod { get; }

        public string ClaimTypeName { get; }

        public string AllocationGroupCode { get; }

        public int ClaimVersionNumber { get; }

        public override string ToString()
        {
            return
                $"Ukprn: {Ukprn}, FundingPeriod: {FundingPeriod}, ClaimTypeName: {ClaimTypeName}, AllocationGroupCode: {AllocationGroupCode}, ClaimVersionNumber: {ClaimVersionNumber}";
        }
    }
}
