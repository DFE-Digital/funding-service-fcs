namespace PerformanceManagementDomain.XrmEndpoint.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.Framework.Logging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using XrmTestModel;
    using Contract = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Contract;
    using ContractAllocation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractAllocation;
    using ContractDeliverable = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractDeliverable;
    using PerformanceManagementDomain.XrmEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCS.Worker.Common.Crm;

    [TestClass]
    public class FundingClaimReconciliationCommandRepositoryTests
    {
        private const string AllocationNumber = "ASC-9995";
        private const string AllocationStartDate = "2015-08-01";
        private const string AllocationEndDate = "2016-07-31";
        private const string ContractApprovalDate = "2015-06-01";
        private const string StatusLastUpdatedDate = "2016-08-11";
        private const string FundingStreamPeriodCode = "ASC1516";
        private const string FundingTypeCode = "MAIN";
        private const string FundingTypeName = "Mainstream";
        private const string Ukprn = "999995";
        private const string MasterContractNumber = "SFA-9995";
        private const string ContractNumber = "MAIN-9995";
        private const int ContractVersionNumber = 1;
        private const int ContractSubVersionNumber = 2;
        private const string OrganisationId = "ORG0199995";
        private const string ContractorLegalName = OrgName + " " + Ukprn;
        private const string OrgName = "FcrTestOrg";
        private const string FcrEntityName = "1516_Year End_Adult Skills 15/16_999995";

        private IFundingClaimReconciliationCommandRepository _fundingClaimReconciliationCommandRepository;
        private IWindsorContainer _container;

        private IOrganizationService CrmOrganizationService => CrmConnectionFactory.GetRetryOnErrorOrganizationService();

        [TestInitialize]
        public void TestInitialise()
        {
            _container = new WindsorContainer().Install(new XrmEndpoint.WindsorInstaller(new LoggerFactory()), new XrmServicesInstaller());
            _container.BeginScope();
           _fundingClaimReconciliationCommandRepository = new FundingClaimReconciliationCommandRepository(CrmOrganizationService);

            RemoveTestFixturesFromCrm();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationCommandRepository_ShouldSuccessfullyCreateFundingClaimReconciliationEntities()
        {
            // Arrange
            CreateTestFixturesInCrm();

            FundingClaimReconciliation fcrToPersist = GetFundingClaimReconciliationToPersist();

            // Act
            _fundingClaimReconciliationCommandRepository.CreateFundingClaimReconciliation(fcrToPersist);

            // Assert
            sfa_fundingclaimreconciliation crmFundingClaimReconciliation = RetrieveFundingClaimReconciliationFromCrm(FcrEntityName);
            sfa_fcrallocation crmFcrAllocation = RetrieveFcrAllocationFromCrm(crmFundingClaimReconciliation.Id);

            // Reconciliation
            Assert.IsNotNull(crmFundingClaimReconciliation);
            Assert.AreEqual(fcrToPersist.Amounts.ClaimedValue, crmFundingClaimReconciliation.sfa_ClaimedValue);
            Assert.AreEqual(fcrToPersist.Amounts.ProposedReconciliationValue, crmFundingClaimReconciliation.sfa_ProposedReconciliationValue);
            Assert.AreEqual(fcrToPersist.Amounts.AdjustedCappedClaimValue, crmFundingClaimReconciliation.sfa_adjustedcappedclaimedvalue, "The sfa_adjustedcappedclaimedvalue has not been set");
            Assert.AreEqual(fcrToPersist.Contractor.UKPRN, int.Parse(crmFundingClaimReconciliation.sfa_ukprn));

            // Allocation
            Assert.IsNotNull(crmFcrAllocation);
            Assert.AreEqual(fcrToPersist.Contractor.UKPRN, int.Parse(crmFcrAllocation.sfa_ukprn));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationCommandRepository_ShouldSuccessfullyUpdateFundingClaimToPublished()
        {
            // Arrange
            var publishedDate = DateTime.Now.AddDays(1);
            const string nameOfFcr = "Some name";
            Guid fcrGuid = CreateRowInFcrEntity(nameOfFcr);

            // Act
            _fundingClaimReconciliationCommandRepository.SetStatusOfFundingClaimReconciliationToPublished(fcrGuid, publishedDate);

            // Assert
            sfa_fundingclaimreconciliation updatedFundingClaimReconciliation = GetFcrEntity(fcrGuid);

            Assert.AreEqual(sfa_FCRServiceStatus.PublishSuccessful, (sfa_FCRServiceStatus)updatedFundingClaimReconciliation.sfa_servicestatus.Value);
            Assert.IsTrue(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.HasValue, "Published Date has not been set in CRM");
            Assert.AreEqual(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Year, publishedDate.Year);
            Assert.AreEqual(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Month, publishedDate.Month);
            Assert.AreEqual(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Day, publishedDate.Day);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationCommandRepository_ShouldSuccessfullyUpdateFundingClaimToManuallyPublished()
        {
            // Arrange
            DateTime publishedDate = DateTime.Now.AddDays(1);
            const string nameOfFcr = "Some name";
            Guid fcrGuid = CreateRowInFcrEntity(nameOfFcr);

            // Act
            _fundingClaimReconciliationCommandRepository.SetStatusOfFundingClaimReconciliationToManuallyPublished(fcrGuid, publishedDate);

            // Assert
            sfa_fundingclaimreconciliation updatedFundingClaimReconciliation = GetFcrEntity(fcrGuid);

            Assert.AreEqual(sfa_FCRServiceStatus.ManuallyPublished, (sfa_FCRServiceStatus)updatedFundingClaimReconciliation.sfa_servicestatus.Value, "Service status has not been set correctly in CRM");
            Assert.IsTrue(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.HasValue, "Published Date has not been set in CRM");
            Assert.AreEqual(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Year, publishedDate.Year, "Published Date Year has not been set correctly in CRM");
            Assert.AreEqual(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Month, publishedDate.Month, "Published Date Month has not been set correctly in CRM");
            Assert.AreEqual(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Day, publishedDate.Day, "Published Date Day has not been set correctly in CRM");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationCommandRepository_ShouldSuccessfullyUpdateFundingClaimToPublishFailed()
        {
            // Arrange
            var dateOccurred = DateTime.Now.AddDays(1);
            const string nameOfFcr = "Some name";
            Guid fcrGuid = CreateRowInFcrEntity(nameOfFcr);
            const string reasonForFailure = "Some reason";

            // Act
            _fundingClaimReconciliationCommandRepository.SetStatusOfFundingClaimReconciliationToPublishFailed(fcrGuid, dateOccurred, reasonForFailure);

            // Assert
            sfa_fundingclaimreconciliation updatedFundingClaimReconciliation = GetFcrEntity(fcrGuid);
            sfa_notification latestNotification = GetLatestNotificationEntity();

            Assert.AreEqual(null, updatedFundingClaimReconciliation.sfa_servicestatus, "The status is set");
            Assert.IsTrue(updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.HasValue, "sfa_StatusLastUpdatedDate has not been set in CRM");
            Assert.AreEqual(dateOccurred.Year, updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Year, "The year is not correct");
            Assert.AreEqual(dateOccurred.Month, updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Month, "The month is not correct");
            Assert.AreEqual(dateOccurred.Day, updatedFundingClaimReconciliation.sfa_StatusLastUpdatedDate.Value.Day, "The day is not correct");
            Assert.AreEqual(null, updatedFundingClaimReconciliation.sfa_serviceresponse, "The sfa_serviceresponse still has a value");
            Assert.IsTrue(latestNotification.sfa_Name.Contains($"Publish Failed -{nameOfFcr}"), "The notification has not been created correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationCommandRepository_ShouldNotCreateDuplicateFundingClaimReconciliationsDueToCrmContraint()
        {
            // arrange
            CreateTestFixturesInCrm();

            FundingClaimReconciliation fcrToPersist = GetFundingClaimReconciliationToPersist();

            _fundingClaimReconciliationCommandRepository.CreateFundingClaimReconciliation(fcrToPersist);

            // act
            Exception actualException = null;
            try
            {
                _fundingClaimReconciliationCommandRepository.CreateFundingClaimReconciliation(fcrToPersist);
            }
            catch (System.ServiceModel.FaultException ex)
            {
                actualException = ex;
            }

            // assert
            Assert.IsNotNull(actualException, "Exception was not thrown when creating second instance");
            Assert.AreEqual(
                "Cannot Create the Funding Claim Reconciliation since a similar record with the same Claim Type, Funding Period, Allocation Group and Provider already exists.",
                actualException.Message,
                "Exception was not thrown when creating second instance");

            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                List<sfa_fundingclaimreconciliation> fundingClaimReconciliationsInCrm =
                    xrmServiceContext.sfa_fundingclaimreconciliationSet
                        .Where(fcr => fcr.sfa_name == FcrEntityName)
                        .ToList();

                Assert.AreEqual(1, fundingClaimReconciliationsInCrm.Count, "Unexpected number of Funding Claim Reconciliations were found in CRM");
            }
        }

        private Guid CreateRowInFcrEntity(string name)
        {
            sfa_claimtype claimType = GetClaimType("Year End");
            sfa_claimreconallocgroup allocationGroup = GetAllocationGroupCode("ASC1516");
            sfa_period fundingPeriod = GetFundingPeriod("AY1516");

            Account account = new Account
            {
                sfa_UKPRN = Ukprn,
                Name = ContractorLegalName,
                sfa_OrganisationID = OrganisationId
            };

            var accountId = CrmOrganizationService.Create(account);

            sfa_fundingclaimreconciliation fundingClaimReconciliation = new sfa_fundingclaimreconciliation
            {
                sfa_ClaimTypeId = claimType.ToEntityReference(),
                sfa_FundingPeriodId = fundingPeriod.ToEntityReference(),
                sfa_AllocationGroupId = allocationGroup.ToEntityReference(),
                sfa_ProviderId = new EntityReference(Account.EntityLogicalName, accountId),
                sfa_StatusCodeEnum = sfa_sfastatuscode.Draft,
                sfa_StatusLastUpdatedDate = DateTime.UtcNow,
                sfa_name = name
            };

            return CrmOrganizationService.Create(fundingClaimReconciliation);
        }

        private sfa_fundingclaimreconciliation GetFcrEntity(Guid fcrGuid)
        {
            using (var xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return (from fcr in xrmServiceContext.sfa_fundingclaimreconciliationSet
                        where fcr.Id == fcrGuid
                        select fcr).SingleOrDefault();
            }
        }

        private sfa_notification GetLatestNotificationEntity()
        {
            using (var xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return (from fcr in xrmServiceContext.sfa_notificationSet
                        where fcr.CreatedOn > DateTime.UtcNow.AddMinutes(-10)
                        select fcr).AsEnumerable().OrderByDescending(fcr => fcr.CreatedOn).First();
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

        private sfa_fcrallocation RetrieveFcrAllocationFromCrm(Guid fcrId)
        {
            using (var xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmServiceContext.sfa_fcrallocationSet.Single(fcra => fcra.sfa_FundingClaimReconciliationId.Id == fcrId);
            }
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
                            ReconciliationValue = 500m,
                            AdjustedCappedClaimValue = 201m
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
                    OrganisationIdentifier = OrganisationId,
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

        private void CreateTestFixturesInCrm()
        {
            Account account = new Account
            {
                sfa_OrganisationID = OrganisationId,
                sfa_UKPRN = Ukprn.ToString(),
                Name = OrgName
            };
            Guid accountId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(account);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, accountId),
                sfa_organisationname = OrgName
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
                    new EntityReference(SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype.EntityLogicalName, GetFundingType(FundingTypeCode)),
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
                    new EntityReference(SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype.EntityLogicalName, GetFundingType(FundingTypeCode)),
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

        private XrmContractDeliverable CreateXrmContractDeliverable(XrmContract contract,
            XrmContractAllocation allocation, int deliverableCode, string deliverableName, decimal plannedValue,
            XrmContractDeliverable parentDeliverable = null)
        {
            XrmContractDeliverable deliverable = _container.Resolve<XrmContractDeliverable>();
            deliverable.Contract = contract;
            deliverable.Allocation = allocation;
            deliverable.DeliverableCode = deliverableCode.ToString();
            deliverable.DeliverableName = deliverableName;
            deliverable.PlannedValue = plannedValue;
            deliverable.PlannedVolume = 0;
            deliverable.ProfileDeliverable = "Aggregate";
            deliverable.ParentDeliverable = parentDeliverable;
            deliverable.Periods =
                Enumerable.Range(1, 12)
                    .Select(i =>
                    {
                        string[] periodNames =
                        {
                            "AUG-15", "SEP-15", "OCT-15", "NOV-15", "DEC-15", "JAN-16", "FEB-16",
                            "MAR-16", "APR-16", "MAY-16", "JUN-16", "JUL-16"
                        };
                        int[] periodNumbers = { 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7 };
                        XrmContractDeliverablePeriod deliverableperiod =
                            _container.Resolve<XrmContractDeliverablePeriod>();
                        deliverableperiod.Deliverable = deliverable;
                        deliverableperiod.PeriodName = periodNames[i - 1];
                        deliverableperiod.PeriodNumber = periodNumbers[i - 1];
                        deliverableperiod.Year = i <= 5 ? 2015 : 2016;
                        deliverableperiod.PaymentPosted = false;

                        return deliverableperiod;
                    })
                    .Cast<ContractDeliverablePeriod>()
                    .ToList();

            return deliverable;
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
            GetOrganisationsForOrganisationId(OrganisationId).ToList().ForEach(o => RemoveOrganisation(o.Id));
        }

        private sfa_claimtype GetClaimType(string claimTypeName)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmServiceContext.sfa_claimtypeSet
                    .Single(ct => ct.sfa_name == claimTypeName);
            }
        }

        private sfa_period GetFundingPeriod(string periodName)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmServiceContext.sfa_periodSet
                    .Single(fp => fp.sfa_periodname == periodName);
            }
        }

        private sfa_claimreconallocgroup GetAllocationGroupCode(string allocationGroupCode)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(CrmOrganizationService))
            {
                return xrmServiceContext.sfa_claimreconallocgroupSet
                    .Single(ag => ag.sfa_AllocationGroupCode == allocationGroupCode);
            }
        }

        private void RemoveContract(Guid contractGuid)
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