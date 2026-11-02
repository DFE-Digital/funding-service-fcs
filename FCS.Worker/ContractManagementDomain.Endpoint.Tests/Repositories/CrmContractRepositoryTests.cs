namespace ContractManagementDomain.Endpoint.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Linq.Expressions;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Endpoint.ContractClosure;
    using Endpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.ContractManagementService.Common.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;
    using sfa_fundingtype = SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype;

    [TestClass]
    public class CrmContractRepositoryTests
    {
        private EntityReference _providerId = null;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_UpdateStartDate_ShouldUpdateStartDate()
        {
            // arrange 
            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 1;
            DateTime updateStartDate = new DateTime(2018, 1, 1);

            RemoveContract(contractNumberToTest, versionToTest);

            Guid contractId = CreateTestContract(contractNumberToTest, GetFundingType("AGE"), GetPeriod("FY1617"), lastApprovedVersion: true, version: versionToTest);
            Guid allocationId = CreateContractAllocation(contractId);
            Guid deliverableId = CreateDeliverable(allocationId);
            CreateDeliverablePeriod(deliverableId);

            ICrmContractRepository crmContractRepository = GetContainer().Resolve<ICrmContractRepository>();

            // act
            crmContractRepository.UpdateStartDate(contractId, updateStartDate);

            // assert
            sfa_contract sfaContract = GetContract(contractId);

            Assert.AreEqual(updateStartDate, sfaContract.sfa_StartDate, "Incorrect Contract Start Date");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetFundingTypeFundingPeriodKeyForLatestContract_ShouldReturnCorrectKey()
        {
            // arrange
            const string testContractNumber = "Test-contract";
            const int versionToTest = 1;
            DeleteContracts(testContractNumber);

            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("LEVY1799"), lastApprovedVersion: true, version: versionToTest);

            // act
            CrmContractRepository contractCrmRepository = new CrmContractRepository(GetConnection());
            FundingTypeFundingPeriodKeyDto fundingTypeFundingPeriodKeyKey = contractCrmRepository.GetFundingTypeFundingPeriodKeyDtoForLatestContract(testContractNumber, versionToTest);

            // assert
            Assert.AreEqual(fundingTypeFundingPeriodKeyKey.FundingTypeCode, "LEVY");
            Assert.AreEqual(fundingTypeFundingPeriodKeyKey.FundingPeriodName, "LEVY1799");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_HasContractBeenApprovedBefore_WhenAContractHasALastApprovedFlag_ShouldReturnTrue()
        {
            const string testContractNumber = "Test-contract";
            
            // arrange
            DeleteContracts(testContractNumber);

            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: true, version: 1);
            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: false, version: 2);

            CrmContractRepository contractCrmRepository = new CrmContractRepository(GetConnection());

            // act            
            bool hasContractBeenApprovedBefore = contractCrmRepository.HasContractBeenApproved(testContractNumber);

            // assert
            Assert.IsTrue(hasContractBeenApprovedBefore);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_HasContractBeenApproved_WhenAContractHasNoLastApprovedFlag_ShouldReturnFalse()
        {
            const string testContractNumber = "Test-contract";
            DeleteContracts(testContractNumber);

            // arrange
            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: false, version: 1);
            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: false, version: 2);

            CrmContractRepository contractCrmRepository = new CrmContractRepository(GetConnection());

            // act            
            bool hasContractBeenApprovedBefore = contractCrmRepository.HasContractBeenApproved(testContractNumber);

            // assert
            Assert.IsFalse(hasContractBeenApprovedBefore);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldGetContractEndDate()
        {
            // arrange
            const string contractNumber = "TEST-9742";
            const int versionNumber = 1;
            const int subversionNumber = 0;
            DateTime contractEndDate = new DateTime(2017, 6, 1, 0, 0, 0, DateTimeKind.Utc);

            DeleteContracts(contractNumber);
            CreateTestContractWithEndDate(contractNumber, versionNumber, subversionNumber, contractEndDate);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            ContractEndDateInfo contract = repository.GetContractEndDateInfoByContractNumberVersionAndSubVersion(contractNumber, versionNumber, subversionNumber);

            // assert
            Assert.IsNotNull(contract, "Failed to retrieve info from CRM");
            Assert.IsTrue(contract.IsContractPresent, "Contract was not found in CRM");
            Assert.AreEqual(contractEndDate, contract.EndDate, "End date was not as expected");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldNotGetEndDateIfContractNotPresent()
        {
            // arrange
            const string contractNumber = "TEST-9742";
            const int versionNumber = 1;
            const int subversionNumber = 0;

            DeleteContracts(contractNumber);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            ContractEndDateInfo contract = repository.GetContractEndDateInfoByContractNumberVersionAndSubVersion(contractNumber, versionNumber, subversionNumber);

            // assert
            Assert.IsNotNull(contract, "Failed to retrieve info from CRM");
            Assert.IsFalse(contract.IsContractPresent, "IsContractPresent should not be true");
            Assert.IsNull(contract.EndDate, "End date was not null");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldUpdateServiceResponseToClosureInitiationSuccessful()
        {
            // arrange
            const string contractNumber = "TEST-9749";
            const int versionNumber = 1;
            const int subversionNumber = 0;
            const sfa_serviceresponse serviceresponse = sfa_serviceresponse.ClosureInitiationSuccessful;

            DeleteContracts(contractNumber);
            Guid contractId = CreateTestApprovedContractWithEndDate(contractNumber, versionNumber, subversionNumber, DateTime.Now);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            repository.UpdateServiceResponseOnContract(contractNumber, versionNumber, subversionNumber,
                serviceresponse);

            // assert
            sfa_contract contract = GetContract(contractId);

            Assert.AreEqual(serviceresponse, (sfa_serviceresponse)contract.sfa_ServiceResponse.Value);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldUpdateServiceResponseToClosureInitiationFailed()
        {
            // arrange
            const string contractNumber = "TEST-9749";
            const int versionNumber = 1;
            const int subversionNumber = 0;
            const sfa_serviceresponse serviceresponse = sfa_serviceresponse.ClosureInitiationFailed;

            DeleteContracts(contractNumber);
            Guid contractId = CreateTestApprovedContractWithEndDate(contractNumber, versionNumber, subversionNumber, DateTime.Now);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            repository.UpdateServiceResponseOnContract(contractNumber, versionNumber, subversionNumber,
                serviceresponse);

            // assert
            sfa_contract contract = GetContract(contractId);

            Assert.AreEqual(serviceresponse, (sfa_serviceresponse)contract.sfa_ServiceResponse.Value);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldDetermineContractIsLatestVersion()
        {
            // arrange
            const string contractNumber = "TEST-9751";
            const int versionNumber = 1;
            const int subversionNumber = 0;

            DeleteContracts(contractNumber);
            CreateTestContractWithLatestVersionFlag(
                contractNumber,
                versionNumber,
                subversionNumber,
                shouldApprove: true,
                isLatestVersion: true);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            bool isContractLatestVersion = repository.IsContractLatestVersion(contractNumber, versionNumber, subversionNumber);

            // assert
            Assert.IsTrue(isContractLatestVersion, "Did not correctly determine latest version");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldDetermineContractIsNotLatestVersion()
        {
            // arrange
            const string contractNumber = "TEST-9751";
            const int versionNumber = 1;
            const int subversionNumber = 0;

            DeleteContracts(contractNumber);
            CreateTestContractWithLatestVersionFlag(
                contractNumber,
                versionNumber,
                subversionNumber,
                shouldApprove: true,
                isLatestVersion: false);

            CreateTestContractWithLatestVersionFlag(
                contractNumber,
                versionNumber + 1,
                subversionNumber,
                shouldApprove: false,
                isLatestVersion: true);

            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            bool isContractLatestVersion = repository.IsContractLatestVersion(contractNumber, versionNumber, subversionNumber);

            // assert
            Assert.IsFalse(isContractLatestVersion, "Did not correctly determine latest version");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsContractClosed_WhenAContractIsClosed_ShouldReturnTrue()
        {
            const string testContractNumber = "Test-contract";

            // pre-clean up
            DeleteContracts(testContractNumber);

            // arrange
            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: true, version: 1);
            SetContractState(testContractNumber, 1, sfa_contractstatus.Closed, "Closed");
            CrmContractRepository contractCrmRepository = new CrmContractRepository(GetConnection());

            // act            
            bool isContractClosed = contractCrmRepository.IsContractClosed(testContractNumber);

            // assert
            Assert.IsTrue(isContractClosed);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsContractClosed_WhenAContractIsNotClosed_ShouldReturnFalse()
        {
            const string testContractNumber = "Test-contract";

            // pre-clean up
            DeleteContracts(testContractNumber);

            // arrange
            CreateTestContract(testContractNumber, GetFundingType("LEVY"), GetPeriod("AY1617"), lastApprovedVersion: true, version: 1);
            SetContractState(testContractNumber, 1, sfa_contractstatus.Approved, "Closure in Progress");
            CrmContractRepository contractCrmRepository = new CrmContractRepository(GetConnection());

            // act            
            bool isContractClosed = contractCrmRepository.IsContractClosed(testContractNumber);

            // assert
            Assert.IsFalse(isContractClosed);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractId_ShouldGetContractId()
        {
            // arrange
            const string contractNumber = "TEST-9742";
            const int versionNumber = 2;
            const int subVersionNumber = 1;

            DeleteContracts(contractNumber);
            Guid expectedContractId = CreateTestContract(
                contractNumber, GetFundingType("AGE"), GetPeriod("FY1617"), true, versionNumber, subVersionNumber);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            Guid actualContractId = repository.GetContractId(contractNumber, versionNumber, subVersionNumber);

            // assert
            Assert.AreEqual(expectedContractId, actualContractId, "Contract Id was not returned as expected");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_UpdateContract_ShouldUpdateContract()
        {
            // arrange
            const string contractNumber = "TEST-9742";
            const int versionNumber = 2;
            const int subVersionNumber = 1;

            DeleteContracts(contractNumber);
            Guid contractId = CreateTestContractWithEndDate(contractNumber, versionNumber, subVersionNumber, contractEndDate: null);
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            DateTime contractEndDate = DateTime.UtcNow;

            repository.UpdateContract(new sfa_contract
            {
                Id = contractId,
                sfa_EndDate = contractEndDate
            });

            // assert
            sfa_contract updatedContract = GetContract(contractId);
            Assert.AreEqual(TrimDateTime(contractEndDate), TrimDateTime(updatedContract.sfa_EndDate.Value), "Contract was not updated as expected");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetAllocationIdsForContract_ShouldReturnExpectedAllocationIds()
        {
            // arrange
            const string contractNumber = "TEST-9742";
            const int versionNumber = 2;
            const int subVersionNumber = 1;

            DeleteContracts(contractNumber);
            Guid contractId = GetConnection().Create(new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = versionNumber,
                sfa_SubVersion = subVersionNumber,
                sfa_ProviderName = GetProvider(),
                sfa_sfa_contract_sfa_contractallocation = new List<sfa_contractallocation>
                {
                    new sfa_contractallocation { sfa_contractallocationnumber = "ALLOC-1" },
                    new sfa_contractallocation { sfa_contractallocationnumber = "ALLOC-2" }
                }
            });
            ICrmContractRepository repository = new CrmContractRepository(GetConnection());

            // act
            IReadOnlyCollection<Guid> returnedAllocationIds = repository.GetAllocationIdsForContract(contractNumber, versionNumber, subVersionNumber);

            // assert
            IReadOnlyCollection<Guid> actualAllocationIds = GetAllocationsForContract(contractId).Select(a => a.Id).ToList();
            Assert.AreEqual(returnedAllocationIds.Count, actualAllocationIds.Count, "Incorrect number of Allocation Ids returned");
            Assert.IsTrue(actualAllocationIds.All(id => returnedAllocationIds.Contains(id)), "Not all Allocation Ids returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetMasterContractNumber_ShouldReturnCorrectContractNumber()
        {
            // Arrange
            const string testMasterNumber = "Test-Master-GMCN";
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);
            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testMasterNumber);

            sfa_contractBuilder builder = new sfa_contractBuilder();

            sfa_contract masterContract = builder.Build(c =>
            {
                c.sfa_number = testMasterNumber;
            });
            Guid masterContractId = CrmCommon.CreateEntity(masterContract);
            EntityReference masterReference = new EntityReference(sfa_contract.EntityLogicalName, masterContractId);

            sfa_contract childContract = builder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_ParentContractId = masterReference;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            string returnedMasterContractNumber = crmContractRepository.GetMasterContractNumber(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(testMasterNumber, returnedMasterContractNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusIfContractIsLatest_ShouldReturnContractStatusIfItIsTheLatest()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            ContractStatusInfo contractStatusInfo = crmContractRepository.GetContractStatusIfContractIsLatest(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(ContractStatus.Draft, contractStatusInfo.ContractStatus);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusIfContractIsLatest_ShouldReturnNullIfItIsNotTheLatest()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            childContract.sfa_LatestVersion = false;
            CrmCommon.UpdateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            ContractStatusInfo contractStatusInfo = crmContractRepository.GetContractStatusIfContractIsLatest(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(null, contractStatusInfo);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusIfContractIsLatest_ShouldGetCorrectValueForAwaitingTerminationInitiationApproval()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            childContract.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
            childContract.sfa_SubStatus = GetSubStatus("Awaiting Termination Initiation Approval");
            CrmCommon.UpdateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            ContractStatusInfo contractStatusInfo = crmContractRepository.GetContractStatusIfContractIsLatest(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(ContractStatus.Approved, contractStatusInfo.ContractStatus, "Contract status should be \"Approved\"");
            Assert.AreEqual(ContractSubStatus.AwaitingTerminationInitiationApproval, contractStatusInfo.ContractSubStatus, "Contract substatus should be \"Awaiting Termination Initiation Approval\"");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusIfContractIsLatest_ShouldGetCorrectValueForUnderTermination()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            sfa_contractBuilder contractBuilder = new sfa_contractBuilder();

            sfa_contract childContract = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
                c.sfa_SubVersion = 1;
            });
            CrmCommon.CreateEntity(childContract);

            childContract.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
            childContract.sfa_SubStatus = GetSubStatus("Under Termination");
            CrmCommon.UpdateEntity(childContract);

            // Act
            CrmContractRepository crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            ContractStatusInfo contractStatusInfo = crmContractRepository.GetContractStatusIfContractIsLatest(testChildNumber, 2, 1);

            // Assert
            Assert.AreEqual(ContractStatus.Approved, contractStatusInfo.ContractStatus, "Contract status should be \"Approved\"");
            Assert.AreEqual(ContractSubStatus.UnderTermination, contractStatusInfo.ContractSubStatus, "Contract substatus should be \"Under Termination\"");
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_LastApprovedContractDoesNotIncludeAllocation_ShouldReturnFalseWhenNONLEVY2019AllocationDoesNotExist()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";
            const string fundingStreamPeriod = "NONLEVY2019";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            var contractBuilder = new sfa_contractBuilder();

            var childContractVersion1 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 1;
            });
            var previousContractId = CrmCommon.CreateEntity(childContractVersion1);
            CreateContractAllocation(previousContractId, DateTime.Now.Date, "ALLOC999", fundingStreamPeriod);
            childContractVersion1.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
            childContractVersion1.sfa_LastApprovedVersion = true;
            CrmCommon.UpdateEntity(childContractVersion1);

            var childContractVersion2 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
            });
            CrmCommon.CreateEntity(childContractVersion2);

            var crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            // Act
            var lastApprovedContractIncludesAllocation = crmContractRepository.LastApprovedContractDoesNotIncludeAllocation(testChildNumber, fundingStreamPeriod);

            // Assert
            Assert.IsFalse(lastApprovedContractIncludesAllocation, "LastApprovedContractDoesNotIncludeAllocation did not return false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_LastApprovedContractDoesNotIncludeAllocation_ShouldReturnTrueWhenAllocationExistsButContractIsNotApproved()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";
            const string fundingStreamPeriod = "NONLEVY2019";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            var contractBuilder = new sfa_contractBuilder();

            var childContractVersion1 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 1;
            });
            var previousContractId = CrmCommon.CreateEntity(childContractVersion1);
            CreateContractAllocation(previousContractId, DateTime.Now.Date, "ALLOC999", fundingStreamPeriod);
            CrmCommon.UpdateEntity(childContractVersion1);

            var childContractVersion2 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
            });
            CrmCommon.CreateEntity(childContractVersion2);

            var crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            // Act
            var lastApprovedContractIncludesAllocation = crmContractRepository.LastApprovedContractDoesNotIncludeAllocation(testChildNumber, fundingStreamPeriod);

            // Assert
            Assert.IsTrue(lastApprovedContractIncludesAllocation, "LastApprovedContractIncludesAllocation did not return true");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_LastApprovedContractDoesNotIncludeAllocation_ShouldReturnTrueWhenLastApprovedExistsAndFspDoesNot()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";
            const string fundingStreamPeriod = "NONLEVY2019";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            var contractBuilder = new sfa_contractBuilder();

            var childContractVersion1 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 1;
            });
            var previousContractId = CrmCommon.CreateEntity(childContractVersion1);
            CreateContractAllocation(previousContractId, DateTime.Now.Date, "ALLOC999", "LEVY1799");
            childContractVersion1.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
            childContractVersion1.sfa_LastApprovedVersion = true;
            CrmCommon.UpdateEntity(childContractVersion1);

            var childContractVersion2 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
            });
            CrmCommon.CreateEntity(childContractVersion2);

            var crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            // Act
            var lastApprovedContractIncludesAllocation = crmContractRepository.LastApprovedContractDoesNotIncludeAllocation(testChildNumber, fundingStreamPeriod);

            // Assert
            Assert.IsTrue(lastApprovedContractIncludesAllocation, "LastApprovedContractIncludesAllocation did not return true");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_LatestContractIncludesAllocation_ShouldReturnTrueWhenLatestVersionHasAllocation()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";
            const string fundingStreamPeriod = "NONLEVY2019";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            var contractBuilder = new sfa_contractBuilder();

            var childContractVersion1 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 1;
            });
            var previousContractId = CrmCommon.CreateEntity(childContractVersion1);
            CreateContractAllocation(previousContractId, DateTime.Now.Date, "ALLOC999", fundingStreamPeriod);

            childContractVersion1.sfa_LatestVersion = true;
            CrmCommon.UpdateEntity(childContractVersion1);

            var childContractVersion2 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
            });
            CrmCommon.CreateEntity(childContractVersion2);

            var crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            // Act
            var latestContractIncludesAllocation = crmContractRepository.LatestContractIncludesAllocation(testChildNumber, fundingStreamPeriod);

            // Assert
            Assert.IsTrue(latestContractIncludesAllocation, "LatestContractIncludesAllocation did not return true");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_LatestContractIncludesAllocation_ShouldReturnFalseWhenLatestVersionDoesNotHaveAllocation()
        {
            // Arrange
            const string testChildNumber = "Test-Child-GMCN";
            const string fundingStreamPeriod = "NONLEVY2019";

            CrmCommon.DeleteEntityFromATable(c => c.sfa_contractSet, c => c.sfa_number == testChildNumber);

            var contractBuilder = new sfa_contractBuilder();

            var childContractVersion1 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 1;
            });
            var previousContractId = CrmCommon.CreateEntity(childContractVersion1);
            CreateContractAllocation(previousContractId, DateTime.Now.Date, "ALLOC999", "LEVY1799");
 
            childContractVersion1.sfa_LatestVersion = true;
            CrmCommon.UpdateEntity(childContractVersion1);

            var childContractVersion2 = contractBuilder.Build(c =>
            {
                c.sfa_number = testChildNumber;
                c.sfa_Version = 2;
            });
            CrmCommon.CreateEntity(childContractVersion2);

            var crmContractRepository = new CrmContractRepository(CrmCommon.GetConnection());

            // Act
            var latestContractIncludesAllocation = crmContractRepository.LatestContractIncludesAllocation(testChildNumber, fundingStreamPeriod);

            // Assert
            Assert.IsFalse(latestContractIncludesAllocation, "LatestContractIncludesAllocation did not return false");
        }

        private static Guid CreateContractAllocation(Guid contractId, DateTime setupDateTime, string allocationNumber, string fspCode)
        {
            var allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_contractallocationnumber = allocationNumber,
                sfa_startdate = setupDateTime,
                sfa_FundingStreamPeriodId = GetFundingStreamPeriodEntityRef(fspCode)
            };

            return GetConnection().Create(allocation);
        }

        private static EntityReference GetFundingStreamPeriodEntityRef(string fspCode)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_fundingstreamperiodSet.First(fsp => fsp.sfa_fundingstreamperiodcode == fspCode).ToEntityReference();
            }
        }

        private static DateTime TrimDateTime(DateTime dt)
        {
            return new DateTime(dt.Year, dt.Month, dt.Day, dt.Hour, dt.Minute, dt.Second);
        }

        private Guid CreateTestContractWithEndDate(string contractNumber, int versionNumber, int subversionNumber, DateTime? contractEndDate)
        {
            IOrganizationService orgService = GetConnection();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = versionNumber,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetProvider(),
                sfa_SubVersion = subversionNumber,
                sfa_EndDate = contractEndDate
            };

            return orgService.Create(contract);
        }

        private Guid CreateTestApprovedContractWithEndDate(string contractNumber, int versionNumber, int subversionNumber, DateTime contractEndDate)
        {
            IOrganizationService orgService = GetConnection();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = versionNumber,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetProvider(),
                sfa_SubVersion = subversionNumber,
                sfa_EndDate = contractEndDate,
            };

            Guid contractId = orgService.Create(contract);

            contract.Id = contractId;
            contract.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
            contract.sfa_SubStatus = GetSubStatus("Closure Initiation in Progress");
            contract.EntityState = EntityState.Changed;
            orgService.Update(contract);

            return contractId;
        }

        private Guid CreateTestContractWithLatestVersionFlag(string contractNumber, int versionNumber, int subversionNumber, bool shouldApprove, bool isLatestVersion)
        {
            IOrganizationService orgService = GetConnection();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = versionNumber,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetProvider(),
                sfa_SubVersion = subversionNumber,
                sfa_LatestVersion = isLatestVersion,
            };

            Guid contractId = orgService.Create(contract);

            if (shouldApprove)
            {
                contract.Id = contractId;
                contract.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
                contract.sfa_SubStatus = GetSubStatus("Closure Initiation in Progress");
                contract.EntityState = EntityState.Changed;
                orgService.Update(contract);
            }

            return contractId;
        }

        private EntityReference GetSubStatus(string statusName)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_statusSet.Single(s => s.sfa_name == statusName).ToEntityReference();
            }
        }

        private sfa_contract GetContract(Guid contractId)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_contractSet.SingleOrDefault(x => x.sfa_contractId.Value == contractId);
            }
        }

        private static IReadOnlyCollection<sfa_contractallocation> GetAllocationsForContract(Guid contractId)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_contractallocationSet
                    .Where(a => a.sfa_ContractId.Id == contractId)
                    .ToList();
            }
        }

        private Guid CreateTestContract(string contractNumber, Guid fundingType, Guid period, bool lastApprovedVersion, int version, int subVersion = 0)
        {
            IOrganizationService orgService = GetConnection();
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_LastApprovedVersion = lastApprovedVersion,
                sfa_ProviderName = GetProvider(),
                sfa_FundingType = new EntityReference(sfa_fundingtype.EntityLogicalName, fundingType),
                sfa_PeriodId = new EntityReference(sfa_period.EntityLogicalName, period)
            };
            return orgService.Create(contract);
        }

        private Guid CreateContractAllocation(Guid contractId)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_startdate = new DateTime(year: 2017, month: 5, day: 1, hour: 0, minute: 0, second: 0)
            };

            return GetConnection().Create(allocation);
        }

        private Guid CreateDeliverable(Guid allocationId)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contract.EntityLogicalName, allocationId),
            };

            return GetConnection().Create(deliverable);
        }

        private Guid CreateDeliverablePeriod(Guid contractDeliverableId)
        {
            sfa_contractdeliverableperiod deliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contract.EntityLogicalName, contractDeliverableId),
                sfa_Period = 5,
                sfa_PeriodName = "May-2017"
            };

            return GetConnection().Create(deliverableperiod);
        }

        private EntityReference GetProvider()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                if (_providerId == null)
                {
                    var orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
                    _providerId = new EntityReference(Account.EntityLogicalName, orgId);
                }

                return _providerId;
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => ActionRetrier.RetryWhenExceptionThrown<System.ServiceModel.FaultException>(() => organizationService.Delete(sfa_contract.EntityLogicalName, id)));
            }
        }

        private void RemoveContract(string contractNumber, int verion)
        {
            using (var context = new XrmServiceContext(GetConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber && c.sfa_Version == verion)
                    .ForEach(c => GetConnection().Delete(sfa_contract.EntityLogicalName, c.Id));
            }
        }

        private static void SetContractState(string contractNumber, int versionNumber, sfa_contractstatus status, string subStatusName)
        {
            IOrganizationService organizationService = GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                Guid contractId = context.sfa_contractSet
                    .Single(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber).Id;
                Guid subStatus = context.sfa_statusSet.Single(s => s.sfa_name == subStatusName).Id;

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_ContractStatusEnum = status,
                    sfa_SubStatus = new EntityReference(sfa_status.EntityLogicalName, subStatus),
                    sfa_LastApprovedVersion = true,
                    sfa_LatestVersion = true,
                    sfa_ContractApprovalDate = DateTime.UtcNow,
                    sfa_StatusLastUpdatedDate = DateTime.UtcNow
                });
            }
        }

        private static IWindsorContainer GetContainer()
        {
            ILoggerFactory loggerFactory = new LoggerFactory();
            var container = new WindsorContainer().Install(new WindsorInstaller(loggerFactory));
            container.BeginScope();

            return container;
        }

        public static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private Guid GetFundingType(string fundingTypeCode)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(GetConnection()))
            {
                return serviceContext.sfa_fundingtypeSet.First(f => f.sfa_fundingtypecode == fundingTypeCode).Id;
            }
        }

        private Guid GetPeriod(string periodName)
        {
            using (XrmServiceContext serviceContext = new XrmServiceContext(GetConnection()))
            {
                return serviceContext.sfa_periodSet.First(p => p.sfa_periodname == periodName).Id;
            }
        }
    }

    public class CrmCommon
    {
        public static Guid CreateEntity(Entity entityToAddToCrm)
        {
            Guid guid = GetConnection().Create(entityToAddToCrm);
            entityToAddToCrm.Id = guid;
            return guid;
        }

        public static void UpdateEntity(Entity entityToUpdate)
        {
            entityToUpdate.EntityState = EntityState.Changed;
            GetConnection().Update(entityToUpdate);
        }

        public static void DeleteEntityFromATable<T>(Func<XrmServiceContext, IQueryable<T>> entitySetToQuery, Expression<Func<T, bool>> queryPredicate)
            where T : Entity
        {
            IOrganizationService orgService = GetConnection();
            using (XrmServiceContext crmContext = new XrmServiceContext(orgService))
            {
                var entitySet = entitySetToQuery(crmContext);
                List<Guid> guids = entitySet.Where(queryPredicate).Select(c => c.Id).ToList();
                guids.ForEach(cid =>
                {
                    orgService.Delete(typeof(T).GetEntityLogicalName(), cid);
                });
            }
        }

        public static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        public static EntityReference GetSubstatus(string subStatusName)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_statusSet.Single(s => s.sfa_name == subStatusName).ToEntityReference();
            }
        }

        public static EntityReference GetFirstProvider()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                Guid orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
                return new EntityReference(Account.EntityLogicalName, orgId);
            }
        }
    }

    public class sfa_contractBuilder : AbsBuilder<sfa_contract>
    {
        protected override sfa_contract GetDefault()
        {
            return new sfa_contract()
            {
                sfa_number = "12345678",
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Draft),
                sfa_SubStatus = CrmCommon.GetSubstatus("In Review"),
                sfa_ProviderName = CrmCommon.GetFirstProvider()
            };
        }
    }

    public abstract class AbsBuilder<T>
    {
        protected abstract T GetDefault();

        public T Build(Action<T> creator = null)
        {
            T defaultEntity = GetDefault();
            creator?.Invoke(defaultEntity);

            return defaultEntity;
        }
    }

}
