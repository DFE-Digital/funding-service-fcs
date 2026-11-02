namespace PerformanceManagementDomain.Tests.Common
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Globalization;
    using System.Linq;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.PerformanceManagementDomain.Common.Repositories;
   
    using XrmTestModel;
    using Contract = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Contract;
    using ContractAllocation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractAllocation;
    using ContractDeliverable = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractDeliverable;

    [TestClass]
    public class FundingClaimReconciliationQueryRepositoryTests
    {
        private const string DateFormat = "yyyy-MM-dd";
        private const string AllocationNumber = "ASC-9996";
        private const string AllocationStartDate = "2015-08-01";
        private const string AllocationEndDate = "2016-07-31";
        private const string ContractApprovalDate = "2015-06-01";
        private const string StatusLastUpdatedDate = "2016-08-11";
        private const string FundingStreamPeriodCode = "ASC1516";
        private const string FundingTypeCode = "MAIN";
        private const string FundingTypeName = "Mainstream";
        private const string Ukprn = "999996";
        private const string MasterContractNumber = "SFA-9996";
        private const string ContractNumber = "MAIN-9996";
        private const int ContractVersionNumber = 1;
        private const int ContractSubVersionNumber = 2;
        private const int AmendedContractVersionNumber = 2;
        private const string OrganisationIdTest1 = "ORG0099997";
        private const string OrganisationIdTest2 = "ORG0099998";
        private const string ContractorLegalName = OrgName + " " + Ukprn;
        private const string OrgName = "FcrTestOrg";
        private const string FcrEntityName = "1516_Year End_Adult Skills 15/16_999996";
        private IFundingClaimReconciliationQueryRepository _fundingClaimReconciliationQueryRepository;
        private EntityReference _orgEntityReference;
        private EntityReference _fundingTypeEntityReference;

        private static IOrganizationService CrmOrganizationService => CrmConnectionFactory.GetRetryOnErrorOrganizationService();

        [TestInitialize]
        public void TestInitialise()
        {
            _fundingClaimReconciliationQueryRepository = new FundingClaimReconciliationQueryRepository(CrmOrganizationService);
            RemoveTestFixturesFromCrm();
        }

        [TestCleanup]
        public void CleanUp()
        {
            RemoveTestFixturesFromCrm();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationQueryRepository_ShouldSuccessfullyRetrieveStoredFundingClaimReconciliationEntity()
        {
            // Arrange
            string organisationId = OrganisationIdTest1;
            CreateTestFixturesInCrm(organisationId);

            FundingClaimReconciliation fcrToPersist = GetFundingClaimReconciliationToPersist(organisationId);
            FundingClaimReconciliationCommandRepository fundingClaimReconciliationCommandRepository = new FundingClaimReconciliationCommandRepository(CrmOrganizationService);
            Guid crmEntityId = fundingClaimReconciliationCommandRepository.CreateFundingClaimReconciliation(fcrToPersist);

            AddClaimAdjustmentValuesToStoredFcr(crmEntityId, fcrToPersist);
            UpdateFcrStatusToPublishInProgress(crmEntityId);

            // Act
            FundingClaimReconciliation retrievedFundingClaimReconciliation = _fundingClaimReconciliationQueryRepository.GetFundingClaimReconciliation(crmEntityId);

            // Assert
            Assert.IsNotNull(retrievedFundingClaimReconciliation, "Retrieved Funding Claim Reconciliation Entity is null.");
            Assert.AreNotSame(fcrToPersist, retrievedFundingClaimReconciliation, "Funding Claim Repository has retrieved the same object as passed for persisting.");

            // Contractor
            Assert.IsNotNull(retrievedFundingClaimReconciliation.Contractor, "Retrieved Contractor is null.");
            Contractor expectedContractor = fcrToPersist.Contractor;
            Contractor actualContractor = retrievedFundingClaimReconciliation.Contractor;
            Assert.AreEqual(expectedContractor.OrganisationIdentifier, actualContractor.OrganisationIdentifier, "Contractor.OrganisationIdentifier is different.");
            Assert.AreEqual(expectedContractor.UKPRN, actualContractor.UKPRN, "Contractor.UKPRN is different.");
            Assert.AreEqual(expectedContractor.LegalName, actualContractor.LegalName, "Contractor.LegalName is different.");

            // Period
            Assert.IsNotNull(retrievedFundingClaimReconciliation.Period, "Retrieved Period is null.");
            Period expectedPeriod = fcrToPersist.Period;
            Period actualPeriod = retrievedFundingClaimReconciliation.Period;
            Assert.AreEqual(expectedPeriod.PeriodTypeCode, actualPeriod.PeriodTypeCode, "Period.PeriodTypeCode is different.");
            Assert.AreEqual(expectedPeriod.PeriodTypeName, actualPeriod.PeriodTypeName, "Period.PeriodTypeName is different.");
            Assert.AreEqual(expectedPeriod.PeriodYear, actualPeriod.PeriodYear, "Period.PeriodYear is different.");

            // ClaimVersionNumber
            Assert.AreEqual(retrievedFundingClaimReconciliation.ClaimVersionNumber, fcrToPersist.ClaimVersionNumber, "ClaimVersionNumber is different.");

            // ClaimType
            Assert.IsNotNull(retrievedFundingClaimReconciliation.ClaimType, "Retrieved ClaimType is null.");
            ClaimType expectedClaimType = fcrToPersist.ClaimType;
            ClaimType actualClaimType = retrievedFundingClaimReconciliation.ClaimType;
            Assert.AreEqual(expectedClaimType.ClaimTypeCode, actualClaimType.ClaimTypeCode, "ClaimType.ClaimTypeCode is different.");
            Assert.AreEqual(expectedClaimType.ClaimTypeName, actualClaimType.ClaimTypeName, "ClaimType.ClaimTypeName is different.");

            // Allocation Group
            Assert.IsNotNull(retrievedFundingClaimReconciliation.AllocationGroup, "Retrieved AllocationGroup is null.");
            AllocationGroup expectedAllocationGroup = fcrToPersist.AllocationGroup;
            AllocationGroup actualAllocationGroup = retrievedFundingClaimReconciliation.AllocationGroup;
            Assert.AreEqual(expectedAllocationGroup.AllocationGroupCode, actualAllocationGroup.AllocationGroupCode, "AllocationGroup.AllocationGroupCode is different.");
            Assert.AreEqual(expectedAllocationGroup.AllocationGroupName, actualAllocationGroup.AllocationGroupName, "AllocationGroup.AllocationGroupName is different.");

            // Status
            Assert.AreEqual(fcrToPersist.Status, retrievedFundingClaimReconciliation.Status, "Status is different.");

            // StatusLastUpdatedDate
            Assert.AreNotEqual(DateTime.MinValue, retrievedFundingClaimReconciliation.StatusLastUpdatedDate, "StatusLastUpdatedDate is not set.");
            Assert.AreNotEqual(0, retrievedFundingClaimReconciliation.StatusLastUpdatedDate.Ticks, "StatusLastUpdatedDate is not set.");

            // Amounts
            Assert.IsNotNull(retrievedFundingClaimReconciliation.Amounts, "Retrieved Amounts is null.");
            AmountSummary expectedAmounts = fcrToPersist.Amounts;
            AmountSummary actualAmounts = retrievedFundingClaimReconciliation.Amounts;
            Assert.AreEqual(expectedAmounts.PlannedValue, actualAmounts.PlannedValue, "Amounts.PlannedValue is different.");
            Assert.AreEqual(expectedAmounts.ClaimedValue, actualAmounts.ClaimedValue, "Amounts.ClaimedValue is different.");
            Assert.AreEqual(expectedAmounts.ProposedReconciliationValue, actualAmounts.ProposedReconciliationValue, "Amounts.ProposedReconciliationValue is different.");
            Assert.AreEqual(expectedAmounts.ReconciliationValue, actualAmounts.ReconciliationValue, "Amounts.ReconciliationValue is different.");
            Assert.AreEqual(expectedAmounts.CappedClaimedValue, actualAmounts.CappedClaimedValue, "Amounts.CappedClaimedValue is different.");
            Assert.AreEqual(expectedAmounts.AdjustedCappedClaimValue, actualAmounts.AdjustedCappedClaimValue, "Amounts.AdjustedCappedClaimValue is different.");

            // ContractAllocations collection
            Assert.IsNotNull(retrievedFundingClaimReconciliation.ContractAllocations, "Retrieved ContractAllocations is null.");
            Assert.AreEqual(fcrToPersist.ContractAllocations.Count, retrievedFundingClaimReconciliation.ContractAllocations.Count, "ContractAllocations.Count is different.");

            // Individual ContractAllocation
            ContractAllocation expectedContractAllocation = fcrToPersist.ContractAllocations.First();
            ContractAllocation actualContractAllocation = retrievedFundingClaimReconciliation.ContractAllocations.First();
            Assert.AreEqual(expectedContractAllocation.ContractAllocationNumber, actualContractAllocation.ContractAllocationNumber, "ContractAllocation.ContractAllocationNumber is different.");
            Assert.AreEqual(expectedContractAllocation.FundingstreamPeriodCode, actualContractAllocation.FundingstreamPeriodCode, "ContractAllocation.FundingstreamPeriodCode is different.");
            Assert.AreEqual(expectedContractAllocation.AllocationStartDate, actualContractAllocation.AllocationStartDate, "ContractAllocation.AllocationStartDate is different.");
            Assert.AreEqual(expectedContractAllocation.AllocationEndDate, actualContractAllocation.AllocationEndDate, "ContractAllocation.AllocationStartDate is different.");

            // ContractAllocation.Amounts
            Assert.IsNotNull(actualContractAllocation.Amounts, "Retrieved ContractAllocation.Amounts is null.");
            Assert.AreEqual(expectedContractAllocation.Amounts.PlannedValue, actualContractAllocation.Amounts.PlannedValue, "ContractAllocation.Amounts.PlannedValue is different.");
            Assert.AreEqual(expectedContractAllocation.Amounts.ClaimedValue, actualContractAllocation.Amounts.ClaimedValue, "ContractAllocation.Amounts.ClaimedValue is different.");
            Assert.AreEqual(expectedContractAllocation.Amounts.AdjustedCappedClaimValue, actualContractAllocation.Amounts.AdjustedCappedClaimValue, "ContractAllocation.Amounts.AdjustedCappedClaimValue is different.");

            // ContractAllocation.Amounts.ClaimAdjustments
            Assert.IsNotNull(actualContractAllocation.Amounts.ClaimAdjustments, "ContractAllocation.Amounts.ClaimAdjustments is null.");
            Assert.AreEqual(expectedContractAllocation.Amounts.ClaimAdjustments.ClaimAdjustmentValue, actualContractAllocation.Amounts.ClaimAdjustments.ClaimAdjustmentValue, "ContractAllocation.Amounts.ClaimAdjustments.ClaimAdjustmentValue is different.");
            Assert.AreEqual(expectedContractAllocation.Amounts.ClaimAdjustments.ClaimAdjustmentReason, actualContractAllocation.Amounts.ClaimAdjustments.ClaimAdjustmentReason, "ContractAllocation.Amounts.ClaimAdjustments.ClaimAdjustmentReason is different.");

            // ContractAllocation.ContractDeliverables
            Assert.IsNotNull(actualContractAllocation.ContractDeliverables, "Retrieved ContractAllocation.ContractDeliverables is null.");
            Assert.AreEqual(expectedContractAllocation.ContractDeliverables.Count, actualContractAllocation.ContractDeliverables.Count, "ContractAllocations.ContractDeliverables.Count is different.");

            // Individual ContractDeliverable entities
            expectedContractAllocation.ContractDeliverables.ToList()
                .ForEach(expectedContractDeliverable =>
                {
                    ContractDeliverable actualContractDeliverable = actualContractAllocation.ContractDeliverables.SingleOrDefault(cd => cd.Deliverable.DeliverableCode == expectedContractDeliverable.Deliverable.DeliverableCode);
                    Assert.IsNotNull(actualContractDeliverable, $"ContractDeliverable for Deliverable Code {expectedContractDeliverable.Deliverable.DeliverableCode} missing.");

                    // ContractDeliverable.Deliverable
                    Assert.IsNotNull(actualContractDeliverable.Deliverable, "ContractDeliverable.Deliverable is null.");
                    Assert.AreEqual(expectedContractDeliverable.Deliverable.DeliverableCode, actualContractDeliverable.Deliverable.DeliverableCode, "ContractDeliverable.Deliverable.DeliverableCode is different");
                    Assert.AreEqual(expectedContractDeliverable.Deliverable.DeliverableName, actualContractDeliverable.Deliverable.DeliverableName, "ContractDeliverable.Deliverable.DeliverableName is different");
                    Assert.IsNotNull(actualContractDeliverable, $"ContractDeliverable for Deliverable Code {expectedContractDeliverable.Deliverable.DeliverableCode} missing.");

                    // ContractDeliverable.Amounts
                    Assert.IsNotNull(actualContractDeliverable.Amounts, "ContractDeliverable.Amounts is null.");
                    Assert.AreEqual(expectedContractDeliverable.Amounts.PlannedValue, actualContractDeliverable.Amounts.PlannedValue, "ContractDeliverable.Amounts.PlannedValue is different.");
                    Assert.AreEqual(expectedContractDeliverable.Amounts.ClaimedValue, actualContractDeliverable.Amounts.ClaimedValue, "ContractDeliverable.Amounts.ClaimedValue is different.");
                    Assert.AreEqual(expectedContractDeliverable.Amounts.ProposedReconciliationValue, actualContractDeliverable.Amounts.ProposedReconciliationValue, "ContractDeliverable.Amounts.ProposedReconciliationValue is different.");
                    Assert.AreEqual(expectedContractDeliverable.Amounts.ReconciliationValue, actualContractDeliverable.Amounts.ReconciliationValue, "ContractDeliverable.Amounts.ReconciliationValue is different.");
                    Assert.AreEqual(expectedContractDeliverable.Amounts.CappedClaimedValue, actualContractDeliverable.Amounts.CappedClaimedValue, "ContractDeliverable.Amounts.CappedClaimedValue is different.");
                });

            // ContractAllocation.Contract
            Assert.IsNotNull(actualContractAllocation.Contract, "Retrieved ContractAllocation.Contract is null.");
            Assert.AreEqual(expectedContractAllocation.Contract.ContractNumber, actualContractAllocation.Contract.ContractNumber, "ContractAllocation.Contract.ContractNumber is different.");
            Assert.AreEqual(expectedContractAllocation.Contract.ContractVersionNumber, actualContractAllocation.Contract.ContractVersionNumber, "ContractAllocation.Contract.ContractVersionNumber is different.");
            Assert.AreEqual(expectedContractAllocation.Contract.ContractSubVersionNumber, actualContractAllocation.Contract.ContractSubVersionNumber, "ContractAllocation.Contract.ContractSubVersionNumber is different.");
            Assert.IsNotNull(actualContractAllocation.Contract.FundingType, "Retrieved ContractAllocation.Contract.FundingType is null.");
            Assert.AreEqual(expectedContractAllocation.Contract.FundingType.FundingTypeCode, actualContractAllocation.Contract.FundingType.FundingTypeCode, "ContractAllocation.Contract.FundingType.FundingTypeCode is different.");
            Assert.AreEqual(expectedContractAllocation.Contract.FundingType.FundingTypeName, actualContractAllocation.Contract.FundingType.FundingTypeName, "ContractAllocation.Contract.FundingType.FundingTypeName is different.");
            Assert.AreEqual(expectedContractAllocation.Contract.ContractApprovalDate, actualContractAllocation.Contract.ContractApprovalDate, "ContractAllocation.Contract.ContractApprovalDate is different.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationQueryRepository_ShouldGetFcrWithLatestContractAndAllocationInfo()
        {
            // Arrange
            string organisationId = OrganisationIdTest2;
            CreateTestFixturesInCrm(organisationId);

            FundingClaimReconciliation fcrToPersist = GetFundingClaimReconciliationToPersist(organisationId);
            FundingClaimReconciliationCommandRepository fundingClaimReconciliationCommandRepository = new FundingClaimReconciliationCommandRepository(CrmOrganizationService);
            Guid crmEntityId = fundingClaimReconciliationCommandRepository.CreateFundingClaimReconciliation(fcrToPersist);

            UpdateFcrStatusToPublishInProgress(crmEntityId);

            // now add in a new contract and allocations with for the amended contract
            CreateContractAndAllocationsInCrm(AmendedContractVersionNumber, sfa_contractstatus.Approved);
            CreateContractAndAllocationsInCrm(AmendedContractVersionNumber + 1, sfa_contractstatus.Approved);
            CreateContractAndAllocationsInCrm(AmendedContractVersionNumber + 2, sfa_contractstatus.Withdrawn);

            // Act
            FundingClaimReconciliation retrievedFundingClaimReconciliation = _fundingClaimReconciliationQueryRepository.GetFundingClaimReconciliation(crmEntityId);

            Assert.AreEqual(AmendedContractVersionNumber + 1, retrievedFundingClaimReconciliation.ContractAllocations.First().Contract.ContractVersionNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationQueryRepository_ShouldShowIfPlannedValueHasChangedForAllocation()
        {
            // arrange
            CreateTestFixturesInCrm(OrganisationIdTest2);
            FundingClaimReconciliation fcrToPersist = GetFundingClaimReconciliationToPersist(OrganisationIdTest2);
            FundingClaimReconciliationCommandRepository fundingClaimReconciliationCommandRepository = new FundingClaimReconciliationCommandRepository(CrmOrganizationService);
            fundingClaimReconciliationCommandRepository.CreateFundingClaimReconciliation(fcrToPersist);

            // act
            var hasChanged =
                _fundingClaimReconciliationQueryRepository.IsPlannedValueDifferentForAllocation(AllocationNumber, 200m);

            // assert
            Assert.IsTrue(hasChanged);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationQueryRepository_ShouldShowIfPlannedValueHasNotChangedForAllocation()
        {
            // arrange
            CreateTestFixturesInCrm(OrganisationIdTest2);
            FundingClaimReconciliation fcrToPersist = GetFundingClaimReconciliationToPersist(OrganisationIdTest2);
            FundingClaimReconciliationCommandRepository fundingClaimReconciliationCommandRepository = new FundingClaimReconciliationCommandRepository(CrmOrganizationService);
            fundingClaimReconciliationCommandRepository.CreateFundingClaimReconciliation(fcrToPersist);

            // act
            var hasChanged =
                _fundingClaimReconciliationQueryRepository.IsPlannedValueDifferentForAllocation(AllocationNumber, 300m);

            // assert
            Assert.IsFalse(hasChanged);
        }

        private static void AddClaimAdjustmentValuesToStoredFcr(Guid crmEntityId, FundingClaimReconciliation fcrToPersist)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmOrganizationService))
            {
                sfa_fundingclaimreconciliation fcrUpdate = new sfa_fundingclaimreconciliation
                {
                    Id = crmEntityId,
                    sfa_adjustedcappedclaimedvalue = fcrToPersist.Amounts.AdjustedCappedClaimValue
                };

                CrmOrganizationService.Update(fcrUpdate);

                context.sfa_fcrallocationSet
                    .Where(fcra => fcra.sfa_FundingClaimReconciliationId.Id == crmEntityId)
                    .Select(fcra => fcra.Id)
                    .AsEnumerable()
                    .ToList().ForEach(fcraId =>
                    {
                        ContractAllocation fcrAllocationToPersist = fcrToPersist.ContractAllocations.Single();

                        sfa_fcrallocation fcrAllocationUpdate = new sfa_fcrallocation
                        {
                            Id = fcraId,
                            sfa_adjustedcappedclaimedvalue = fcrAllocationToPersist.Amounts.AdjustedCappedClaimValue,
                            sfa_claimadjustmentvalue = fcrAllocationToPersist.Amounts.ClaimAdjustments.ClaimAdjustmentValue,
                            sfa_claimadjustmentreason = new OptionSetValue((int)Enum.Parse(typeof(sfa_ClaimAdjustmentReason), fcrAllocationToPersist.Amounts.ClaimAdjustments.ClaimAdjustmentReason.Replace(" ", string.Empty)))
                        };

                        CrmOrganizationService.Update(fcrAllocationUpdate);
                    });
            }
        }

        private sfa_fundingclaimreconciliation RetrieveFundingClaimReconciliationFromCrm(string entityName)
        {
            using (var xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return (from fcr in xrmServiceContext.sfa_fundingclaimreconciliationSet
                        where fcr.sfa_name == entityName
                        select fcr).SingleOrDefault();
            }
        }

        private static FundingClaimReconciliation GetFundingClaimReconciliationToPersist(string organisationId)
        {
            return new FundingClaimReconciliation
            {
                AllocationGroup = new AllocationGroup
                {
                    AllocationGroupCode = "ASC1516",
                    AllocationGroupName = "Adult Skills 15/16"
                },
                Amounts = new AmountSummary
                {
                    CappedClaimedValue = 100m,
                    ClaimedValue = 200m,
                    PlannedValue = 300m,
                    ProposedReconciliationValue = 400m,
                    ReconciliationValue = 500m,
                    AdjustedCappedClaimValue = 601m
                },
                ClaimType = new ClaimType
                {
                    ClaimTypeCode = "YE",
                    ClaimTypeName = "Year End"
                },
                ClaimVersionNumber = 1,
                ContractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        AllocationStartDate =  DateTime.ParseExact(AllocationStartDate, DateFormat, CultureInfo.InvariantCulture),
                        AllocationEndDate = DateTime.ParseExact(AllocationEndDate, DateFormat, CultureInfo.InvariantCulture),
                        ContractAllocationNumber = AllocationNumber,
                        FundingstreamPeriodCode = "ASC1516",
                        Contract = new Contract
                        {
                            FundingType = new FundingType
                            {
                                FundingTypeCode = FundingTypeCode,
                                FundingTypeName = FundingTypeName
                            },
                            ContractNumber = ContractNumber,
                            ContractVersionNumber = ContractVersionNumber,
                            ContractSubVersionNumber = ContractSubVersionNumber,
                            ContractApprovalDate = DateTime.Parse(ContractApprovalDate)
                        },
                        Amounts = new AmountSummary
                        {
                            CappedClaimedValue = 100m,
                            ClaimedValue = 200m,
                            PlannedValue = 300m,
                            ProposedReconciliationValue = 400m,
                            ReconciliationValue = 500m,
                            AdjustedCappedClaimValue = 602m,
                            ClaimAdjustments = new ClaimAdjustment(1m, "FRM Data Query")
                        },
                        ContractDeliverables = new List<ContractDeliverable>
                        {
                            new ContractDeliverable
                            {
                                Amounts = new AmountSummary
                                {
                                    ClaimedValue = 100m,
                                    PlannedValue = 200m
                                },
                                Deliverable = new Deliverable
                                {
                                    DeliverableCode = 5,
                                    DeliverableName = "19-23 Apprenticeships Learning Support"
                                }
                            },
                            new ContractDeliverable
                            {
                                Amounts = new AmountSummary
                                {
                                    ClaimedValue = 100m,
                                    PlannedValue = 200m
                                },
                                Deliverable = new Deliverable
                                {
                                    DeliverableCode = 6,
                                    DeliverableName = "19+ Apprenticeships Learner Support"
                                }
                            }
                        }
                    }
                },
                Contractor = new Contractor
                {
                    LegalName = ContractorLegalName,
                    OrganisationIdentifier = organisationId,
                    UKPRN = int.Parse(Ukprn)
                },
                Period = new Period
                {
                    PeriodTypeCode = PeriodTypeCode.AY,
                    PeriodTypeName = PeriodTypeName.ACADEMICYEAR,
                    PeriodYear = "1516"
                },
                Status = ReconciliationStatus.Draft,
                StatusLastUpdatedDate = DateTime.Parse(StatusLastUpdatedDate)
            };
        }

        private void UpdateFcrStatusToPublishInProgress(Guid fcrGuid)
        {
            CrmOrganizationService.Update(new sfa_fundingclaimreconciliation
            {
                Id = fcrGuid,
                sfa_substatusEnum = sfa_sfasubstatuscode.PublishInProgress,
                sfa_StatusLastUpdatedDate = DateTime.UtcNow
            });
        }

        private void CreateContractAndAllocationsInCrm(int contractVersionNumber, sfa_contractstatus contractStatus)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = Ukprn,
                sfa_number = ContractNumber,
                sfa_Version = contractVersionNumber,
                sfa_ProviderName = GetOrgEntityReference(),
                sfa_FundingType = GetFundingTypeEntityReference()
            };

            contract.Id = CrmOrganizationService.Create(contract);
            contract.sfa_ContractStatus = new OptionSetValue((int)contractStatus);
            CrmOrganizationService.Update(contract);

            sfa_contractallocation contractallocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contract.Id),
                sfa_contractallocationnumber = AllocationNumber,
            };

            CrmOrganizationService.Create(contractallocation);
        }

        private EntityReference GetOrgEntityReference()
        {
            if (_orgEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(CrmOrganizationService))
                {
                    _orgEntityReference = crmContext.AccountSet.First(a => a.sfa_UKPRN == Ukprn).ToEntityReference();
                }
            }

            return _orgEntityReference;
        }

        private EntityReference GetFundingTypeEntityReference()
        {
            if (_fundingTypeEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(CrmOrganizationService))
                {
                    _fundingTypeEntityReference = crmContext.sfa_fundingtypeSet.First(ft => ft.sfa_fundingtypecode == "MAIN").ToEntityReference();
                }
            }

            return _fundingTypeEntityReference;
        }

        private void CreateTestFixturesInCrm(string organisationId)
        {
            Account account = new Account
            {
                sfa_OrganisationID = organisationId,
                sfa_UKPRN = Ukprn.ToString(),
                Name = ContractorLegalName
            };
            Guid accountId = CrmOrganizationService.Create(account);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, accountId),
                sfa_organisationname = ContractorLegalName
            };

            CrmOrganizationService.Create(caseload);

            sfa_contract masterContract = new sfa_contract
            {
                sfa_UKPRN = Ukprn.ToString(),
                sfa_number = MasterContractNumber,
                sfa_Description = "Test Description",
                sfa_ContractType = new EntityReference(sfa_contracttype.EntityLogicalName,
                    GetContractType("Contract for Services")),
                sfa_FundingType =
                    new EntityReference(SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype.EntityLogicalName, GetFundingType(FundingTypeCode)),
                sfa_Version = ContractVersionNumber,
                sfa_SubVersion = ContractSubVersionNumber,
                sfa_ProviderName = new EntityReference(Account.EntityLogicalName, accountId)
            };

            Guid masterContractId = CrmOrganizationService.Create(masterContract);

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = Ukprn.ToString(),
                sfa_number = ContractNumber,
                sfa_Description = "Test Description",
                sfa_ContractType = new EntityReference(sfa_contracttype.EntityLogicalName,
                    GetContractType("Contract for Services")),
                sfa_FundingType =
                    new EntityReference(SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype.EntityLogicalName, GetFundingType(FundingTypeCode)),
                sfa_Version = ContractVersionNumber,
                sfa_SubVersion = ContractSubVersionNumber,
                sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, masterContractId),
                sfa_ContractApprovalDate = DateTime.SpecifyKind(DateTime.Parse(ContractApprovalDate), DateTimeKind.Utc),
                sfa_ProviderName = new EntityReference(Account.EntityLogicalName, accountId)
            };

            Guid contractId = CrmOrganizationService.Create(contract);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_contractallocationnumber = AllocationNumber,
                sfa_startdate = DateTime.SpecifyKind(DateTime.Parse(AllocationStartDate), DateTimeKind.Utc),
                sfa_enddate = DateTime.SpecifyKind(DateTime.Parse(AllocationEndDate), DateTimeKind.Utc),
                sfa_FundingStreamPeriodId = new EntityReference(sfa_fundingstreamperiod.EntityLogicalName,
                    GetFspId(FundingStreamPeriodCode))
            };

            Guid allocationId = CrmOrganizationService.Create(allocation);

            UpdateContractStatusToApproved(contractId, DateTime.SpecifyKind(DateTime.Parse(ContractApprovalDate), DateTimeKind.Utc));
        }

        private Guid GetFspId(string fundingStreamPeriodCode)
        {
            using (var context = new XrmServiceContext(CrmOrganizationService))
            {
                return context.sfa_fundingstreamperiodSet.Single(fsp => fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode).Id;
            }
        }

        private Guid GetFundingType(string fundingTypeCode)
        {
            using (var context = new XrmServiceContext(CrmOrganizationService))
            {
                return context.sfa_fundingtypeSet.Single(ft => ft.sfa_fundingtypecode == fundingTypeCode).Id;
            }
        }

        private Guid GetContractType(string contractType)
        {
            using (var context = new XrmServiceContext(CrmOrganizationService))
            {
                return context.sfa_contracttypeSet.Single(ct => ct.sfa_name == contractType).Id;
            }
        }

        private void UpdateContractStatusToApproved(Guid contractId, DateTime approvalDate)
        {
            sfa_contract contractToUpdate = new sfa_contract
            {
                Id = contractId,
                sfa_ContractStatusEnum = sfa_contractstatus.Approved,
                sfa_LastApprovedVersion = true,
                sfa_ContractApprovalDate = approvalDate,
                sfa_StatusLastUpdatedDate = approvalDate
            };

            CrmOrganizationService.Update(contractToUpdate);
        }

        private void RemoveTestFixturesFromCrm()
        {
            sfa_fundingclaimreconciliation fcrToDelete = RetrieveFundingClaimReconciliationFromCrm(FcrEntityName);

            if (fcrToDelete != null)
            {
                CrmOrganizationService.Delete(nameof(sfa_fundingclaimreconciliation), fcrToDelete.Id);
                //also removes fundingAllocations & Dels
            }

            GetContractsForContractNumber(ContractNumber).ToList().ForEach(c => RemoveContract(c.Id));
            GetContractsForContractNumber(MasterContractNumber).ToList().ForEach(c => RemoveContract(c.Id));

            GetOrganisationsForOrganisationId(OrganisationIdTest1).ToList().ForEach(o => RemoveOrganisation(o.Id));
            GetOrganisationsForOrganisationId(OrganisationIdTest2).ToList().ForEach(o => RemoveOrganisation(o.Id));
        }

        protected void RemoveContract(Guid contractGuid)
        {
            CrmOrganizationService.Delete("sfa_contract", contractGuid);
        }

        private void RemoveOrganisation(Guid organisationGuid)
        {
            CrmOrganizationService.Delete("account", organisationGuid);
        }

        private IList<Account> GetOrganisationsForOrganisationId(string organisationId)
        {
            using (var xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmServiceContext.AccountSet.Where(a => a.sfa_OrganisationID == organisationId).ToList();
            }
        }

        private IList<sfa_contract> GetContractsForContractNumber(string contractNumber)
        {
            using (var xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmServiceContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber).ToList();
            }
        }

        private class XrmServicesInstaller : IWindsorInstaller
        {
            public void Install(IWindsorContainer container, IConfigurationStore store)
            {
                XrmConnectionString connectionString = new XrmConnectionString
                {
                    ConnectionStringDictionary = new Dictionary<string, string>()
                };
                connectionString.ConnectionStringDictionary.Add("CRMIntegration", ConfigurationManager.ConnectionStrings["CrmConnectionString"]?.ConnectionString);

                container.Register(
                    Types.FromAssembly(typeof(IUseXrmService).Assembly)
                        .BasedOn<IUseXrmService>().LifestyleTransient(),
                    Component.For<IXrmServiceFactory>()
                        .ImplementedBy<XrmServiceFactory>().LifeStyle.Transient,
                    Component.For<IXrmConnectionString>().Instance(connectionString));
            }
        }
    }
}
