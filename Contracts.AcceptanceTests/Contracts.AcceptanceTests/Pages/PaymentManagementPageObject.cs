namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Diagnostics;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using SystemTask = System.Threading.Tasks;
    using SFA.FCT.Xrm.TestFramework;
    using corpContractType = CrossDomain.Integration.Entities.CorporateContract;
    using ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Events;
    using Xrm.TestFramework.Utils;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using NUnit.Framework.Legacy;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;
    using TechTalk.SpecFlow;   
    using ContractManagement.DataStore;
    using PaymentManagementDomain.PaymentSchedule.DataStore;
    using AllocationDeliveryDomain.Common.DataStore;
    using ContractManagement.DataStore.Model;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk.Messages;
    using DTO;
    using Extensions;
    using Infrastructure.Repositories;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Infrastructure.Services;
    using MoreLinq;   
    using Polly;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using Utilities;   
    using System.Data.SqlClient;
    using sfa_subnominalaggregation = CrossDomain.Integration.Entities.Xrm.sfa_subnominalaggregation;
    using sfa_contract = CrossDomain.Integration.Entities.Xrm.sfa_contract;
    using sfa_caseload = CrossDomain.Integration.Entities.Xrm.sfa_caseload;

    public class PaymentManagementPageObject
    {
        private readonly List<XrmWebEntity> _orgs = new List<XrmWebEntity>();
        private XrmPackageEntity _statusEntity;
        private XrmPackageEntity _orgEntity;
        private XrmPackageEntity _systemUserEntity;
        private XrmPackageEntity _caseloadEntity;
        private readonly IList<object> _ukprnList = new List<object>();
        private IList<string> _allContractsNumbers = new List<string>();
        private AcceptanceTestUtils _acceptanceTestUtils;
        private IContractsManager _contractsManager;
        private corpContractType.ExtendedContract _contractToTest;
        private DateTime _contractCreatedDateTime;
        private List<SubnominalAggregation> _subnominalAggregations = null;

        public List<sfa_contractdeliverableperiod> ContractDeliverablePeriods = null;

        public List<PaymentManagementCheckPeriod> PeriodListToCheck = new List<PaymentManagementCheckPeriod>();

        public List<corpContractType.ExtendedContractType> ContractListToTest =
            new List<corpContractType.ExtendedContractType>();

        public List<string> contractNumbersList = new List<string>();
        public List<string> mastercontractNumbersList = new List<string>();

        public string CaseloadAdvisor { get; set; }

        public string ContractManager { get; set; }

        public string CollectionReturnCode { get; set; }

        public DateTime TodaysDate { get; set; }

        public int SleepInterval { get; set; }

        public int DoesRecordExistInterval { get; set; }

        public DateTime DateStarted { get; private set; }

        public int MaxSecondsToWait { get; set; }

        private IOrganizationService _crmService;

        public List<ContractAllocationActualsType> ContractAllocationActuals { get; set; }

        public string CollectionType { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public corpContractType.ExtendedContract ContractToTest
        {
            get
            {
                if (_contractToTest == null)
                {
                    _contractToTest = new corpContractType.ExtendedContract();
                }
                if (_contractToTest.contracts == null)
                {
                    _contractToTest.contracts = new List<corpContractType.ExtendedContractType>();
                }
                return _contractToTest;
            }
            set { _contractToTest = value; }
        }

        public void AssociateUpinWithUkprn(string ukprn, string upin)
        {
            IOrganizationService organizationService = GetOrganizationService();

            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                Account account = xrmContext.AccountSet.Single(org => org.sfa_UKPRN == ukprn);

                organizationService.Update(new Account
                {
                    Id = account.Id,
                    sfa_orgupin = upin
                });
            }
        }

        public AcceptanceTestUtils AcceptanceTestUtils
        {
            get
            {
                if (_acceptanceTestUtils == null)
                {
                    _acceptanceTestUtils = new AcceptanceTestUtils(CaseloadAdvisor);
                }

                return _acceptanceTestUtils;
            }
        }

        public int? PeriodsInContractToTest
        {
            get
            {
                if (_contractToTest != null && _contractToTest.contracts.Count > 0)
                {
                    int x = ((_contractToTest.contracts[0].endDate.GetValueOrDefault().Year - _contractToTest.contracts[0].startDate.GetValueOrDefault().Year) * 12 +
                             _contractToTest.contracts[0].endDate.GetValueOrDefault().Month - _contractToTest.contracts[0].startDate.GetValueOrDefault().Month) + 1;
                    if (x < 12)
                    {
                        return 12;
                    }
                    else
                    {
                        return x;
                    }
                }
                return null;
            }
        }

        private List<SubnominalAggregation> SubnominalAggregations
        {
            get
            {
                if (_subnominalAggregations == null)
                {
                    _subnominalAggregations = new List<SubnominalAggregation>();
                }

                return _subnominalAggregations;
            }
        }

        public PaymentManagementPageObject()
        {
            DateStarted = DateTime.Now;
            SleepInterval = 5;
            DoesRecordExistInterval = 120;
            MaxSecondsToWait = 360;
        }

        private IOrganizationService GetOrganizationService()
        {
            return _crmService ?? (_crmService = CrmConnectionFactory.GetConnection());
        }

        public void Setup()
        {
            var connection = CrmConnectionFactory.GetConnection();
            _contractsManager = new ContractsManager
            {
                LookupManager = new LookupManager
                {
                    BatchCacheManager = new BatchCacheManager(),
                    BatchId = "XX",
                    EnduringCacheManager = new EnduringCacheManager(),
                    OrganizationService = connection
                },
                OrganizationService = connection,
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = connection
                }
            };
            _contractsManager.BatchId = "XX";
            _orgEntity = XrmService.Configuration.Entity("account");
            _statusEntity = XrmService.Configuration.Entity("sfa_status");
            _systemUserEntity = XrmService.Configuration.Entity("systemuser");
            _caseloadEntity = XrmService.Configuration.Entity("sfa_caseload");
        }

        public void SetupOrgansiation(string advisorName, string orgName, string ukprn, string orgId)
        {
            if (!IsOrgPresentInCrm(orgId))
            {
                var activeStatus = XrmService.Connection.GetRecord(_statusEntity, "Active");
                var advisorRecord = XrmService.Connection.GetRecord(_systemUserEntity, advisorName, "fullname");

                CreateOrgAndCaseLoad(ukprn, orgId, orgName, activeStatus, "Active", advisorName);

                _ukprnList.Add(ukprn);
            }
            else
            {
                // the org (Account) is present, let's make sure that the name is correct
                using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
                {
                    var matchingOrgs = xrmContext.AccountSet.Where(a => a.sfa_OrganisationID == orgId).ToList();
                    matchingOrgs.ForEach(o =>
                    {
                        o.Name = orgName;
                        o.sfa_UKPRN = ukprn;
                    });
                    xrmContext.SaveChanges();
                }
            }
        }

        public void SetupOrganisationWithStatusSpecified(string ukprn, string orgId, string orgName, string orgStatus)
        {
            var status = XrmService.Connection.GetRecord(_statusEntity, orgStatus);
            _orgs.Add(XrmService.Connection.SetRecord(_orgEntity, orgName)
                .SetField("sfa_organisationid", orgId)
                .SetField("sfa_ukprn", ukprn)
                .SetLookupField(_statusEntity, "sfa_status", status)
                .Create()
                .GetLatestRecord());

            _ukprnList.Add(ukprn);
        }

        public void CreateCaseload(string orgName, string ukprn, string advisorName)
        {
            var activeStatus = XrmService.Connection.GetRecord(_statusEntity, "Active");
            var advisorRecord = XrmService.Connection.GetRecord(_systemUserEntity, advisorName, "fullname");

            var caseload = XrmService.Connection.SetRecord(_caseloadEntity, orgName)
                .SetField("sfa_ukprn", ukprn)
                .SetLookupField(_statusEntity, "sfa_status", activeStatus)
                .SetLookupField(_orgEntity, "Organisation", _orgs.First(o => (string)o.GetField("sfa_ukprn") == ukprn));

            if (advisorRecord != null)
            {
                caseload.SetOwner(advisorRecord);
            }
        }

        private void CreateOrgAndCaseLoad(string ukprn, string orgId, string orgName, XrmWebEntity orgStatus,
            string caseloadStatus, string adviserName)
        {
            var status = CrmStatusRepository.GetStatus(caseloadStatus);
            Account account = new Account
            {
                sfa_OrganisationID = orgId,
                sfa_UKPRN = ukprn,
                sfa_Status = status,
                Name = orgName
            };

            Guid organisationId = CrmConnectionFactory.GetNonRetryingConnection().Create(account);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, organisationId),
                sfa_UKPRN = ukprn,
                sfa_Status = status,
                sfa_organisationname = orgName,
                OwnerId = new EntityReference(SystemUser.EntityLogicalName, CrmUserRepository.GetUserId(adviserName))
            };

            CrmConnectionFactory.GetNonRetryingConnection().Create(caseload);
        }

        public void CreateAllocationForMultipleContract(PaymentManagementContractAllocation pmcAllocationType,
            corpContractType.ExtendedContractType contractToTestObject, int x)
        {
            var alref = pmcAllocationType.AllocationRef.Split('-')[0] + "-" + (int.Parse(pmcAllocationType.AllocationRef.Split('-')[1]) + x);
            var cn = pmcAllocationType.ContractNumber.Split('-')[0] + "-" + (int.Parse(pmcAllocationType.ContractNumber.Split('-')[1]) + x);

            // Get contract we need
            corpContractType.ExtendedContractType contractRequired = (from n in contractToTestObject.contracts
                                                                      where n.contractNumber == cn
                                                                      select n).First();

            if (contractRequired.contractAllocations == null)
                contractRequired.contractAllocations = new List<corpContractType.ExtendedContractAllocation>();

            contractRequired.contractAllocations.Add(new corpContractType.ExtendedContractAllocation()
            {
                contractAllocationNumber = alref,
                startDate = pmcAllocationType.AllocationStartDate,
                endDate = pmcAllocationType.AllocationEndDate,
                maximumContractValue = pmcAllocationType.AllocationValue,
                fundingStream = new corpContractType.fundingStream()
                {
                    fundingStreamCode = pmcAllocationType.FundingStreamCode
                },
                period = new corpContractType.Period()
                {
                    period1 = pmcAllocationType.Period
                }
            });
        }

        public void CreateAllocationForContract(PaymentManagementContractAllocation gwtAllocation)
        {
            var allocationReference = gwtAllocation.AllocationRef;
            var contractNumber = gwtAllocation.ContractNumber;

            string fundingStreamPeriodCode = String.Empty;

            if (gwtAllocation.FundingStreamPeriodCode == null)
            {
                if (gwtAllocation.FundingStreamCode == "ESF 201420")
                {
                    fundingStreamPeriodCode = "ESF1420";
                }
                else if (gwtAllocation.FundingStreamCode == "EOF")
                {
                    fundingStreamPeriodCode = "EOF1417";
                }
                else if (gwtAllocation.FundingStreamCode == "24+ ALLF" && (gwtAllocation.Period == "1617" || gwtAllocation.Period == "1718"))
                {
                    fundingStreamPeriodCode = "ALLF" + gwtAllocation.Period;
                }
                else if (gwtAllocation.FundingStreamCode == "24+ ALLB" && (gwtAllocation.Period == "1617" || gwtAllocation.Period == "1718"))
                {
                    fundingStreamPeriodCode = "ALLB" + gwtAllocation.Period;
                }
                else if (gwtAllocation.FundingStreamCode == "24+ ALLBC" && (gwtAllocation.Period == "1617" || gwtAllocation.Period == "1718"))
                {
                    fundingStreamPeriodCode = "ALLBC" + gwtAllocation.Period;
                }
                else
                {
                    fundingStreamPeriodCode = gwtAllocation.FundingStreamCode.Replace(" ", "") + gwtAllocation.Period;
                }
            }

            this.FundingStreamPeriodCode = gwtAllocation.FundingStreamPeriodCode ?? fundingStreamPeriodCode;
            // Get contract we need
            corpContractType.ExtendedContractType contractRequired = (from n in _contractToTest.contracts
                                                                      where n.contractNumber == contractNumber
                                                                      select n).First();

            if (contractRequired.contractAllocations == null)
                contractRequired.contractAllocations = new List<corpContractType.ExtendedContractAllocation>();

            contractRequired.contractAllocations.Add(new corpContractType.ExtendedContractAllocation()
            {
                contractAllocationNumber = allocationReference,
                startDate = gwtAllocation.AllocationStartDate,
                endDate = gwtAllocation.AllocationEndDate,
                maximumContractValue = gwtAllocation.AllocationValue,
                fundingStream = new corpContractType.fundingStream()
                {
                    fundingStreamCode = gwtAllocation.FundingStreamCode
                },
                period = new corpContractType.Period()
                {
                    period1 = gwtAllocation.Period,
                    fundingStreamPeriods = new List<corpContractType.fundingStreamPeriodsFundingStreamPeriod>()
                    {
                        new corpContractType.fundingStreamPeriodsFundingStreamPeriod()
                        {
                            fundingStreamPeriodCode = FundingStreamPeriodCode
                        }
                    },
                    periodType = new corpContractType.periodTypeType
                    {
                        periodTypeCode = GetPeriodTypeCode(gwtAllocation.FundingStreamPeriodType),
                        periodTypeName = GetPeriodTypeName(gwtAllocation.FundingStreamPeriodType)
                    }
                },
                fundingStreamPeriodCode = FundingStreamPeriodCode,
                uopCode = gwtAllocation.UoPCode,
                description = gwtAllocation.AllocationDescription,
                LEPCode = gwtAllocation.LepCode,
                LEPName = gwtAllocation.LepName,
                tenderSpecificationReference = gwtAllocation.TendetSpecificationReference,
                lotReference = gwtAllocation.LotReference,
                tenderAwardReference = gwtAllocation.TenderAwardRefernece,
                InvestmentPriority = gwtAllocation.InvestmentPriority,
                AgreementNumber = gwtAllocation.AgreementNumber,
                ActivityDescription = gwtAllocation.ActivityDescription,
                SpecificationTitle = gwtAllocation.SpecificationTitle,
                RegionType = gwtAllocation.RegionType,
                LearningRatePremium = gwtAllocation.LearningRatePremium,
                DeliveryOrganisation = gwtAllocation.DeliveryOrganisation
            });

            contractRequired.period = contractRequired.contractAllocations.First().period;
        }

        public void CopyFirstContractsFirstAllocationsPeriodIntoMasterContract()
        {
            // copy the 1st allocation's period in the first sub-contract into the master contract's period
            // (which defaults to a period type of AY, which isn't always correct, e.g. for EOP)
            // PublishApprovedContractHandler in ContractManagementDomain.Integration does something similar:
            // it copies the period from the first sub-contract's allocation into all sub-contracts and the master contract

            // it's ok to point to the same object, we don't need to clone

            _contractToTest.period = _contractToTest.contracts.First().period;
        }

        private corpContractType.periodTypeNameType GetPeriodTypeName(string fundingStreamPeriodType)
        {
            switch (fundingStreamPeriodType)
            {
                case "AY":
                    return corpContractType.periodTypeNameType.ACADEMICYEAR;

                case "FY":
                    return corpContractType.periodTypeNameType.FINANCIALYEAR;

                case "EOP":
                    return corpContractType.periodTypeNameType.EMPLOYEROWNERSHIPPILOT;

                case "ESF":
                    return corpContractType.periodTypeNameType.EUROPEANSOCIALFUND;

                case "NONLEVY":
                    return corpContractType.periodTypeNameType.NONLEVYAPPRENTICESHIPS;

                case "NCS":
                    return corpContractType.periodTypeNameType.NATIONALCAREERSSERVICE;
                    // would be better to fail fast here, but would doing this break any tests relying on receiving AY as a default?
                    //default:
                    //    throw new Exception("Unknown fundingStreamPeriodType in GetPeriodTypeName");

                    // ******************************* ADD MORE AS REQUIRED ********************************************************
            }

            // default
            return corpContractType.periodTypeNameType.ACADEMICYEAR;
        }

        private corpContractType.periodTypeCodeType GetPeriodTypeCode(string fundingStreamPeriodType)
        {
            switch (fundingStreamPeriodType)
            {
                case "AY":
                    return corpContractType.periodTypeCodeType.AY;

                case "FY":
                    return corpContractType.periodTypeCodeType.FY;

                case "EOP":
                    return corpContractType.periodTypeCodeType.EOP;

                case "ESF":
                    return corpContractType.periodTypeCodeType.ESF;

                case "EOF":
                    return corpContractType.periodTypeCodeType.EOF;

                case "NONLEVY":
                    return corpContractType.periodTypeCodeType.NONLEVY;

                case "NCS":
                    return corpContractType.periodTypeCodeType.NCS;

                    // would be better to fail fast here, but would doing this break any tests relying on receiving AY as a default?
                    //default:
                    //    throw new Exception("Unknown fundingStreamPeriodType in GetPeriodTypeCode");
            }
            // ******************************* ADD MORE AS REQUIRED ********************************************************

            // default
            return corpContractType.periodTypeCodeType.AY;
        }

        public void CreateDeliverableForAllocation(PaymentManagementContractDeliverable pmcDeliverableType,
            corpContractType.ExtendedContractType contractToTestObject, int x)
        {
            var allocNum = pmcDeliverableType.AllocationRef.Split('-')[0] + "-" + (int.Parse(pmcDeliverableType.AllocationRef.Split('-')[1]) + x);

            corpContractType.ExtendedContractType contractRequired = contractToTestObject.contracts.First();
            corpContractType.ExtendedContractAllocation contractAllocationRequired =
                contractRequired.contractAllocations.First(
                    p => p.contractAllocationNumber == allocNum);

            corpContractType.contractDeliverablesTypeContractDeliverable deliverable = new corpContractType.
                contractDeliverablesTypeContractDeliverable()
            {
                deliverable = new corpContractType.deliverableType()
                {
                    deliverableCode = Int32.Parse(pmcDeliverableType.DeliverableCode),
                    deliverableName = pmcDeliverableType.DeliverableDesciption
                },
                DisplayOrder = pmcDeliverableType.DisplayOrder == 0 ? Int32.Parse(pmcDeliverableType.DeliverableCode) : pmcDeliverableType.DisplayOrder,
                deliverableDescription = pmcDeliverableType.DeliverableDesciption
            };

            decimal deliverableTotal = 0;

            foreach (KeyValuePair<string, decimal> period in pmcDeliverableType.Period)
            {
                deliverable.contractDeliverablePeriods.Add(new corpContractType.
                    contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    year = 2000 + Int32.Parse(period.Key.Substring(4, 2)),
                    period = DateTime.ParseExact(period.Key.Substring(0, 3), "MMM", CultureInfo.CurrentCulture).Month,
                    plannedValue = period.Value,
                    displayOrder =
                        2000 +
                        Int32.Parse(period.Key.Substring(4, 2) +
                                    string.Format("{0:00}",
                                        DateTime.ParseExact(period.Key.Substring(0, 3), "MMM",
                                            CultureInfo.CurrentCulture).Month)),
                    periodName = period.Key
                });
                deliverableTotal += period.Value;
            }
            deliverable.plannedValue = deliverableTotal;

            contractAllocationRequired.contractDeliverables.Add(deliverable);
        }

        public void CreateDeliverableForAllocation(PaymentManagementContractDeliverable gwtDeliverable)
        {
            corpContractType.ExtendedContractType contractRequired = _contractToTest.contracts.First();

            corpContractType.ExtendedContractAllocation contractAllocationRequired = null;

            if (!String.IsNullOrWhiteSpace(gwtDeliverable.DeliveryOrganisation))
            {
                contractAllocationRequired =
                    contractRequired.contractAllocations.First(
                        ca => ca.contractAllocationNumber == gwtDeliverable.AllocationRef &&
                        ca.DeliveryOrganisation == gwtDeliverable.DeliveryOrganisation);
            }
            else
            {
                contractAllocationRequired =
                    contractRequired.contractAllocations.First(
                        ca => ca.contractAllocationNumber == gwtDeliverable.AllocationRef);
            }

            corpContractType.contractDeliverablesTypeContractDeliverable deliverable = new corpContractType.
                contractDeliverablesTypeContractDeliverable()
            {
                deliverable = new corpContractType.deliverableType()
                {
                    deliverableCode = Int32.Parse(gwtDeliverable.DeliverableCode),
                    deliverableName = gwtDeliverable.DeliverableName
                },
                DisplayOrder = gwtDeliverable.DisplayOrder == 0 ? Int32.Parse(gwtDeliverable.DeliverableCode) : gwtDeliverable.DisplayOrder,
                deliverableDescription = gwtDeliverable.DeliverableDesciption,
                ParentDeliverableCode = gwtDeliverable.ParentDeliverableCode
            };

            if (gwtDeliverable.UnitCost.HasValue)
            {
                deliverable.unitCost = gwtDeliverable.UnitCost.Value;
            }

            decimal deliverableTotal = 0;

            foreach (KeyValuePair<string, decimal> period in gwtDeliverable.Period)
            {
                deliverable.contractDeliverablePeriods.Add(new contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    year = 2000 + Int32.Parse(period.Key.Substring(4, 2)),
                    period =
                        DateTime.ParseExact(period.Key.Substring(0, 3), "MMM", CultureInfo.CurrentCulture).Month,
                    plannedValue = period.Value,
                    displayOrder =
                        ((2000 + Int32.Parse(period.Key.Substring(4, 2))) * 100) +
                        Int32.Parse(string.Format("{0:00}",
                            DateTime.ParseExact(period.Key.Substring(0, 3), "MMM", CultureInfo.CurrentCulture).Month)),
                    periodName = period.Key,
                    periodType = new periodTypeType
                    {
                        periodTypeCode = CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType.CM,
                        periodTypeName = periodTypeNameType.CALENDARMONTH
                    }
                });

                deliverableTotal += period.Value;
            }

            deliverable.plannedValue = deliverableTotal;

            contractAllocationRequired.contractDeliverables.Add(deliverable);
        }

        public void CreateMultipleContractsInCrm(PaymentManagementPageObject paymentObject)
        {
            _contractCreatedDateTime = DateTime.Now;
            foreach (var contractToTestobject in ContractListToTest)
            {
                Guid correlationId = Guid.NewGuid();

                _contractsManager.CreateContract(contractToTestobject, correlationId.ToString());
                foreach (corpContractType.contractType contract in paymentObject.ContractToTest.contracts)
                {
                    _allContractsNumbers.Add(contract.contractNumber);
                }
                _allContractsNumbers.Add(paymentObject.ContractToTest.contractNumber);
            }
        }

        public void CreateContractInCrm(ExtendedContract extendedContract)
        {
            if (_contractsManager == null)
            {
                Setup();
            }
            _contractToTest = extendedContract;
            CreateContractInCrm();
        }

        public void CreateContractInCrm()
        {
            EnrichContract(_contractToTest);
            
            Action createContract = GetCreateContractAction();

            Xrm.TestFramework.Utils.ActionRetrier.RetryWhenExceptionThrown(() =>
            {
                createContract();
            });

            foreach (corpContractType.contractType contract in _contractToTest.contracts)
            {
                _allContractsNumbers.Add(contract.contractNumber);
            }
            _allContractsNumbers.Add(ContractToTest.contractNumber);

            _contractCreatedDateTime = DateTime.Now;
        }

        private Action GetCreateContractAction()
        {
            bool isExistingMasterContract = CrmContractRepository.IsExistingMasterContract(_contractToTest.contractNumber);

            if (_contractToTest.contracts.First().PreviousVersionId != null || isExistingMasterContract)
            {
                return () => _contractsManager.CreateNewAmendedContract(_contractToTest, Guid.NewGuid().ToString());
            }

            return () => _contractsManager.CreateContract(_contractToTest, Guid.NewGuid().ToString());
        }

        private Guid? GetCurrentLatestContractId(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                var latestContract = xrmContext.sfa_contractSet.FirstOrDefault(c => c.sfa_number == contractNumber &&
                                                                                    c.sfa_LatestVersion == true);
                return latestContract?.sfa_contractId;
            }
        }

        private void EnrichContract(ExtendedContract contractToTest)
        {
            ExtendedContractType childContract = contractToTest.contracts.First();
            var fundingTypeCode = childContract.fundingType.fundingTypeCode;
            var fundingPeriod = childContract.period.GetFundingPeriodName();

            // if we don't do this line then we may get more than 1 latest
            childContract.PreviousVersionId = GetCurrentLatestContractId(childContract.contractNumber);

            using (var context = new ContractManagementDbContext())
            {
                FundingTypeFundingPeriod fundingTypeFundingPeriod =
                    context.FundingTypeFundingPeriodItems.Find(fundingTypeCode, fundingPeriod);

                if (fundingTypeFundingPeriod != null)
                {
                    childContract.DocumentationRequired = fundingTypeFundingPeriod.DocumentsRequired;
                    childContract.SkipDocumentMerge = fundingTypeFundingPeriod.SkipDocumentMerge;
                    childContract.SkipReviewAndInternalApproval =
                        fundingTypeFundingPeriod.SkipReviewAndInternalApproval;
                    childContract.SkipCaseloadAssignment = fundingTypeFundingPeriod.SkipCaseloadAssignment;
                }
            }

        }

        public void AmendContractInCrm(string amendmentType)
        {
            Guid correlationId = Guid.NewGuid();

            var newMasterContract = _contractsManager.GetLatestContract(_contractToTest.contractNumber,
                _contractToTest.contracts.Select(c => c.contractNumber));

            var firstContractId = newMasterContract.contracts[0].Id;

            foreach (var childContract in _contractToTest.contracts)
            {
                childContract.contractSubVersionNumber = _contractToTest.contracts[0].contractSubVersionNumber;
                childContract.ParentContractId = newMasterContract.Id;
                childContract.PreviousVersionId = firstContractId;
                childContract.Id = null;
                childContract.amendmentType = amendmentType;
                childContract.contractAllocations.ForEach(ca => ca.reasonForAmendment = "test");
            }


            _contractsManager.AmendContract(_contractToTest, correlationId.ToString());

            foreach (corpContractType.contractType contract in _contractToTest.contracts)
            {
                _allContractsNumbers.Add(contract.contractNumber);
            }
            _allContractsNumbers.Add(ContractToTest.contractNumber);

            _contractCreatedDateTime = DateTime.Now;
        }

        public void DeleteContracts(string[] contractNumbers)
        {
            foreach (string contractNumber in contractNumbers)
            {
                DeleteContractWithNumber(contractNumber);
            }
        }

        public void DeleteSubnominals(string allocationRef)
        {
            var subEntity = XrmService.Configuration.Entity("sfa_subnominalaggregation");
            var filter = new Dictionary<string, object>()
            {
                {"sfa_subnominalaggregatekey", allocationRef}
            };

            List<XrmWebEntity> subs = XrmService.Connection.GetPartMatchingRecords(subEntity, filter).ToList();
            foreach (XrmWebEntity sub in subs)
            {
                var aggregation = sub.Entity as SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_subnominalaggregation;
                if (aggregation != null && aggregation.sfa_SubnominalAggregateKey.Contains(allocationRef))
                {
                    CrmConnectionFactory.GetConnection().Delete(sfa_subnominalaggregation.EntityLogicalName, sub.Entity.Id);
                }
            }
        }

        public void DeleteOrganisation(int UKPRN)
        {
            var orgIds = CrmOrganisationRepository.GetOrganisationsByUkprn(UKPRN.ToString());

            orgIds.ForEach(id =>
            {
                try
                {
                    CrmConnectionFactory.GetConnection().Delete(Account.EntityLogicalName, id);
                }
                catch (Exception e)
                {
                    if (e.Message.Contains("associated with another object"))
                    {
                        CrmContractRepository.DeleteContractsForOrganisation(id);
                        CrmConnectionFactory.GetConnection().Delete(Account.EntityLogicalName, id);
                    }
                }
            });
        }

        public void TestTearDown()
        {
            // Reverse contracts so master is the last to be deleted - this has a Referential, Restrict Delete relationship
            foreach (string contractNumber in contractNumbersList)
            {
                DeleteContractWithNumber(contractNumber);
            }
            foreach (string contractNumber in mastercontractNumbersList)
            {
                DeleteContractWithNumber(contractNumber);
            }

            // Delete Orgs
            _orgs.Where(o => !_ukprnList.Contains(o.GetField("sfa_ukprn").ToString())).ToList().ForEach(o => o.Delete());
        }

        public void DeleteContracts(IReadOnlyCollection<Entity> contractEntities)
        {
            contractEntities.Where(c => c.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value == (int)sfa_contracthierarchytype.Contract)
               .ForEach(c => AcceptanceTestUtils.Delete(c));

            contractEntities.Where(c => c.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value == (int)sfa_contracthierarchytype.Contract)
               .ForEach(c => CrmReplicatedRepository.DeleteContract(c.Id)); 

            contractEntities.Where(c => c.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value == (int)sfa_contracthierarchytype.Master)
               .ForEach(c =>
               {
                   // sellotape some more time around deleting the master contracts
                   Policy.Handle<Exception>(ex => ex.Message.Contains("The object you tried to delete is associated with another object and cannot be deleted"))
                       .WaitAndRetry(5, count => TimeSpan.FromSeconds(count * 5))
                       .Execute(() => AcceptanceTestUtils.Delete(c));
               });

            contractEntities.Where(c => c.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value == (int)sfa_contracthierarchytype.Master)
              .ForEach(c =>
              {
                  // sellotape some more time around deleting the master contracts
                  Policy.Handle<Exception>(ex => ex.Message.Contains("The object you tried to delete is associated with another object and cannot be deleted"))
                      .WaitAndRetry(5, count => TimeSpan.FromSeconds(count * 5))
                      .Execute(() => CrmReplicatedRepository.DeleteContract(c.Id));
              });
        }

        private void DeleteContractWithNumber(string contractNumber)
        {
            IEnumerable<Entity> contractEntities = AcceptanceTestUtils.GetContractsForContractNumber(contractNumber);

            contractEntities.Where(c => c.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value == (int)sfa_contracthierarchytype.Contract)
                .ForEach(c => AcceptanceTestUtils.Delete(c));

            contractEntities.Where(c => c.GetAttributeValue<OptionSetValue>("sfa_hierarchytype").Value == (int)sfa_contracthierarchytype.Master)
               .ForEach(c => AcceptanceTestUtils.Delete(c));
        }

        public void ChangeContractSubStatus(string contractNumber, string version, string newState)
        {
            var contract = XrmService.Configuration.Entity("Contract");
            var systemUser = XrmService.Configuration.Entity("User");
            var contractAdviser = XrmService.Connection.GetRecord(systemUser, CaseloadAdvisor, "FullName");
            var substatus = XrmService.Configuration.Entity("sfa_status");

            var filterList = new Dictionary<string, object>
            {
                {"sfa_number", contractNumber},
                {"sfa_version", int.Parse(version)}
            };

            var substatusId = XrmService.Connection.GetRecord(substatus, newState);

            XrmService.ConnectAsUser(CaseloadAdvisor)
                .GetRecords(contract, filterList).First()
                .SetLookupField(substatus, "Sub Status", substatusId) //Set the contract to the substatusid
                .SetLookupField(systemUser, "Modified By", contractAdviser)
                .Update();

            SystemTask.Task.Delay(2000).Wait();
        }

        public void UpdateDeliverableInContractToTestWithVolumeAndUnitCost(List<SimpleContractDeliverable> simpleContractDeliverables)
        {
            foreach (SimpleContractDeliverable simpleContractDeliverable in simpleContractDeliverables)
            {
                contractDeliverablesTypeContractDeliverable deliverable = _contractToTest.contracts[0].contractAllocations
                    .First(x => x.contractAllocationNumber == simpleContractDeliverable.AllocationReference)
                    .contractDeliverables.First(d =>
                        d.deliverable.deliverableCode == int.Parse(simpleContractDeliverable.DeliverableCode));
                deliverable.unitCost = simpleContractDeliverable.UnitCost;
                deliverable.plannedVolume = simpleContractDeliverable.Volume;

                foreach (SimpleContractDeliverablePeriod simpleContractDeliverablePeriod in simpleContractDeliverable.Periods)
                {
                    contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod = _contractToTest.contracts[0].contractAllocations.First(x => x.contractAllocationNumber == simpleContractDeliverable.AllocationReference).
                        contractDeliverables.First(x => x.deliverable.deliverableCode == int.Parse(simpleContractDeliverable.DeliverableCode)).contractDeliverablePeriods.First(x => x.periodName == simpleContractDeliverablePeriod.Name);

                    deliverablePeriod.plannedVolume = simpleContractDeliverablePeriod.PlannedVolume;
                }
            }
        }

        public void ClearMonthEndHistory()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[MonthEndHistory]");
            }
        }

        public void ChangeContractStateFromReadyToBeApprovedToApproved(string contractNumber)
        {
            ChangeContractStateThroughAGivenTransition(contractNumber, "Confirm receipt of signed contract");
        }

        public void ChangeContractStateThroughAGivenTransition(string contractNumber, string transitionState)
        {
            Guid contractId = CrmContractRepository.GetContractIdForNumber(contractNumber);
            Guid transitionId = CrmTransitionRepository.GetTransitionId(transitionState);

            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_NextAction = new EntityReference(sfa_transition.EntityLogicalName, transitionId)
            };

            CrmConnectionFactory.GetConnectionForSpecificUser(CaseloadAdvisor).Update(contract);
        }

        public void ChangeContractState(string contractNumber, string transitionState, string reasonForChange, string userDisplayName)
        {
            Guid contractId = CrmContractRepository.GetContractIdForNumber(contractNumber);
            Guid transitionId = CrmTransitionRepository.GetTransitionId(transitionState);

            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_NextAction = new EntityReference(sfa_transition.EntityLogicalName, transitionId),
                sfa_ReasonForRejection = reasonForChange
            };

            CrmConnectionFactory.GetConnectionForSpecificUser(userDisplayName).Update(contract);
        }

        public void AssertContractStatus(string contractNumber, string status)
        {
            var substatus = XrmService.Configuration.Entity("Status");
            var contract = XrmService.Configuration.Entity("Contract");
            XrmService.Connection.GetRecord(contract, contractNumber)
                .FieldValue(XrmFieldValueComparison.Equals, "Contract Status", status);
        }

        public bool AssertContractSubStatus(string contractNumber, string contractSubStatus)
        {
            var isSubStatusCorrect = true;

            var substatus = XrmService.Configuration.Entity("Status");
            var contract = XrmService.Configuration.Entity("Contract");
            try
            {
                XrmService.Connection.GetRecord(contract, contractNumber)
                    .LookupFieldValueEquals(substatus, "sfa_substatus", contractSubStatus);
            }
            catch (Exception ex)
            {
                isSubStatusCorrect = false;
            }
            return isSubStatusCorrect;
        }

        public bool AssertContractStatusAndSubStatus(string contractNumber, string contractState)
        {
            var substatus = XrmService.Configuration.Entity("Status");
            var contract = XrmService.Configuration.Entity("Contract");

            var isSubStatusCorrect = true;

            try
            {
                XrmService.Connection.GetRecord(contract, contractNumber)
                    .LookupFieldValueEquals(substatus, "sfa_substatus", contractState)
                    .FieldValue(XrmFieldValueComparison.Equals, "Contract Status", contractState);
            }
            catch (Exception ex)
            {
                isSubStatusCorrect = false;
            }

            return isSubStatusCorrect;
        }

        public void AssertContractIsLastApprovedVersion(string contractNumber)
        {
            var contract = XrmService.Configuration.Entity("Contract");
            XrmService.Connection.GetRecord(contract, contractNumber)
                .FieldValueEquals("Last Approved Version", true);
        }

        public void AssertContractAsDocumentRequiredAsTrue(string contractNumber)
        {
            var contract = XrmService.Configuration.Entity("Contract");
            XrmService.Connection.GetRecord(contract, contractNumber)
                .FieldValueEquals("Documentation Required", true);
        }

        private List<sfa_contractdeliverableperiod> GetDeliverablePeriods(string contractAllocationNumber, string deliverableCode, int expectedNonNullPeriods, Func<sfa_contractdeliverableperiod, decimal?> selectPayment)
        {
            List<sfa_contractdeliverableperiod> contractDeliverablePeriods = new List<sfa_contractdeliverableperiod>();

            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                { 
                    using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
                    {
                        contractDeliverablePeriods = (from a in xrmContext.sfa_contractallocationSet
                            join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                            join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                                d.sfa_ContractAllocationId.Id
                            join cdp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId
                                equals
                                cdp.sfa_ContractDeliverableId.Id
                            where
                                c.sfa_LastApprovedVersion == true &&
                                //c.sfa_Version == _contractToTest.contracts[0].contractVersionNumber &&
                                a.sfa_contractallocationnumber == contractAllocationNumber &&
                                d.sfa_DeliverableCode == deliverableCode
                            select cdp).ToList();

                        //TODO: if the test is checking for all nulls, how do we tell the difference between the deliverable period's state in crm after approval, and post actuals?
                        var nonNullPeriods = contractDeliverablePeriods.Count(dp => selectPayment(dp) != null);

                        return contractDeliverablePeriods.Any() && nonNullPeriods == expectedNonNullPeriods;
                    }
                },
                maxNumChecks: 10,
                waitIntervalSeconds: 2);

                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
            return contractDeliverablePeriods;
        }

        private bool GetDeliverablePeriodNfr(string contractAllocationNumber, string deliverableCode, string period, int numberOfChecks = 60)
        {
            Debug.Print("Getting deliverable periods for allocation number " + contractAllocationNumber +
                        " deliverable code " + deliverableCode);
            IQueryable<sfa_contractdeliverableperiod> data = null;
            int checks = 0;

            while (checks < numberOfChecks)
            {
                using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
                {
                    data = from a in xrmContext.sfa_contractallocationSet
                           join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                           join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                               d.sfa_ContractAllocationId.Id
                           join cdp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                               cdp.sfa_ContractDeliverableId.Id
                           where
                               c.sfa_LastApprovedVersion == true &&
                               c.sfa_Version == _contractToTest.contracts[0].contractVersionNumber &&
                               a.sfa_contractallocationnumber == contractAllocationNumber &&
                               d.sfa_DeliverableCode == deliverableCode &&
                               cdp.sfa_ProfilePaymentAmount != null &&
                               cdp.sfa_PeriodName == period
                           select cdp;
                }

                Debug.Print("number of records back from CRM:{0} expecting:{1}", data.ToList().Count, PeriodsInContractToTest);
                var periods = data.ToList();

                if (periods.Count > 0)
                {
                    ContractDeliverablePeriods = periods;
                    return true;
                }

                Debug.Print("Going around the check loop again - " + checks + " of " + numberOfChecks);
                checks++;
                System.Threading.Thread.Sleep(3000);
            }
            return false;
        }

        private List<sfa_contractdeliverable> GetDeliverables(string contractAllocationNumber, int count)
        {
            List<sfa_contractdeliverable> contractDeliverables = new List<sfa_contractdeliverable>();

            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
                    {
                        var data = from a in xrmContext.sfa_contractallocationSet
                            join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                            join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                                d.sfa_ContractAllocationId.Id
                            where
                                c.sfa_LastApprovedVersion == true &&
                                //c.sfa_Version == _contractToTest.contracts[0].contractVersionNumber &&
                                a.sfa_contractallocationnumber == contractAllocationNumber
                            select d;
                        contractDeliverables = data.ToList();

                        // actual payment checks only check for monitoring deliverables, not legal, so the count is less than the number of deliverables
                        return contractDeliverables.Count() >= count;
                    }
                },
                maxNumChecks: 10,
                waitIntervalSeconds: 2);

            if (!checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime())
            {
                throw new Exception($"Unable to get {count} deliverables for allocation {contractAllocationNumber} at {DateTime.Now}");
            }

            return contractDeliverables;
        }
        
        private void SetSubnominalAggregations(string subnominalCode, string paymentType, int periodsExpected)
        {
            Debug.Print("Getting subnominal aggregations for subnominal code {0}, paymentType {1}, periodsExpected {2}, contractNumber {3} ", subnominalCode, paymentType, periodsExpected, _contractToTest.contracts[0].contractNumber);
            int checks = 0;

            while (checks < 150)
            {
                try
                {
                    IQueryable<SubnominalAggregation> data = null;
                    switch (paymentType.ToUpper())
                    {
                        case "PROFILE":
                            {
                                using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
                                {
                                    data = (from a in xrmContext.sfa_contractallocationSet
                                            join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                                            join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                                                d.sfa_ContractAllocationId.Id
                                            join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                                                d.sfa_contractdeliverableId equals
                                                cdp.sfa_ContractDeliverableId.Id
                                            join sas in xrmContext.sfa_subnominalaggregationSet on cdp.sfa_profilesubnominal.Id
                                                equals
                                                sas.sfa_subnominalaggregationId
                                            where
                                                sas.sfa_SubnominalCode == subnominalCode &&
                                                c.sfa_LastApprovedVersion == true &&
                                                c.sfa_number == _contractToTest.contracts[0].contractNumber
                                            select new SubnominalAggregation()
                                            {
                                                SubnominalCode = sas.sfa_SubnominalCode,
                                                Period = sas.sfa_Period,
                                                AggregatedValue =
                                                    sas.sfa_AggregatedValue.HasValue
                                                        ? sas.sfa_AggregatedValue.Value
                                                        : new decimal(-1),
                                                PaymentType = sas.sfa_PaymentTypeEnum.Value.ToString()
                                            });
                                }
                                break;
                            }
                        case "RECONCILIATION":
                            {
                                using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
                                {
                                    data = (from a in xrmContext.sfa_contractallocationSet
                                            join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                                            join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                                                d.sfa_ContractAllocationId.Id
                                            join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                                                d.sfa_contractdeliverableId equals
                                                cdp.sfa_ContractDeliverableId.Id
                                            join sas in xrmContext.sfa_subnominalaggregationSet on
                                                cdp.sfa_reconciliationsubnominal.Id equals
                                                sas.sfa_subnominalaggregationId
                                            where
                                                sas.sfa_SubnominalCode == subnominalCode &&
                                                c.sfa_LastApprovedVersion == true &&
                                                c.sfa_number == _contractToTest.contracts[0].contractNumber
                                            select new SubnominalAggregation()
                                            {
                                                SubnominalCode = sas.sfa_SubnominalCode,
                                                Period = sas.sfa_Period,
                                                AggregatedValue =
                                                    sas.sfa_AggregatedValue.HasValue
                                                        ? sas.sfa_AggregatedValue.Value
                                                        : new decimal(-1),
                                                PaymentType = sas.sfa_PaymentTypeEnum.Value.ToString()
                                            });
                                }
                                break;
                            }
                        case "CAPPING":
                            {
                                using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
                                {
                                    data = (from a in xrmContext.sfa_contractallocationSet
                                            join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                                            join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                                                d.sfa_ContractAllocationId.Id
                                            join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                                                d.sfa_contractdeliverableId equals
                                                cdp.sfa_ContractDeliverableId.Id
                                            join sas in xrmContext.sfa_subnominalaggregationSet on cdp.sfa_CappingSubnominal.Id
                                                equals
                                                sas.sfa_subnominalaggregationId
                                            where
                                                sas.sfa_SubnominalCode == subnominalCode &&
                                                c.sfa_LastApprovedVersion == true &&
                                                c.sfa_number == _contractToTest.contracts[0].contractNumber
                                            select new SubnominalAggregation()
                                            {
                                                SubnominalCode = sas.sfa_SubnominalCode,
                                                Period = sas.sfa_Period,
                                                AggregatedValue =
                                                    sas.sfa_AggregatedValue.HasValue
                                                        ? sas.sfa_AggregatedValue.Value
                                                        : new decimal(-1),
                                                PaymentType = sas.sfa_PaymentTypeEnum.Value.ToString()
                                            });
                                }
                                break;
                            }
                    }

                    var aggregations = data.ToList().Distinct().ToList();
                    if (aggregations.Count == periodsExpected)
                    {
                        Debug.Print("retrieved all records from CRM, count:{0} ", aggregations.Count);
                        _subnominalAggregations = aggregations;
                        break;
                    }

                    Debug.Print("number of records back from CRM is: {0} expecting: {1}", aggregations.Count,
                        periodsExpected);
                    Debug.Print("Going around the check loop again - " + checks);

                    System.Threading.Thread.Sleep(2000);
                    checks++;
                }
                catch (Exception ex)
                {
                    // Not sure of the exception type being thrown so checking the message text instead (make this better later)
                    if (ex.Message.Contains("Generic SQL error"))
                    {
                        // Wait an extra second to give the error time to go away.
                        Debug.Print("Caught a generic SQL error, ignoring and trying again..." + ex.ToString());
                        System.Threading.Thread.Sleep(1000);
                    }
                    else
                    {
                        // Obviously a proper fault - re-throw it
                        throw new Exception("Error checking deliverables: " + ex.Message, ex);
                    }
                }
            }
        }

        public bool CheckProfilePaymentsNfr(string contractAllocationNumber, string deliverableCode, string deliverablePeriod, decimal expectedProfilePayment)
        {
            if (ContractDeliverablePeriods == null)
            {
                if (GetDeliverablePeriodNfr(contractAllocationNumber, deliverableCode, deliverablePeriod) == false)
                {
                    return false;
                }
            }

            if (ContractDeliverablePeriods.Where(m => m.sfa_PeriodName == deliverablePeriod)
                .Select(n => n.sfa_ProfilePaymentAmount)
                .FirstOrDefault() != null)
                return true;

            return false;
        }

        public decimal? GetPayment(List<sfa_contractdeliverableperiod> contractDeliverablePeriods, string deliverablePeriod, Func<sfa_contractdeliverableperiod, decimal?> selectPayment)
        {
            return contractDeliverablePeriods.Where(m => m.sfa_PeriodName == deliverablePeriod)
                .Select(selectPayment)
                .SingleOrDefault();
        }

        public void CheckGWTPayments(IContractRepositoryPageObject contractRepositoryPageObject, Table paymentsTable, Func<sfa_contractdeliverableperiod, decimal?> selectPayment)
        {
            var paymentsGroup = paymentsTable.Rows.GroupBy(row =>
            {
                string allocationNumber = row["AllocationRef"];
                if (allocationNumber.StartsWith("[AllocRef"))
                {
                    allocationNumber =
                        contractRepositoryPageObject.GetLatestContractDataItem(
                            allocationNumber.Replace("[", "").Replace("]", ""));
                }
                return allocationNumber;
            });

            string deliverablesAreForAllocation = null;
            List<sfa_contractdeliverable> deliverables = null;

            foreach (TableRow row in paymentsTable.Rows)
            {
                int expectedNonNullPayments = row.GetPeriodValues().Count(pv => pv.Value.HasValue);

                string allocationNumber = row["AllocationRef"];
                if (allocationNumber.StartsWith("[AllocRef"))
                {
                    allocationNumber =
                        contractRepositoryPageObject.GetLatestContractDataItem(
                            allocationNumber.Replace("[", "").Replace("]", ""));
                }

                if (allocationNumber != deliverablesAreForAllocation)
                {
                    var numberOfDeliverablesForAllocation = paymentsGroup.Single(m => m.Key == allocationNumber).Count();

                    deliverables = GetDeliverables(allocationNumber, numberOfDeliverablesForAllocation);
                    deliverablesAreForAllocation = allocationNumber;
                }

                var deliverablePeriods = GetDeliverablePeriods(allocationNumber, row["DeliverableCode"], expectedNonNullPayments, selectPayment);

                ClassicAssert.IsTrue(deliverablePeriods.Any(), "Unable to get deliverable periods for allocation: {0} deliverable code: {1} at: {2}", allocationNumber, row["DeliverableCode"], DateTime.Now);

                foreach (string columnHeading in row.Keys)
                {
                    DateTime dt;
                    if (DateTime.TryParse("01-" + columnHeading, out dt))
                    {
                        decimal? expected = (row[columnHeading] == "?") ? (decimal?)null : decimal.Parse(row[columnHeading]);
                        var actual = GetPayment(deliverablePeriods, columnHeading, selectPayment);

                        // Now check the data returned by from CRM - if it doesn't match what is expected - fire off the read to CRM again.
                        //
                        // NOTE: This means that if the expected numbers are not the same as the calculated ones, the test will loop over and over
                        // until it times out.  This is less efficient than the old way of looping until the right number of nulls appears however
                        // for 24+ Loans, you will never get nulls so there is no way of telling when the payment calcs have finished.....

                        CheckResultPoller checkResultPoller = new CheckResultPoller(
                            checkResult: () =>
                            {
                                // Invoke the CRM get again
                                deliverablePeriods = GetDeliverablePeriods(allocationNumber, row["DeliverableCode"], expectedNonNullPayments, selectPayment);

                                // extract the expected data
                                return expected == GetPayment(deliverablePeriods, columnHeading, selectPayment);
                            },
                            maxNumChecks: 20,
                            waitIntervalSeconds: 4);

                        checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                        //TODO: say what payment type we're checking?
                        ClassicAssert.AreEqual(expected.GetValueOrDefault(0), actual.GetValueOrDefault(0), "Expected Payment for Allocation Ref {0}, Deliverable Code {1}, Period {2}",
                            allocationNumber,
                            row["DeliverableCode"],
                            columnHeading);
                    }
                    else if (columnHeading == "DeliverableName")
                    {
                        var deliverable = deliverables.Single(d => d.sfa_DeliverableCode == row["DeliverableCode"]);

                        ClassicAssert.AreEqual(row["DeliverableName"], deliverable.sfa_deliverablename,
                            $"Deliverable name did not match for allocation: {allocationNumber} deliverable code {row["DeliverableCode"]}");
                    }
                }

                // need to handle all nulls seperately??
            }
        }

        public bool CheckSubnominalValue(string profileSubnominal, string deliverablePeriod,
            decimal expectedSubnominalValue, out decimal calculatedTotal, int expectedPeriods, string paymentType = "Profile", int internalCount = 10)
        {
            calculatedTotal = -1;

            if (SubnominalAggregations.Count != expectedPeriods ||
                !SubnominalAggregations.Any(m => m.SubnominalCode == profileSubnominal && m.Period == deliverablePeriod))
            {
                SetSubnominalAggregations(profileSubnominal, paymentType, expectedPeriods);
            }

            if (SubnominalAggregations.Any(m => m.SubnominalCode == profileSubnominal && m.Period == deliverablePeriod))
            {
                calculatedTotal =
                    SubnominalAggregations.Where(
                        m => m.SubnominalCode == profileSubnominal && m.Period == deliverablePeriod && string.Equals(m.PaymentType, paymentType, StringComparison.CurrentCultureIgnoreCase))
                        .Select(m => m.AggregatedValue)
                        .FirstOrDefault();
                if (expectedSubnominalValue != calculatedTotal && internalCount > 0)
                {
                    System.Threading.Thread.Sleep(2000);
                    return (CheckSubnominalValue(profileSubnominal, deliverablePeriod, expectedSubnominalValue, out calculatedTotal, expectedPeriods, paymentType, internalCount - 1));
                }
                return (expectedSubnominalValue == calculatedTotal);
            }

            return expectedSubnominalValue == -1;
        }

        public void MakeDeliverablesHierarchical()
        {
            // Run through all the allocations and invoke the method to hierarchicalise them
            corpContractType.ExtendedContractType contractRequired = _contractToTest.contracts.First();
            foreach (ExtendedContractAllocation allocation in contractRequired.contractAllocations)
            {
                // Restructure the contract to look like a hierarchy
                allocation.contractDeliverables = allocation.AssembleChildDeliverables(allocation.contractDeliverables, null);
            }
        }

        public void SetOverrideDate(string overrideDate)
        {
            OverrideDateDBContext dbContext = new OverrideDateDBContext();
            RemoveOverrideDate(dbContext);
            dbContext.OverrideDate.Add(new OverrideDate()
            {
                SystemOverrideDate = overrideDate.Length == 10 ? DateTime.ParseExact(overrideDate, "dd/MM/yyyy", CultureInfo.CurrentCulture) : DateTime.ParseExact(overrideDate, "dd/MM/yyyy HH:mm", CultureInfo.CurrentCulture)
            });
            dbContext.SaveChanges();
        }

        public void ResetOverrideDate()
        {
            OverrideDateDBContext dbContext = new OverrideDateDBContext();
            RemoveOverrideDate(dbContext);
        }

        private void RemoveOverrideDate(OverrideDateDBContext dbContext)
        {
            foreach (OverrideDate overrideDate in dbContext.OverrideDate)
            {
                dbContext.OverrideDate.Remove(overrideDate);
            }
            dbContext.SaveChanges();
        }

        public void RemoveContractFromContractManagementAtomFeedTable(string contractNumber)
        {
            int noOfRowDeleted;
            using (var context = new ContractManagementDbContext())
            {
                noOfRowDeleted = context.AtomFeedItems.Count(af => af.BusinessKey.Contains(contractNumber));
                context.AtomFeedItems.RemoveWhere(af =>
                af.BusinessKey.Contains(contractNumber));
                context.SaveChanges();
            }

            Debug.WriteLine("Number of Atom Feed Items Records Deleted: " + noOfRowDeleted.ToString());
        }

        public void RemoveContractFromMonitoringDeliverablesTables(string contractNumber)
        {
            int noOfRowDeleted;
            using (var context = new MonitoringDeliverablesDbContext())
            {
                SqlParameter[] param1 = {
                new SqlParameter("@schema", "MonitoringDeliverables"),
                new SqlParameter("@table", "AllocationDeliverablePeriodActualAudit"),
                new SqlParameter("@contractNumber", contractNumber)};
                
                SqlParameter[] param2 = {
                new SqlParameter("@schema", "MonitoringDeliverables"),
                new SqlParameter("@table", "AllocationDeliverablePeriod"),
                new SqlParameter("@contractNumber", contractNumber)};
                
                SqlParameter[] param3 = {
                new SqlParameter("@schema", "MonitoringDeliverables"),
                new SqlParameter("@table", "CurrentViewActual"),
                new SqlParameter("@contractNumber", contractNumber)};

                noOfRowDeleted = context.Database.ExecuteSqlCommand("sp_RemoveContractbyMontDelNo @schema,@table,@contractNumber", param1);
                noOfRowDeleted += context.Database.ExecuteSqlCommand("sp_RemoveContractbyMontDelNo @schema,@table,@contractNumber", param2);
                noOfRowDeleted += context.Database.ExecuteSqlCommand("sp_RemoveContractbyMontDelNo @schema,@table,@contractNumber", param3);
            }

            Debug.WriteLine("Number of Monitoring Deliverable Records Deleted: " + noOfRowDeleted.ToString());
        }

        public void RemoveContractFromPaymentScheduleTables(string contractNumber)
        {
            int noOfRowDeleted;

            using (var context = new PaymentSchedulePolicyContext())
            {
                noOfRowDeleted = context.Database.ExecuteSqlCommand("DELETE dp FROM [PaymentSchedule].[DeliverablePayment] dp INNER JOIN [PaymentSchedule].[Allocation] a ON dp.AllocationNumber = a.AllocationNumber WHERE a.ContractNumber = @p0", contractNumber);
                noOfRowDeleted += context.Database.ExecuteSqlCommand("DELETE org FROM [PaymentSchedule].[OrganisationIdentifer] org INNER JOIN [PaymentSchedule].[Allocation] a ON org.AllocationNumber = a.AllocationNumber WHERE a.ContractNumber = @p0", contractNumber);
                noOfRowDeleted += context.Database.ExecuteSqlCommand("DELETE prov FROM [PaymentSchedule].[ProvisionIdentifier] prov INNER JOIN [PaymentSchedule].[Allocation] a ON prov.AllocationNumber = a.AllocationNumber WHERE a.ContractNumber = @p0", contractNumber);
                noOfRowDeleted += context.Database.ExecuteSqlCommand("DELETE a FROM [PaymentSchedule].[Allocation] a WHERE a.ContractNumber = @p0", contractNumber);
            }

            Debug.WriteLine("Number of Payment Schedule Records Deleted: " + noOfRowDeleted.ToString());
        }

        public void PublishAllocationActuals()
        {
            foreach (ContractAllocationActualsType contractAllocationActualsType in ContractAllocationActuals)
            {
                AllocationActualsVerified allocationActualsVerifiedEvent = new AllocationActualsVerified()
                {
                    AllocationActuals = contractAllocationActualsType
                };

                MessageSendingBus.Publish("AllocationDeliveryDomain.Validation", allocationActualsVerifiedEvent);
            }
        }

        public void SetupContractAllocationActualsType(Table summarisedActuals)
        {
            ContractAllocationActuals = new List<ContractAllocationActualsType>();
            var groups = summarisedActuals.Rows.GroupBy(r => r["AllocationRef"]);
            foreach (var group in groups)
            {
                var allocation = new ContractAllocationActualsType
                {
                    ContractAllocationNumber = group.Key,
                    CollectionReturnCode = CollectionReturnCode,
                    CollectionType = CollectionType,
                    ContractReference = new ContractReferenceType()
                    {
                        ContractNumber = _contractToTest.contracts[0].contractNumber,
                        ContractVersionNumber = _contractToTest.contracts[0].contractVersionNumber,
                        ContractSubVersionNumber = _contractToTest.contracts[0].contractSubVersionNumber
                    },
                    ContractorReference = new OrganisationReferenceType()
                    {
                        OrganisationIdentifier = _contractToTest.contractor.organisationIdentifier,
                        AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>()
                        {
                            new organisationIdentifiersOrganisationIdentifier()
                            {
                                organisationIdentifier = _contractToTest.contractor.ukprn.ToString(),
                                organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER,
                                effectiveDateRange = new effectiveDateRange()
                            }
                        }
                    },
                    ActualsSummary = new List<ActualsSummaryType>(),
                    FundingStreamPeriodCode = _contractToTest.contracts[0].contractAllocations.Where(m => m.contractAllocationNumber == group.Key).Select(m => m.fundingStreamPeriodCode).FirstOrDefault()
                };

                foreach (TableRow row in group)
                {
                    string[] ar = row.Keys.ToArray();
                    for (int i = 3; i < row.Keys.Count; i++)
                    {
                        DateTime dt;
                        if (DateTime.TryParse("01-" + ar[i], out dt) && row[i] != "?")
                        {
                            ActualsSummaryType actualsSummaryType = new ActualsSummaryType()
                            {
                                Period = dt.ToString("yyyyMM"),
                                PeriodType = new PeriodTypeType()
                                {
                                    PeriodTypeCode =
                                        _contractToTest.contracts[0].contractAllocations.Where(
                                            m => m.contractAllocationNumber == group.Key)
                                            .Select(m => m.period.periodType.periodTypeCode.ToString())
                                            .FirstOrDefault(),
                                    PeriodTypeName =
                                        _contractToTest.contracts[0].contractAllocations.Where(
                                            m => m.contractAllocationNumber == group.Key)
                                            .Select(m => m.period.periodType.periodTypeName.ToString())
                                            .FirstOrDefault()
                                },
                                DeliverableCode = int.Parse(row["DeliverableCode"]),
                                ActualValue = decimal.Parse(row[i]),
                                ActualVolume = 0
                            };

                            allocation.ActualsSummary.Add(actualsSummaryType);
                        }

                    }
                }
                ContractAllocationActuals.Add(allocation);
            }
        }

        public int GetCountOfDeliverablesPeriodsInCrmForGivenContract(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                var countOfContractDeliverablePeriods =
                    (from a in xrmContext.sfa_contractallocationSet
                     join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                     join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                         d.sfa_ContractAllocationId.Id
                     join cdp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                         cdp.sfa_ContractDeliverableId.Id
                     where
                         c.sfa_number == contractNumber &&
                         c.sfa_LatestVersion == true
                     select cdp.Id).ToList().Count;

                return countOfContractDeliverablePeriods;
            }
        }

        public int GetCountOfDeliverablesPeriodsInCrmForGivenAllocation(string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                var countOfContractDeliverablePeriods =
                    (from a in xrmContext.sfa_contractallocationSet
                     join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                     join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                         d.sfa_ContractAllocationId.Id
                     join cdp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                         cdp.sfa_ContractDeliverableId.Id
                     where
                         a.sfa_contractallocationnumber == allocationNumber &&
                         c.sfa_LatestVersion == true
                     select cdp.Id).ToList().Count();

                return countOfContractDeliverablePeriods;
            }
        }

        public IReadOnlyCollection<Entity> GetContractsByUkprnNoRetry(string ukprn)
        {
            var contract = XrmService.Configuration.Entity("Contract");

            var contracts = XrmService.Connection.GetRecords(contract, ukprn, "sfa_UKPRN");
            if (contracts.Any())
            {
                foreach (var returnedContract in contracts)
                {
                    var latestContract = returnedContract.GetLatestRecord();
                    if (latestContract.GetField("sfa_hierarchytype").ToString() == "Contract")
                    {
                        contractNumbersList.Add(latestContract.GetField("sfa_number").ToString());
                    }
                    else
                    {
                        mastercontractNumbersList.Add(latestContract.GetField("sfa_number").ToString());
                    }
                }
            }

            return contracts.Select(c => c.Entity).ToList();
        }

        public void DeleteNotifications(string notificationType, string notificationNameKey)
        {
            IReadOnlyCollection<EntityReference> notificationIds = null;
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                int notificationTypeId = (int)(sfa_notificationtype)Enum.Parse(typeof(sfa_notificationtype), notificationType.Replace(" ", string.Empty));

                // the projection below is weird as the implementation of LinqToCrm is weird
                // select n.ToEntityReference()).ToList() doesn't work if the list is empty
                notificationIds =
                    (from n in xrmContext.sfa_notificationSet
                     where n.sfa_NotificationType.Value == notificationTypeId
                           && n.sfa_Name.Contains(notificationNameKey)
                     select n).ToList().Select(n => n.ToEntityReference()).ToList();
            }

            if (notificationIds.Any())
            {
                DeleteEntityReferences(notificationIds);
            }
        }

        private void DeleteEntityReferences(IEnumerable<EntityReference> entityReferences)
        {
            var multipleRequest = new ExecuteMultipleRequest
            {
                Settings = new ExecuteMultipleSettings()
                {
                    ContinueOnError = true,
                    ReturnResponses = false
                },
                Requests = new OrganizationRequestCollection()
            };
            var deleteRequests = entityReferences.Select(er => new DeleteRequest { Target = er });
            multipleRequest.Requests.AddRange(deleteRequests);

            GetOrganizationService().Execute(multipleRequest);
        }

        private bool IsOrgPresentInCrm(string orgId)
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                return (xrmContext.AccountSet.Where(a => a.sfa_OrganisationID == orgId).ToList().Count > 0);
            }
        }

        public List<SubnominalAggregation> GetSubnominalAggregationsForSubnominalCodeAndAllocationNumber(string allocationNumber, string subnominalCode, string paymentType)
        {
            IQueryable<SubnominalAggregation> data = null;
            switch (paymentType.ToUpper())
            {
                case "PROFILE":
                    {
                        using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
                        {
                            data = (from a in xrmContext.sfa_contractallocationSet
                                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                                    join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                                        d.sfa_ContractAllocationId.Id
                                    join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                                        d.sfa_contractdeliverableId equals
                                        cdp.sfa_ContractDeliverableId.Id
                                    join sas in xrmContext.sfa_subnominalaggregationSet on cdp.sfa_profilesubnominal.Id
                                        equals
                                        sas.sfa_subnominalaggregationId
                                    where
                                        sas.sfa_SubnominalCode == subnominalCode &&
                                        c.sfa_LastApprovedVersion == true &&
                                        a.sfa_contractallocationnumber == allocationNumber
                                    select new SubnominalAggregation()
                                    {
                                        SubnominalCode = sas.sfa_SubnominalCode,
                                        Period = sas.sfa_Period,
                                        AggregatedValue =
                                        sas.sfa_AggregatedValue.HasValue
                                            ? sas.sfa_AggregatedValue.Value
                                            : new decimal(-1),
                                        PaymentType = sas.sfa_PaymentTypeEnum.Value.ToString()
                                    });
                        }
                        break;
                    }
                case "RECONCILIATION":
                    {
                        using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
                        {
                            data = (from a in xrmContext.sfa_contractallocationSet
                                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                                    join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                                        d.sfa_ContractAllocationId.Id
                                    join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                                        d.sfa_contractdeliverableId equals
                                        cdp.sfa_ContractDeliverableId.Id
                                    join sas in xrmContext.sfa_subnominalaggregationSet on
                                        cdp.sfa_reconciliationsubnominal.Id equals
                                        sas.sfa_subnominalaggregationId
                                    where
                                        sas.sfa_SubnominalCode == subnominalCode &&
                                        c.sfa_LastApprovedVersion == true &&
                                        a.sfa_contractallocationnumber == allocationNumber
                                    select new SubnominalAggregation()
                                    {
                                        SubnominalCode = sas.sfa_SubnominalCode,
                                        Period = sas.sfa_Period,
                                        AggregatedValue =
                                        sas.sfa_AggregatedValue.HasValue
                                            ? sas.sfa_AggregatedValue.Value
                                            : new decimal(-1),
                                        PaymentType = sas.sfa_PaymentTypeEnum.Value.ToString()
                                    });
                        }
                        break;
                    }
                case "CAPPING":
                    {
                        using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
                        {
                            data = (from a in xrmContext.sfa_contractallocationSet
                                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                                    join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                                        d.sfa_ContractAllocationId.Id
                                    join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                                        d.sfa_contractdeliverableId equals
                                        cdp.sfa_ContractDeliverableId.Id
                                    join sas in xrmContext.sfa_subnominalaggregationSet on cdp.sfa_CappingSubnominal.Id
                                        equals
                                        sas.sfa_subnominalaggregationId
                                    where
                                        sas.sfa_SubnominalCode == subnominalCode &&
                                        c.sfa_LastApprovedVersion == true &&
                                        a.sfa_contractallocationnumber == allocationNumber
                                    select new SubnominalAggregation()
                                    {
                                        SubnominalCode = sas.sfa_SubnominalCode,
                                        Period = sas.sfa_Period,
                                        AggregatedValue =
                                        sas.sfa_AggregatedValue.HasValue
                                            ? sas.sfa_AggregatedValue.Value
                                            : new decimal(-1),
                                        PaymentType = sas.sfa_PaymentTypeEnum.Value.ToString()
                                    });
                        }
                        break;
                    }
            }

            return data.Distinct().ToList();
        }

        public IReadOnlyCollection<sfa_contract> GetContractsByUkprnPrefixAndSubStatus(int ukprnPrefix, string subStatus)
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                List<sfa_contract> results = new List<sfa_contract>();

                var contractNumbers = (from c in xrmContext.sfa_contractSet
                                       where c.sfa_UKPRN.StartsWith(ukprnPrefix.ToString())
                                       select new Tuple<string, sfa_contract>(c.sfa_number, c))
                    .ToList();

                foreach (var cn in contractNumbers)
                {
                    var substatus = XrmService.Configuration.Entity("Status");
                    var contract = XrmService.Configuration.Entity("Contract");
                    try
                    {
                        XrmService.Connection.GetRecord(contract, cn.Item1)
                            .LookupFieldValueEquals(substatus, "sfa_substatus", subStatus);

                        results.Add(cn.Item2);
                    }
                    catch (Exception)
                    {
                        // ignored - not in correct substatus
                    }
                }

                return results;
            }
        }

        public void DeleteContractsByUkprnPrefix(int ukprnPrefix)
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                var contractNumbers = (from c in xrmContext.sfa_contractSet
                                       where c.sfa_UKPRN.StartsWith(ukprnPrefix.ToString())
                                             && c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                                       select c.sfa_number)
                    .ToArray();

                var masterContractNumbers = (from c in xrmContext.sfa_contractSet
                                             where c.sfa_UKPRN.StartsWith(ukprnPrefix.ToString())
                                                   && c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Master
                                             select c.sfa_number)
                    .ToArray();

                if (contractNumbers.Any())
                {
                    DeleteContracts(contractNumbers);

                    foreach (var contractNumber in contractNumbers)
                    {
                        RemoveContractFromPaymentScheduleTables(contractNumber);

                        RemoveContractFromMonitoringDeliverablesTables(contractNumber);

                        RemoveContractFromContractManagementAtomFeedTable(contractNumber);
                    }
                }

                if (masterContractNumbers.Any())
                {
                    DeleteContracts(masterContractNumbers);
                }
            }
        }

        public void RemoveAllocationDeliverablePeriods(string ukprn)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var records = context.AllocationDeliverablePeriods.Where(x => x.Ukprn == ukprn);
                context.AllocationDeliverablePeriods.RemoveRange(records);
                context.SaveChanges();
            }
        }

        public sfa_serviceresponse? GetServiceResponseOfContract(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                return xrmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .ToList()
                    .OrderByDescending(c => c.sfa_Version)
                    .First().sfa_ServiceResponseEnum;
            }
        }
    }

    public class PaymentManagementCheckPeriod
    {
        public string AllocationNumber;

        public string DeliverableCode;

        public string Period;
    }

    public class PaymentManagementContractAllocation
    {
        public string Ukprn { get; set; }

        public string ContractNumber { get; set; }

        public string AllocationRef { get; set; }

        public string FundingStreamCode { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public string FundingStreamPeriodType { get; set; }

        public DateTime AllocationStartDate { get; set; }

        public DateTime? AllocationEndDate { get; set; }

        public decimal AllocationValue { get; set; }

        public string Period { get; set; }

        public string UoPCode { get; set; }

        public string UoPName { get; set; }

        public string AllocationDescription { get; set; }

        public string LepCode { get; set; }

        public string LepName { get; set; }

        public string TendetSpecificationReference { get; set; }

        public string LotReference { get; set; }

        public string TenderAwardRefernece { get; set; }

        public string InvestmentPriority { get; set; }

        public string AgreementNumber { get; set; }

        public string ActivityDescription { get; set; }

        public string SpecificationTitle { get; set; }

        public string RegionType { get; set; }

        public string LearningRatePremium { get; set; }

        public string DeliveryOrganisation { get; set; }
    }

    public class PaymentManagementContractDeliverable
    {
        public string AllocationRef { get; set; }

        public string DeliverableCode { get; set; }

        public int? ParentDeliverableCode { get; set; }

        public string DeliverableDesciption { get; set; }
        public string DeliverableName { get; set; }

        public Dictionary<string, decimal> Period { get; set; }

        public int DisplayOrder { get; set; }

        public decimal? UnitCost { get; set; }

        public string DeliveryOrganisation { get; set; }
    }

    public class SubnominalAggregation
    {
        public string SubnominalCode { get; set; }
        public string Period { get; set; }
        public decimal AggregatedValue { get; set; }
        public string PaymentType { get; set; }

        protected bool Equals(SubnominalAggregation other)
        {
            return string.Equals(SubnominalCode, other.SubnominalCode) && string.Equals(Period, other.Period) && AggregatedValue == other.AggregatedValue && string.Equals(PaymentType, other.PaymentType);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((SubnominalAggregation)obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                var hashCode = (SubnominalCode != null ? SubnominalCode.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ (Period != null ? Period.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ AggregatedValue.GetHashCode();
                hashCode = (hashCode * 397) ^ (PaymentType != null ? PaymentType.GetHashCode() : 0);
                return hashCode;
            }
        }

        public static bool operator ==(SubnominalAggregation left, SubnominalAggregation right)
        {
            return Equals(left, right);
        }

        public static bool operator !=(SubnominalAggregation left, SubnominalAggregation right)
        {
            return !Equals(left, right);
        }
    }
}