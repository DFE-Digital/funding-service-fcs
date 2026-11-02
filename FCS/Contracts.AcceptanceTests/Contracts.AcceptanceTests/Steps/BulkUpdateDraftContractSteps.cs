namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using NUnit.Framework;
    using Pages;
    using TechTalk.SpecFlow;
    using Utilities;
    using Xrm.TestFramework;
    using corpContractType = CrossDomain.Integration.Entities.CorporateContract;

    [Binding]
    public class BulkUpdateDraftContractSteps
    {
        private readonly List<sfa_contract> _allContracts = new List<sfa_contract>();
        private readonly List<XrmWebEntity> _newContracts = new List<XrmWebEntity>();
        private readonly List<SimpleOrg> _orgs = new List<SimpleOrg>();
        private readonly List<XrmWebEntity> _previousAllocations = new List<XrmWebEntity>();
        private readonly List<XrmWebEntity> _newAllocations = new List<XrmWebEntity>();
        private readonly List<XrmWebEntity> _newDeliverables = new List<XrmWebEntity>();
        private readonly IList<object> _ukprnList = new List<object>();
        private readonly IList<string> _inputFileList = new List<string>();
        private readonly ContractLoadPage _contractLoadPage;
        private string _sourceFolder;
        private string _inputFile;
        private XrmPackageEntity _statusEntity;
        private XrmPackageEntity _orgEntity;
        private XrmPackageEntity _contractEntity;
        private XrmPackageEntity _allocationEntity;
        private XrmPackageEntity _deliverableEntity;
        private XrmPackageEntity _deliverablePeriodEntity;
        private XrmPackageEntity _workflowHistoryEntity;
        private XrmPackageEntity _systemUserEntity;
        private XrmPackageEntity _caseloadEntity;
        private XrmPackageEntity _periodTypeEntity;
        private EntityReference _activeStatus;
        private EntityReference _unassignedTeam;
        private EntityReference _inactiveStatus;
        private EntityReference _zoeFoster;
        private readonly PaymentManagementPageObject _paymentManagementPageObject;

        public BulkUpdateDraftContractSteps(ContractLoadPage contractLoadPage, PaymentManagementPageObject paymentManagementPageObject)
        {
            _contractLoadPage = contractLoadPage;
            _paymentManagementPageObject = paymentManagementPageObject;
        }

        [BeforeScenario("BulkUpdateDraftContracts")]
        public void SetupServicesAndData()
        {
            SetupServicesForBulkContracts();

            // Create Organisation and add it to list
            CreateOrgAndCaseLoad("10040000", "NACRO", _activeStatus, _activeStatus, _zoeFoster);

            CreateOrgAndCaseLoad("10040001", "NACRO Unassigned", _activeStatus, _activeStatus, _unassignedTeam);

            CreateOrgAndCaseLoad("10009987", "NACRO INACTIVE", _activeStatus, _inactiveStatus, _zoeFoster);
        }

        [BeforeScenario("UpdateDraftContractAmendmentsInBulk")]
        public void SetupUpdateDraftContractAmendmentsInBulk()
        {
            SetupServicesForBulkContracts();

            // Create Organisation and add it to list
            CreateOrgAndCaseLoad("10060000", "NACRO", _activeStatus, _activeStatus, _zoeFoster);

            CreateOrgAndCaseLoad("10060001", "NACRO Unassigned", _activeStatus, _activeStatus, _unassignedTeam);

            CreateOrgAndCaseLoad("10060003", "NACRO Unassigned", _activeStatus, _activeStatus, _unassignedTeam);
        }

        [AfterScenario("NewAmendment", "BulkUpdateDraftContracts", "UpdateDraftContractAmendmentsInBulk", "InitiateBulkAmendmentCreation")]
        private void TestTeardown()
        {
            // first delete the ones created by the spreadsheet
            _contractLoadPage.DeleteContracts();

            // Reverse contracts so master is the last to be deleted - this has a Referential, Restrict Delete relationship
            _allContracts.Where(c => c.sfa_HierarchyTypeEnum == sfa_contracthierarchytype.Contract)
                .ForEach(
                    c =>
                    {
                        try
                        {
                            CrmConnectionFactory.GetConnection().Delete(sfa_contract.EntityLogicalName, c.Id);
                        }
                        catch (Exception)
                        {
                        }
                    });

            _allContracts.Where(c => c.sfa_HierarchyTypeEnum == sfa_contracthierarchytype.Master)
                .ForEach(
                    c =>
                    {
                        try
                        {
                            CrmConnectionFactory.GetConnection().Delete(sfa_contract.EntityLogicalName, c.Id);
                        }
                        catch (Exception)
                        {
                            // Dont error
                        }
                    });

            // Delete Orgs
            _orgs.Where(o => !_ukprnList.Contains(o.Ukprn))
                .Distinct()
                .ForEach(o =>
                {
                    try
                    {
                        CrmConnectionFactory.GetConnection().Delete(Account.EntityLogicalName, o.Id);
                    }
                    catch (Exception)
                    {
                        // Dont error
                    }
                });

            foreach (var u in _ukprnList.Distinct())
            {
                try
                {
                    XrmService.Connection.GetRecord(_orgEntity, u.ToString(), "sfa_ukprn").Delete();
                }
                catch (Exception)
                {
                    // Dont throw
                }
            }
        }

        [Given(@"The file '(.*)' file exists at '(.*)' with a UKPRN '(.*)'")]
        public void GivenTheFileFileExistsAtWithAUKPRN(string p0, string p1, int p2)
        {
            _sourceFolder = p1;
            _inputFile = p0;

            _contractLoadPage.InputFilePath = Path.Combine(_sourceFolder, _inputFile);
            Assert.IsTrue(File.Exists(_contractLoadPage.InputFilePath), "Input file does not exist");

            _inputFileList.Add(Path.Combine(_sourceFolder, _inputFile));
            _ukprnList.Add(p2.ToString());
        }

        [Given(@"[T|t]he file '(.*)' exists at '(.*)' with the following UKPRNs")]
        public void GivenTheFileExistsAtWithTheFollowingUKPRNs(string p0, string p1, Table table)
        {
            _sourceFolder = p1;
            _inputFile = p0;

            _contractLoadPage.InputFilePath = Path.Combine(_sourceFolder, _inputFile);
            Assert.IsTrue(File.Exists(_contractLoadPage.InputFilePath), "Input file does not exist");

            _inputFileList.Add(Path.Combine(_sourceFolder, _inputFile));

            foreach (var row in table.Rows)
            {
                _ukprnList.Add(row["UKPRN"]);
            }
        }

        [Given(@"CRM has an '(.*)' organisation for each UKPRN")]
        public void GivenCRMHasAnOrganisationForEachUKPRN(string p0)
        {
            foreach (var ukprn in _ukprnList)
            {
                CreateOrgAndCaseLoad(ukprn.ToString(), "NACRO " + ukprn, _activeStatus, _activeStatus, _unassignedTeam);
            }
        }

        [Given(@"the following data exists in the CRM Contract table")]
        public void GivenTheFollowingDataExistsInTheCRMContractTable(Table contractHeader)
        {
            // Check for new version
            if (_paymentManagementPageObject.ContractToTest != null && _paymentManagementPageObject.ContractToTest.contracts.Count > 0 &&
                (_paymentManagementPageObject.ContractToTest.contracts[0].contractVersionNumber != int.Parse(contractHeader.Rows[0]["Version"]) ||
                _paymentManagementPageObject.ContractToTest.contracts[0].contractNumber != contractHeader.Rows[0]["Contract No"]))
            {
                // reset contract on page object
                _paymentManagementPageObject.ContractToTest = new corpContractType.ExtendedContract();
            }

            // Assign master contract details
            _paymentManagementPageObject.ContractToTest.contractNumber =
                   contractHeader.Rows[0]["Parent Contract"];
            _paymentManagementPageObject.ContractToTest.contractVersionNumber = int.Parse(contractHeader.Rows[0]["Version"]);
            var masterContract = contractHeader.Rows[0]["Parent Contract"];
            _paymentManagementPageObject.ContractToTest.contractor = new corpContractType.contractor
            {
                legalName = contractHeader.Rows[0]["Provider"],
                ukprn = int.Parse(contractHeader.Rows[0]["UKPRN"]),
                organisationIdentifier = contractHeader.Rows[0]["OrgId"]
            };
          //  _paymentManagementPageObject.ContractToTest.amendmentType = contractHeader.Rows[0]["CRMIntent"];
            _paymentManagementPageObject.ContractToTest.hierarchyType =
                corpContractType.hierarchyType.MASTERCONTRACT;

            // use contract start and end dates for now, this can always be modified later if we need to have specific master contract start and end dates.
            _paymentManagementPageObject.ContractToTest.startDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["Start Date"]);

            DateTime? endDate = null;
            if (contractHeader.Rows[0]["End Date"].DoesNotContain("?"))
            {
                endDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["End Date"]);
            }

            _paymentManagementPageObject.ContractToTest.endDate = endDate; // ParseGwtDateAsUtc(contractHeader.Rows[0]["ContractEndDate"]);

            // Create new contract

            _paymentManagementPageObject.ContractToTest.contracts.Add(new corpContractType.ExtendedContract());
            _paymentManagementPageObject.ContractToTest.contracts[0].contractNumber =
                contractHeader.Rows[0]["Contract No"];
            _paymentManagementPageObject.mastercontractNumbersList.Add(masterContract);
            _paymentManagementPageObject.contractNumbersList.Add(contractHeader.Rows[0]["Contract No"]);
            _paymentManagementPageObject.ContractToTest.contracts[0].endDate = endDate;
            _paymentManagementPageObject.ContractToTest.contracts[0].startDate = ParseGwtDateAsUtc(contractHeader.Rows[0]["Start Date"]);
            _paymentManagementPageObject.ContractToTest.contracts[0].contractVersionNumber = int.Parse(contractHeader.Rows[0]["Version"]);

            _paymentManagementPageObject.ContractToTest.contracts[0].contractValue = decimal.Parse(contractHeader.Rows[0]["Contract Value"]);
            _paymentManagementPageObject.ContractToTest.contracts[0].contractType1 = contractHeader.Rows[0]["Contract Type"];
            _paymentManagementPageObject.ContractToTest.contracts[0].period = new corpContractType.period
            {
                period1 = contractHeader.Rows[0]["Period"]
            };

            _paymentManagementPageObject.ContractToTest.contracts[0].contractor = new corpContractType.contractor
            {
                legalName = contractHeader.Rows[0]["Provider"],
                ukprn = int.Parse(contractHeader.Rows[0]["UKPRN"]),
                organisationIdentifier = contractHeader.Rows[0]["UKPRN"],
                Status = "Active"
            };

            var fundingType = new corpContractType.fundingType();

            switch (contractHeader.Rows[0]["Contract No"].Split('-')[0].ToUpper())
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

                case "AEBP":
                    fundingType.fundingTypeName = "Adult Education Budget";
                    fundingType.fundingTypeCode = "AEB";
                    break;

                case "APPLEVY":
                    fundingType.fundingTypeName = "Apprenticeship Levy";
                    fundingType.fundingTypeCode = "LEVY";
                    break;

                default:
                    throw new Exception("Contract prefix not found when setting funding type");
            }
            _paymentManagementPageObject.ContractToTest.fundingType = fundingType;
            _paymentManagementPageObject.ContractToTest.contracts[0].fundingType = fundingType;

            _paymentManagementPageObject.ContractToTest.contracts[0].hierarchyType = corpContractType.hierarchyType.CONTRACT;
        }

        [Given(@"the following data in spreadsheet '(.*)' existing at '(.*)' exists in the CRM Contract table")]
        public void GivenTheFollowingDataInSpreadsheetExistingAtExistsInTheCRMContractTable(string spreadSheet, string location, Table table)
        {
            string sFileContents = "";

            using (StreamReader oStreamReader = new StreamReader(File.OpenRead(Path.Combine(location, spreadSheet))))
            {
                sFileContents = oStreamReader.ReadToEnd();
            }

            string[] sFileLines = sFileContents.Split(Environment.NewLine.ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            //string[] sFileLines = sFileContents.Split(",".ToCharArray());
            //Table BulksummarisedActuals = new Table();
            foreach (string sFileLine in sFileLines)
            {
                table.AddRow(sFileLine.Split("|".ToCharArray()));
            }

            GivenTheFollowingDataExistsInTheCRMContractTable(table);
        }

        [Given(@"the following data exists in the CRM Allocations table")]
        public void GivenTheFollowingDataExistsInTheCRMAllocationsTable(Table contractAllocations)
        {
            foreach (TableRow row in contractAllocations.Rows)
            {
                string fundingStreamPeriodCode;
                DateTime? endDate;
                if (row["End Date"].Contains("?"))
                {
                    endDate = null;
                }
                else
                {
                    endDate = ParseGwtDateAsUtc(row["End Date"]);
                }

                var gwtAllocation = new PaymentManagementContractAllocation
                {
                    Ukprn = row["UKPRN"],
                    ContractNumber = row["Contract"],
                    AllocationRef = row["Contract Allocation Ref"],
                    FundingStreamCode = row["Funding Stream"],
                    FundingStreamPeriodCode = row.TryGetValue("Funding Stream Period", out fundingStreamPeriodCode) ? fundingStreamPeriodCode : null,
                    AllocationStartDate = ParseGwtDateAsUtc(row["Start Date"]),
                    AllocationEndDate = endDate,
                    AllocationValue = decimal.Parse(row["Contract Allocation Value (£)"]),
                    Period = row["Period"],
                };

                _paymentManagementPageObject.CreateAllocationForContract(gwtAllocation);
            }

            _paymentManagementPageObject.CopyFirstContractsFirstAllocationsPeriodIntoMasterContract();
        }

        [Given(@"the following data in spreadsheet '(.*)' existing at '(.*)' exists in the CRM Allocations table")]
        public void GivenTheFollowingDataInSpreadsheetExistingAtExistsInTheCRMAllocationsTable(string spreadSheet, string location, Table table)
        {
            string sFileContents = "";

            using (StreamReader oStreamReader = new StreamReader(File.OpenRead(Path.Combine(location, spreadSheet))))
            {
                sFileContents = oStreamReader.ReadToEnd();
            }

            string[] sFileLines = sFileContents.Split(Environment.NewLine.ToCharArray(), StringSplitOptions.RemoveEmptyEntries);

            foreach (string sFileLine in sFileLines)
            {
                table.AddRow(sFileLine.Split("|".ToCharArray()));
            }

            GivenTheFollowingDataExistsInTheCRMAllocationsTable(table);
        }

        [Given(@"the following data exists in the CRM Deliverable Period table")]
        public void GivenTheFollowingDataExistsInTheCRMDeliverablePeriodTable(Table table)
        {
            table.Rows.ForEach(row =>
            {
                string allocationNumber = row["Contract Allocation"];
                int deliverableCode = row.ParseInt("Deliverable Code");
                int month = row.ParseInt("Period Number");
                int year = row.ParseInt("Year");

                sfa_contractdeliverableperiod contractDeliverablePeriod = null;

                CheckResultPoller poller = new CheckResultPoller(
                    checkResult: () =>
                    {
                        contractDeliverablePeriod = CrmContractDeliverablePeriodRepository.GetLatestContractDeliverablePeriod(allocationNumber, deliverableCode, year, month);
                        return contractDeliverablePeriod != null;
                    },
                    maxNumChecks: 10,
                    waitIntervalSeconds: 1);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsNotNull(contractDeliverablePeriod, $"Contract Deliverable Period not found for {row.ToHeaderAndValueString()}");
                Assert.AreEqual(row["Period Type"], contractDeliverablePeriod.sfa_PeriodTypeId.Name,
                    $"Unexpected PeriodType returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
                Assert.AreEqual(row["Period"], contractDeliverablePeriod.sfa_PeriodName,
                    $"Unexpected PeriodName returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
                Assert.AreEqual(row.ParseNullableDecimal("Planned Value"), contractDeliverablePeriod.sfa_PlannedValue,
                    $"Unexpected PlannedValue returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
                Assert.AreEqual(row.ParseNullableInt("Planned Volume"), contractDeliverablePeriod.sfa_PlannedVolume,
                    $"Unexpected PlannedVolume returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
            });

        }
        
        [Given(@"the following data data in spreadsheet '(.*)' existing at '(.*)' exists in the CRM Deliverable Period table")]
        public void GivenTheFollowingDataDataInSpreadsheetExistingAtExistsInTheCRMDeliverablePeriodTable(string spreadSheet, string location, Table table)
        {
            string sFileContents = "";
            

            using (StreamReader oStreamReader = new StreamReader(File.OpenRead(Path.Combine(location, spreadSheet))))
            {
                sFileContents = oStreamReader.ReadToEnd();
            }

            string[] sFileLines = sFileContents.Split(Environment.NewLine.ToCharArray(), StringSplitOptions.RemoveEmptyEntries);

            foreach (string sFileLine in sFileLines)
            {
                table.AddRow(sFileLine.Split("|".ToCharArray()));
            }

            GivenTheFollowingDataExistsInTheCRMDeliverablePeriodTable(table);
        }

        [When(@"A file '(.*)' is created in location '(.*)'")]
        public void WhenAFileIsCreatedInLocation(string fileName, string folderName)
        {
            switch (folderName)
            {
                case "Reports":
                {
                    Assert.IsTrue(_contractLoadPage.IsResultsReportFileGenerated(), "Output Report file not found");
                    break;
                }
                
                /*    //RM: To check if it is being called from anywhere
                case "Contracts":
                {
                    var versionNumber =
                        (int)_previousContracts.First(c => (string)c.GetField("Hierarchy Type") == "Contract")
                            .GetField("Version");
                    fileName = fileName.Replace("*", "_" + _contractNumber + "_v" + versionNumber);

                    Assert.IsTrue(_contractDocumentGeneration.DoesFileExist(fileName), "output pdf file not found");
                    break;
                }
                */
            }
        }

        [When(@"The file is copied from the source location to the '(.*)'")]
        public void WhenTheFileIsCopiedFromTheSourceLocationToThe(string p0)
        {
            _contractLoadPage.InitializeUkprnList(_ukprnList);
            _contractLoadPage.CopyFile();
        }

        [Then(@"the following data exists in the CRM Deliverable table")]
        public void ThenTheFollowingDataExistsInTheCRMDeliverableTable(Table table)
        {
            var firstRow = table.Rows[0];
            if (firstRow["Contract"].Contains("<ContractNumber>"))
            {
                firstRow["Contract"] = _contractLoadPage.ContractNumbersFromFile.First(
                    x => x.Contains(firstRow["Contract"].Replace("<ContractNumber>", string.Empty)));
            }

            var firstContractFromTable = GetLatestContractFromTestData((table.Rows[0])["Contract"], false);

            int loopCount = 1;
            int deliverablesCount = 0;

            while (loopCount <= 12)
            {
                deliverablesCount =
                    firstContractFromTable.GetRelatedRecords(_allocationEntity, "Contract")
                        .Sum(a => a.GetRelatedRecords(_deliverableEntity, "Contract Allocation").Count());

                if (deliverablesCount == table.RowCount)
                {
                    break;
                }

                System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(10)).Wait();
                loopCount++;
            }

            Assert.AreEqual(table.RowCount, deliverablesCount, "The number of deliverables is not correct for contract: {0}", firstContractFromTable.GetField("Contract"));

            foreach (var r in table.Rows)
            {
                if (r["Contract"].Contains("<ContractNumber>"))
                {
                    r["Contract"] = _contractLoadPage.ContractNumbersFromFile.First(
                        x => x.Contains(r["Contract"].Replace("<ContractNumber>", string.Empty)));
                }
                if (r["Contract Allocation"].Contains("<AllocationNumber>"))
                {
                    r["Contract Allocation"] = _contractLoadPage.AllocationNumbersFromFile.First(
                        x => x.Contains(r["Contract Allocation"].Replace("<AllocationNumber>", string.Empty)));
                }

                var allocation = GetAllocationFromTestData(r["Contract Allocation"], false);

                var filterList = new Dictionary<string, object>
                {
                    { "sfa_deliverablename", r["Deliverable"] },
                    { "sfa_contractallocationid", allocation.GetId() }
                };

                var deliverables = XrmService.Connection.GetRecords(_deliverableEntity, filterList);

                Assert.AreEqual(deliverables.Count, 1, "More than one matching record based on combination of Contract Id and Allocation Id");

                var deliverable = deliverables.First().GetLatestRecord();

                deliverable.FieldValueEquals("Deliverable Code", r["Deliverable Code"]);

                // DOn't check owner as it is a system account and can chnage across environments
                //deliverable.FieldValueEquals("Owner", r["Owner"]);
                // TODO: Funding Stream Period Deliverable is not carried over
                //.LookupFieldValueEquals(_fundingStreamPeriodDeliverableEntity, "Funding Stream Period Deliverable", r["Funding Stream Period Deliverable"]);

                _newDeliverables.Add(deliverable);
            }
        }
 
        [Then(@"the following data exists in the CRM Deliverable Period table")]
        public void ThenTheFollowingDataExistsInTheCRMDeliverablePeriodTable(Table table)
        {
            var newContract =
                _newContracts.OrderByDescending(y => (int)y.GetField("sfa_subversion")).FirstOrDefault(x => ((string)x.GetField("Hierarchy Type")).ToUpper() != "MASTER");

            var deliverablesPeriodsCount =
                newContract.GetRelatedRecords(_allocationEntity, "Contract")
                    .Sum(
                        a =>
                            a.GetRelatedRecords(_deliverableEntity, "Contract Allocation")
                                .Sum(d => d.GetRelatedRecords(_deliverablePeriodEntity, "Contract Deliverable").Count()));


            var deliverables =
                newContract.GetRelatedRecords(_allocationEntity, "Contract")
                    .SelectMany(
                        a =>
                            a.GetRelatedRecords(_deliverableEntity, "Contract Allocation")
                                .Select(d => d));

            Assert.AreEqual(table.RowCount, deliverablesPeriodsCount, "The number of deliverable periods is not correct for contract: {0}", newContract.GetField("Contract No"));

            foreach (var r in table.Rows)
            {
                //var deliverable = GetDeliverableFromTestData(r["Deliverable"], false);

                var deliverable = deliverables.Single(d => (string)d.GetField("Deliverable") == r["Deliverable"]);

                var filterList = new Dictionary<string, object>
                {
                    { "sfa_period", r["Period Number"] },
                    { "sfa_year", r["Year"] },
                    { "sfa_contractdeliverableid", deliverable.GetId() }
                };

                var deliverablePeriods = XrmService.Connection.GetRecords(_deliverablePeriodEntity, filterList);

                Assert.AreEqual(deliverablePeriods.Count, 1, "More than one matching record based on combination of Contract Id and Allocation Id");

                var deliverablePeriod = deliverablePeriods.First().GetLatestRecord();

                deliverablePeriod
                    .FieldValueEquals("Period", r["Period"])
                    .FieldValueEquals("Planned Value (£)", r["Planned Value"])
                    .FieldValueEquals("sfa_displayorder", r["Display Order"])
                    .LookupFieldValueEquals(_periodTypeEntity, "Period Type", r["Period Type"])
                    .FieldValueEquals("Period Number", r["Period Number"])
                    .FieldValueEquals("Year", r["Year"]);

                if (r["Planned Volume"] != "<Blank>")
                {
                    deliverablePeriod.FieldValueEquals("Planned Volume", r["Planned Volume"]);
                }
            }
        }

        [Then(@"a syntax results report named '(.*)' is created in the Sharepoint '(.*)' folder")]
        [Then(@"[A|a] file '(.*)' is created with success message indicating the processing of the spreadsheet in location '(.*)'")]
        public void ThenAFileIsCreatedWithSuccessMessageIndicatingTheProcessingOfTheSpreadsheetInLocation(string p0, string p1)
        {
            Assert.IsTrue(_contractLoadPage.IsSyntaxFileGeneratedAndIsSuccess(), "Output Syntax file does not Exist or contains success message");
        }

        [Then(@"[A|a] file '(.*)' is created in location '(.*)' in less than (.*) seconds")]
        public void ThenAFileIsCreatedInLocationInLessThanSeconds(string fileName, string folderName, int SLA2)
        {
            switch (folderName)
            {
                case "Reports":
                {
                    _contractLoadPage.IsResultsReportFileGeneratedInterval = SLA2;
                    Assert.IsTrue(_contractLoadPage.IsResultsReportFileGenerated(), "Output Report file not found");
                    break;
                }
            }
        }

        [Then(@"'(.*)' is displayed in field '(.*)' on the '(.*)' tab of the result report file")]
        public void ThenIsDisplayedInFieldOnTheTabOfTheResultReportFile(string message, string cellAddress, string worksheet)
        {
            // need to get the results report excel file from blob and read cell values
            var results = _contractLoadPage.GetCellValueFromResultsReport(worksheet, cellAddress, false);

            Assert.IsTrue(results.Replace(" ", string.Empty).Contains(message.Replace(" ", string.Empty)), "Expected Response is not available: " + message + "; Actually: " + results);
        }

        [When(@"A file '(.*)' is created with success message indicating the processing of the spreadsheet in location '(.*)'")]
        public void WhenAFileIsCreatedWithSuccessMessageIndicatingTheProcessingOfTheSpreadsheetInLocation(string p0, string p1)
        {
            Assert.IsTrue(_contractLoadPage.IsSyntaxFileGeneratedAndIsSuccess(), "Output Syntax file does not Exist or contains success message");
        }

        [When(@"'(.*)' is displayed in field '(.*)' on the '(.*)' tab of the result report file")]
        public void WhenIsDisplayedInFieldOnTheTabOfTheResultReportFile(string p0, string p1, string p2)
        {
            ThenIsDisplayedInFieldOnTheTabOfTheResultReportFile(p0, p1, p2);
        }

        [Given(@"all contracts with this ukprn have been deleted '(.*)'")]
        public void GivenAllContractsWithThisUkprnHaveBeenDeleted(int ukprn)
        {
            _contractLoadPage.DeleteContractsWithThisUkprn(ukprn.ToString());
        }

        private void CreateOrgAndCaseLoad(string ukprn, string orgName, EntityReference orgStatus, EntityReference caseloadStatus, EntityReference caseloadOwner)
        {
            string orgid = "ORG" + ukprn.Substring(1, 7);

            Account account = new Account
            {
                sfa_OrganisationID = orgid,
                sfa_UKPRN = ukprn,
                sfa_Status = orgStatus,
                Name = orgName
            };

            Guid organisationId = CrmConnectionFactory.GetNonRetryingConnection().Create(account);
            _orgs.Add(new SimpleOrg(organisationId, ukprn));

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, organisationId),
                sfa_UKPRN = ukprn,
                sfa_Status = caseloadStatus,
                sfa_organisationname = orgName,
                OwnerId = caseloadOwner
            };

            CrmConnectionFactory.GetNonRetryingConnection().Create(caseload);
        }

        private void SetupServicesForBulkContracts()
        {
            if (_orgEntity == null)
            {
                _orgEntity = XrmService.Configuration.Entity("account");
                _statusEntity = XrmService.Configuration.Entity("sfa_status");
                _contractEntity = XrmService.Configuration.Entity("sfa_contract");
                _allocationEntity = XrmService.Configuration.Entity("sfa_contractallocation");
                _deliverableEntity = XrmService.Configuration.Entity("sfa_contractdeliverable");
                _deliverablePeriodEntity = XrmService.Configuration.Entity("sfa_contractdeliverableperiod");
                _workflowHistoryEntity = XrmService.Configuration.Entity("sfa_contracttransitionhistory");
                _systemUserEntity = XrmService.Configuration.Entity("systemuser");
                _caseloadEntity = XrmService.Configuration.Entity("sfa_caseload");
                _periodTypeEntity = XrmService.Configuration.Entity("sfa_periodtype");
                _activeStatus = CrmStatusRepository.GetStatus("Active");
                _unassignedTeam = CrmTeamRepository.GetTeamEntityReference("Unassigned");
                _inactiveStatus = CrmStatusRepository.GetStatus("Inactive");
                _zoeFoster = new EntityReference(SystemUser.EntityLogicalName, CrmUserRepository.GetUserId("FCS2 Test"));
            }
        }

        private XrmWebEntity GetLatestContractFromTestData(string contractNumber, bool existingContract = true)
        {
            XrmWebEntity contract = null;

            Func<XrmWebEntity, bool> getByNumberPredicate = c => (string)c.GetField("sfa_number") == contractNumber;

            if (!existingContract)
            {
                contract = _newContracts.Where(getByNumberPredicate).MaxBy(c => decimal.Parse(c.GetField("Version").ToString()) + (decimal.Parse(c.GetField("Sub Version").ToString()) / 100));
            }
            else
            {
               // contract = _previousContracts.Where(getByNumberPredicate).MaxBy(c => decimal.Parse(c.GetField("Version").ToString()) + (decimal.Parse(c.GetField("Sub Version").ToString()) / 100));
            }

            return contract;
        }

        private XrmWebEntity GetAllocationFromTestData(string allocationReference, bool existingContract = true)
        {
            XrmWebEntity allocation;

            if (!existingContract)
            {
                allocation = _newAllocations.Single(c => (string)c.GetField("sfa_contractallocationnumber") == allocationReference);
            }
            else
            {
                allocation = _previousAllocations.Single(c => (string)c.GetField("sfa_contractallocationnumber") == allocationReference);
            }

            return allocation;
        }

        private static DateTime ParseGwtDateAsUtc(string date)
        {
            return DateTime.SpecifyKind(DateTime.ParseExact(date, "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc);
        }

        private class SimpleOrg
        {
            public SimpleOrg(Guid id, string ukprn)
            {
                Id = id;
                Ukprn = ukprn;
            }

            public Guid Id { get; }

            public string Ukprn { get; }
        }
    }
}