namespace PerformanceManagementDomain.Tests.ReconciliationPublication.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using PerformanceManagementDomain.ReconciliationPublication.Repositories;
    using PerformanceManagementDomain.ReconciliationPublication.Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Repositories;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using ClaimType = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ClaimType;
    using Contract = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Contract;
    using ContractAllocation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractAllocation;
    using ContractDeliverable = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractDeliverable;
    using sfa_fundingtype = SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype;

    [TestClass]
    public class FcrPublisherTests
    {
        private const string AllocationNumber = "ASC-9994";
        private const string AllocationStartDate = "2015-08-01";
        private const string AllocationEndDate = "2016-07-31";
        private const string ContractApprovalDate = "2015-06-01";
        private const string StatusLastUpdatedDate = "2016-08-11";
        private const string FundingStreamPeriodCode = "ASC1516";
        private const string FundingTypeCode = "MAIN";
        private const string FundingTypeName = "Mainstream";
        private const int Ukprn = 999994;
        private const string MasterContractNumber = "SFA-9994";
        private const string ContractNumber = "MAIN-9994";
        private const int ContractVersionNumber = 1;
        private const int ContractSubVersionNumber = 2;
        private const string OrganisationId = "ORG0099994";
        private const string OrgName = "FcrTestOrg2";
        private const string FcrEntityName = "1516_Year End_Adult Skills 15/16_999994";

        private IWindsorContainer _container = null;
        private static string _contractorLegalName;

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            _contractorLegalName = OrgName + " " + Ukprn;
            RemoveTestFixturesFromCrm();
            RemovePasTableRows();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrPublisher_ShouldInsertAtomFeedItem()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = true.ToString();

            CreateTestFixturesInCrm();

            IFcrPublisher fcrPublisher =
                GetContainer().Resolve<IFcrPublisher>();

            IFundingClaimReconciliationCommandRepository fundingClaimCommandReconciliationRepository =
                new FundingClaimReconciliationCommandRepository(CrmOrganizationService);

            FundingClaimReconciliation fcr = GetFundingClaimReconciliationToPersist();

            fundingClaimCommandReconciliationRepository.CreateFundingClaimReconciliation(fcr);

            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, dbContext.Database.Connection);

                // act
                fcrPublisher.PublishToFeed(connectionInfo, fcr).Wait();
            }

            // assert
            int numMatchingRows = 0;
            using (var context = new PerformanceManagementDbContext())
            {
                numMatchingRows = context.AtomFeedItems.Count(a => a.Ukprn == Ukprn);
            }

            Assert.AreEqual(1, numMatchingRows);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrPublisher_ShouldNotInsertAtomFeedItem()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = true.ToString();

            CreateTestFixturesInCrm();

            IFcrPublisher fcrPublisher =
                GetContainer().Resolve<IFcrPublisher>();

            IFundingClaimReconciliationCommandRepository fundingClaimCommandReconciliationRepository =
                new FundingClaimReconciliationCommandRepository(CrmOrganizationService);

            FundingClaimReconciliation fcr = GetFundingClaimReconciliationToPersist();

            fundingClaimCommandReconciliationRepository.CreateFundingClaimReconciliation(fcr);

            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, dbContext.Database.Connection);

                // act
                fcrPublisher.PublishManually(connectionInfo, fcr);
            }

            // assert
            int numMatchingRows = 0;
            using (var context = new PerformanceManagementDbContext())
            {
                numMatchingRows = context.AtomFeedItems.Count(a => a.Ukprn == Ukprn);
            }

            Assert.AreEqual(0, numMatchingRows);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrPublisher_ShouldThrowExceptionWhenPublishingADuplicateAtomFeedItem()
        {
            // arrange
            FundingClaimReconciliation fundingClaimReconciliation = GetFundingClaimReconciliationToPersist();

            Mock<IAtomFeedItemRepository> atomCommandRepository = new Mock<IAtomFeedItemRepository>();
            atomCommandRepository.Setup(r => r.Add(It.IsAny<ConnectionInfo>(), It.IsAny<AtomFeedItem>())).Throws(new DuplicateKeyStorageException(new Exception()));

            DateTime createdDate = DateTime.Now;
            AtomFeedItem atomFeedItem = new AtomFeedItem(AtomItemType.Published, 1, "", "", "", "", createdDate);

            atomCommandRepository.Setup(r => r.GetByUkprnClaimTypeAllocationGroupAndPeriod(
                It.IsAny<ConnectionInfo>(),
                It.IsAny<int>(),
                It.IsAny<string>(),
                It.IsAny<string>(),
                It.IsAny<string>())).Returns(System.Threading.Tasks.Task.FromResult(atomFeedItem));

            IFcrPublisher fcrPublisher = new FcrPublisher(atomCommandRepository.Object, Mock.Of<IDateProvider>());

            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, dbContext.Database.Connection);

                // act
                FcrPublishResult result = fcrPublisher.PublishToFeed(connectionInfo, fundingClaimReconciliation).Result;

                // assert
                Assert.AreEqual(true, result.IsAtomFeedDuplicate, "We have not flagged that a duplicate has occured");
                Assert.AreEqual(createdDate, result.PublishedDate, "We have not set the published date correctly");
            }
        }

        private IOrganizationService CrmOrganizationService => CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        
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
            GetOrganisationsForOrganisationId(OrganisationId).ToList().ForEach(o => RemoveOrganisation(o.Id));
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

        private IWindsorContainer GetContainer()
        {
            if (_container == null)
            {
                Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
                loggerFactoryMock.Setup(l => l.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

                _container = new WindsorContainer().Install(new PerformanceManagementDomain.ReconciliationPublication.WindsorInstaller(loggerFactoryMock.Object));
                _container.Register(
                Component.For<IPerformanceManagementDbContext>()
                    .ImplementedBy<PerformanceManagementDbContext>().IsDefault()
                    .LifestyleSingleton());

                _container.BeginScope();
            }

            return _container;
        }

        protected void RemoveContract(Guid contractGuid)
        {
            CrmOrganizationService.Delete("sfa_contract", contractGuid);
        }

        private void RemoveOrganisation(Guid organisationGuid)
        {
            CrmOrganizationService.Delete("account", organisationGuid);
        }

        private static FundingClaimReconciliation GetFundingClaimReconciliationToPersist()
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
                    ReconciliationValue = 500m
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
                        AllocationStartDate = DateTime.Parse(AllocationStartDate),
                        AllocationEndDate = DateTime.Parse(AllocationEndDate),
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
                            ReconciliationValue = 500m
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
                    LegalName = _contractorLegalName,
                    OrganisationIdentifier = OrganisationId,
                    UKPRN = Ukprn
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

        private void CreateTestFixturesInCrm()
        {
            Account account = new Account
            {
                sfa_OrganisationID = OrganisationId,
                sfa_UKPRN = Ukprn.ToString(),
                Name = _contractorLegalName
            };
            Guid accountId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(account);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, accountId),
                sfa_organisationname = _contractorLegalName
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(caseload);

            sfa_contract masterContract = new sfa_contract
            {
                sfa_UKPRN = Ukprn.ToString(),
                sfa_number = MasterContractNumber,
                sfa_Description = "Test Description",
                sfa_ContractType = new EntityReference(sfa_contracttype.EntityLogicalName,
                    GetContractType("Contract for Services")),
                sfa_FundingType =
                    new EntityReference(sfa_fundingtype.EntityLogicalName, GetFundingType(FundingTypeCode)),
                sfa_Version = ContractVersionNumber,
                sfa_SubVersion = ContractSubVersionNumber,
                sfa_ProviderName = new EntityReference(Account.EntityLogicalName, accountId)
            };

            Guid masterContractId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(masterContract);

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = Ukprn.ToString(),
                sfa_number = ContractNumber,
                sfa_Description = "Test Description",
                sfa_ContractType = new EntityReference(sfa_contracttype.EntityLogicalName,
                    GetContractType("Contract for Services")),
                sfa_FundingType =
                    new EntityReference(sfa_fundingtype.EntityLogicalName, GetFundingType(FundingTypeCode)),
                sfa_Version = ContractVersionNumber,
                sfa_SubVersion = ContractSubVersionNumber,
                sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, masterContractId),
                sfa_ContractApprovalDate = DateTime.Parse(ContractApprovalDate),
                sfa_ProviderName = new EntityReference(Account.EntityLogicalName, accountId)
            };

            Guid contractId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contract);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_contractallocationnumber = AllocationNumber,
                sfa_startdate = DateTime.Parse(AllocationStartDate),
                sfa_enddate = DateTime.Parse(AllocationEndDate),
                sfa_FundingStreamPeriodId = new EntityReference(sfa_fundingstreamperiod.EntityLogicalName,
                    GetFspId(FundingStreamPeriodCode))
            };

            Guid allocationId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(allocation);

            UpdateContractStatusToApproved(contractId, DateTime.Parse(ContractApprovalDate));
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

        private void RemovePasTableRows()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.AtomFeedItems.Where(a => a.Ukprn == Ukprn).ToList().ForEach(a => context.AtomFeedItems.Remove(a));
                context.SaveChanges();
            }
        }
    }
}
