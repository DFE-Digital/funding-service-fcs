namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Optional;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class PreviousContractRepositoryTests : IntegrationTestBase
    {
        private EntityReference _providerEntityReference;

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreviousContractRepository_GetLatestContract_ShouldReturnPreviousContractWhenLatestVersionIsTrue()
        {
            // arrange
            // contract values
            const string contractNumber = "XX=Test";
            const int versionNumber = 2;
            DateTime contractStartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc);
            DateTime contractEndDate = new DateTime(2018, 09, 01, 0, 0, 0, DateTimeKind.Utc);
            const string masterContractNumber = "MXX=Test";
            const string deliveryOrgUkprn = "43211212";
            const string deliveryOrgLegalName = "Some Org";
            const string amendmentType = "Variation";
            const string contractDescription = "Contract Description";
            const string contractType = "16-19 Funding";

            // allocation values
            const string allocNumber = "ALLC-PREV";
            DateTime allocStartDate = new DateTime(2017, 08, 01, 0, 0, 0, DateTimeKind.Utc);
            DateTime allocEndDate = new DateTime(2017, 09, 01, 0, 0, 0, DateTimeKind.Utc);
            const string allocLepName = "lepname";
            const string allocLepCode = "lepcode";
            const string allocTenderSpecRef = "tender_spec_ref";
            const string allocLotreference = "lot";
            const string allocTenderAwardReference = "award";
            const string allocActivityDescription = "project";
            const string allocDescription = "description";
            const string allocAmendmentReason = "AmendmentReason";
            const string allocInvestmentPriority = "Priority";
            const string allocAgreementNumber = "agreementNo";
            const string allocSpecificationTitle = "spec";
            const string allocRegionType = "RegionType";
            const string allocLearningRatePremium = "learning";
            const string allocFundingstreamcode = "ESF 201420";
            const string allocFundingstreamperiodcode = "ESF1420";


            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            DeleteOrg(deliveryOrgUkprn);
            EntityReference deliveryOrgEntityRef = CreateOrg(deliveryOrgUkprn, deliveryOrgLegalName);

            Guid masterContract = CreateTestContract(
                contractNumber: masterContractNumber,
                version: versionNumber);

            CreateTestContract(
                contractNumber: contractNumber,
                version: versionNumber - 1,
                isLatestVersion: false,
                isLastApprovedVersion: null,
                parentContract: new EntityReference(sfa_contract.EntityLogicalName, masterContract),
                contractStartDate: contractStartDate,
                contractEndDate: contractEndDate,
                amendmentType: amendmentType,
                contractDescription: contractDescription,
                contractType: GetContractTypeEntityReference(contractType));


            Guid contractId = CreateTestContract(
                contractNumber: contractNumber,
                version: versionNumber,
                isLatestVersion: true,
                isLastApprovedVersion: null,
                parentContract: new EntityReference(sfa_contract.EntityLogicalName, masterContract),
                contractStartDate: contractStartDate,
                contractEndDate: contractEndDate,
                amendmentType: amendmentType,
                contractDescription: contractDescription,
                contractType: GetContractTypeEntityReference(contractType));

            CreateAllocation(allocNumber, allocStartDate, allocEndDate, allocLepName,
                allocLepCode, allocTenderSpecRef, allocLotreference, allocTenderAwardReference, allocActivityDescription,
                allocDescription, allocAmendmentReason, allocInvestmentPriority, allocAgreementNumber, allocSpecificationTitle,
                allocRegionType, allocLearningRatePremium, allocFundingstreamcode, allocFundingstreamperiodcode, deliveryOrgUkprn,
                deliveryOrgEntityRef, contractId);

            PreviousContractRepository previousContractRepository = new PreviousContractRepository(CrmOrganizationService);

            // act
            Option<PreviousContract> latestContract = previousContractRepository.GetLatestContract(contractNumber);

            // assert
            PreviousContract previousContract = null;
            latestContract.Match(some: x => { previousContract = x; }, none: () => Assert.Fail("GetLatestContract method did not return previous contract information"));

            Assert.AreEqual(contractStartDate.ToUniversalTime(), previousContract.ContractStartDate.Value.ToUniversalTime(), "The ContractStartDate is incorrect");
            Assert.AreEqual(contractEndDate.ToUniversalTime(), previousContract.ContractEndDate.Value.ToUniversalTime(), "The ContractEndDate is incorrect");
            Assert.AreEqual(masterContractNumber, previousContract.MasterContractReferenceNumber, "The MasterContractReferenceNumber is incorrect");
            Assert.AreEqual(amendmentType, previousContract.AmendmentType, "The AmendType is incorrect");
            Assert.AreEqual(contractDescription, previousContract.ContractDescription, "The ContractDescription is incorrect");
            Assert.AreEqual(contractType, previousContract.ContractType, "The ContractType is incorrect");

            Assert.AreEqual(1, previousContract.PreviousAllocations.Count, "Incorrect number of previous allocations returned");
            var previousAllocation = previousContract.PreviousAllocations.First();

            Assert.AreEqual(allocNumber, previousAllocation.AllocationNumber, "The PreviousAllocation AllocationNumber is incorrect");
            Assert.AreEqual(allocStartDate.ToUniversalTime(), previousAllocation.StartDate, "The PreviousAllocation StartDate is incorrect");
            Assert.AreEqual(allocEndDate.ToUniversalTime(), previousAllocation.EndDate, "The PreviousAllocation EndDate is incorrect");
            Assert.AreEqual(allocFundingstreamcode, previousAllocation.FundingStreamCode, "The PreviousAllocation FundingStreamCode is incorrect");
            Assert.AreEqual(allocLepName, previousAllocation.LepName, "The PreviousAllocation LepName is incorrect");
            Assert.AreEqual(allocLepCode, previousAllocation.LepCode, "The PreviousAllocation LepCode is incorrect");
            Assert.AreEqual(allocTenderSpecRef, previousAllocation.TenderSpecReference, "The PreviousAllocation TenderSpecReference is incorrect");
            Assert.AreEqual(allocLotreference, previousAllocation.LotReference, "The PreviousAllocation LotReference is incorrect");
            Assert.AreEqual(allocTenderAwardReference, previousAllocation.TenderAwardReference, "The PreviousAllocation TenderAwardReference is incorrect");
            Assert.AreEqual(allocActivityDescription, previousAllocation.ActivityDescription, "The PreviousAllocation ActivityDescription is incorrect");
            Assert.AreEqual(allocDescription, previousAllocation.AllocationDescription, "The PreviousAllocation AllocationDescription is incorrect");
            Assert.AreEqual(allocAmendmentReason, previousAllocation.AmendmentReason, "The PreviousAllocation AmendmentReason is incorrect");
            Assert.AreEqual(allocInvestmentPriority, previousAllocation.InvestmentPriority, "The PreviousAllocation InvestmentPriority is incorrect");
            Assert.AreEqual(allocAgreementNumber, previousAllocation.AgreementNumber, "The PreviousAllocation AgreementNumber is incorrect");
            Assert.AreEqual(allocSpecificationTitle, previousAllocation.SpecificationTitle, "The PreviousAllocation SpecificationTitle is incorrect");
            Assert.AreEqual(allocRegionType, previousAllocation.RegionType, "The PreviousAllocation RegionType is incorrect");
            Assert.AreEqual(allocLearningRatePremium, previousAllocation.LearningRatePremium, "The LearningRatePremium is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreviousContractRepository_GetLatestContract_ShouldNotReturnPreviousContractWhenLatestVersionIsNotTrue()
        {
            // arrange
            const string contractNumber = "XX=Test";
            const int versionNumber = 1;

            DateTime startDate = new DateTime(2018, 08, 01);
            DateTime endtDate = new DateTime(2018, 09, 01);
            const string masterContractNumber = "MXX=Test";
            const string amendmentType = "Variation";
            const string contractDescription = "Contract Description";
            const string contractType = "16-19 Funding";

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            Guid masterContract = CreateTestContract(
                contractNumber: masterContractNumber,
                version: versionNumber);

            Guid contractId = CreateTestContract(
                contractNumber: contractNumber,
                version: versionNumber,
                isLatestVersion: false,
                isLastApprovedVersion: null,
                parentContract: new EntityReference(sfa_contract.EntityLogicalName, masterContract),
                contractStartDate: startDate,
                contractEndDate: endtDate,
                amendmentType: amendmentType,
                contractDescription: contractDescription,
                contractType: GetContractTypeEntityReference(contractType));

            PreviousContractRepository previousContractRepository = new PreviousContractRepository(CrmOrganizationService);

            // act
            Option<PreviousContract> latestContract = previousContractRepository.GetLatestContract(contractNumber);

            // assert
            latestContract.Match(some: x => { Assert.Fail("GetLatestContract method incorrectly returned previous contract information"); }, none: () => { });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreviousContractRepository_GetLastApprovedContract_ShouldReturnPreviousContractWhenLastApprovedVersionIsTrue()
        {
            // arrange
            // contract values
            const string contractNumber = "XX=Test";
            const int versionNumber = 1;
            DateTime contractStartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc);
            DateTime contractEndDate = new DateTime(2018, 09, 01, 0, 0, 0, DateTimeKind.Utc);
            const string masterContractNumber = "MXX=Test";
            const string deliveryOrgUkprn = "45621212";
            const string deliveryOrgLegalName = "Some Org";
            const string amendmentType = "Variation";
            const string contractDescription = "Contract Description";
            const string contractType = "16-19 Funding";

            // allocation values
            const string allocNumber = "ALLC-PREV";
            DateTime allocStartDate = new DateTime(2017, 08, 01, 0, 0, 0, DateTimeKind.Utc);
            DateTime allocEndDate = new DateTime(2017, 09, 01, 0, 0, 0, DateTimeKind.Utc);
            const string allocLepName = "lepname";
            const string allocLepCode = "lepcode";
            const string allocTenderSpecRef = "tender_spec_ref";
            const string allocLotreference = "lot";
            const string allocTenderAwardReference = "award";
            const string allocActivityDescription = "project";
            const string allocDescription = "description";
            const string allocAmendmentReason = "AmendmentReason";
            const string allocInvestmentPriority = "Priority";
            const string allocAgreementNumber = "agreementNo";
            const string allocSpecificationTitle = "spec";
            const string allocRegionType = "RegionType";
            const string allocLearningRatePremium = "learning";
            const string allocFundingstreamcode = "ALLBC";
            const string allocFundingstreamperiodcode = "24+ALLBC1516";

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            DeleteOrg(deliveryOrgUkprn);
            EntityReference deliveryOrgEntityRef = CreateOrg(deliveryOrgUkprn, deliveryOrgLegalName);

            Guid masterContract = CreateTestContract(
                contractNumber: masterContractNumber,
                version: versionNumber);

            Guid contractId = CreateTestContract(
                contractNumber: contractNumber,
                version: versionNumber,
                isLatestVersion: false,
                isLastApprovedVersion: true,
                parentContract: new EntityReference(sfa_contract.EntityLogicalName, masterContract),
                contractStartDate: contractStartDate,
                contractEndDate: contractEndDate,
                amendmentType: amendmentType,
                contractDescription: contractDescription,
                contractType: GetContractTypeEntityReference(contractType));

            CreateAllocation(allocNumber, allocStartDate, allocEndDate, allocLepName,
                allocLepCode, allocTenderSpecRef, allocLotreference, allocTenderAwardReference, allocActivityDescription,
                allocDescription, allocAmendmentReason, allocInvestmentPriority, allocAgreementNumber, allocSpecificationTitle,
                allocRegionType, allocLearningRatePremium, allocFundingstreamcode, allocFundingstreamperiodcode, deliveryOrgUkprn,
                deliveryOrgEntityRef, contractId);

            PreviousContractRepository previousContractRepository = new PreviousContractRepository(CrmOrganizationService);

            // act
            Option<PreviousContract> latestContract = previousContractRepository.GetLastApprovedContract(contractNumber);

            // assert
            PreviousContract previousContract = null;
            latestContract.Match(some: x => { previousContract = x; }, none: () => Assert.Fail("GetLatestContract method did not return previous contract information"));

            Assert.AreEqual(contractStartDate.ToUniversalTime(), previousContract.ContractStartDate.Value.ToUniversalTime(), "The ContractStartDate is incorrect");
            Assert.AreEqual(contractEndDate.ToUniversalTime(), previousContract.ContractEndDate.Value.ToUniversalTime(), "The ContractEndDate is incorrect");
            Assert.AreEqual(masterContractNumber, previousContract.MasterContractReferenceNumber, "The MasterContractReferenceNumber is incorrect");
            Assert.AreEqual(amendmentType, previousContract.AmendmentType, "The AmendType is incorrect");
            Assert.AreEqual(contractDescription, previousContract.ContractDescription, "The ContractDescription is incorrect");
            Assert.AreEqual(contractType, previousContract.ContractType, "The ContractType is incorrect");

            Assert.AreEqual(1, previousContract.PreviousAllocations.Count, "Incorrect number of previous allocations returned");
            var previousAllocation = previousContract.PreviousAllocations.First();

            Assert.AreEqual(allocNumber, previousAllocation.AllocationNumber, "The PreviousAllocation AllocationNumber is incorrect");
            Assert.AreEqual(allocStartDate.ToUniversalTime(), previousAllocation.StartDate.Value.ToUniversalTime(), "The PreviousAllocation StartDate is incorrect");
            Assert.AreEqual(allocEndDate.ToUniversalTime(), previousAllocation.EndDate.Value.ToUniversalTime(), "The PreviousAllocation EndDate is incorrect");
            Assert.AreEqual(allocFundingstreamcode, previousAllocation.FundingStreamCode, "The PreviousAllocation FundingStreamCode is incorrect");
            Assert.AreEqual(allocFundingstreamperiodcode, previousAllocation.FundingStreamPeriodCode, "The PreviousAllocation FundingStreamPeriodCode is incorrect");
            Assert.AreEqual(allocLepName, previousAllocation.LepName, "The PreviousAllocation LepName is incorrect");
            Assert.AreEqual(allocLepCode, previousAllocation.LepCode, "The PreviousAllocation LepCode is incorrect");
            Assert.AreEqual(allocTenderSpecRef, previousAllocation.TenderSpecReference, "The PreviousAllocation TenderSpecReference is incorrect");
            Assert.AreEqual(allocLotreference, previousAllocation.LotReference, "The PreviousAllocation LotReference is incorrect");
            Assert.AreEqual(allocTenderAwardReference, previousAllocation.TenderAwardReference, "The PreviousAllocation TenderAwardReference is incorrect");
            Assert.AreEqual(allocActivityDescription, previousAllocation.ActivityDescription, "The PreviousAllocation ActivityDescription is incorrect");
            Assert.AreEqual(allocDescription, previousAllocation.AllocationDescription, "The PreviousAllocation AllocationDescription is incorrect");
            Assert.AreEqual(allocAmendmentReason, previousAllocation.AmendmentReason, "The PreviousAllocation AmendmentReason is incorrect");
            Assert.AreEqual(allocInvestmentPriority, previousAllocation.InvestmentPriority, "The PreviousAllocation InvestmentPriority is incorrect");
            Assert.AreEqual(allocAgreementNumber, previousAllocation.AgreementNumber, "The PreviousAllocation AgreementNumber is incorrect");
            Assert.AreEqual(allocSpecificationTitle, previousAllocation.SpecificationTitle, "The PreviousAllocation SpecificationTitle is incorrect");
            Assert.AreEqual(allocRegionType, previousAllocation.RegionType, "The PreviousAllocation RegionType is incorrect");
            Assert.AreEqual(allocLearningRatePremium, previousAllocation.LearningRatePremium, "The LearningRatePremium is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreviousContractRepository_GetLastApprovedContract_ShouldNotReturnPreviousContractWhenLastApprovedVersionIsNotTrue()
        {
            // arrange
            const string contractNumber = "XX=Test";
            const int versionNumber = 1;

            DateTime startDate = new DateTime(2018, 08, 01);
            DateTime endtDate = new DateTime(2018, 09, 01);
            const string masterContractNumber = "MXX=Test";
            const string amendmentType = "Variation";
            const string contractDescription = "Contract Description";
            const string contractType = "16-19 Funding";

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            Guid masterContract = CreateTestContract(
                contractNumber: masterContractNumber,
                version: versionNumber);

            Guid contractId = CreateTestContract(
                contractNumber: contractNumber,
                version: versionNumber,
                isLatestVersion: false,
                isLastApprovedVersion: false,
                parentContract: new EntityReference(sfa_contract.EntityLogicalName, masterContract),
                contractStartDate: startDate,
                contractEndDate: endtDate,
                amendmentType: amendmentType,
                contractDescription: contractDescription,
                contractType: GetContractTypeEntityReference(contractType));

            PreviousContractRepository previousContractRepository = new PreviousContractRepository(CrmOrganizationService);

            // act
            Option<PreviousContract> latestContract = previousContractRepository.GetLastApprovedContract(contractNumber);

            // assert
            latestContract.Match(some: x => { Assert.Fail("GetLastApprovedContract method incorrectly returned previous contract information"); }, none: () => { });
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmOrganizationService;

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                var matchingContracts =
                    crmContext.sfa_contractSet.Where(
                            c => c.sfa_number == contractNumber)
                        .Select(c => c.Id);

                matchingContracts.ForEach(c => organizationService.Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private Guid CreateTestContract(
            string contractNumber, int version, bool? isLatestVersion = null, bool? isLastApprovedVersion = null,
            EntityReference parentContract = null, DateTime? contractStartDate = null, DateTime? contractEndDate = null,
            string amendmentType = null, string contractDescription = null, EntityReference contractType = null)
        {
            var organizationService = CrmOrganizationService;

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = isLastApprovedVersion,
                sfa_ProviderName = GetOrgEntityReference(),
                sfa_ParentContractId = parentContract,
                sfa_StartDate = contractStartDate,
                sfa_EndDate = contractEndDate,
                sfa_Description = contractDescription,
                sfa_ContractType = contractType
            };

            Guid contractId = organizationService.Create(contract);

            if (isLatestVersion.HasValue)
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_LatestVersion = isLatestVersion
                });
            }

            if (amendmentType != null)
            {
                if (amendmentType == "Variation")
                    organizationService.Update(new sfa_contract
                    {
                        Id = contractId,
                        sfa_AmendmentType = new OptionSetValue((int)sfa_amendmenttype.Variation)
                    });
                else if (amendmentType == "Notification")
                {
                    organizationService.Update(new sfa_contract
                    {
                        Id = contractId,
                        sfa_AmendmentType = new OptionSetValue((int)sfa_amendmenttype.Notification)
                    });
                }
            }

            return contractId;
        }

        private static void CreateAllocation
        (string allocNumber, DateTime allocStartDate, DateTime allocEndDate, string allocLepName,
            string allocLepCode, string allocTenderSpecRef, string allocLotreference, string allocTenderAwardReference, string allocActivityDescription,
            string allocDescription, string allocAmendmentReason, string allocInvestmentPriority, string allocAgreementNumber, string allocSpecificationTitle,
            string allocRegionType, string allocLearningRatePremium, string allocFundingstreamcode, string fspCode, string deliveryOrgUkprn,
            EntityReference deliveryOrgEntityRef, Guid contractId)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocNumber,
                sfa_startdate = allocStartDate,
                sfa_enddate = allocEndDate,
                sfa_LEPName = allocLepName,
                sfa_LEPcode = allocLepCode,
                sfa_ITTReference = allocTenderSpecRef,
                sfa_lotreference = allocLotreference,
                sfa_awardreference = allocTenderAwardReference,
                sfa_ProjectDescription = allocActivityDescription,
                sfa_description = allocDescription,
                sfa_AmendmentReason = allocAmendmentReason,
                sfa_Priority = allocInvestmentPriority,
                sfa_AgreementNumber = allocAgreementNumber,
                sfa_SpecificationTitle = allocSpecificationTitle,
                sfa_RegionType = allocRegionType,
                sfa_LearningRatePremium = allocLearningRatePremium,
                sfa_FundingStreamId = GetFundingStreamEntityRef(allocFundingstreamcode),
                sfa_FundingStreamPeriodId = GetFundingStreamPeriodEntityRef(fspCode),
                sfa_deliveryorganisationukprn = deliveryOrgUkprn,
                sfa_deliveryorganisationprovider = deliveryOrgEntityRef,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };

            CrmOrganizationService.Create(allocation);
        }
        
        private static EntityReference GetFundingStreamPeriodEntityRef(string fspCode)
        {
            using (var crmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return crmContext.sfa_fundingstreamperiodSet.First(fsp => fsp.sfa_fundingstreamperiodcode == fspCode).ToEntityReference();
            }
        }

        private EntityReference GetOrgEntityReference()
        {
            if (_providerEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(CrmOrganizationService))
                {
                    _providerEntityReference = crmContext.AccountSet.First().ToEntityReference();
                }
            }

            return _providerEntityReference;
        }

        private static EntityReference GetFundingStreamEntityRef(string fsCode)
        {
            using (var crmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return crmContext.sfa_fundingstreamSet.First(fs => fs.sfa_fundingstreamcode == fsCode).ToEntityReference();
            }
        }

        private static EntityReference GetContractTypeEntityReference(string contractType)
        {
            using (var crmContext = new XrmServiceContext(CrmOrganizationService))
            {
                return crmContext.sfa_contracttypeSet.Single(ct => ct.sfa_name == contractType).ToEntityReference();
            }
        }

        private static EntityReference CreateOrg(string ukprn, string legalName)
        {
            Account account = new Account
            {
                sfa_UKPRN = ukprn,
                Name = legalName
            };

            Guid accountId = CrmOrganizationService.Create(account);

            return new EntityReference(Account.EntityLogicalName, accountId);
        }

        private static void DeleteOrg(string ukprn)
        {
            using (var crmContext = new XrmServiceContext(CrmOrganizationService))
            {
                crmContext.AccountSet.Where(a => a.sfa_UKPRN == ukprn)
                    .Select(a => a.Id)
                    .ForEach(id => CrmOrganizationService.Delete(Account.EntityLogicalName, id));
            }
        }
    }
}
