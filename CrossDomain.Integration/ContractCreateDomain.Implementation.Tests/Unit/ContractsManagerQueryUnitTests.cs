namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class ContractsManagerQueryUnitTests
    {
        private static ContractsManager CreateManager(FakeCrm crm)
        {
            return new ContractsManager { OrganizationService = crm.Service };
        }

        private static object StandardValues(string entity, string column)
        {
            switch (column)
            {
                case "sfa_number": return "C-1";
                case "sfa_contractstatus": return new OptionSetValue((int)sfa_contractstatus.Approved);
                case "sfa_periodtypecode": return "AY";
                case "sfa_periodtypename": return "Academic Year";
                case "sfa_fundingtypecode": return "GG";
                case "sfa_fundingstreamcode": return "FS";
                case "sfa_fundingstreamperiodcode": return "FSP";
                default: return null;
            }
        }

        private static Func<QueryExpression, int> SingleLevelDeliverables()
        {
            var nestedQueries = 0;
            return query => query.EntityName != "sfa_contractdeliverable" || query.LinkEntities.Any() ? 1 : (nestedQueries++ == 0 ? 1 : 0);
        }
        private static Func<QueryExpression, int> OneContractRowOnly()
        {
            var contractQueries = 0;
            return query => query.EntityName == "sfa_contract" && contractQueries++ > 0 ? 0 : 1;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLatestContract_ShouldMapMasterContractChildrenAllocationsAndDeliverables()
        {
            var crm = new FakeCrm(StandardValues);

            var master = CreateManager(crm).GetLatestContract("C-1", new[] { "C-1" });

            Assert.AreEqual("C-1", master.contractNumber);
            Assert.AreEqual("Approved", master.status);
            Assert.AreEqual("GG", master.fundingTypeCode);
            Assert.AreEqual(1, master.contracts.Count);

            var child = master.contracts.Single();
            Assert.AreEqual("C-1", child.contractNumber);
            Assert.AreEqual("Approved", child.status);
            Assert.AreEqual("AY", child.period.periodType1.periodTypeCode);
            Assert.AreEqual(SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.amendmentType.None, child.amendmentType);
            Assert.IsNull(child.NewStartsSuspendedReason);

            var allocation = child.contractAllocations.Single();
            Assert.AreEqual("FS", allocation.fundingStreamCode);
            Assert.AreEqual("FSP", allocation.fundingStreamPeriodCode);
            Assert.AreEqual(1, allocation.DeliveryOrganisationDetail.ukprn);

            var deliverable = allocation.contractDeliverables.Single();
            Assert.AreEqual(1, deliverable.deliverable.deliverableCode);
            Assert.AreEqual(1, deliverable.contractDeliverablePeriods.Count);
            Assert.AreEqual("AY", deliverable.contractDeliverablePeriods.Single().periodType.periodTypeCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLatestContract_ShouldReturnNoChildren_WhenNoChildContractNumbersAreSupplied()
        {
            var crm = new FakeCrm(StandardValues);

            var master = CreateManager(crm).GetLatestContract("C-1", new string[0]);

            Assert.AreEqual(0, master.contracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLatestContract_ShouldReturnNull_WhenNothingMatches()
        {
            var crm = new FakeCrm(StandardValues, query => 0);

            Assert.IsNull(CreateManager(crm).GetLatestContract("C-1", new[] { "C-1" }));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractForId_ShouldMapMasterWithTheSingleChild()
        {
            var crm = new FakeCrm(StandardValues);

            var master = CreateManager(crm).GetContractForId(Guid.NewGuid());

            Assert.AreEqual("C-1", master.contractNumber);
            Assert.AreEqual(1, master.contracts.Count);
            Assert.AreEqual("C-1", master.contracts.Single().contractNumber);
            Assert.AreEqual(1, master.contracts.Single().contractAllocations.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractForId_ShouldReturnNull_WhenNothingMatches()
        {
            var crm = new FakeCrm(StandardValues, query => 0);

            Assert.IsNull(CreateManager(crm).GetContractForId(Guid.NewGuid()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractForId_ShouldTranslateOptionSetsOwnerAndOptionalLookups()
        {
            var ownerId = Guid.NewGuid();
            var crm = new FakeCrm((entity, column) =>
            {
                switch (column)
                {
                    case "ownerid": return new EntityReference("team", ownerId);
                    case "sfa_amendmenttype": return new OptionSetValue((int)sfa_amendmenttype.Variation);
                    case "sfa_terminationreason": return new OptionSetValue((int)sfa_TerminationReasons.ContractNovation);
                    case "sfa_inflightterminationreason": return new OptionSetValue((int)sfa_TerminationReasons.DeactivatedUKPRN);
                    case "sfa_defaultnewstartssuspendedreason": return new OptionSetValue((int)sfa_newstartssuspendedreason.RemovedfromRoATP);
                    case "sfa_inflightnewstartssuspendedreason": return new OptionSetValue((int)sfa_newstartssuspendedreason.InadequateOfsted);
                    case "sfa_newstartssuspendedreason": return new OptionSetValue((int)sfa_newstartssuspendedreason.Other);
                    case "sfa_deliveryorganisationprovider": return FakeCrm.Omit;
                    default: return StandardValues(entity, column);
                }
            });

            var child = CreateManager(crm).GetContractForId(Guid.NewGuid()).contracts.Single();

            Assert.AreEqual(SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.amendmentType.Variation, child.amendmentType);
            Assert.AreEqual(ownerId, child.Owner.OwnerId);
            Assert.AreEqual(SFA.FCT.CrossDomain.Integration.Entities.OwnerType.Team, child.Owner.OwnerType);
            Assert.AreEqual("ContractNovation", child.TerminationReason);
            Assert.AreEqual("DeactivatedUKPRN", child.InflightTerminationReason);
            Assert.AreEqual("Removed from RoATP", child.NewStartsSuspendedReason);
            Assert.AreEqual("Inadequate Ofsted", child.InflightNewStartsSuspendedReason);
            Assert.AreEqual("Other", child.contractAllocations.Single().NewStartsSuspendedReason);
            Assert.IsNull(child.contractAllocations.Single().DeliveryOrganisationDetail.legalName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLatestContract_ShouldMapNotificationAmendmentsAndSystemUserOwners()
        {
            var crm = new FakeCrm((entity, column) =>
            {
                switch (column)
                {
                    case "sfa_amendmenttype": return new OptionSetValue((int)sfa_amendmenttype.Notification);
                    case "ownerid": return FakeCrm.Omit;
                    default: return StandardValues(entity, column);
                }
            });

            var child = CreateManager(crm).GetLatestContract("C-1", new[] { "C-1" }).contracts.Single();

            Assert.AreEqual(SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.amendmentType.Notification, child.amendmentType);
            Assert.IsNull(child.Owner.OwnerId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractForId_ShouldMapSystemUserOwners()
        {
            var crm = new FakeCrm(StandardValues);

            var child = CreateManager(crm).GetContractForId(Guid.NewGuid()).contracts.Single();

            Assert.AreEqual(SFA.FCT.CrossDomain.Integration.Entities.OwnerType.SystemUser, child.Owner.OwnerType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldReturnTheLastApprovedContractWithDatesInLocalTime()
        {
            var crm = new FakeCrm(StandardValues);

            var contract = CreateManager(crm).GetCorporateContract("C-1", "C-1");

            Assert.AreEqual("C-1", contract.contractNumber);
            Assert.AreEqual(new DateTime(2019, 1, 1, 1, 0, 0), contract.startDate);
            Assert.AreEqual("GG", contract.fundingType.fundingTypeCode);
            var child = contract.contracts.Single();
            Assert.AreEqual("Approved", child.contractStatus.parentStatus);
            Assert.AreEqual(new DateTime(2019, 1, 1, 1, 0, 0), child.startDate);
            Assert.AreEqual(new DateTime(2019, 1, 1, 1, 0, 0), child.period.startDate);

            var allocation = child.contractAllocations.Single();
            Assert.AreEqual(new DateTime(2019, 1, 1, 1, 0, 0), allocation.startDate);
            Assert.AreEqual("GG", allocation.fundingStream.fundingTypeCode);
            Assert.AreEqual("FS", allocation.fundingStream.fundingStreamCode);
            Assert.AreEqual("FSP", allocation.fundingStreamPeriodCode);
            Assert.AreEqual(1, allocation.contractDeliverables.Count);
            Assert.AreEqual(1, allocation.contractDeliverables.Single().contractDeliverablePeriods.Count);
            Assert.IsNotNull(allocation.DeliveryOrganisationDetail);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldReturnTheLatestVersion_WhenLastApprovedIsNotRequired()
        {
            var crm = new FakeCrm(StandardValues);

            var contract = CreateManager(crm).GetCorporateContract("C-1", "C-1", false);

            Assert.AreEqual("C-1", contract.contractNumber);
            Assert.AreEqual(1, contract.contracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldReturnNull_WhenNothingMatches()
        {
            var crm = new FakeCrm(StandardValues, query => 0);

            Assert.IsNull(CreateManager(crm).GetCorporateContract("C-1", "C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldNotAdjustDates_WhenThereAreNoChildContracts()
        {
            var crm = new FakeCrm(StandardValues, OneContractRowOnly());

            var contract = CreateManager(crm).GetCorporateContract("C-1", "C-1");

            Assert.AreEqual(0, contract.contracts.Count);
            Assert.AreEqual(new DateTime(2019, 1, 1), contract.startDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldFail_WhenTheUsersTimeZoneIsNotKnown()
        {
            var crm = new FakeCrm(StandardValues) { TimeZoneCode = null };
            var manager = CreateManager(crm);

            ThrowsHelper.Throws<Exception>(() => manager.GetCorporateContract("C-1", "C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldSupportContractsWithoutPeriodsOrFundingTypes()
        {
            var crm = new FakeCrm((entity, column) =>
            {
                switch (column)
                {
                    case "sfa_periodid": return FakeCrm.Omit;
                    case "sfa_contractvalue": return new Money(0m);
                    case "sfa_enddate": return FakeCrm.Omit;
                    case "sfa_description": return FakeCrm.Omit;
                    default: return StandardValues(entity, column);
                }
            });

            var contract = CreateManager(crm).GetCorporateContract("C-1", "C-1");

            Assert.IsNull(contract.contractValue);
            Assert.IsNull(contract.contracts.Single().period);
            Assert.IsNull(contract.contracts.Single().description);
            Assert.IsNull(contract.contracts.Single().contractAllocations.Single().period);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldAddLepRelationship_WhenAllocationHasALepWithNumericOrganisationId()
        {
            var crm = new FakeCrm((entity, column) => column == "sfa_organisationid" ? "1234" : StandardValues(entity, column));

            var allocation = CreateManager(crm).GetCorporateContract("C-1", "C-1").contracts.Single().contractAllocations.Single();

            var relationship = allocation.allocationOrganisationRelationships.Single();
            Assert.AreEqual(1234, relationship.organisationIdentifier);
            Assert.AreEqual(SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.organisationRelationshipType.LEP, relationship.organisationRelationshipType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldIgnoreLep_WhenOrganisationIdIsNotNumeric()
        {
            var crm = new FakeCrm((entity, column) => column == "sfa_organisationid" ? "abc" : StandardValues(entity, column));

            var allocation = CreateManager(crm).GetCorporateContract("C-1", "C-1").contracts.Single().contractAllocations.Single();

            Assert.IsNull(allocation.allocationOrganisationRelationships);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldIgnoreLep_WhenAllocationHasNoLepCode()
        {
            var crm = new FakeCrm((entity, column) => column == "sfa_lepcode" ? FakeCrm.Omit : StandardValues(entity, column));

            var allocation = CreateManager(crm).GetCorporateContract("C-1", "C-1").contracts.Single().contractAllocations.Single();

            Assert.IsNull(allocation.allocationOrganisationRelationships);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldIgnoreDeliveryOrganisation_WhenNoUkprnIsHeld()
        {
            var crm = new FakeCrm((entity, column) => column == "sfa_deliveryorganisationukprn" ? FakeCrm.Omit : StandardValues(entity, column));

            var allocation = CreateManager(crm).GetCorporateContract("C-1", "C-1").contracts.Single().contractAllocations.Single();

            Assert.IsNull(allocation.DeliveryOrganisation);
            Assert.IsFalse(allocation.HasDeliveryOrganisation());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContract_ShouldReadChildDeliverablesRecursively()
        {
            var nestedQueries = 0;
            var crm = new FakeCrm(
                StandardValues,
                query =>
                {
                    if (query.EntityName != "sfa_contractdeliverable" || query.LinkEntities.Any())
                    {
                        return 1;
                    }

                    return nestedQueries++ == 0 ? 1 : 0;
                });

            var deliverable = CreateManager(crm).GetCorporateContract("C-1", "C-1")
                .contracts.Single().contractAllocations.Single().contractDeliverables.Single();

            Assert.AreEqual(1, deliverable.contractDeliverables.Count);
            Assert.AreEqual(1, deliverable.contractDeliverables.Single().deliverable.deliverableCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContractForSpecificVersion_ShouldReturnTheRequestedVersion()
        {
            var crm = new FakeCrm(StandardValues, SingleLevelDeliverables());

            var contract = CreateManager(crm).GetCorporateContractForSpecificVersion("C-1", "C-1", 1);

            Assert.AreEqual("C-1", contract.contractNumber);
            Assert.AreEqual(1, contract.contracts.Count);
            Assert.AreEqual(new DateTime(2019, 1, 1, 1, 0, 0), contract.contracts.Single().startDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContractForSpecificVersion_ShouldReturnNull_WhenNothingMatches()
        {
            var crm = new FakeCrm(StandardValues, query => 0);

            Assert.IsNull(CreateManager(crm).GetCorporateContractForSpecificVersion("C-1", "C-1", 1));
            Assert.IsNull(CreateManager(crm).GetCorporateContractForSpecificVersion("C-1", 1, 0));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContractForSpecificVersion_ShouldReturnNoChildren_WhenTheVersionDoesNotExist()
        {
            var crm = new FakeCrm(StandardValues, OneContractRowOnly());

            var contract = CreateManager(crm).GetCorporateContractForSpecificVersion("C-1", "C-1", 5);

            Assert.AreEqual(0, contract.contracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContractForSpecificVersionAndSubVersion_ShouldReturnTheRequestedVersion()
        {
            var crm = new FakeCrm((entity, column) => column == "sfa_previousversion" ? FakeCrm.Omit : StandardValues(entity, column), SingleLevelDeliverables());

            var contract = CreateManager(crm).GetCorporateContractForSpecificVersion("C-1", 1, 0);

            var child = contract.contracts.Single();
            Assert.AreEqual("C-1", contract.contractNumber);
            Assert.AreEqual(Guid.Empty, child.PreviousVersionId);
            Assert.AreNotEqual(Guid.Empty, child.ContractAdvisorId);
            Assert.IsNotNull(child.CrmContractId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCorporateContractForSpecificVersionAndSubVersion_ShouldReturnNoChildren_WhenTheVersionDoesNotExist()
        {
            var crm = new FakeCrm(StandardValues, OneContractRowOnly());

            var contract = CreateManager(crm).GetCorporateContractForSpecificVersion("C-1", 5, 5);

            Assert.AreEqual(0, contract.contracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetApprovedContracts_ShouldSummariseTheContractsReturned()
        {
            var crm = new FakeCrm((entity, column) => column == "sfa_version" ? 3 : StandardValues(entity, column));

            var summaries = CreateManager(crm).GetApprovedContracts(new DateTime(2019, 1, 1));

            var summary = summaries.Single();
            Assert.AreEqual("C-1", summary.ContractNumber);
            Assert.AreEqual(3, summary.ContractVersionNumber);
            Assert.AreEqual("Name", summary.MasterContractNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetApprovedContracts_ShouldUseTheCrmMinimumDate_WhenNoDateIsGiven()
        {
            var crm = new FakeCrm((entity, column) => column == "sfa_parentcontractid" ? FakeCrm.Omit : StandardValues(entity, column));

            var summaries = CreateManager(crm).GetApprovedContracts(DateTime.MinValue);

            Assert.AreEqual(string.Empty, summaries.Single().MasterContractNumber);
            Assert.IsTrue(crm.Xrm.Queries.Single().Criteria.Filters.SelectMany(f => f.Conditions).Concat(crm.Xrm.Queries.Single().Criteria.Conditions)
                .Any(c => c.AttributeName == "modifiedon" && c.Values.OfType<DateTime>().Any(d => d == new DateTime(1900, 1, 1))));
        }
    }
}
