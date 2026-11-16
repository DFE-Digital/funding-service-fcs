namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Runtime.Caching;
    using System.Threading;
    using System.Threading.Tasks;
    using AllocationDelivery.DataStore;
    using AllocationDelivery.DataStore.Model;
    using CrossDomain.Integration.Common.Extensions;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;
    using Infrastructure.DTO;
    using Infrastructure.Repositories;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Infrastructure.Services;
    using MoreLinq;
    using Pages.DTO;
    using Utilities;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Metadata;
    using NUnit.Framework;
    using NUnit.Framework.Legacy;
    using Pages;
    using Polly;
    using TechTalk.SpecFlow;
    using Xrm.TestFramework;
    using corpContractType = CrossDomain.Integration.Entities.CorporateContract;
    using SFAEntities = CrossDomain.Integration.Entities.Xrm;
    using Dapper;

    [Binding]
    public class PaymentManagementSteps
    {
        private readonly PaymentManagementPageObject _paymentManagementPageObject;
        private readonly ADMonitoringDomainPageObject _adMonitoringDomainPageObject;
        private readonly ContractLoadPage _contractLoadStep;
        private readonly ContractRepositoryPageObject _contractRepositoryPageObject;
        private string _contractNumber;
        readonly Stopwatch _stopwatch = new Stopwatch();
        private const string SourceFolder = @"DataFiles";
        private IList<SimpleContractAllocation> _allocationEntriesInFeed;

        public PaymentManagementSteps(
            PaymentManagementPageObject paymentManagementPageObject,
            ADMonitoringDomainPageObject adMonitoringDomainPageObject,
            ContractLoadPage contractLoadStep,
            ContractRepositoryPageObject contractRepositoryPageObject)
        {
            _contractRepositoryPageObject = contractRepositoryPageObject;
            _paymentManagementPageObject = paymentManagementPageObject;
            _paymentManagementPageObject.Setup();
            _adMonitoringDomainPageObject = adMonitoringDomainPageObject;
            _contractLoadStep = contractLoadStep;
        }

        [Given(@"caseload advisor '(.*)' is assigned to provider '(.*)' with UKPRN '(.*)' and OrgId '(.*)' and has '(.*)' as a manager")]
        [When(@"caseload advisor '(.*)' is assigned to provider '(.*)' with UKPRN '(.*)' and OrgId '(.*)' and has '(.*)' as a manager")]
        public void GivenCaseloadAdvisorIsAssignedToProviderWithUkprn(string advisorName, string orgName, string ukprn, string orgId, string managerName)
        {
            _paymentManagementPageObject.SetupOrgansiation(advisorName, orgName, ukprn, orgId);
            _paymentManagementPageObject.CaseloadAdvisor = advisorName;
            _paymentManagementPageObject.ContractManager = managerName;
        }

        [Given(@"UPIN '(.*)' is associated with UKPRN '(.*)' in the CRM Organisation table")]
        public void GivenUpinIsAssociatedWithUkprnInTheCrmOrganisationTable(string upin, string ukprn)
        {
            _paymentManagementPageObject.AssociateUpinWithUkprn(ukprn, upin);
        }

        [Given(@"the Organisation in CRM for UKPRN '(.*)' has OrgId '(.*)' is named '(.*)' and has a status of '(.*)'")]
        public void GivenTheOrganisationDataForUkprnWithOrgIdAsAndWithNameAsIsSetupAs(string ukprn, string orgId, string orgName, string status)
        {
            _paymentManagementPageObject.SetupOrganisationWithStatusSpecified(ukprn, orgId, orgName, status);
        }

        [Given(@"caseload advisor '(.*)' is assigned to provider '(.*)' with UKPRN '(.*)' and OrgId '(.*)' already created and has '(.*)' as a manager")]
        public void GivenCaseloadAdvisorIsAssignedToProviderWithUkprnAndOrgIdAlreadyCreatedAndHasAsAManager(string advisorName, string orgName, string ukprn, string orgId, string managerName)
        {
            _paymentManagementPageObject.CreateCaseload(orgName, ukprn, advisorName);
            _paymentManagementPageObject.CaseloadAdvisor = advisorName;
            _paymentManagementPageObject.ContractManager = managerName;
        }

        [Given(@"caseload advisor '(.*)' is assigned to UKPRN '(.*)'")]
        public void GivenCaseloadAdvisorIsAssignedToUkprn(string advisorName, int ukprn)
        {
            EntityReference status = CrmStatusRepository.GetStatus("Active");

            _paymentManagementPageObject.CaseloadAdvisor = advisorName;

            CrmCaseloadRepository.CreateCaseloadIfNotThere(advisorName: advisorName, ukrpn: ukprn.ToString(), status: status);
        }

        [Given(@"caseload advisor '(.*)' is assigned to provider '(.*)' with UKPRN '(.*)' and OrgId '(.*)' and has '(.*)' as a manager for (.*) providers")]
        public void GivenCaseloadAdvisorIsAssignedToProviderWithUkprnAndOrgIdAndHasAsAManagerForProviders(string advisorName, string orgName, int ukprn, string orgId, string managerName, int iterations)
        {
            for (int x = 1; x <= iterations; x++)
            {
                string orgukprn = (ukprn + x).ToString();

                var orgIdIteration = int.Parse(orgId.Replace("ORG", "")) + x;

                var newOrgId = $"ORG{orgIdIteration.ToString("D7")}";

                GivenCaseloadAdvisorIsAssignedToProviderWithUkprn(advisorName, orgName, orgukprn, newOrgId, managerName);

                //_paymentManagementPageObject.SetupOrgansiation(advisorName, orgName, orgukprn, orgId);
                //_paymentManagementPageObject.CaseloadAdvisor = advisorName;
                //_paymentManagementPageObject.ContractManager = managerName;
            }
        }

        [Given(@"there is no Subnominal data in CRM or PaaS for the following contract allocations")]
        [Given(@"there is no Subnominal data for the following contract allocations")]
        public void GivenThereIsNoSubnominalDataForTheFollowingContractAllocations(TransformedTable contractAllocations)
        {
            foreach (var row in contractAllocations.Rows)
            {
                string allocationNumber = row[0];
                _paymentManagementPageObject.DeleteSubnominals(allocationNumber);
                CrmReplicatedRepository.DeleteSubnominals(allocationNumber);
                SubnominalAggregationRepository.DeleteSubnominalAggregations(allocationNumber);
            }
        }

        [Given(@"there is no Subnominal data in CRM for the following subnominal codes")]
        public void GivenThereIsNoSubnominalDataInCRMForTheFollowingSubnominalCodes(Table table)
        {
            foreach (var row in table.Rows)
            {
                string subnominalCode = row[0];
                CrmSubnominalAggregationRepository.DeleteSubmoninalsForCode(subnominalCode);
                CrmReplicatedRepository.DeleteSubmoninalsForCode(subnominalCode);
                SubnominalAggregationRepository.DeleteSubnominalAggregationsForSubnominalCode(subnominalCode);
            }
        }

        [Given(@"there is no Subnominal data for the following FSPs")]
        [Given(@"there is no Subnominal data in PaaS for the following FSPs")]
        public void GivenThereIsNoSubnominalDataForFsp(TransformedTable fspTable )
        {
            fspTable.Rows.Select(r => r["FSP"]).ForEach(SubnominalAggregationRepository.DeleteSubnominalAggregationsForFsp);
        }

        [Given(@"there is no Subnominal or event history data for the following contract allocations")]
        public void GivenThereIsNoSubnominalOrEventDataForTheFollowingContractAllocations(Table contractAllocations)
        {
            Parallel.ForEach(contractAllocations.Rows, row =>
            {
                string allocationNumber = row[0];
                _paymentManagementPageObject.DeleteSubnominals(allocationNumber);
                CrmReplicatedRepository.DeleteSubnominals(allocationNumber);
                Console.WriteLine($"DeleteSubnominalAggregationsForAllocation complete for {allocationNumber}");
                AllocationDeliveryEventReceivedRepository.ClearDownAllocationDeliveryEventReceivedTableForAllocation(allocationNumber);
            });
        }

        [Given(@"there is no Subnominal data for '(.*)' consecutive contract allocations commencing with '(.*)'")]
        public void GivenThereIsNoSubnominalDataForConsecutiveContractAllocationsCommencingWith(int numIterations, string startAllocationRef)
        {
            string[] splitAllocRef = startAllocationRef.Split('-');
            string allocType = splitAllocRef[0];
            int allocNumber = int.Parse(splitAllocRef[1]);

            for (int x = 1; x <= numIterations; x++)
            {
                _paymentManagementPageObject.DeleteSubnominals($"{allocType}-{allocNumber + x}");
                CrmReplicatedRepository.DeleteSubnominals($"{allocType}-{allocNumber + x}");
            }
        }

        [Given(@"the draft contract header details for the latest version of the contract are as follows")]
        public void GivenADraftContractHeaderDetailsAreAsFollows(Table contractHeader)
        {
            // Check for new version
            if (_paymentManagementPageObject.ContractToTest != null && _paymentManagementPageObject.ContractToTest.contracts.Any() &&
                (_paymentManagementPageObject.ContractToTest.contracts[0].contractVersionNumber != int.Parse(contractHeader.Rows[0]["ContractVersionNumber"]) ||
                _paymentManagementPageObject.ContractToTest.contracts[0].contractNumber != contractHeader.Rows[0]["ContractNumber"]))
            {
                // reset contract on page object
                _paymentManagementPageObject.ContractToTest = new corpContractType.ExtendedContract();
            }

            // Assign master contract details
            _paymentManagementPageObject.ContractToTest.contractNumber =
                   contractHeader.Rows[0]["MasterContractNumber"];
            _paymentManagementPageObject.ContractToTest.contractVersionNumber = int.Parse(contractHeader.Rows[0]["ContractVersionNumber"]);
            var masterContract = contractHeader.Rows[0]["MasterContractNumber"];
            _paymentManagementPageObject.ContractToTest.contractor = new corpContractType.Contractor
            {
                legalName = contractHeader.Rows[0]["LegalName"],
                ukprn = int.Parse(contractHeader.Rows[0]["UKPRN"]),
                organisationIdentifier = contractHeader.Rows[0]["OrgId"]
            };
            _paymentManagementPageObject.ContractToTest.amendmentType = contractHeader.Rows[0]["CRMIntent"];
            _paymentManagementPageObject.ContractToTest.hierarchyType =
                corpContractType.hierarchyType.MASTERCONTRACT;

            // use contract start and end dates for now, this can always be modified later if we need to have specific master contract start and end dates.
            _paymentManagementPageObject.ContractToTest.startDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractStartDate"]);

            DateTime? endDate = null;
            if (contractHeader.Rows[0]["ContractEndDate"].DoesNotContain("?"))
            {
                endDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractEndDate"]);
            }

            _paymentManagementPageObject.ContractToTest.endDate = endDate; // ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractEndDate"]);

            // Create new contract

            _paymentManagementPageObject.ContractToTest.contracts.Add(new corpContractType.ExtendedContract());
            _paymentManagementPageObject.ContractToTest.contracts[0].contractNumber =
                contractHeader.Rows[0]["ContractNumber"];
            _paymentManagementPageObject.mastercontractNumbersList.Add(masterContract);
            _paymentManagementPageObject.contractNumbersList.Add(contractHeader.Rows[0]["ContractNumber"]);
            _paymentManagementPageObject.ContractToTest.contracts[0].endDate = endDate;
            _paymentManagementPageObject.ContractToTest.contracts[0].startDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractStartDate"]);
            _paymentManagementPageObject.ContractToTest.contracts[0].contractVersionNumber = int.Parse(contractHeader.Rows[0]["ContractVersionNumber"]);

            // Add the sub version number if it has been included.
            if (contractHeader.Rows[0].ContainsKey("ContractSubVersionNumber"))
                _paymentManagementPageObject.ContractToTest.contracts[0].contractSubVersionNumber = int.Parse(contractHeader.Rows[0]["ContractSubVersionNumber"]);

            _paymentManagementPageObject.ContractToTest.contracts[0].contractValue = decimal.Parse(contractHeader.Rows[0]["ContractValue"]);
            _paymentManagementPageObject.ContractToTest.contracts[0].contractType1 = contractHeader.Rows[0]["ContractType"];
            _paymentManagementPageObject.ContractToTest.contracts[0].period = new corpContractType.Period
            {
                period1 = contractHeader.Rows[0]["Period"]
            };

            _paymentManagementPageObject.ContractToTest.contracts[0].contractor = new corpContractType.Contractor
            {
                legalName = contractHeader.Rows[0]["LegalName"],
                ukprn = int.Parse(contractHeader.Rows[0]["UKPRN"]),
                organisationIdentifier = contractHeader.Rows[0]["OrgId"],
                Status = contractHeader.Rows[0].ParseNullableString("OrgStatus") ?? "Active"
            };

            var fundingType = new corpContractType.fundingType();

            switch (contractHeader.Rows[0]["ContractNumber"].Split('-')[0].ToUpper())
            {
                case "MAIN":
                    fundingType.fundingTypeName = "Mainstream";
                    fundingType.fundingTypeCode = "MAIN";
                    break;

                case "NLAP":
                    fundingType.fundingTypeName = "Non-Levy Apprenticeships";
                    fundingType.fundingTypeCode = "NLA";
                    break;

                case "EMPAGE":
                    fundingType.fundingTypeName = "Apprenticeship Grant for Employers";
                    fundingType.fundingTypeCode = "AGE";
                    break;

                case "LOANS":
                    fundingType.fundingTypeName = "Advanced Learner Loans";
                    fundingType.fundingTypeCode = "LOANS";
                    break;

                case "24LOANS":
                    fundingType.fundingTypeName = "24+ Loans";
                    fundingType.fundingTypeCode = "24+LOANS";
                    break;

                case "CCFUND":
                    fundingType.fundingTypeName = "College Collaboration Fund";
                    fundingType.fundingTypeCode = "CCF";
                    break;

                case "DADAS":
                    fundingType.fundingTypeName = "Dance and Drama Awards";
                    fundingType.fundingTypeCode = "DADA";
                    break;

                case "EMP1":
                    fundingType.fundingTypeName = "Employer Ownership Pilot";
                    fundingType.fundingTypeCode = "EOP";
                    break;

                case "EMPF":
                    fundingType.fundingTypeName = "Employer Ownership Fund";
                    fundingType.fundingTypeCode = "EOF";
                    break;

                case "EDSK":
                    fundingType.fundingTypeName = "Education & Skills Funding";
                    fundingType.fundingTypeCode = "EDSK";
                    break;

                case "ESIF":
                    fundingType.fundingTypeName = "European Social Fund 2014-20";
                    fundingType.fundingTypeCode = "ESF";
                    break;

                case "FEC":
                    fundingType.fundingTypeName = "FE Condition Allocation";
                    fundingType.fundingTypeCode = "FECA";
                    break;

                case "FEPDGP":
                    fundingType.fundingTypeName = "FE Professional Development Grants Pilot";
                    fundingType.fundingTypeCode = "FE-PDGP";
                    break;

                case "HTEPGF":
                    fundingType.fundingTypeName = "HTE Provider Growth Fund";
                    fundingType.fundingTypeCode = "HTE-PGF";
                    break;

                case "NCS":
                    fundingType.fundingTypeName = "National Careers Service";
                    fundingType.fundingTypeCode = "NCS";
                    break;

                case "NLA":
                    fundingType.fundingTypeName = "Non-Levy Apprenticeships";
                    fundingType.fundingTypeCode = "NLA";
                    break;

                case "NONLG":
                    fundingType.fundingTypeName = "Non-learning Grants";
                    fundingType.fundingTypeCode = "NLG";
                    break;

                case "1619F":
                    fundingType.fundingTypeName = "16-19 Funding";
                    fundingType.fundingTypeCode = "1619FUND";
                    break;

                case "1618FU":
                    fundingType.fundingTypeName = "16-18 Forensic Unit";
                    fundingType.fundingTypeCode = "16-18FU";
                    break;

                case "AEBP":
                    fundingType.fundingTypeName = "Adult Education Budget";
                    fundingType.fundingTypeCode = "AEB";
                    break;

                case "AEBP21":
                    fundingType.fundingTypeName = "Adult Education Budget - 2021 Procurement";
                    fundingType.fundingTypeCode = "AEB2021";
                    break;

                case "ASFP23":
                    fundingType.fundingTypeName = "Adult Education Budget - 2023 Procurement";
                    fundingType.fundingTypeCode = "AEB2023";
                    break;

                case "19TR20":
                    fundingType.fundingTypeName = "19-24 Traineeships - 2020 Procurement";
                    fundingType.fundingTypeCode = "19TRN2020";
                    break;

                case "SAD":
                    fundingType.fundingTypeName = "Skills Accelerator Development Fund";
                    fundingType.fundingTypeCode = "SADF";
                    break;

                case "SDF2":
                    fundingType.fundingTypeName = "Strategic Development Fund II";
                    fundingType.fundingTypeCode = "SDFII";
                    break;

                case "SBP":
                    fundingType.fundingTypeName = "Skills Bootcamps";
                    fundingType.fundingTypeCode = "SB";
                    break;

                case "MLT":
                    fundingType.fundingTypeName = "Multiply";
                    fundingType.fundingTypeCode = "MULT";
                    break;

                case "APPLEVY":
                    fundingType.fundingTypeName = "Apprenticeship Levy";
                    fundingType.fundingTypeCode = "LEVY";
                    break;

                case "FEACA":
                    fundingType.fundingTypeName = "Additional Capital Allocations";
                    fundingType.fundingTypeCode = "FE-ACA";
                    break;

                case "HTESIF":
                    fundingType.fundingTypeName = "HTE Skills Injection Fund";
                    fundingType.fundingTypeCode = "HTE-SIF";
                    break;

                case "FERCA":
                    fundingType.fundingTypeName = "FE Reclassification Capital Allocation";
                    fundingType.fundingTypeCode = "FE-RCA";
                    break;

                default:
                    throw new Exception("Contract prefix not found when setting funding type");
            }
            _paymentManagementPageObject.ContractToTest.fundingType = fundingType;
            _paymentManagementPageObject.ContractToTest.contracts[0].fundingType = fundingType;

            _paymentManagementPageObject.ContractToTest.contracts[0].amendmentType = contractHeader.Rows[0]["CRMIntent"];
            _paymentManagementPageObject.ContractToTest.contracts[0].hierarchyType = corpContractType.hierarchyType.CONTRACT;
            _paymentManagementPageObject.ContractToTest.contracts[0].description =
                contractHeader.Rows[0].ContainsKey("ContractDescription") ? contractHeader.Rows[0]["ContractDescription"] : "";
        }

        [Given(@"the draft contract header details are as follows with '(.*)' iterations")]
        public void GivenTheDraftContractHeaderDetailsAreAsFollowsWithIterations(int iterations, Table contractHeader)
        {
            for (int x = 1; x <= iterations; x++)
            {
                if (_paymentManagementPageObject.ContractToTest != null)
                {
                    var masterContract = contractHeader.Rows[0]["MasterContractNumber"].Split('-')[0] + "-"
                                            + (int.Parse(contractHeader.Rows[0]["MasterContractNumber"].Split('-')[1])
                                               + x);
                    _paymentManagementPageObject.ContractToTest.contractNumber = masterContract;

                    _paymentManagementPageObject.ContractToTest.contractor = new corpContractType.Contractor
                    {
                        legalName = contractHeader.Rows[0]["LegalName"],
                        ukprn = int.Parse(contractHeader.Rows[0]["UKPRN"]) + x,
                        organisationIdentifier = "ORG" + (int.Parse(contractHeader.Rows[0]["OrgId"].Replace("ORG", "")) + x).ToString("D7")
                    };

                    _paymentManagementPageObject.ContractToTest.amendmentType = contractHeader.Rows[0]["CRMIntent"];
                    _paymentManagementPageObject.ContractToTest.hierarchyType = corpContractType.hierarchyType.MASTERCONTRACT;
                    _paymentManagementPageObject.ContractToTest.startDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractStartDate"]);
                    _paymentManagementPageObject.ContractToTest.endDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractEndDate"]);
                    // Create new contract

                    _paymentManagementPageObject.ContractToTest.contracts.Add(new corpContractType.ExtendedContract());
                    var contractNumber = contractHeader.Rows[0]["ContractNumber"].Split('-')[0] + "-"
                                         + (int.Parse(contractHeader.Rows[0]["ContractNumber"].Split('-')[1]) + x);

                    _paymentManagementPageObject.ContractToTest.contracts[0].contractNumber = contractNumber;
                    _paymentManagementPageObject.mastercontractNumbersList.Add(masterContract);
                    _paymentManagementPageObject.contractNumbersList.Add(contractNumber);

                    _paymentManagementPageObject.ContractToTest.contracts[0].endDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractEndDate"]);
                    _paymentManagementPageObject.ContractToTest.contracts[0].startDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractStartDate"]);
                    _paymentManagementPageObject.ContractToTest.contracts[0].contractVersionNumber =
                        int.Parse(contractHeader.Rows[0]["ContractVersionNumber"]);
                    _paymentManagementPageObject.ContractToTest.contracts[0].contractValue =
                        decimal.Parse(contractHeader.Rows[0]["ContractValue"]);
                    _paymentManagementPageObject.ContractToTest.contracts[0].contractType1 =
                        contractHeader.Rows[0]["ContractType"];
                    _paymentManagementPageObject.ContractToTest.contracts[0].period = new corpContractType.Period
                    {
                        period1 = contractHeader.Rows[0]["Period"]
                    };

                    var fundingType = new corpContractType.fundingType();

                    switch (contractHeader.Rows[0]["ContractNumber"].Split('-')[0])
                    {
                        case "MAIN":
                            fundingType.fundingTypeName = "Mainstream";
                            fundingType.fundingTypeCode = "MAIN";
                            break;

                        case "EMPAGE":
                            fundingType.fundingTypeName = "Apprenticeship Grant for Employers";
                            fundingType.fundingTypeCode = "AGE";
                            break;

                        case "24LOANS":
                            fundingType.fundingTypeName = "24+ Loans";
                            fundingType.fundingTypeCode = "24+LOANS";
                            break;

                        case "EMP1":
                            fundingType.fundingTypeName = "Employer Ownership Pilot";
                            fundingType.fundingTypeCode = "EOP";
                            break;

                        case "EOF":
                            fundingType.fundingTypeName = "Employer Ownership Fund";
                            fundingType.fundingTypeCode = "EOF";
                            break;

                        case "ESIF":
                            fundingType.fundingTypeName = "European Social Fund 2014-20";
                            fundingType.fundingTypeCode = "ESF";
                            break;

                        case "NCS":
                            fundingType.fundingTypeName = "National Careers Service";
                            fundingType.fundingTypeCode = "NCS";
                            break;

                        case "HTSIF":
                            fundingType.fundingTypeName = "HTE Skills Injection Fund";
                            fundingType.fundingTypeCode = "HTE-SIF";
                            break;

                        default:
                            throw new Exception("Contract reference prefix not found when setting funding type");
                    }
                    _paymentManagementPageObject.ContractToTest.fundingType = fundingType;
                    _paymentManagementPageObject.ContractToTest.contracts[0].fundingType = fundingType;
                    _paymentManagementPageObject.ContractToTest.contracts[0].amendmentType = contractHeader.Rows[0]["CRMIntent"];
                    _paymentManagementPageObject.ContractToTest.contracts[0].hierarchyType =
                        corpContractType.hierarchyType.CONTRACT;
                    _paymentManagementPageObject.ContractListToTest.Add(_paymentManagementPageObject.ContractToTest);
                }

                _paymentManagementPageObject.ContractToTest = null;
            }
        }

        [Given(@"the draft contract allocations details are as follows with '(.*)' iterations")]
        public void GivenTheDraftContractAllocationsDetailsAreAsFollowsWithIterations(int iterations, Table contractAllocations)
        {
            var x = 0;
            foreach (corpContractType.ExtendedContractType contractObject in _paymentManagementPageObject.ContractListToTest)
            {
                x++;
                foreach (TableRow row in contractAllocations.Rows)
                {
                    var pmcAllocationType = new PaymentManagementContractAllocation
                    {
                        Ukprn = (int.Parse(row["UKPRN"]) + x).ToString("D8"),
                        ContractNumber = row["ContractNumber"],
                        AllocationRef = row["AllocationRef"],
                        FundingStreamCode = row["FundingStreamCode"],
                        AllocationStartDate = ParseGwtDateAsUtc(row["AllocationStartDate"]),
                        AllocationEndDate = ParseGwtDateAsUtc(row["AllocationEndDate"]),
                        AllocationValue = Decimal.Parse(row["AllocationValue"]),
                        Period = contractObject.contracts[0].period.period1
                    };

                    _paymentManagementPageObject.CreateAllocationForMultipleContract(pmcAllocationType, contractObject, x);
                }
            }
        }

        [Given(@"the draft contract allocations details for the latest version of the contract are as follows")]
        public void GivenADraftContractAllocationsDetailsAreAsFollows(Table contractAllocations)
        {
            foreach (TableRow row in contractAllocations.Rows)
            {
                string fundingStreamPeriodCode;
                DateTime? endDate;
                if (row["AllocationEndDate"].Contains("?"))
                {
                    endDate = null;
                }
                else
                {
                    endDate = ParseGwtDateAsUtc(row["AllocationEndDate"]);
                }

                var gwtAllocation = new PaymentManagementContractAllocation
                {
                    Ukprn = row["UKPRN"],
                    ContractNumber = row["ContractNumber"],
                    AllocationRef = row["AllocationRef"],
                    FundingStreamCode = row["FundingStreamCode"],
                    FundingStreamPeriodCode = row.TryGetValue("FundingStreamPeriodCode", out fundingStreamPeriodCode) ? fundingStreamPeriodCode : null,
                    FundingStreamPeriodType = row["FundingStreamPeriodType"],
                    AllocationStartDate = ParseGwtDateAsUtc(row["AllocationStartDate"]),
                    AllocationEndDate = endDate,
                    AllocationValue = decimal.Parse(row["AllocationValue"]),
                    Period = _paymentManagementPageObject.ContractToTest.contracts[0].period.period1,
                    UoPCode = row["UoPCode"],
                    UoPName = row["UoPName"],
                    AllocationDescription = GetCellValue(row, "AllocationDescription"),
                    LepCode = GetCellValue(row, "LEPCode"),
                    LepName = GetCellValue(row, "LEPName"),
                    TendetSpecificationReference = GetCellValue(row, "TenderSpecificationReference"),
                    LotReference = GetCellValue(row, "LotReference"),
                    TenderAwardRefernece = GetCellValue(row, "TenderAwardReference"),
                    InvestmentPriority = GetCellValue(row, "InvestmentPriority"),
                    AgreementNumber = GetCellValue(row, "AgreementNumber"),
                    ActivityDescription = GetCellValue(row, "ActivityDescription"),
                    SpecificationTitle = GetCellValue(row, "SpecificationTitle"),
                    RegionType = GetCellValue(row, "RegionType"),
                    LearningRatePremium = GetCellValue(row, "LearningRatePremium"),
                    DeliveryOrganisation = GetCellValue(row, "DeliveryOrg")
                };

                _paymentManagementPageObject.CreateAllocationForContract(gwtAllocation);
            }

            _paymentManagementPageObject.CopyFirstContractsFirstAllocationsPeriodIntoMasterContract();
        }

        [Given(@"the draft contract deliverables details for the latest version of the contract are as follows")]
        public void GivenADraftContractDeliverablesDetailsAreAsFollows(Table contractDeliverables)
        {
            foreach (TableRow row in contractDeliverables.Rows)
            {
                var pmcDeliverableType = new PaymentManagementContractDeliverable
                {
                    AllocationRef = row["AllocationRef"],
                    DeliverableCode = row["DeliverableCode"],
                    DeliverableDesciption = row.ContainsKey("DeliverableDescription") ? row["DeliverableDescription"] : string.Empty,
                    DeliverableName = row.ContainsKey("DeliverableName") ? row["DeliverableName"] : string.Empty,
                    ParentDeliverableCode = null
                };

                if (string.IsNullOrEmpty(pmcDeliverableType.DeliverableName))
                {
                    pmcDeliverableType.DeliverableName = pmcDeliverableType.DeliverableDesciption;
                    pmcDeliverableType.DeliverableDesciption = string.Empty;
                }

                string unitCost = row.TryGetValue("UnitCost", out unitCost) ? unitCost : null;
                decimal decimalUnitCost;
                if (decimal.TryParse(unitCost, out decimalUnitCost))
                {
                    pmcDeliverableType.UnitCost = decimalUnitCost;
                }

                if (row.ContainsKey("ParentDeliverableCode"))
                {
                    if (!string.IsNullOrEmpty(row["ParentDeliverableCode"]) && row["ParentDeliverableCode"] != "0")
                    {
                        pmcDeliverableType.ParentDeliverableCode = int.Parse(row["ParentDeliverableCode"]);
                    }
                }

                if (row.ContainsKey("DisplayOrder"))
                {
                    if (!string.IsNullOrEmpty(row["DisplayOrder"]) && row["DisplayOrder"] != "0")
                    {
                        pmcDeliverableType.DisplayOrder = int.Parse(row["DisplayOrder"]);
                    }
                }

                pmcDeliverableType.Period = row.GetPeriodValues().ToDictionary(pv => pv.Period, pv => pv.Value.GetValueOrDefault());

                if (row.ContainsKey("DeliveryOrg"))
                {
                    pmcDeliverableType.DeliveryOrganisation = row["DeliveryOrg"];
                }

                _paymentManagementPageObject.CreateDeliverableForAllocation(pmcDeliverableType);
            }

            _paymentManagementPageObject.MakeDeliverablesHierarchical();
        }

        [Given(@"all the contracts are approved")]
        public void GivenTheContractsAreApproved()
        {
            foreach (var contract in _paymentManagementPageObject.contractNumbersList)
            {
                _contractLoadStep.UpdateContractStatus(contract, "Approved", "Approved");
            }
        }

        [Given(@"the draft contract deliverable volume details for the latest version of the contract are as follows")]
        [Given(@"the draft contract deliverable volume details are as follows")]
        public void GivenTheDraftContractDeliverableVolumeDetailsAreAsFollows(Table contractDeliverables)
        {
            List<SimpleContractDeliverable> simpleContractDeliverables = 
                contractDeliverables.Rows
                .Select(row => new SimpleContractDeliverable
                {
                    AllocationReference = row["AllocationRef"],
                    DeliverableCode = row["DeliverableCode"],
                    UnitCost = row.ParseNullableInt("UnitCost") ?? 0,
                    Volume = row.Where(cell => cell.IsPeriodColumn()).Sum(cell => int.Parse(cell.Value)),
                    Periods = row
                        .Where(cell => cell.IsPeriodColumn())
                        .Select(cell => new SimpleContractDeliverablePeriod
                        {
                            Name = cell.Key,
                            PlannedVolume = int.Parse(cell.Value)
                        })
                        .ToList()
                })
                .ToList();

            _paymentManagementPageObject.UpdateDeliverableInContractToTestWithVolumeAndUnitCost(simpleContractDeliverables);
        }

        [Given(@"the draft contract deliverables details are as follows with '(.*)' iterations")]
        public void GivenTheDraftContractDeliverablesDetailsAreAsFollowsWithIterations(int iterations, Table contractDeliverables)
        {
            var x = 0;
            foreach (corpContractType.ExtendedContractType contractToTestobject in _paymentManagementPageObject.ContractListToTest)
            {
                x++;

                foreach (TableRow row in contractDeliverables.Rows)
                {
                    var pmcDeliverableType = new PaymentManagementContractDeliverable
                    {
                        AllocationRef = row["AllocationRef"],
                        DeliverableCode = row["DeliverableCode"],
                        DeliverableDesciption = row["DeliverableDescription"],
                        Period = row.GetPeriodValues().ToDictionary(pv => pv.Period, pv => pv.Value.GetValueOrDefault())
                    };

                    if (row.ContainsKey("ParentDeliverableCode"))
                    {
                        if (!string.IsNullOrEmpty(row["ParentDeliverableCode"]) && row["ParentDeliverableCode"] != "0")
                        {
                            pmcDeliverableType.ParentDeliverableCode = int.Parse(row["ParentDeliverableCode"]);
                        }
                    }

                    if (row.ContainsKey("DisplayOrder"))
                    {
                        if (!string.IsNullOrEmpty(row["DisplayOrder"]) && row["DisplayOrder"] != "0")
                        {
                            pmcDeliverableType.DisplayOrder = int.Parse(row["DisplayOrder"]);
                        }
                    }

                    _paymentManagementPageObject.CreateDeliverableForAllocation(pmcDeliverableType, contractToTestobject, x);
                }
            }
        }

        [Given(@"file '(.*)' is copied '(.*)' times from Sharepoint folder '(.*)' to '(.*)' with incremented UKPRNs and contract numbers")]
        public void GivenFileIsCopiedTimesFromSharepointFolderToWithIncrementedUkprnsAndContractNumbers(string originalFileName, int numberOfTimes, string sourceDocumentLibrary, string targetDocumentLibrary)
        {
            IOffice365Adapter o365Helper = new Office365StorageWrapper();

            foreach (
                corpContractType.ExtendedContractType contractToTestobject in
                    _paymentManagementPageObject.ContractListToTest)
            {

                string newFileName = DetermineNewFileName(originalFileName, contractToTestobject.contractor.ukprn.ToString(),
                    contractToTestobject.contracts.First().contractNumber);

                o365Helper.UploadFile(newFileName, o365Helper.GetFileContents(originalFileName, sourceDocumentLibrary), targetDocumentLibrary);

            }
        }

        [When(@"an '(.*)' action is triggered in CRM for each of the '(.*)' contracts in this test")]
        public void WhenAnActionIsTriggeredInCrmForEachOfTheContractsInThisTest(string actionName, int numberOfContracts)
        {
            foreach (
                corpContractType.ExtendedContractType contractToTestobject in
                    _paymentManagementPageObject.ContractListToTest)
            {
                _paymentManagementPageObject.ChangeContractStateThroughAGivenTransition(contractToTestobject.contracts.First().contractNumber, actionName);
            }

        }

        [Then(@"there are '(.*)' files in Sharepoint folder '(.*)' prefixed '(.*)'")]
        public void ThenThereAreFilesInSharepointFolderPrefixed(int expectedNumberOfFiles, string documentLibrary, string prefixFileName)
        {
            IOffice365Adapter o365Adapter = new Office365StorageWrapper();

            int countAttempts = 0;

            int actualNumberOfFiles =
                o365Adapter.GetFilenamesByFileNameStartText(documentLibrary, prefixFileName).Count;

            while (actualNumberOfFiles != expectedNumberOfFiles && countAttempts < expectedNumberOfFiles)
            {
                Task.Delay(2000).Wait();
                actualNumberOfFiles = o365Adapter.GetFilenamesByFileNameStartText(documentLibrary, prefixFileName).Count;
                countAttempts++;
            }

            ClassicAssert.IsTrue(actualNumberOfFiles == expectedNumberOfFiles, $"Number of files {actualNumberOfFiles} in the sharepoint document library {documentLibrary} don't match expected value of {expectedNumberOfFiles}");
        }

        [Then(@"there are '(.*)' files in (.*) seconds in Sharepoint folder '(.*)' prefixed '(.*)'")]
        public void ThenThereAreFilesInSharepointFolderPrefixed(int expectedNumberOfFiles, int maxSecondsToWait, string documentLibrary, string prefixFileName)
        {
            IOffice365Adapter o365Adapter = new Office365StorageWrapper();

            int actualNumberOfFiles =
                o365Adapter.GetFilenamesByFileNameStartText(documentLibrary, prefixFileName).Count;
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            while (actualNumberOfFiles != expectedNumberOfFiles && stopwatch.Elapsed.Seconds < maxSecondsToWait)
            {
                Task.Delay(TimeSpan.FromSeconds(2)).Wait();
                actualNumberOfFiles = o365Adapter.GetFilenamesByFileNameStartText(documentLibrary, prefixFileName).Count;
                Debug.WriteLine($"Found {actualNumberOfFiles} - Expected {expectedNumberOfFiles}");
                Debug.WriteLine($"Wait time remaining: {maxSecondsToWait - stopwatch.Elapsed.Seconds}s");
            }

            stopwatch.Stop();
            ClassicAssert.IsTrue(actualNumberOfFiles == expectedNumberOfFiles, $"Number of files {actualNumberOfFiles} in the sharepoint document library {documentLibrary} don't match expected value of {expectedNumberOfFiles}");
        }

        [Given(@"all the contracts exist in CRM")]
        [Given(@"all the contract exists in CRM")]
        public void GivenAllTheContractExistsInCrm()
        {
            _paymentManagementPageObject.CreateMultipleContractsInCrm(_paymentManagementPageObject);
        }

        [Given(@"there are '(.*)' deliverable period rows in CRM linked to the latest version of contract '(.*)'")]
        [Then(@"there are '(.*)' deliverable period rows in CRM linked to the latest version of contract '(.*)'")]
        public void GivenThereAreDeliverablePeriodRowsInCrmLinkedToTheLatestVersionOfContract(int numberOfDeliverableRecords, TransformedString contractNumber)
        {
            int actualDeliverablePeriodsCount = 0;
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    actualDeliverablePeriodsCount = _paymentManagementPageObject.GetCountOfDeliverablesPeriodsInCrmForGivenContract(contractNumber);
                    return actualDeliverablePeriodsCount == numberOfDeliverableRecords;
                },
                maxNumChecks: 60,
                waitIntervalSeconds: 3
                );

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(
                actualDeliverablePeriodsCount == numberOfDeliverableRecords,
                $"The test expected to find {numberOfDeliverableRecords} records in CRM for contract {contractNumber} but instead found {actualDeliverablePeriodsCount}");
        }

        [Then(@"CRM subnominals have been created for the following allocations")]
        public void ThenCrmSubnominalsHaveBeenCreatedForTheseAllocations(TransformedTable table)
        {
            var subnominals = table.Rows.Select(r => new SubnominalKeyInfo(r["AllocationRef"], r["Period"], r.ParseInt("Subnominal Code"),
                r["Payment Type"])).ToList();

            subnominals.ForEach(s =>
            {
                CheckResultPoller checkResultPoller = new CheckResultPoller(
                    checkResult: () => CrmSubnominalAggregationRepository.IsSubnominalPresent(
                        s.AllocationNumber,
                        s.SubnominalCode,
                        s.Period,
                        s.PaymentType),

                    maxNumChecks: 100,
                    waitIntervalSeconds: 30
                );

                bool isPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(
                    isPresent,
                    $"Subnominal not found for: {s}");
            });

        }

        [Then(@"there are '(.*)' deliverable periods in CRM linked to the latest version of contract '(.*)' and allocation '(.*)'")]
        public void ThenThereAreDeliverablePeriodsInCrmLinkedToTheLatestVersionOfContractAndAllocation(int expectedNumberOfDeliverablePeriods, string contractNumber, string allocationNumber)
        {
            int actualDeliverablePeriodsCount = 0;
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    actualDeliverablePeriodsCount = _paymentManagementPageObject.GetCountOfDeliverablesPeriodsInCrmForGivenAllocation(allocationNumber);
                    return actualDeliverablePeriodsCount == expectedNumberOfDeliverablePeriods;
                },
                maxNumChecks: 30,
                waitIntervalSeconds: 3
                );

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(
                actualDeliverablePeriodsCount == expectedNumberOfDeliverablePeriods,
                $"The test expected to find {expectedNumberOfDeliverablePeriods} records in CRM for allocation {allocationNumber} but instead found {actualDeliverablePeriodsCount}");
        }

        [Given(@"the contract exists in CRM")]
        public void GivenTheContractExistsInCrm()
        {
            int numSecondsToBackOff = 5;

            Policy.Handle<Exception>(e => e.Message.Contains("Account With Id"))
                .WaitAndRetry(3, count => TimeSpan.FromSeconds(count * numSecondsToBackOff))
                .Execute(() =>
                {
                    Console.WriteLine("Creating Contract...");
                    _paymentManagementPageObject.CreateContractInCrm();
                    MemoryCache.Default.Dispose();
                });
            
        }

        [Given(@"the current contract has been removed from memory")]
        [Given(@"reset contract to test")]
        public void GivenResetContractToTest()
        {
            _paymentManagementPageObject.ContractToTest = null;
        }

        [Given(@"wait '(.*)' seconds")]
        [When(@"wait '(.*)' seconds")]
        [Then(@"wait '(.*)' seconds")]
        public void GivenAllowTimeForTheContractToBeCreated(int seconds)
        {
            Task.Delay(millisecondsDelay: seconds * 1000).Wait();
        }

        [Then(@"the amended contract exists in CRM")]
        public void ThenTheAmmendedContractExistsInCrm()
        {
            _paymentManagementPageObject.AmendContractInCrm("Variation");
        }

        [Given(@"the amended contract exists in CRM with an Amendment Type of '(.*)'")]
        public void GivenTheAmendedContractExistsInCrmWithAnAmendmentTypeOf(string amendmentType)
        {
            _paymentManagementPageObject.AmendContractInCrm(amendmentType);
        }

        [Given(@"the contracts are in a state of '(.*)'")]
        public void GivenTheContractsAreInAStateOf(string newSubStatus)
        {
            foreach (var contractNumber in _paymentManagementPageObject.contractNumbersList)
            {
                string contractNumberWithoutSquareBrackets = contractNumber;
                if (contractNumber.Contains("["))
                {
                    contractNumberWithoutSquareBrackets = _contractRepositoryPageObject.GetLatestContractDataItem("ContractNo");
                }
                _paymentManagementPageObject.ChangeContractSubStatus(
                    contractNumberWithoutSquareBrackets,
                    _paymentManagementPageObject.ContractToTest.contracts.Where(x => x.contractNumber == contractNumber).Select(x => x.contractVersionNumber).ToString()
                    , newSubStatus);
            }
        }

        [Given(@"the latest version of contract '(.*)' is in a state of '(.*)'")]
        [Then(@"the latest version of contract '(.*)' is in a state of '(.*)'")]
        [When(@"the latest version of contract '(.*)' is in a state of '(.*)'")]
        public void ThenTheLatestVersionOfContractIsInAStateOf(TransformedString contractNumber, string newContractSubStatus)
        {
            CrmContractRepository.SetSubStatusForLatestContractWithVersion(contractNumber.Value,
                _contractLoadStep.GetLatestVersionForContract(contractNumber.Value), newContractSubStatus,
                _paymentManagementPageObject.CaseloadAdvisor);
        }

        [Given(@"todays date is '(.*)'")]
        public void GivenTodaysDateIs(string todaysDate)
        {
            _paymentManagementPageObject.TodaysDate = ParseGwtDateAsUtc(todaysDate);
        }

        [Then(@"the override date is '(.*)'")]
        [When(@"the override date is '(.*)'")]
        public void ThenTheOverrideDateIs(string overrideDate)
        {
            _paymentManagementPageObject.SetOverrideDate(overrideDate);
        }

        [Given(@"the override date is '(.*)'")]
        public void GivenTheOverrideDateIs(string overrideDate)
        {
            Console.WriteLine("\r\n     " + overrideDate + "\r\n");
            _paymentManagementPageObject.SetOverrideDate(overrideDate);
        }

        [Then(@"the override date is reset")]
        public void ThenTheOverrideDateIsReset()
        {
            _paymentManagementPageObject.ResetOverrideDate();
        }

        [Given(@"the override date is reset")]
        public void GivenTheOverrideDateIsReset()
        {
            _paymentManagementPageObject.ResetOverrideDate();
        }

        [Then(@"the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events")]
        [When(@"the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events")]
        public void ThenTheAllocationDeliveryMonitoringServiceAtomFeedContainsTheFollowingAllocationDeliveryPerformanceEvents(TransformedTable table)
        {
            List<SimpleContractAllocation> contractAllocationsToCheck = table.Rows
                .Select(r => new SimpleContractAllocation(
                    GetAllocationNumber(r["AllocationNumber"]),
                    Convert.ToInt32(r["ContractVersionNumber"]),
                    (AllocationDeliveryEntryCategory)Enum.Parse(typeof(AllocationDeliveryEntryCategory), r["AllocationDeliveryEntryCategory"])))
                .ToList();

            CheckResultPoller resultPoller = new CheckResultPoller(
                checkResult: () => _adMonitoringDomainPageObject.VerifyAllocationsAreInFeed(contractAllocationsToCheck),
                maxNumChecks: 18,
                waitIntervalSeconds: 10);

            _allocationEntriesInFeed = _adMonitoringDomainPageObject.GetAllEntriesInFeed();

            bool allEventsFound = resultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(allEventsFound, "Not all expected allocation delivery performance events are in retrieved atom feed");
        }

        [Then(@"the planned volume details on the '(.*)' event on the ADP feed for version '(.*)' of contract allocation '(.*)' are as follows")]
        public void ThenThePlannedVolumeDetailsOnTheEventOnTheAdpFeedForVersionOfContractAreAsFollows(string categoryName, int contractVersion, TransformedString contractAllocation, Table table)
        {
            FeedAllocation contractAllocationsToCheck = new FeedAllocation
            {
                AllocationNumber = contractAllocation,
                AllocationVersion = contractVersion,
                EntryCategory = (AllocationDeliveryEntryCategory)Enum.Parse(typeof(AllocationDeliveryEntryCategory), categoryName),
                AllocationDeliverablePeriods = table.Rows
                                                   .Select(r => new FeedAllocationDeliverablePeriod(
                                                       Convert.ToInt32(r["DeliverableCode"]),
                                                       r["Period"],
                                                       0m,
                                                       Convert.ToInt32(r["PlannedVolume"])
                                                       )).ToList()
            };

            _adMonitoringDomainPageObject.VerifyPlannedVolumeInFeed(contractAllocationsToCheck, _allocationEntriesInFeed);

            ClassicAssert.IsTrue(contractAllocationsToCheck.AllocationDeliverablePeriods.Where(x => x.IsPlannedVolumeMatches == false).Count() == 0, "Planned Volume do not match with the feed entry");
        }

        [Then(@"the actual volume details on the '(.*)' event on the ADP feed for version '(.*)' of contract allocation '(.*)' are as follows")]
        public void ThenTheActualVolumeDetailsOnTheEventOnTheAdpFeedForVersionOfContractAreAsFollows(string categoryName, int contractVersion, TransformedString contractAllocation, Table table)
        {
            FeedAllocation contractAllocationsToCheck = new FeedAllocation
            {
                AllocationNumber = contractAllocation,
                AllocationVersion = contractVersion,
                EntryCategory = (AllocationDeliveryEntryCategory)Enum.Parse(typeof(AllocationDeliveryEntryCategory), categoryName),
                AllocationDeliverablePeriods = table.Rows
                                                  .Select(r => new FeedAllocationDeliverablePeriod(
                                                      Convert.ToInt32(r["DeliverableCode"]),
                                                      r["Period"],
                                                      Convert.ToInt32(r["ActualVolume"])
                                                      )).ToList()
            };
            _adMonitoringDomainPageObject.VerifyActualVolumeInFeed(contractAllocationsToCheck, _allocationEntriesInFeed);
            ClassicAssert.IsTrue(contractAllocationsToCheck.AllocationDeliverablePeriods.Where(x => x.IsActualVolumeMatches == false).Count() == 0, "Actual Volume don not match with the feed entry");
        }

        [Given(@"the following allocation periods are present in the subnominal aggregation PaaS table")]
        [Then(@"the following allocation periods are present in the subnominal aggregation PaaS table")]
        public void ThenTheFollowingAllocationPeriodsArePresentInTheSubnominalAggregationPaaSTable(TransformedTable table)
        {
            CheckResultPoller resultPoller = new CheckResultPoller(
             checkResult: () => table.Rows.All(r => SubnominalAggregationRepository.IsRowPresentForAllocationAndPeriod(GetAllocationNumber(r["ContractAllocationNumber"]), r["Period"])),
             maxNumChecks: 30,
             waitIntervalSeconds: 4);

            bool areSubnominalAggregationsPresent = resultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(areSubnominalAggregationsPresent, "Not all the subnominal aggregations are present - " + string.Join(",", table.Rows.Select(r => GetAllocationNumber(r["ContractAllocationNumber"])).Distinct()));
        }

        [Then(@"the AllocationDeliveryEntry Atom feed has '(.*)' ContractAllocationActualsReceived rows with allocation numbers prefixed '(.*)'")]
        public void ThenTheAllocationDeliveryEntryAtomFeedHasContractAllocationActualsReceivedRowsWithAllocationNumbersPrefixed(int numIterations, string allocPrefix)
        {
            List<string> allocations = new List<string>();

            for (int x = 1; x <= numIterations; x++)
            {
                allocations.Add($"{allocPrefix}{x.ToString("D3")}");
            }

            CheckResultPoller resultPoller =
                new CheckResultPoller(() => _adMonitoringDomainPageObject.VerifyAllocationsAreInFeedByAllocRef(allocations), 9, 5);

            bool allEventsFound = resultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(allEventsFound, "Not all expected allocation delivery performance events are in retrieved atom feed");
        }

        [When(@"all contracts are approved")]
        public void WhenAllContractsAreApproved()
        {
            //file.WriteLine("Preformance Test Initiated for " + _paymentManagementPageObject.contractNumbersList.Count + " Contracts");
            _stopwatch.Start();

            //file.WriteLine("Watch Started" + _stopwatch.Elapsed + "\n");
            foreach (var contractNumber in _paymentManagementPageObject.contractNumbersList)
            {
                _paymentManagementPageObject.ChangeContractStateFromReadyToBeApprovedToApproved(contractNumber);
            }
        }

        [Then(@"the draft contract header details for the latest version of the contract are as follows")]
        public void ThenTheDraftContractHeaderDetailsForTheLatestVersionOfTheContractAreAsFollows(Table table)
        {
            GivenADraftContractHeaderDetailsAreAsFollows(table);
        }

        [Then(@"the draft contract allocations details for the latest version of the contract are as follows")]
        public void ThenTheDraftContractAllocationsDetailsForTheLatestVersionOfTheContractAreAsFollows(Table table)
        {
            GivenADraftContractAllocationsDetailsAreAsFollows(table);
        }

        [Then(@"the draft contract deliverables details for the latest version of the contract are as follows")]
        public void ThenTheDraftContractDeliverablesDetailsForTheLatestVersionOfTheContractAreAsFollows(Table table)
        {
            GivenADraftContractDeliverablesDetailsAreAsFollows(table);
        }

        [Then(@"the draft contract deliverable volume details are as follows")]
        public void ThenTheDraftContractDeliverableVolumeDetailsAreAsFollows(Table table)
        {
            GivenTheDraftContractDeliverableVolumeDetailsAreAsFollows(table);
        }

        [Then(@"the contract exists in CRM")]
        public void ThenTheContractExistsInCrm()
        {
            _paymentManagementPageObject.CreateContractInCrm();
        }

        [Then(@"poll CRM every '(.*)' minutes to check if the esb message has been successfull for '(.*)' contracts in '(.*)' seconds\.")]
        public void ThenPollCRMEveryMinutesToCheckIfTheEsbMessageHasBeenSuccessfullForContractsInSeconds_(int runs, int sample, int seconds)
        {

            TimeSpan tryrun = new TimeSpan(0, 0, runs);
            TimeSpan interval = new TimeSpan(0, 0, seconds);

            decimal expectedValue = (decimal)0.00;

            //file.Write("\nAllocation, Deliverable Code, Period, Time");
            foreach (var eachPeriodCheck in _paymentManagementPageObject.PeriodListToCheck)
            {

                while (_paymentManagementPageObject.CheckProfilePaymentsNfr(eachPeriodCheck.AllocationNumber,
                    eachPeriodCheck.DeliverableCode, eachPeriodCheck.Period, expectedValue) == false &&
                       _stopwatch.Elapsed.TotalHours < interval.TotalHours)
                {
                    Thread.Sleep((tryrun));
                }

                //file.Write("\n" + eachPeriodCheck.AllocationNumber + "," + eachPeriodCheck.DeliverableCode + "," + eachPeriodCheck.Period + "," + _stopwatch.Elapsed);

            }


            _stopwatch.Stop();
            //file.Write("\nTest completed for " + sample + " records Total Time =" + _stopwatch.Elapsed);

            //file.Close();
            ClassicAssert.IsTrue(_stopwatch.Elapsed.TotalHours < interval.TotalHours);
        }

        [Given(@"the latest version of contract '(.*)' is approved")]
        [When(@"the latest version of contract '(.*)' is approved")]
        [Then(@"the latest version of contract '(.*)' is approved")]
        public void WhenTheContractIsApproved(string contractNum)
        {
            _paymentManagementPageObject.ClearMonthEndHistory();
            _paymentManagementPageObject.ChangeContractStateFromReadyToBeApprovedToApproved(contractNum);
        }

        [Given(@"the latest version of contract '(.*)' is set to approved")]
        [Then(@"the latest version of contract '(.*)' is set to approved")]
        public void ThenTheLatestVersionOfContractIsSetToApproved(string contractNum)
        {
            WhenTheContractIsApproved(contractNum);
        }

        [Given(@"the status and sub-status of the latest version of contract '(.*)' are changed to '(.*)'")]
        [Then(@"the status and sub-status of the latest version of contract '(.*)' are changed to '(.*)'")]
        public void ThenTheStatusAndSub_StatusOfContractAreChangedTo(string contractNum, string contractState)
        {
            foreach (var contractNumber in _paymentManagementPageObject.contractNumbersList)
            {
                int count = 1;
                bool successfullMatch = false;

                while (count <= 15)
                {
                    Task.Delay(TimeSpan.FromSeconds(8)).Wait();

                    Console.WriteLine($"Attempting to assert contract status & sub status for contract {contractNumber}, attempt number : {count} ");
                    successfullMatch = _paymentManagementPageObject.AssertContractStatusAndSubStatus(contractNumber, contractState);
                    count++;

                    if (successfullMatch)
                        break;
                }

                ClassicAssert.IsTrue(successfullMatch, $"The sub status of contract {contractNumber} is not {contractState}");
            }
        }

        [Given(@"the latest version of contract '(.*)' is marked as the last approved version")]
        [Then(@"the latest version of contract '(.*)' is marked as the last approved version")]
        public void ThenTheContractIsMarkedAsTheLastApprovedVersion(string contractNum)
        {
            foreach (var contractNumber in _paymentManagementPageObject.contractNumbersList)
            {
                _paymentManagementPageObject.AssertContractIsLastApprovedVersion(contractNumber);
            }
        }

        [Then(@"the contract data is now removed from CRM")]
        public void ThenTheContractDataIsNowRemovedFromCrm()
        {
            _paymentManagementPageObject.TestTearDown();
            ClassicAssert.Pass(("Total Time" + _stopwatch.Elapsed));
        }

        [Given(@"there is no Organisation data in CRM for UKPRN '(.*)'")]
        [Given(@"there is no Organisation data for UKPRN '(.*)'")]
        public void GivenThereIsNoOrganisationDataForUkprn(int ukprn)
        {
            _paymentManagementPageObject.DeleteOrganisation(ukprn);
        }

        [Then(@"there is no Organisation data for '(.*)' UKPRN '(.*)'")]
        [Given(@"there is no Organisation data for '(.*)' UKPRN '(.*)'")]
        [Given(@"there is no Organisation data for '(.*)' consecutive UKPRNs commencing at '(.*)'")]
        public void GivenThereIsNoOrganisationDataForUkprn(int iterations, int ukprn)
        {
            for (int x = 1; x <= iterations; x++)
            {
                int orgukprn = ukprn + x;
                _paymentManagementPageObject.DeleteOrganisation(orgukprn);
            }
        }

        [Given(@"there is no Contract, Task or Workflow data for contract '(.*)' and master contract '(.*)'")]
        [Then(@"there is no Contract, Task or Workflow data for contract '(.*)' and master contract '(.*)'")]
        public void GivenThereIsNoContractTaskOrWorkflowDataForContractAndMasterContract(string contractNumber, string masterContractNumber)
        {
            _contractNumber = contractNumber;
            _paymentManagementPageObject.DeleteContracts(new[] { contractNumber, masterContractNumber });
            ApprovedContractRepository.ClearApprovedContractsForContractNumber(contractNumber);
            RemoveLocalDataStoreObjects(contractNumber);
        }

        [Given(@"there is no Contract, Task or Workflow data for contract '(.*)' and master contract '(.*)' for '(.*)' iterations")]
        public void GivenThereIsNoContractTaskOrWorkflowDataForContractAndMasterContractForIterations(string contractNumber, string masterContractNumber, int iterations)
        {
            for (int x = 1; x <= iterations; x++)
            {
                var splitContractNum = contractNumber.Split('-');
                var contractNumInt = int.Parse(splitContractNum[1]);
                var contractNum = $"{splitContractNum[0]}-{contractNumInt + x}";

                var splitMasterContractNum = masterContractNumber.Split('-');
                var masterContractNumInt = int.Parse(splitMasterContractNum[1]);
                var masterContractNum = $"{splitMasterContractNum[0]}-{masterContractNumInt + x}";

                GivenThereIsNoContractTaskOrWorkflowDataForContractAndMasterContract(contractNum, masterContractNum);
            }
        }

        [Then(@"the Profile Payments are calculated as follows")]
        public void ThenTheProfilePaymentsAreCalculatedAsFollows(TransformedTable profilePaymentsTable)
        {
            //_paymentManagementPageObject.CheckGWTPayments(_contractRepositoryPageObject, profilePaymentsTable, dp => dp.sfa_ProfilePaymentAmount);
            CheckCrmPaymentValues(profilePaymentsTable.Value, cdp => cdp.sfa_ProfilePaymentAmount, "The Profile Payment is not present -");
        }

        [Then(@"the Balancing Payments are calculated as follows")]
        public void ThenTheBalancingPaymentsAreCalculatedAsFollows(TransformedTable balancingPaymentsTable)
        {
            CheckCrmPaymentValues(balancingPaymentsTable.Value, cdp => cdp.sfa_BalancingPaymentAmount, "The Balancing Payment is not present -");
        }

        [Then(@"the Net Payments are calculated as follows")]
        public void ThenTheNetPaymentsAreCalculatedAsFollows(TransformedTable netPaymentsTable)
        {
            CheckCrmPaymentValues(netPaymentsTable.Value, cdp => cdp.sfa_NetPaymentAmount, "The Net Value is not present -");
        }

        [When(@"the Net Payments for a given version number are calculated as follows")]
        public void WhenTheNetPaymentsForAGivenVersionNumberAreCalculatedAsFollows(TransformedTable netPaymentsTable)
        {
            CheckCrmPaymentValuesForAGivenVersionNumber(netPaymentsTable.Value, cdp => cdp.sfa_NetPaymentAmount, "The Net Value is not present -");
        }

        [Then(@"the Reconciliation Data is calculated as follows")]
        public void ThenTheReconciliationDataIsCalculatedAsFollows(TransformedTable reconciliationTable)
        {
            CheckCrmPaymentValues(reconciliationTable.Value, cdp => cdp.sfa_ReconciliationPaymentAmount, "The Reconciliation Value is not present -");
        }

        [Then(@"the Actuals Value Data is as follows")]
        [Then(@"the Actuals Value Data is stored in CRM against the last approved version of the contract as follows")]
        public void ThenTheActualsValueDataIsStoredInCrmAgainstTheLastApprovedVersionOfTheContractAsFollows(TransformedTable actualsTable)
        {
            CheckCrmPaymentValues(actualsTable.Value, cdp => cdp.sfa_ActualValue, "The Actual Value is not present -");
            //_paymentManagementPageObject.CheckGWTPayments(_contractRepositoryPageObject, actualsTable, dp => dp.sfa_ActualValue);
        }

        [Then(@"the Actuals Volume Data is as follows")]
        [Then(@"the Actuals Volume Data is stored in CRM against the last approved version of the contract as follows")]
        public void ThenTheActualsVolumeDataIsStoredInCrmAgainstTheLastApprovedVersionOfTheContractAsFollows(Table actualsTable)
        {
            _paymentManagementPageObject.CheckGWTPayments(_contractRepositoryPageObject, actualsTable, dp => dp.sfa_ActualVolume);
        }

        [Then(@"the Profile Subnominal Amounts are calculated as follows")]
        public void ThenTheProfileSubnominalAmountsAreCalculatedAsFollows(TransformedTable subnominalsTable)
        {
            CheckSubnominalAggregationValues(subnominalsTable.Value, "Profile");
        }

        [Then(@"the Planned Values are calculated as follows")]
        public void ThenThePlannedValuesAreCalculatedAsFollows(TransformedTable table)
        {
            CheckCrmPaymentValues(table, dp => dp.sfa_PlannedValue.GetValueOrDefault(0), "Expected Planned Values not present in Crm for:") ;
        }

        [Then(@"the Planned Volumes are calculated as follows")]
        [Then(@"the planned volume data recorded in CRM against the latest version of the contract is as follows")]
        public void ThenThePlannedVolumeDataRecordedInCrmAgainstTheLatestVersionOfTheContractIsAsFollows(TransformedTable table)
        {
            table.Rows
                .SelectMany(ExtractDeliverablePeriodsFromTableRow)
                .GroupBy(dpvi => new { dpvi.AllocationNumber, dpvi.DeliverableCode })
                .ForEach(grouping =>
                         {
                             IReadOnlyCollection<PeriodVolume> delPeriods =
                                 CrmContractDeliverablePeriodRepository.GetLatestContractDeliverablePeriodVolumes(
                                     grouping.Key.AllocationNumber, grouping.Key.DeliverableCode.ToString());

                             grouping.ForEach(g =>
                                              {
                                                  DateTime period = new DateTime(g.Year, g.Month, 1);
                                                  string periodString = $"{period.ToString("MMM")}-{period.ToString("yy")}";
                                                  var matching =
                                                      delPeriods.SingleOrDefault(dp => dp.Period == periodString);
                                                  ClassicAssert.NotNull(matching, $"Deliverable Period: {g} not returned from CRM.");
                                                  ClassicAssert.AreEqual(g.PlannedVolume, matching.Volume, $"Planned volume incorrect for Deliverable Period: {g}.");
                                              });
                });
        }

        [Then(@"the Reconciliation Subnominal Amounts are calculated as follows")]
        public void ThenTheReconciliationSubnominalAmountsAreCalculatedAsFollows(TransformedTable subnominalsTable)
        {
            CheckSubnominalAggregationValues(subnominalsTable.Value, "Reconciliation");
        }

        [Given(@"the Reconciliation Subnominal Amounts in CRM are as follows")]
        [Then(@"the Reconciliation Subnominal Amounts in CRM are as follows")]
        public void ThenTheReconciliationSubnominalAmountsAreCalculatedAsFollowsInCrm(Table table)
        {
            IReadOnlyCollection<SubnominalInfo> subnominalInfos = table.Rows.Select(
                r =>
                    new SubnominalInfo(int.Parse(r["ReconciliationSubnominal"]), r["AllocationRef"],
                        "Reconciliation", r.GetPeriodValues())).ToList();

            subnominalInfos.ForEach(si =>
            {
                si.Values.ForEach(siv =>
                {
                    CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult:

                        () => siv.Value ==
                              CrmSubnominalAggregationRepository.GetAggregatedValue(allocationNumber: si.AllocationRef,
                                  code: si.Code, period: siv.Period, paymentType: si.PaymentType),
                   maxNumChecks: 30,
                   waitIntervalSeconds: 3);

                    bool isPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                    ClassicAssert.IsTrue(isPresent, $"This one is not present {si} - {siv}");
                });
            });
        }

        [Then(@"I receive Summarised Actuals from DCFS for period '(.*)' for collection type '(.*)' as follows")]
        public void ThenIReceiveSummarisedActualsFromDcfsForPeriodAsFollows(string collectionReturnCode, string collectionType, Table summarisedActuals)
        {
            _paymentManagementPageObject.CollectionReturnCode = collectionReturnCode;
            _paymentManagementPageObject.CollectionType = collectionType;

            _paymentManagementPageObject.SetupContractAllocationActualsType(summarisedActuals);

            _paymentManagementPageObject.PublishAllocationActuals();
        }

        [Then(@"the Capping Amounts are calculated as follows")]
        public void ThenTheCappingAmountsAreCalculatedAsFollows(TransformedTable cappingAmountsTable)
        {
            CheckCrmPaymentValues(cappingAmountsTable.Value, cdp => cdp.sfa_CappedPaymentAmount,
                "The Capping Payment Value is not present -");
        }

        [Then(@"the Capping Subnominal Amounts are calculated as follows")]
        public void ThenTheCappingSubnominalAmountsAreCalculatedAsFollows(TransformedTable cappingSubnominalTable)
        {
            IReadOnlyCollection<SubnominalInfo> subnominalInfos = cappingSubnominalTable.Rows.Select(
                r =>
                    new SubnominalInfo(int.Parse(r["CappingSubnominal"]), r["AllocationRef"],
                        "Capping", r.GetPeriodValues())).ToList();

            subnominalInfos.ForEach(si =>
            {
                si.Values.ForEach(siv =>
                {
                    CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult:

                        () => siv.Value.GetValueOrDefault(0) ==
                              CrmSubnominalAggregationRepository.GetAggregatedValue(allocationNumber: si.AllocationRef,
                                  code: si.Code, period: siv.Period, paymentType: si.PaymentType).GetValueOrDefault(0),
                        maxNumChecks: 30,
                        waitIntervalSeconds: 3);

                    bool isPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                    ClassicAssert.IsTrue(isPresent, $"This one is not present {si} - {siv}");
                });
            });
        }

        [When(@"the latest version of contract '(.*)' is '(.*)'")]
        public void WhenTheLatestVersionOfContractIs(string p0, string p1)
        {
            _paymentManagementPageObject.ChangeContractStateThroughAGivenTransition(p0, p1);
        }

        [Then(@"the latest workflow history service response on contract '(.*)' is '(.*)'")]
        public void ThenTheServiceResponseOfContractIs(string contractNumber, string serviceResponseString)
        {
            sfa_serviceresponse expectedServiceResponse;
            sfa_serviceresponse? serviceresponseOfContract = null;
            string trimmedServiceResponseString = serviceResponseString.Replace(" ", String.Empty);
            if (Enum.TryParse(trimmedServiceResponseString, true, out expectedServiceResponse))
            {
                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    serviceresponseOfContract = _paymentManagementPageObject.GetServiceResponseOfContract(contractNumber);
                    return serviceresponseOfContract == expectedServiceResponse;
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 3);

                ClassicAssert.IsTrue(poller.CheckResultAndWaitTillCompleteOrOutOfTime(), $"The contract {contractNumber} does not have the expected service response {serviceResponseString} it actually has {serviceresponseOfContract}");
            }
            else
            {
                ClassicAssert.Fail($"This service response is not supported {serviceResponseString}");
            }
        }

        [Then(@"an excel spreadsheet exists and has cell '(.*)' with a UKPRN '(.*)' and a file Name '(.*)'")]
        public void GivenAnExcelSpreadsheetExistsAndHasCellWithAUkprnAndAFileName(string p0, string p1, string p2)
        {
            _contractLoadStep.InputFilePath = Path.Combine(SourceFolder, p2);
            ClassicAssert.IsTrue(File.Exists(_contractLoadStep.InputFilePath), "Input file does not exist");

            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, "Contract", p0);
           ClassicAssert.That(excelValue, Is.EqualTo(p1));

            _contractLoadStep.Ukprns.Add(p1);
        }

        [Then(@"the file for syntax validation is copied from the source location to the '(.*)'")]
        public void WhenTheFileForSyntaxValidationIsCopiedFromTheSourceLocationToThe(string p0)
        {
            _contractLoadStep.InitializeUkprnList(_contractLoadStep.Ukprns);
            _contractLoadStep.CopyFile();
        }

        [When(@"the next action performed on the latest version of contract '(.*)' is '(.*)' with reason '(.*)' by '(.*)'")]
        public void WhenTheNextActionPerformedOnTheLatestVersionOfContractIsWithReasonBy(TransformedString contractNumber, string action, string reason, string userDisplayName)
        {
            _paymentManagementPageObject.ChangeContractState(contractNumber, action, reason, userDisplayName);
        }

        [Then(@"the latest version of contract '(.*)' is '(.*)'")]
        public void ThenTheLatestVersionOfContractIs(string contractNumber, string status)
        {
            _paymentManagementPageObject.AssertContractSubStatus(contractNumber, status);
        }

        [Then(@"the latest version of contract '(.*)' has a substatus of '(.*)'")]
        [Then(@"the latest version of contract '(.*)' is showing as '(.*)'")]
        [Then(@"the latest version of contract '(.*)' is in status '(.*)'")]
        public void ThenTheLatestVersionOfContractIsInStatus(TransformedString contractNumber, string status)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () => _paymentManagementPageObject.AssertContractSubStatus(contractNumber.Value, status),
                maxNumChecks: 40,
                waitIntervalSeconds: 3);

            ClassicAssert.True(checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime(), $"Contract {contractNumber} is not at status: {status}");
        }

        [When(@"the latest version of '(.*)' contract '(.*)' is '(.*)'")]
        public void WhenTheLatestVersionOfContractIs(int iterations, string p1, string p2)
        {
            for (int x = 1; x <= iterations; x++)
            {
                _paymentManagementPageObject.ChangeContractStateThroughAGivenTransition(p1 + x, p2);
            }
        }

        [Given(@"the contract status is set to '(.*)'")]
        [When(@"the contract status is set to '(.*)'")]
        [Then(@"the contract status is now set to '(.*)'")]
        public void GivenTheContractStatusIsSetTo(string p0)
        {
            foreach (var contractNumber in _paymentManagementPageObject.contractNumbersList)
            {
                _paymentManagementPageObject.AssertContractStatus(contractNumber, p0);
            }
        }

        [Given(@"the contract sub-status is set to '(.*)'")]
        [When(@"the contract sub-status is set to '(.*)'")]
        public void GivenTheContractSub_StatusIsSetTo(string p0)
        {
            //Task.Delay(5000).Wait();
            foreach (var contractNumber in _paymentManagementPageObject.contractNumbersList)
            {
                bool successfullMatch = _paymentManagementPageObject.AssertContractSubStatus(contractNumber, p0);
                ClassicAssert.IsTrue(successfullMatch, $"Sub status of contract {contractNumber} does not match {p0}");
            }
        }

        [Then(@"the contract sub-status is now set to '(.*)'")]
        public void ThenTheContractSub_StatusIsNowSetTo(string p0)
        {
            foreach (var contractNumber in _paymentManagementPageObject.contractNumbersList)
            {
                int count = 1;
                bool successfullMatch = false;

                while (count <= 10)
                {
                    Task.Delay(TimeSpan.FromSeconds(8)).Wait();

                    Console.WriteLine($"Attempting to assert contract sub status for contract {contractNumber}, attempt number : {count} ");
                    successfullMatch = _paymentManagementPageObject.AssertContractSubStatus(contractNumber, p0);
                    count++;

                    if (successfullMatch)
                        break;
                }

                ClassicAssert.IsTrue(successfullMatch, $"Sub status of contract {contractNumber} does not match {p0}");
            }
        }

        [Given(@"the contract is set with documentation required")]
        public void GivenTheContractIsSetWithDocumentationRequired()
        {
            foreach (var contractNumber in _paymentManagementPageObject.contractNumbersList)
            {
                _paymentManagementPageObject.AssertContractAsDocumentRequiredAsTrue(contractNumber);
            }
        }

        [Then(@"a new Task record for contract '(.*)' is created as follows")]
        public void ThenANewTaskRecordForContractIsCreatedAsFollows(string contractNumber, Table table)
        {
            var contractEntity = XrmService.Configuration.Entity("Contract");
            var contractRecord = XrmService.Connection
                      .GetRecord(contractEntity, _contractNumber);
            var task = XrmService.Configuration.Entity("task");

            var s = contractRecord.GetRelatedRecords(task, "Regarding");

            XrmWebEntity newtask = s[0];

            try
            {
                ReturnTheFollowingFields(newtask, table);
            }
            catch (Exception e)
            {
                Debug.Print(string.Empty + e);
            }
        }

        [Given(@"there is no '(.*)' notification for '(.*)'")]
        public void GivenThereIsNoNotificationFor(string notificationType, string messageTextKey)
        {
            _paymentManagementPageObject.DeleteNotifications(notificationType, messageTextKey);
        }

        [Then(@"a notification has not been created with '(.*)' in the Notification Name and with a Notification Type of '(.*)'")]
        [Then(@"a new notification for '(.*)' is not sent with Notification Type '(.*)'")]
        public void ThenANewNotificationForIsNotSentWithNotificationType(TransformedString notificationName, string notificationType)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            
            int notificationTypeId = GetOptionsSetValueForLabel(organizationService, "sfa_notification", "sfa_notificationtype", notificationType);
            using (var context = new SFAEntities.XrmServiceContext(organizationService))
            {
                var notification = (from n in context.sfa_notificationSet
                                    where n.sfa_Name.Contains(notificationName.Value)
                                          && n.sfa_NotificationType.Value == notificationTypeId
                                    orderby n.CreatedOn descending
                                    select n).FirstOrDefault();

                ClassicAssert.IsNull(notification, $"Unexpected notification found for {notificationName}");
            }
        }

        [Given(@"there is no Contract, Task or Workflow data for UKPRN '(.*)'")]
        public void GivenThereIsNoContractTaskOrWorkflowDataForUkprn(string ukprn)
        {
            var contracts = _paymentManagementPageObject.GetContractsByUkprnNoRetry(ukprn);

            _paymentManagementPageObject.DeleteContracts(contracts);

            CreatedContractRepository.RemoveRange(contracts.Select(c => c.GetAttributeValue<string>("sfa_number")).ToArray());

            _contractNumber = (_paymentManagementPageObject.contractNumbersList.Count > 0)
                ? _paymentManagementPageObject.contractNumbersList[0]
                : string.Empty;
            AllocationDeliverablePeriodActualAuditRepository.DeleteAllocationDeliverablePeriodActualAudits(int.Parse(ukprn));
            RemoveLocalDataStoreObjects(_contractNumber);
            ApprovedContractRepository.ClearApprovedContractsForUkprn(int.Parse(ukprn));

            _paymentManagementPageObject.RemoveAllocationDeliverablePeriods(ukprn);
            _paymentManagementPageObject.contractNumbersList.Clear();
            _paymentManagementPageObject.mastercontractNumbersList.Clear();
        }

        [Given(@"the Allocation Delivery Monitoring Service atom feed is empty")]
        public void GivenTheAllocationDeliveryMonitoringServiceAtomFeedIsEmpty()
        {
            using (var context = new AllocationDeliveryDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "AllocationDeliveryEntry", Schema = "AllocationDelivery", ReqType = "Delete" });
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "AllocationDeliveryEntryData", Schema = "AllocationDelivery", ReqType = "Delete" });
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "AllocationDeliveryEventReceived", Schema = "AllocationDeliveryMonitoring", ReqType = "Truncate" });
            }
        }

        [Then(@"the Actuals Data is stored in CRM at deliverable level against the last approved version of the contract as follows")]
        public void ThenTheActualsDataIsStoredInCrmAgainstTheLastApprovedVersionOfTheContractAtDeliverableLevel(TransformedTable table)
        {
            List<SimpleDeliverable> expectedDeliverables = table.Rows.Select(r => new SimpleDeliverable(
                allocationNumber: r["AllocationRef"],
                deliverableCode: int.Parse(r["DeliverableCode"]),
                actualValue: r.ParseNullableDecimal("ActualValue"),
                actualVolume: r.ParseNullableInt("ActualVolume"))).ToList();

            expectedDeliverables.ForEach(expectedDeliverable =>
            {
                Infrastructure.DTO.SimpleDeliverable crmDeliverable = null;

                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    crmDeliverable = CrmContractDeliverableRepository.GetSimpleLatestDeliverable(expectedDeliverable.AllocationNumber, expectedDeliverable.DeliverableCode);
                    return crmDeliverable != null && crmDeliverable.ActualValue == expectedDeliverable.ActualValue && crmDeliverable.ActualVolume == expectedDeliverable.ActualVolume;
                }, maxNumChecks: 10, waitIntervalSeconds: 2);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsNotNull(crmDeliverable, $"No matching deliverable found for - {expectedDeliverable}");
                ClassicAssert.AreEqual(expectedDeliverable.ActualValue, crmDeliverable.ActualValue, $"The actual value differs from expected - {expectedDeliverable}");
                ClassicAssert.AreEqual(expectedDeliverable.ActualVolume, crmDeliverable.ActualVolume, $"The actual volume differs from expected - {expectedDeliverable}");
            });
        }

        [Then(@"there is '(.*)' deliverable period on the PaymentSchedule\.DeliverablePayment table for version '(.*)' of AllocationNumber '(.*)' for DeliverableCode '(.*)'")]
        [Then(@"there are '(.*)' deliverable periods on the PaymentSchedule\.DeliverablePayment table for version '(.*)' of AllocationNumber '(.*)' for DeliverableCode '(.*)'")]
        public void ThenThereAreDeliverablePeriodsOnThePaymentSchedule_DeliverablePaymentTableForVersionOfAllocationNumberForDeliverableCode(
            int expectedRowCount, int versionNumber, TransformedString allocationNumber, int deliverableCode)
        {
            int? actualRowCount = null;

            CheckResultPoller poller = new CheckResultPoller(
                checkResult: () =>
                {
                    actualRowCount = DeliverablePaymentRepository.GetRowCount(allocationNumber.Value, versionNumber, deliverableCode);
                    return expectedRowCount == actualRowCount;
                },
                maxNumChecks: 10, waitIntervalSeconds: 2);

            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.AreEqual(expectedRowCount, actualRowCount, $"Unexpected number of rows found in PaymentSchedule.DeliverablePayment for Alloc:{allocationNumber.Value}");
        }

        [Given(@"there are no master contracts in CRM for master contract number '(.*)'")]
        public void GivenThereAreNoContractsWithThisNumber(string masterContractNumber)
        {
            var contractInfos = CrmContractRepository.GetContractIdsRelatingToMaster(masterContractNumber);

            contractInfos.ForEach(c => CrmContractRepository.DeleteContract(c.CrmId));
            contractInfos.ForEach(c => CrmReplicatedRepository.DeleteContract(c.CrmId));
            contractInfos.Select(c => c.CrmMasterId).Distinct().ToList()
                .ForEach(CrmContractRepository.DeleteContract);

            if (!contractInfos.Any())
            {
                CrmContractRepository.GetContractsForNumber(masterContractNumber)
                    .ForEach(CrmContractRepository.DeleteContract);
            }
        }

        [Given(@"there are no entries in the DeliverablePayment table in PaaS for the following contract allocations")]
        public void GivenThereIsNoEntriesInTheDeliverablePaymentTableForTheFollowingContractAllocations(TransformedTable contractAllocations)
        {
            var allocationRefs = contractAllocations.Rows.Select(r => r["AllocationRef"]).ToList();

            DeliverablePaymentRepository.DeleteDeliverablePaymentsForAllocations(allocationRefs);
        }

        private void CheckSubnominalAggregationValues(Table subnominalsTable, string subnominalType)
        {
            var periodsToTest = subnominalsTable.Rows.First().GetPeriodValues().Select(pv => pv.Period).ToList();

            foreach (TableRow row in subnominalsTable.Rows)
            {
                int periodsWithValues = row.GetPeriodValues().Count(pv => pv.Value.HasValue);
                var subnominalAggregations = new List<SubnominalAggregation>();
                CheckValuesResult result = null;

                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    subnominalAggregations = _paymentManagementPageObject.GetSubnominalAggregationsForSubnominalCodeAndAllocationNumber(row["AllocationRef"], row[$"{subnominalType}Subnominal"], subnominalType);

                    // trim off the periods that we are not interested in
                    subnominalAggregations =
                        subnominalAggregations.Where(sa => periodsToTest.Contains(sa.Period)).ToList();

                    result = CheckValuesInCrm(row, subnominalAggregations, subnominalType);
                    return subnominalAggregations.Count >= periodsWithValues && result.AreAllValuesPresent;
                },
                maxNumChecks: 40,
                waitIntervalSeconds: 3);

                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(subnominalAggregations.Count >= periodsWithValues, $"Test expected {periodsWithValues} subnominal aggregations in CRM but instead found {subnominalAggregations.Count}");
                var remainingSubNoms = subnominalAggregations.Where(sa => !periodsToTest.Contains(sa.Period));

                var areRemainSubNomsEmptyOrAllZero = remainingSubNoms.Empty() || remainingSubNoms.All(sa => sa.AggregatedValue == 0);
                ClassicAssert.IsTrue(areRemainSubNomsEmptyOrAllZero, "The are other subnominal aggregations that are non zero");

                if (!result.AreAllValuesPresent)
                {
                    ClassicAssert.Fail(result.ErrorMsg);
                }
            }
        }

        private string GetAllocationNumber(string rowValue)
        {
            string allocationNumber = rowValue;

            if (allocationNumber == "[AllocRef]") // for legacy tests
            {
                allocationNumber = _paymentManagementPageObject.ContractToTest.contracts.First().contractAllocations.First().contractAllocationNumber;
            }
            else if (allocationNumber.StartsWith("[AllocRef_"))
            {
                allocationNumber =
                    _contractRepositoryPageObject.GetLatestContractDataItem(
                        allocationNumber.Replace("[", "").Replace("]", ""));
            }

            Debug.Print($"GetAllocationNumber:Allocation Number is {allocationNumber}");
            return allocationNumber;
        }

        private static IList<CheckEsfTotalPlannedVolumeStepsPageObject.DeliverablePeriodValidateInfo> ExtractDeliverablePeriodsFromTableRow(TableRow row)
        {
            int[] years = { 2016, 2017 };
            int[] months = Enumerable.Range(1, 12).ToArray();

            var deliverablePeriods = new List<CheckEsfTotalPlannedVolumeStepsPageObject.DeliverablePeriodValidateInfo>();

            foreach (int year in years)
            {
                foreach (int month in months)
                {
                    DateTime period = new DateTime(year, month, 1);
                    string columnHeading = $"{period.ToString("MMM")}-{period.ToString("yy")}";
                    if (row.ContainsKey(columnHeading))
                    {
                        deliverablePeriods.Add(new CheckEsfTotalPlannedVolumeStepsPageObject.DeliverablePeriodValidateInfo
                        {
                            ContractNumber = row["ContractNumber"],
                            AllocationNumber = row["AllocationRef"],
                            DeliverableCode = int.Parse(row["DeliverableCode"]),
                            Year = year,
                            Month = month,
                            PlannedVolume = GetNullableDecimalValueFromCell(row[columnHeading]),
                            TotalPlannedVolume = GetNullableDecimalValueFromCell(row["Total"])
                        });
                    }
                }
            }

            return deliverablePeriods;
        }

        private static decimal? GetNullableDecimalValueFromCell(string cellValue)
        {
            decimal d;

            if (cellValue.Contains("?") || !decimal.TryParse(cellValue, out d))
            {
                return null;
            }

            return d;
        }

        private static CheckValuesResult CheckValuesInCrm(TableRow row, List<SubnominalAggregation> subnominalAggregations, string subnominalType)
        {
            string error = string.Empty;

            foreach (PeriodValue periodValue in row.GetPeriodValues().Where(pv => pv.Value.HasValue))
            {
                SubnominalAggregation matchingSubnominalAggregation = subnominalAggregations.SingleOrDefault(sa => sa.Period == periodValue.Period);

                if (matchingSubnominalAggregation == null)
                {
                    error = $"No matching subnominal aggregation found for subnominal code  {row[$"{subnominalType}Subnominal"]}, period: {periodValue.Period}";
                }
                else if (periodValue.Value != matchingSubnominalAggregation.AggregatedValue)
                {
                    error = $"Test expected {periodValue.Value} for subnominal {row[$"{subnominalType}Subnominal"]} and period: {periodValue.Period} but instead found {matchingSubnominalAggregation.AggregatedValue}";
                }

                if (error != string.Empty)
                {
                    break;
                }
            }

            return new CheckValuesResult(error == string.Empty, error);
        }

        private void RemoveLocalDataStoreObjects(string contractNumber)
        {
            _paymentManagementPageObject.RemoveContractFromPaymentScheduleTables(contractNumber);

            _paymentManagementPageObject.RemoveContractFromMonitoringDeliverablesTables(contractNumber);

            _paymentManagementPageObject.RemoveContractFromContractManagementAtomFeedTable(contractNumber);
        }

        private static int GetOptionsSetValueForLabel(IOrganizationService service, string entityName, string attributeName, string selectedLabel)
        {

            RetrieveAttributeRequest retrieveAttributeRequest = new
            RetrieveAttributeRequest
            {
                EntityLogicalName = entityName,
                LogicalName = attributeName,
                RetrieveAsIfPublished = true
            };
            // Execute the request.
            RetrieveAttributeResponse retrieveAttributeResponse = (RetrieveAttributeResponse)service.Execute(retrieveAttributeRequest);
            // Access the retrieved attribute.
            PicklistAttributeMetadata retrievedPicklistAttributeMetadata = (PicklistAttributeMetadata)
            retrieveAttributeResponse.AttributeMetadata;// Get the current options list for the retrieved attribute.
            OptionMetadata[] optionList = retrievedPicklistAttributeMetadata.OptionSet.Options.ToArray();

            try
            {
                int selectedOptionValue =
                    optionList
                        .Where(o => o.Label.LocalizedLabels[0].Label.ToLower() == selectedLabel.ToLower())
                        .First()
                        .Value.Value;

                return selectedOptionValue;
            }
            catch
            {
                throw new Exception($"Unable to find value for text {selectedLabel} in option set {attributeName}");
            }
        }

        private static void ReturnTheFollowingFields(XrmWebEntity entity, Table table)
        {
            var systemUser = XrmService.Configuration.Entity("User");
            var contract = XrmService.Configuration.Entity("Contract");
            var team = XrmService.Configuration.Entity("Team");
            var action = XrmService.Configuration.Entity("Transition");
            var status = XrmService.Configuration.Entity("Status");

            foreach (var row in table.Rows)
            {
                foreach (var dataFieldName in row.Keys)
                {
                    var name = dataFieldName;
                    var value = row[dataFieldName];

                    if (value == null || value == " " || value == string.Empty)
                    {
                        continue;
                    }

                    switch (name)
                    {
                        case "Owner":
                            entity.OwnerEquals(value);
                            break;
                        case "Assigned Team":
                            entity.LookupFieldValueEquals(team, "sfa_assignedteam", value);
                            break;
                        case "Regarding":
                            // do nothing
                            break;
                        case "Contract":
                            entity.LookupFieldValueEquals(contract, name, value);
                            break;
                        case "Transition":
                            entity.LookupFieldValueEquals(action, name, value);
                            break;
                        case "New Sub Status":
                        case "Previous Sub Status":
                            entity.LookupFieldValueEquals(status, name, value);
                            break;
                        case "Completed By":
                            entity.LookupFieldValueEquals(systemUser, name, value);
                            break;
                        case "New Task Owner":
                            entity.FieldValue(XrmFieldValueComparison.Equals, "sfa_newowner", value);
                            break;
                        case "Description":
                            entity.FieldValue(XrmFieldValueComparison.BeginsWith, name, value);
                            break;
                        default:
                            var s = entity.FieldValue(XrmFieldValueComparison.Equals, name, value);
                            break;
                    }
                }
            }
        }

        private static DateTime ParseGwtDateAsUtc(string date)
        {
            return DateTime.SpecifyKind(DateTime.ParseExact(date, "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc);
        }

        private static string DetermineNewFileName(string origFileName, string ukprn, string contractNumber)
        {
            string newFileName = origFileName;

            int startIndexHyphen = newFileName.IndexOf("-", StringComparison.Ordinal);
            int startIndexSecondUnderscore = newFileName.IndexOf("_", startIndexHyphen, StringComparison.Ordinal);

            newFileName = ukprn + "_" + contractNumber +
                          origFileName.Substring(startIndexSecondUnderscore,
                              origFileName.Length - startIndexSecondUnderscore);


            return newFileName;
        }

        private static string GetCellValue(TableRow row, string header)
        {
            string cellValue;
            row.TryGetValue(header, out cellValue);
            return cellValue;
        }

        private static void CheckCrmPaymentValues(Table table, Func<SFAEntities.sfa_contractdeliverableperiod, decimal?> getValue, string missingMessagePrefix, int secondsToWait = 120)
        {
            const int waitIntervalSeconds = 3;
            IReadOnlyCollection<ContractDeliverable> contractDeliverables = table.Rows.Select(
              r =>
                  new ContractDeliverable(r["DeliverableCode"], r["AllocationRef"],
                      r["ContractNumber"], r.GetPeriodValues())).ToList();

            contractDeliverables.ForEach(cd =>
            {
                IReadOnlyCollection<PeriodValue> cdps = null;
                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    cdps = FunctionRetrier.RetryWhenExceptionThrown(() => CrmContractDeliverablePeriodRepository.GetLatestContractDeliverablePeriodValues(cd.AllocationRef, cd.Code, getValue));

                    return cd.Values.All(v => cdps.Contains(v));
                },
                maxNumChecks: secondsToWait/ waitIntervalSeconds,
                waitIntervalSeconds: waitIntervalSeconds);

                bool isPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                PeriodValue missingPeriodValue = cd.Values.FirstOrDefault(v => !cdps.Contains(v));
                ClassicAssert.IsTrue(isPresent, $"{missingMessagePrefix} {cd}, {missingPeriodValue}");
            });
        }

        private static void CheckCrmPaymentValuesForAGivenVersionNumber(Table table, Func<SFAEntities.sfa_contractdeliverableperiod, decimal?> getValue, string missingMessagePrefix, int secondsToWait = 90)
        {
            const int waitIntervalSeconds = 6;
            var contractDeliverables = table.Rows.Select(
                r => new { Code = r["DeliverableCode"], AllocationRef = r["AllocationRef"], ContractNubmer = r["ContractNumber"],
                    VersionNumber = r.ParseNullableInt("VersionNumber").Value,
                    Values = r.GetPeriodValues() }).ToList();
 
            contractDeliverables.ForEach(cd =>
            {
                IReadOnlyCollection<PeriodValue> cdps = null;
                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                    {
                        cdps = FunctionRetrier.RetryWhenExceptionThrown(() => 
                            CrmContractDeliverablePeriodRepository.GetContractDeliverablePeriodValuesForAGivenVersionNumber(
                                cd.AllocationRef, cd.Code, cd.VersionNumber, getValue));

                        return cd.Values.All(v => cdps.Contains(v));
                    },
                    maxNumChecks: secondsToWait / waitIntervalSeconds,
                    waitIntervalSeconds: waitIntervalSeconds);

                bool isPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                PeriodValue missingPeriodValue = cd.Values.FirstOrDefault(v => !cdps.Contains(v));
                ClassicAssert.IsTrue(isPresent, $"{missingMessagePrefix} {cd}, {missingPeriodValue}");
            });
        }

        private class SubnominalKeyInfo
        {
            public SubnominalKeyInfo(string allocationNumber, string period, int subnominalCode, string paymentType)
            {
                AllocationNumber = allocationNumber;
                Period = period;
                SubnominalCode = subnominalCode;
                PaymentType = paymentType;
            }

            public string AllocationNumber { get; }
            public string Period { get; }
            public int SubnominalCode { get; }
            public string PaymentType { get; }

            public override string ToString()
            {
                return
                    $"AllocationNumber: {AllocationNumber}, Period: {Period}, SubnominalCode: {SubnominalCode}, PaymentType: {PaymentType}";
            }
        }

        private class SimpleDeliverable
        {
            public SimpleDeliverable(string allocationNumber, int deliverableCode, decimal? actualValue, int? actualVolume)
            {
                AllocationNumber = allocationNumber;
                DeliverableCode = deliverableCode;
                ActualValue = actualValue;
                ActualVolume = actualVolume;
            }

            public string AllocationNumber { get; }

            public int DeliverableCode { get; }

            public decimal? ActualValue { get; }

            public int? ActualVolume { get; }

            public override string ToString()
            {
                return
                    $"AllocationNumber: {AllocationNumber}, DeliverableCode: {DeliverableCode}, ActualValue: {ActualValue}, ActualVolume: {ActualVolume}";
            }
        }

        private class CheckValuesResult
        {
            public CheckValuesResult(bool areAllValuesPresent, string errorMsg)
            {
                AreAllValuesPresent = areAllValuesPresent;
                ErrorMsg = errorMsg;
            }

            public bool AreAllValuesPresent { get; }
            public string ErrorMsg { get; }
        }

        private class ContractDeliverable
        {
            public ContractDeliverable(string code, string allocationRef, string contractNumber, IEnumerable<PeriodValue> values)
            {
                Code = code;
                AllocationRef = allocationRef;
                Values = values;
                ContractNumber = contractNumber;
            }

            public string Code { get; }

            public string AllocationRef { get; }

            public string ContractNumber { get; }

            public IEnumerable<PeriodValue> Values { get; }

            public override string ToString()
            {
                return $"ContractDeliverable - ContractNumber: {ContractNumber}, AllocationRef: {AllocationRef}, Code: {Code}";
            }
        }

        private class SubnominalInfo
        {
            public SubnominalInfo(int code, string allocationRef, string subnominalPaymentType, IEnumerable<PeriodValue> values)
            {
                Code = code;
                AllocationRef = allocationRef;
                Values = values;
                PaymentType = subnominalPaymentType;
            }

            public int Code { get; }

            public string AllocationRef { get; }

            public string PaymentType { get; }

            public IEnumerable<PeriodValue> Values { get; }

            public override string ToString()
            {
                return $"Subnominal - PaymentType: {PaymentType}, AllocationRef: {AllocationRef}, Code: {Code}";
            }
        }
    }
}
