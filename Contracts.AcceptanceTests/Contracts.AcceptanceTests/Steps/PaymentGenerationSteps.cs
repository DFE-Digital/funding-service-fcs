namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Entities.CorporatePaymentGeneration;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using Extensions;
    using Framework.Logging.Interfaces;
    using Infrastructure.DTO;
    using Infrastructure.DTO.PaymentGeneration;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Moq;
    using MoreLinq;
    using Pages;
    using TechTalk.SpecFlow;
    using NUnit.Framework;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Utilities;
    using CorpContract = CrossDomain.Integration.Entities.CorporateContract;
    using PaymentTimetable = Infrastructure.DTO.PaymentGeneration.PaymentTimetable;
    using Newtonsoft.Json;
    using PaymentGenerationDomain.Common.Commands;
    using NUnit.Framework.Legacy;

    [Binding]
    public class PaymentGenerationSteps
    {
        private readonly PaymentGenerationPageObject _paymentGeneration;
        private DateTime _startTime;
        private DateTime _endTime;
        private PaymentInstruction _paymentInstruction;
        private SummaryInstruction _summaryInstruction;
        private SyndicationItem _paymentAtomFeedItemUnderTest;

        public PaymentGenerationSteps(PaymentGenerationPageObject paymentGenerationPageObject)
        {
            _paymentGeneration = paymentGenerationPageObject;
        }

        [BeforeScenario("PaymentGenerationAndTransmission", "PerformancePaymentGeneration")]
        public void ClearDataBefore()
        {
            TestDbContextFactory.InitializeForTests();
            PaymentGenerationDataStore.DeleteAllSubnominalAggregations();
            PaymentGenerationDataStore.ResetPaymentTimetable();
        }

        [When(@"the Payment Generation Batch run is started")]
        public void WhenThePaymentGenerationBatchRunIsStarted()
        {
            MessageSendingBus.Send("PaymentGenerationDomain.InitiatePaymentBatch", new InitiatePaymentBatchCommand());
        }

        [Given(@"the below Subnominal Aggregations exist in the data store")]
        public void GivenTheBelowSubnominalAggregationsExistInTheDataStore(Table table)
        {
            var payments = table.Rows.Select(row => new Payment
            {
                AllocationNumber = row["Allocation Number"],
                AggregatedValue = decimal.Parse(row["AggregatedValue"]),
                FundingStreamPeriodCode = row["Funding Stream Period Code"],
                Ukprn = int.Parse(row["UKPRN"]),
                Period = row["Calendar Year/Period"],
                SubnominalCode = row["Subnominal Code"],
                SubnominalType = row["Payment Type"],
                OrganisationId = row["Org ID"],
                VersionNumber = 0
            }).ToList();

            PaymentGenerationDataStore.CreatePayments(payments);
        }

        [Given(@"the following configuration exists in the Payment Timetable")]
        [Given(@"the below configuration exists in the Payment Timetable")]
        [Then(@"the following configuration is set in the Payment Timetable")]
        public void GivenTheBelowDataExistsInThePaymentTimetable(Table table)
        {
            PaymentGenerationDataStore.DisableAllPaymentRuns();

            table.Rows.ForEach(tim =>
            {
                DateTime? censusEndDate = null;
                if (!string.IsNullOrWhiteSpace(tim["Census End Date/Time"]))
                {
                    censusEndDate = tim["Census End Date/Time"] == "Now" 
                    ? DateTime.Now 
                    : DateTime.ParseExact(tim["Census End Date/Time"], "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
                }

                PaymentGenerationDataStore.UpdatePaymentTimetable(new FundingStreamPeriodCalendarPeriod
                {
                    FundingStreamPeriodCode = tim["Funding Stream Period Code"],
                    CalendarPeriod = tim["Calendar Year/Period"]
                },
                tim["LinkCodeSuffix"],
                tim["Status"], censusEndDate);
            });
        }

        [Given(@"the below ESF Allocation exist in the data store")]
        public void GivenTheBelowEsfAllocationExistInTheDataStore(Table table)
        {

            using (var context = new MonitoringDeliverablesDbContext())
            {

                var esfDataStore= new MonitoringDeliverableStore(Mock.Of<ILogger>());

                table.Rows.ForEach(tablerow =>
                {

                    var allocation = new CorpContract.contractAllocationsContractAllocation()
                    {
                        contractAllocationNumber = tablerow["Allocation Number"],
                        LEPCode = tablerow["LEP Code"],
                        AgreementNumber = tablerow["Agreement Number"],
                        tenderSpecificationReference = tablerow["Agreement Number"], // this is required so that when we serialize (see ShouldSerializeProcurementAttrs) it is included
                        SpecificationTitle = "SpecTitle",
                        tenderAwardReference = "TAR",
                        ActivityDescription = "AD",
                        InvestmentPriority = "IP",
                        LEPName = tablerow["LEP Code"],
                        RegionType = "RT",
                    };

                    esfDataStore.StoreESFAllocation(allocation, tablerow["Contract Number"], ConnectionInfo.CreateFrom(context.Database.Connection));
                });
            }   
        }

        [Given(@"a timer is started")]
        [When(@"a timer is started")]
        [Then(@"a timer is started")]
        public void ThenATimerIsStarted()
        {
            _startTime = DateTime.Now;
        }

        [Then(@"[T|t]he timer should be less than (.*) seconds")]
        public void ThenTheTimerShouldBeLessThanSeconds(int timeLimit)
        {
            _endTime = DateTime.Now;
            var timeSpan = _endTime - _startTime;     

            ClassicAssert.IsTrue(timeSpan <= TimeSpan.FromSeconds(timeLimit));
        }

        [Then(@"there is an entry in the Payment Timetable")]
        public void ThenThereIsAnEntryInThePaymentTimetable(Table table)
        {
            foreach (var tim in table.Rows)
            {
                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    var timetable = PaymentGenerationDataStore.GetPaymentTimetable(new FundingStreamPeriodCalendarPeriod
                    {
                        FundingStreamPeriodCode = tim["Funding Stream Period Code"],
                        CalendarPeriod = tim["Calendar Year/Period"]
                    });

                    return tim["Status"] == timetable.Status;
                },
                maxNumChecks: 30,
                waitIntervalSeconds: 3);
                
                if (!checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime())
                {
                    ClassicAssert.Fail($"Status is not set correctly for funding stream {tim["Funding Stream Period Code"]} and calendar period {tim["Calendar Year/Period"]}");
                }
            }
        }

        [Then(@"Payment file '(.*)' is created in PTS drop location")]
        public void ThenPaymentFileIsCreatedInPtsDropLocation(string paymentInstructionFile)
        {
            // Try n number of times
            var checkResultPoller = new CheckResultPoller(
                () => _paymentGeneration.IsPaymentFileCreatedInDropLocation(paymentInstructionFile),
                maxNumChecks: 30,
                waitIntervalSeconds: 3);

            ClassicAssert.IsTrue(checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime(),
                $"File {paymentInstructionFile} was not created");
        }

        [Given(@"Files are deleted from PTS Sharepoint folder")]
        public void GivenFilesAreDeletedFromPTSSharepointFolder()
        {
            _paymentGeneration.DeleteFilesFromOffice365InPtsFolder();
        }

        [Then(@"Payment file '(.*)' is created in PTS Sharepoint Folder for Funding Stream Period Code '(.*)' and Period '(.*)'")]
        public void ThenPaymentFileIsCreatedInPTSSharepointFolderForFundingStreamPeriodCodeAndPeriod(string paymentFileName, string fundingStreamPeriodCode, int calendarPeriod)
        {
            DateTime censusDate = PaymentGenerationRepository.GetCensusEndDate(fundingStreamPeriodCode, calendarPeriod.ToString());

            string archiveFolderName = censusDate.ToString("yyyy-MM-dd");
            // Try n number of times
            var checkResultPoller = new CheckResultPoller(
                () => _paymentGeneration.IsPaymentFileCreatedInOffice365(paymentFileName, archiveFolderName),
                maxNumChecks: 30,
                waitIntervalSeconds: 3);

            bool isFilePresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
            if (isFilePresent)
            {
                if (paymentFileName.Contains(".nat"))
                {
                    _summaryInstruction = _paymentGeneration.GetLinesFromPaymentSummaryFile(paymentFileName,
                    archiveFolderName);
                }
                else
                {
                    _paymentInstruction = _paymentGeneration.GetLinesFromPaymentInstructionFile(paymentFileName,
                    archiveFolderName);
                }
                
            }

            ClassicAssert.IsTrue(isFilePresent,
                $"File {paymentFileName} was not created");
        }
        
        [Given(@"the following data exists in the payment file")]
        [Then(@"the following data exists in the payment file")]
        public void ThenTheFollowingDataExistsInThePaymentFile(Table table)
        {
            ClassicAssert.IsNotNull(_paymentInstruction, "The _paymentInstruction must be set before we can call this method");

            var expectedTransInstruction = new PaymentInstruction
            {
                Lines = new List<InstructionLine>()
            };

            bool extractExtref3 = table.ContainsColumn("ExternalRef 3");
            table.Rows.ForEach(r =>
            {
                var line = new InstructionLine
                {
                    LineType = r["LineType"],
                    LinkCode = r["LinkCode"],
                    CompanyCode = r["Company Code"],
                    Element1 = r["Element 1"],
                    Element2 = r["Element 2"],
                    Element3 = r["Element 3"],
                    Element4 = r["Element 4"],
                    Element6 = string.Empty, //not used for this test.
                    Amount = r["Amount"],
                    SubnominalShortDescription = r["Subnominal Short Description"],
                    Element25 = r["Element 25"]
                };

                line.ExtRef3 = (extractExtref3) ?  r["ExternalRef 3"] : "";

                expectedTransInstruction.Lines.Add(line);
            });

            PaymentInstruction actualTransInstruction = _paymentInstruction;

            // we are not interested in external ref 3 field for non ESF payment file
            // so we blank out the field when comparing
            if(!extractExtref3)
                actualTransInstruction.Lines.ForEach(x=>x.ExtRef3 ="");

            // not interested in element 6 (allocation number) for payGen tests but are for end to end.
            actualTransInstruction.Lines.ForEach(line => line.Element6 = string.Empty);

            var mismatches = _paymentGeneration.ComparePayGenObjects(expectedTransInstruction, actualTransInstruction).ToList();

            ClassicAssert.IsTrue(!mismatches.Any(), mismatches.WriteMismatches());
        }

        [Then(@"the following data exists in the Summary file")]
        public void ThenTheFollowingDataExistsInTheSummaryFile(Table table)
        {
            ClassicAssert.IsNotNull(_summaryInstruction, "This must be set in a previous step");
            var expectedTransInstruction = new SummaryInstruction
            {
                Lines = new List<SummaryInstructionLine>()
            };

            table.Rows.ForEach(r =>
            {
                expectedTransInstruction.Lines.Add(new SummaryInstructionLine
                {
                    PaymentFileName = r["Payment File Name"],
                    NumberOfPayments = r["Number of Payment Instructions"],
                    ValueOfPayments = r["Value of Payment Instruction"],
                    ErrorFileName = r["Error File Name"],
                    NumberOfErrorPayments = r["Number of Payment Error"],
                    ValueOfErrorPayments = r["Value of Payment Error"]
                });
            });

            SummaryInstruction actualSummaryInstruction = _summaryInstruction;

            var mismatches = _paymentGeneration.ComparePayGenObjects(expectedTransInstruction, actualSummaryInstruction).ToList();

            ClassicAssert.IsTrue(!mismatches.Any(), mismatches.WriteMismatches());
        }

        [Then(@"there is an entry in the Payment History Table")]
        public void ThenThereIsAnEntryInThePaymentHistoryTable(Table table)
        {
            foreach (var tim in table.Rows)
            {
                // Try n number of times
                var tries = 2;

                while (tries > 0)
                {
                    var history = PaymentGenerationDataStore.GetPaymentTimetableHistory(new FundingStreamPeriodCalendarPeriod
                    {
                        FundingStreamPeriodCode = tim["Funding Stream Period Code"],
                        CalendarPeriod = tim["Period"]
                    });

                    if (history.OrderByDescending(h => h.HistoryTime).Any(h => h.Description == tim["Description"]))
                    {
                        break;
                    }

                    tries--;
                    Task.Delay(TimeSpan.FromSeconds(10)).Wait();
                }

                if (tries == 0)
                {
                    ClassicAssert.Fail("Status is not set correctly.");
                }
            }
        }

        [Then(@"the below configuration exists in the Payment Timetable")]
        public void ThenTheBelowConfigurationExistsInThePaymentTimetable(Table table)
        {
            table.Rows.ForEach(row =>
            {
                PaymentTimetable paymentTimetable = null;
                string fsp = null;
                string period = null;
                CheckResultPoller resultPoller = new CheckResultPoller(checkResult:() =>
                {
                    fsp = row["Funding Stream Period Code"];
                    period = row["Calendar Year/Period"];
                    paymentTimetable = PaymentGenerationDataStore.GetPaymentTimetable(
                    new FundingStreamPeriodCalendarPeriod
                    {
                        FundingStreamPeriodCode = fsp,
                        CalendarPeriod = period
                    });

                    return row["Status"] == paymentTimetable.Status;

                },
                maxNumChecks: 20,
                waitIntervalSeconds: 3
                );

                bool isStatusCorrect = resultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(isStatusCorrect, $"Status has not been updated for fsp: {fsp}, period: {period}");
                ClassicAssert.AreEqual(row["LinkCodeSuffix"], paymentTimetable.LinkCodeSuffix, $"Link Code Suffix has not been updated for fsp: {fsp}, period: {period}.");
            });
        }

        [When(@"the Payment Timetable Status is updated")]
        public void WhenThePaymentTimetableStatusIsUpdated(Table table)
        {
            table.Rows.ForEach(tim => PaymentGenerationDataStore.UpdatePaymentTimetable(
                new FundingStreamPeriodCalendarPeriod
                {
                    FundingStreamPeriodCode = tim["Funding Stream Period Code"],
                    CalendarPeriod = tim["Calendar Year/Period"]
                },
                tim["LinkCodeSuffix"],
                tim["Status"]));
        }

        [Then(@"the Payment feed xml for FundingStreamPeriod '(.*)' PaymentPeriod '(.*)' CensusEndDate '(.*)' and LinkCodeSuffix '(.*)' includes the following values")]
        public void ThePaymentFeedForFundingStreamPeriodPaymentPeriodCensusEndDateAndLinkCodeSuffixIncludesTheFollowingValues(string fspCode, string paymentPeriod, string censusEndDate, string linkCodeSuffix, TransformedTable table)
        {
            PaymentBatchFeedNaturalKey key = new PaymentBatchFeedNaturalKey(
                fspCode,
                paymentPeriod,
                DateTime.SpecifyKind(DateTime.ParseExact(censusEndDate, "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc),
                linkCodeSuffix);

            PaymentPeriod expectedFeedData = table.Rows
                .Select(r => new PaymentPeriod
                {
                    FundingStreamShortCode = r["FundingStreamShortCode"],
                    FinancialPaymentFinancialYear = r["FinancialYear"],
                    FinancialPaymentFinancialMonth = r["FinancialMonth"],
                    CensusEndDate = key.CensusEndDate,
                    DueDate = r.ParseNullableDate("DueDate", "yyyy-MM-dd").GetValueOrDefault(),
                    FundingStreamPeriodStartDate = r.ParseNullableDate("FSPStartDate", "yyyy-MM-dd").GetValueOrDefault(),
                    FundingStreamPeriodEndDate = r.ParseNullableDate("FSPEndDate", "yyyy-MM-dd").GetValueOrDefault(),
                    PaymentDetails = new List<PaymentDetail>
                    {
                        new PaymentDetail
                        {
                            Allocation = new AllocationAttrsCT
                            {
                                AllocationNumber = r["AllocationRef"],
                                ProcurementAttrs = new ProcurementAttrsCT
                                {
                                    AgreementNumber = r.ParseNullableString("LEPAgreementNo"),
                                    LEPCode = r.ParseNullableString("LEPCode")
                                }
                            },
                            AggregatedValue = r.ParseNullableDecimal("AggregatedValue").GetValueOrDefault(),
                            PaymentType =
                                (PaymentDetailPaymentType) r
                                    .ParseNullableEnum<PaymentDetailPaymentType>("PaymentType"),
                            SubnominalDescription = r["SubnominalDescription"],
                            SubnominalCode = r["Subnominal"],
                            Organisation = new Organisation
                            {
                                AlternateOrganisationIdentifiers = new List<OrganisationIdentifier>
                                {
                                    new OrganisationIdentifier
                                    {
                                        AlternateOrganisationIdentifier = r["UKPRN"],
                                        AlternateOrganisationIdentifierName =
                                            OrganisationIdentifierAlternateOrganisationIdentifierName
                                                .UKPROVIDERREFERENCENUMBER
                                    }
                                }
                            }
                        }
                    }
                })
                .Aggregate((first, second) =>
                {
                    first.PaymentDetails.AddRange(second.PaymentDetails);
                    return first;
                });

            PaymentBatchFeedItem paymentBatchFeedRow = null;

            CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    paymentBatchFeedRow = PaymentBatchFeedRepository.GetFeedItemByNaturalKey(key);
                    return paymentBatchFeedRow != null;
                }, maxNumChecks: 40, waitIntervalSeconds: 3);

            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsNotNull(paymentBatchFeedRow, $"Feed did not contain a record for {key}");

            PaymentPeriod feedPaymentPeriod = paymentBatchFeedRow.GetPaymentBatchXml().DeserializeXml<PaymentPeriod>();

            ClassicAssertPaymentPeriodsAreEqual(expectedFeedData, feedPaymentPeriod);
        }

        [Then(@"the Payment feed xml for FundingStreamPeriod '(.*)' PaymentPeriod '(.*)' CensusEndDate '(.*)' and LinkCodeSuffix '(.*)' is decrypted and saved to '(.*)' as '(.*)'")]
        public void ThenPaymentFeedDataForFundingStreamPeriodPaymentPeriodCensusEndDateAndLinkCodeSuffixIsDecryptedAndSavedToAs(
                string fspCode, string paymentPeriod, string censusEndDate, string linkCodeSuffix, string path, string fileName)
        {
            PaymentBatchFeedNaturalKey key = new PaymentBatchFeedNaturalKey(
                fspCode,
                paymentPeriod,
                DateTime.SpecifyKind(DateTime.ParseExact(censusEndDate, "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc),
                linkCodeSuffix);

            PaymentBatchFeedItem paymentBatchFeedRow = null;

            CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
            {
                paymentBatchFeedRow = PaymentBatchFeedRepository.GetFeedItemByNaturalKey(key);
                return paymentBatchFeedRow != null;
            }, maxNumChecks: 20, waitIntervalSeconds: 3);

            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsNotNull(paymentBatchFeedRow, $"Feed did not contain a record for {key}");

            string xml = paymentBatchFeedRow.GetPaymentBatchXml();

            string fullFilePath = $"../../{path}/{fileName}";
            Directory.CreateDirectory(Path.GetDirectoryName(fullFilePath));

            File.WriteAllText(fullFilePath, xml, Encoding.UTF8);
        }

        [Then(@"the Payment feed xml for FundingStreamPeriod '(.*)' PaymentPeriod '(.*)' CensusEndDate '(.*)' and LinkCodeSuffix '(.*)' with PaymentLineCount zero contains no payment data")]
        public void ThenThePaymentFeedXmlForFundingStreamPeriodPaymentPeriodCensusEndDateAndLinkCodeSuffixWithPaymentLineCountZeroContainsNoPaymentData(string fspCode, string paymentPeriod, string censusEndDate, string linkCodeSuffix)
        {
            PaymentBatchFeedNaturalKey key = new PaymentBatchFeedNaturalKey(
                fspCode,
                paymentPeriod,
                DateTime.SpecifyKind(DateTime.ParseExact(censusEndDate, "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc),
                linkCodeSuffix);

            PaymentBatchFeedItem paymentBatchFeedRow = null;

            CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
            {
                paymentBatchFeedRow = PaymentBatchFeedRepository.GetFeedItemByNaturalKey(key);
                return paymentBatchFeedRow != null;
            }, maxNumChecks: 10, waitIntervalSeconds: 3);

            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsNotNull(paymentBatchFeedRow, $"Feed did not contain a record for {key}");
            ClassicAssert.AreEqual(0, paymentBatchFeedRow.PaymentLineCount, "PaymentLineCount is not zero");

            PaymentPeriod feedPaymentPeriod = paymentBatchFeedRow.GetPaymentBatchXml().DeserializeXml<PaymentPeriod>();
            ClassicAssert.AreEqual(0, feedPaymentPeriod.PaymentDetails.Count, "There is unexpected payment data - PaymentDetails is not empty");
        }

        [Given(@"there is no data in the Payment feed for FundingStreamPeriod '(.*)' PaymentPeriod '(.*)' CensusEndDate '(.*)' and LinkCodeSuffix '(.*)'")]
        [Given(@"there is no data in the Payment feed for FundingStreamPeriod '(.*)' AccountingPaymentPeriod '(.*)' CensusEndDate '(.*)' and LinkCodeSuffix '(.*)'")]
        public void GivenThereIsNoDataInThePaymentFeedForFundingStreamPeriodPaymentPeriodCensusEndDateAndLinkCodeSuffix(string fspCode, string paymentPeriod, string censusEndDate, string linkCodeSuffix)
        {
            PaymentBatchFeedNaturalKey key = new PaymentBatchFeedNaturalKey(
                fspCode,
                paymentPeriod,
                DateTime.SpecifyKind(DateTime.ParseExact(censusEndDate, "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc),
                linkCodeSuffix);

            PaymentBatchFeedRepository.DeleteItemByNaturalKey(key);
        }

        [Given(@"there is no data in the Payment feed for the following")]
        public void GivenThereIsNoDataInThePaymentFeedForTheFollowing(Table table)
        {
            table.Rows
                .Select(row => new PaymentBatchFeedNaturalKey(
                    fundingStreamPeriod: row["Funding Stream Period Code"],
                    paymentPeriod: row["Payment Period"],
                    censusEndDate: row.ParseDate("Census End Date"),
                    linkCodeSuffix: row["Link Code Suffix"]))
                .ForEach(PaymentBatchFeedRepository.DeleteItemByNaturalKey);
        }

        [Given(@"there is an item on the Payment feed for FundingStreamPeriod '(.*)' AccountingPaymentPeriod '(.*)' and CensusEndDate '(.*)'")]
        [Then(@"there is an item on the Payment feed for FundingStreamPeriod '(.*)' AccountingPaymentPeriod '(.*)' and CensusEndDate '(.*)'")]
        public void ThenThereIsAnItemOnThePaymentFeedForFundingStreamPeriodPaymentPeriodCensusEndDate(string fundingStreamPeriodCode, string paymentPeriod, string censusEndDate)
        {
            DateTime expectedCensusDate = DateTime.SpecifyKind(DateTime.ParseExact(censusEndDate, "d/MM/yyyy", CultureInfo.InvariantCulture).AddHours(22), DateTimeKind.Utc);

            CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
            {
                 IEnumerable<SyndicationItem> feedItems = AtomFeedReader.EnumerateItems(
                    $"{TestConfiguration.Configuration["ContractManagement:ServiceUrl"]}/api/AllocationDelivery/payment-requests/notifications/",
                    AzureAuthenticator.GetAuthenticationConfig(),
                    "application/vnd.sfa.funding-policy.deliverable.setting.v1+atom+xml");

                _paymentAtomFeedItemUnderTest = feedItems.FirstOrDefault(item =>
                {
                    string titleText = item.Title.Text;
                    return titleText.Contains(fundingStreamPeriodCode)
                           && titleText.Contains(paymentPeriod)
                           && titleText.Contains($"{expectedCensusDate:yyyy-MM-ddTHH:mm:ssZ}");
                });
                    
                return _paymentAtomFeedItemUnderTest != null;
            }, maxNumChecks: 15, waitIntervalSeconds: 2);
            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsNotNull(_paymentAtomFeedItemUnderTest, "Payment atom feed item not found");
        }

        [Given(@"the Payment feed item TITLE is as follows")]
        [When(@"the Payment feed item TITLE is as follows")]
        [Then(@"the Payment feed item TITLE is as follows")]
        public void ThenThePaymentFeedItemTitleIsAsFollows(Table table)
        {
            ClassicAssert.IsNotNull(_paymentAtomFeedItemUnderTest, $"{_paymentAtomFeedItemUnderTest} variable not set");

            string expectedTitle = table.Rows.Single()["Title"];
            ClassicAssert.AreEqual(expectedTitle, _paymentAtomFeedItemUnderTest.Title.Text, "Payment atom feed title was not correct");
        }

        [Given(@"the Payment feed item SUMMARY is as follows")]
        [When(@"the Payment feed item SUMMARY is as follows")]
        [Then(@"the Payment feed item SUMMARY is as follows")]
        public void ThenThePaymentFeedItemSummaryIsAsFollows(Table table)
        {
            ClassicAssert.IsNotNull(_paymentAtomFeedItemUnderTest, $"_paymentAtomFeedItemUnderTest variable not set");

            var expectedSummary = table.Rows.Select(r => new Summary(fundingStreamPeriod: r["FundingStreamPeriod"],
                paymentPeriod: r["PaymentPeriod"], censusEndDate: r.ParseDateAndTime("CensusEndDate"),
                paymentLineCount: r.ParseInt("PaymentLineCount"), totalValue: r.ParseDecimal("TotalValue"))).Single();

            Summary summary = JsonConvert.DeserializeObject<Summary>(_paymentAtomFeedItemUnderTest.Summary.Text);

            ClassicAssert.AreEqual(expectedSummary.FundingStreamPeriod, summary.FundingStreamPeriod, "The FundingStreamPeriod on the summary was not correct");
            ClassicAssert.AreEqual(expectedSummary.CensusEndDate, summary.CensusEndDate, "The CensusEndDate on the summary was not correct");
            ClassicAssert.AreEqual(expectedSummary.PaymentLineCount, summary.PaymentLineCount, "The PaymentLineCount on the summary was not correct");
            ClassicAssert.AreEqual(expectedSummary.PaymentPeriod, summary.PaymentPeriod, "The PaymentPeriod on the summary was not correct");
            ClassicAssert.AreEqual(expectedSummary.TotalValue, summary.TotalValue, "The TotalValue on the summary was not correct");
        }

        [Given(@"the Payment feed item PaymentDetails are as follows")]
        [When(@"the Payment feed item PaymentDetails are as follows")]
        [Then(@"the Payment feed item PaymentDetails are as follows")]
        public void ThenThePaymentFeedItemPaymentDetailsAreAsFollows(TransformedTable table)
        {
            ClassicAssert.IsNotNull(_paymentAtomFeedItemUnderTest, $"_paymentAtomFeedItemUnderTest variable not set");

            var expectedPaymentDetails = table.Rows.Select(r => new PaymentDetail
            {
                Organisation = new Organisation
                {
                    OrganisationId = r["OrgId"],
                    AlternateOrganisationIdentifiers = new List<OrganisationIdentifier>
                    {
                        new OrganisationIdentifier
                        {
                            AlternateOrganisationIdentifier = r["AlternateOrgId"],
                            AlternateOrganisationIdentifierName = r.ParseEnum<OrganisationIdentifierAlternateOrganisationIdentifierName>("AlternateOrgIdName")
                        }
                    },
                    OrganisationStatusRelationships = new List<OrganisationStatusRelationship>
                    {
                        new OrganisationStatusRelationship
                        {
                            OrganisationStatus = r.ParseEnum<OrganisationStatusRelationshipOrganisationStatus>("OrgStatus"),
                            OrganisationStatusScheme = r.ParseEnum<OrganisationStatusRelationshipOrganisationStatusScheme>("OrgStatusScheme")
                        }
                    }
                },
                Allocation = new AllocationAttrsCT
                {
                    AllocationNumber = r["AllocRef"],
                    VersionNumber = r.ParseInt("Version"),
                    ProcurementAttrs = new ProcurementAttrsCT
                    {
                        TenderSpecReference = r.ParseNullableString("TenderSpecRef"),
                        TenderSpecTitle = r.ParseNullableString("TenderSpecTitle"),
                        LotReference = r.ParseNullableString("LotRef"),
                        LotSpecificationTitle = r.ParseNullableString("LotSpec"),
                        AwardReference = r.ParseNullableString("AwardRef"),
                        ActivityDescription = r.ParseNullableString("ActivityDescription"),
                        InvestmentPriority = r.ParseNullableString("InvestmentPriority"),
                        LEPCode = r.ParseNullableString("LEPCode"),
                        LEPName = r.ParseNullableString("LEPName"),
                        RegionType = r.ParseNullableString("RegionType"),
                        AgreementNumber = r.ParseNullableString("AgreementNumber"),
                        LearningRatePremium = r.ParseNullableDecimal("LearningRatePremium") ?? 0
                    }
                },
                SubnominalCode = r["Subnominal"],
                SubnominalDescription = r["SubnominalDescription"],
                AggregatedValue = r.ParseDecimal("AggregatedValue"),
                PaymentType = r.ParseEnum<PaymentDetailPaymentType>("PaymentType")
                
            }).ToList();

            PaymentPeriod paymentPeriod = _paymentAtomFeedItemUnderTest.GetContent<PaymentPeriod>();

            expectedPaymentDetails.ForEach(expectedPaymentDetail =>
            {
                var expectedAltOrgId = expectedPaymentDetail.Organisation.AlternateOrganisationIdentifiers[0].AlternateOrganisationIdentifier;

                var paymentDetail = paymentPeriod.PaymentDetails.SingleOrDefault(pd =>
                    pd.SubnominalCode == expectedPaymentDetail.SubnominalCode
                    && pd.PaymentType == expectedPaymentDetail.PaymentType
                    && pd.Organisation.AlternateOrganisationIdentifiers[0].AlternateOrganisationIdentifier == expectedAltOrgId);

                ClassicAssert.IsNotNull(paymentDetail, $"The Subnominal with code {expectedPaymentDetail.SubnominalCode} and payment type {expectedPaymentDetail.PaymentType} for organisation {expectedAltOrgId} is not present");

                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.VersionNumber, paymentDetail.Allocation.VersionNumber, $"The version number of the Allocation {expectedPaymentDetail.Allocation.AllocationNumber} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Organisation.OrganisationId, paymentDetail.Organisation.OrganisationId, $"The OrgId for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Organisation.AlternateOrganisationIdentifiers[0].AlternateOrganisationIdentifier, paymentDetail.Organisation.AlternateOrganisationIdentifiers[0].AlternateOrganisationIdentifier, $"The AlternateOrgId for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Organisation.AlternateOrganisationIdentifiers[0].AlternateOrganisationIdentifierName, paymentDetail.Organisation.AlternateOrganisationIdentifiers[0].AlternateOrganisationIdentifierName, $"The AlternateOrgIdName for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Organisation.OrganisationStatusRelationships[0].OrganisationStatusScheme, paymentDetail.Organisation.OrganisationStatusRelationships[0].OrganisationStatusScheme, $"The OrganisationStatusScheme for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Organisation.OrganisationStatusRelationships[0].OrganisationStatus, paymentDetail.Organisation.OrganisationStatusRelationships[0].OrganisationStatus, $"The OrganisationStatus for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                Func<PaymentDetail, string> getTenderSpecReference = e =>
                    paymentDetail.Allocation.ProcurementAttrs.TenderSpecReference;
                ClassicAssert.Equals(getTenderSpecReference(expectedPaymentDetail), getTenderSpecReference(paymentDetail));

                ClassicAssert.AreEqual(getTenderSpecReference(expectedPaymentDetail), getTenderSpecReference(paymentDetail), $"The TenderSpecReference for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.TenderSpecTitle, paymentDetail.Allocation.ProcurementAttrs.TenderSpecTitle, $"The TenderSpecTitle for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.LotReference, paymentDetail.Allocation.ProcurementAttrs.LotReference, $"The LotReference for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.LotSpecificationTitle, paymentDetail.Allocation.ProcurementAttrs.LotSpecificationTitle, $"The LotSpecificationTitle for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.AwardReference, paymentDetail.Allocation.ProcurementAttrs.AwardReference, $"The AwardReference for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.ActivityDescription, paymentDetail.Allocation.ProcurementAttrs.ActivityDescription, $"The ActivityDescription for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.InvestmentPriority, paymentDetail.Allocation.ProcurementAttrs.InvestmentPriority, $"The InvestmentPriority for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.LEPCode, paymentDetail.Allocation.ProcurementAttrs.LEPCode, $"The LEPCode for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.LEPName, paymentDetail.Allocation.ProcurementAttrs.LEPName, $"The LEPName for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.RegionType, paymentDetail.Allocation.ProcurementAttrs.RegionType, $"The RegionType for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.AgreementNumber, paymentDetail.Allocation.ProcurementAttrs.AgreementNumber, $"The AgreementNumber for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.Allocation.ProcurementAttrs.LearningRatePremium, paymentDetail.Allocation.ProcurementAttrs.LearningRatePremium, $"The LearningRatePremium for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.SubnominalCode, paymentDetail.SubnominalCode, $"The SubnominalCode for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.SubnominalDescription, paymentDetail.SubnominalDescription, $"The SubnominalDescription for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
                ClassicAssert.AreEqual(expectedPaymentDetail.AggregatedValue, paymentDetail.AggregatedValue, $"The AggregatedValue for Subnominal {expectedPaymentDetail.SubnominalCode} is not correct");
            });

            ClassicAssert.IsNotNull(paymentPeriod, "paymentPeriod variable not set");
        }

        [Then(@"the Payment feed item PaymentPeriod details are as follows")]
        public void ThenThePaymentFeedItemPaymentPeriodInfoIsAsFollows(Table table)
        {
            var expectedPaymentPeriod = table.Rows.Select(r => new PaymentPeriod
            {
                Agency = r["Agency"],
                FundingStreamShortCode = r["FSSC"],
                FundingStreamPeriodStartDate = r.ParseDate("FSPStartDate"),
                FundingStreamPeriodEndDate = r.ParseDate("FSPEndDate"),
                CensusEndDate = r.ParseDate("CensusEndDate"),
                DueDate = r.ParseDate("DueDate"),
                FinancialPaymentFinancialYear = r["FinancialYear"],
                FinancialPaymentFinancialMonth = r["FinancialMonth"]
            }).Single();

            PaymentPeriod paymentPeriod = _paymentAtomFeedItemUnderTest.GetContent<PaymentPeriod>();

            ClassicAssert.AreEqual(expectedPaymentPeriod.Agency, paymentPeriod.Agency, "The Agency is not correct");
            ClassicAssert.AreEqual(expectedPaymentPeriod.FundingStreamShortCode, paymentPeriod.FundingStreamShortCode, "The FundingStreamShortCode is not correct");
            ClassicAssert.AreEqual(expectedPaymentPeriod.FundingStreamPeriodStartDate, paymentPeriod.FundingStreamPeriodStartDate, "The FundingStreamPeriodStartDate is not correct");
            ClassicAssert.AreEqual(expectedPaymentPeriod.FundingStreamPeriodEndDate, paymentPeriod.FundingStreamPeriodEndDate, "The FundingStreamPeriodEndDate is not correct");
            ClassicAssert.AreEqual(expectedPaymentPeriod.CensusEndDate, paymentPeriod.CensusEndDate, "The CensusEndDate is not correct");
            ClassicAssert.AreEqual(expectedPaymentPeriod.DueDate, paymentPeriod.DueDate, "The DueDate is not correct");
            ClassicAssert.AreEqual(expectedPaymentPeriod.FinancialPaymentFinancialYear, paymentPeriod.FinancialPaymentFinancialYear, "The FinancialPaymentFinancialYear is not correct");
            ClassicAssert.AreEqual(expectedPaymentPeriod.FinancialPaymentFinancialMonth, paymentPeriod.FinancialPaymentFinancialMonth, "The FinancialPaymentFinancialMonth is not correct");
        }
        
        [Given(@"the subnominal codes on the following PaaS SubnominalAggregation rows have been amended")]
        public void GivenTheSubnominalCodesOnTheFollowingPaaSSubnominalAggregationRowsHaveBeenAmended(TransformedTable table)
        {
            table.Rows.ForEach(r =>
                SubnominalAggregationRepository.ChangeSubnominalAggregationSubnominalCode(
                    r["AllocationNumber"],
                    r["Period"],
                    r["SubnominalCode"],
                    r["PaymentType"],
                    r["AmendSubnominalTo"])
                              );
        }

        [Given(@"the subnominal information in the SubnominalAggregateKey, Code and SubnominalCode on the following CRM Subnominal Aggregations rows have been amended")]
        public void GivenTheSubnominalInformationInTheSubnominalAggregateKeyCodeAndSubnominalCodeOnTheFollowingCRMSubnominalAggregationsRowsHaveBeenAmended(TransformedTable table)
        {
            table.Rows.ForEach(r =>
                CrmSubnominalAggregationRepository.ChangeSubnominalAggregationSubnominalCode(
                r["FundingStreamPeriodCode"],
                r["SubnominalAggregateKey"],
                r["AmendSubnominalTo"],
                r["PaymentType"]));
        }

        [Given(@"that '(.*)' Subnominal Aggregation exists in the data store \(cloned from the record below\)")]
        public void GivenThatSubnominalAggregationExistsInTheDataStore(int p0, Table table)
        {
            var payments = new List<Payment>();

            var rowToCopy = table.Rows[0];

            var ukprn = int.Parse(rowToCopy["UKPRN"]);
            var orgIdIntegerPart = int.Parse(rowToCopy["Org ID"].Substring(3));
            var allocationNumberPrefix = rowToCopy["Allocation Number"].Substring(0, 4);
            var allocationNumberIntegerPart = int.Parse(rowToCopy["Allocation Number"].Substring(5));
            var subnominalCode = rowToCopy["Subnominal Code"];
            var fundingStreamPeriodCode = rowToCopy["Funding Stream Period Code"];
            var calendarPeriod = rowToCopy["Calendar Year/Period"];
            var paymentType = rowToCopy["Payment Type"];
            var aggregatedValue = decimal.Parse(rowToCopy["AggregatedValue"]);

            for (var i = 0; i < p0; i++)
            {
                payments.Add(new Payment
                {
                    AllocationNumber = string.Format(allocationNumberPrefix + "-{0:00}", allocationNumberIntegerPart),
                    AggregatedValue = aggregatedValue,
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    Ukprn = ukprn,
                    Period = calendarPeriod,
                    SubnominalCode = subnominalCode,
                    SubnominalType = paymentType,
                    OrganisationId = $"ORG{orgIdIntegerPart:0000000}",
                    VersionNumber = 0
                });
                allocationNumberIntegerPart++;
                orgIdIntegerPart++;
            }

            PaymentGenerationDataStore.CreatePayments(payments);
        }


        [When(@"a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '([^']*)'")]
        public void WhenThereIsAGrantPaymentSummaryCreatedInSharepointForThisDate(string dateString)
        {
            var date = DateTime.ParseExact(dateString, "dd/MM/yyyy", null);
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            const string containerRoot = "fcs-payment-report";

            string fileName = $"{date.Year}-{date.Month:D2} Grant funding.xlsx";

            string containerName = $"{containerRoot}{AzureBlobStorageHelper.GetEnvironmentSuffix()}";

            AzureBlobStorageHelper.DeleteBlobIfExists(containerName, fileName);

            OverrideDateRepository.SetDate(date);

            MessageSendingBus.Send(destinationEndpointName: "Operations.PaymentSummary", message: new CreatePaymentSummaryReportCommand());
        }

        [When(@"a Consolidated Payment Summary Report is created in Sharepoint for '([^']*)'")]
        public void WhenThereIsAPaymentSummaryCreatedInSharepointForThisDate(string dateString)
        {
            var date = DateTime.ParseExact(dateString, "dd/MM/yyyy", null);
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            const string containerRoot = "fcs-payment-report";

            string fileName = $"{date.Year}-{date.Month:D2} Payments.xlsx";

            string containerName = $"{containerRoot}{AzureBlobStorageHelper.GetEnvironmentSuffix()}";
            
            AzureBlobStorageHelper.DeleteBlobIfExists(containerName, fileName);
            
            OverrideDateRepository.SetDate(date);

            MessageSendingBus.Send(destinationEndpointName:"Operations.PaymentSummary", message: new CreatePaymentSummaryReportCommand());
        }

        private static void ClassicAssertPaymentPeriodsAreEqual(PaymentPeriod expected, PaymentPeriod actual)
        {
            // top level: 
            ClassicAssert.AreEqual(expected.FundingStreamShortCode, actual.FundingStreamShortCode, "Funding Stream Short Code did not match");
            ClassicAssert.AreEqual(expected.FinancialPaymentFinancialYear, actual.FinancialPaymentFinancialYear, "Financial Year did not match");
            ClassicAssert.AreEqual(expected.FinancialPaymentFinancialMonth, actual.FinancialPaymentFinancialMonth, "Financial Month did not match");
            ClassicAssert.AreEqual(expected.CensusEndDate, actual.CensusEndDate, "Census End Date did not match");
            ClassicAssert.AreEqual(expected.DueDate, actual.DueDate, "Due Date did not match");
            ClassicAssert.AreEqual(expected.FundingStreamPeriodStartDate, actual.FundingStreamPeriodStartDate, "FSP Start Date did not match");
            ClassicAssert.AreEqual(expected.FundingStreamPeriodEndDate, actual.FundingStreamPeriodEndDate, "FSP End Date did not match");

            expected.PaymentDetails.ForEach(e =>
            {
                Func<PaymentDetail, string> getUkprn = pd =>
                    pd.Organisation.AlternateOrganisationIdentifiers.Single(o =>
                            o.AlternateOrganisationIdentifierName ==
                            OrganisationIdentifierAlternateOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER)
                        .AlternateOrganisationIdentifier;

                ClassicAssert.IsTrue(null != actual.PaymentDetails.SingleOrDefault(a => 
                                  e.Allocation.AllocationNumber == a.Allocation.AllocationNumber
                               && e.Allocation.ProcurementAttrs?.AgreementNumber == a.Allocation.ProcurementAttrs?.AgreementNumber
                               && e.Allocation.ProcurementAttrs?.LEPCode == a.Allocation.ProcurementAttrs?.LEPCode
                               && e.AggregatedValue == a.AggregatedValue
                               && e.PaymentType == a.PaymentType
                               && e.SubnominalDescription == a.SubnominalDescription
                               && e.SubnominalCode == a.SubnominalCode
                               && getUkprn(e) == getUkprn(a)),
                    $"Could not find Payment Detail with values: AllocNum: {e.Allocation.AllocationNumber}, AgreementNo: {e.Allocation.ProcurementAttrs?.AgreementNumber}, LEPCode: {e.Allocation.ProcurementAttrs?.LEPCode}, Value: {e.AggregatedValue}, PayType: {e.PaymentType.ToString()}, Subnominal: {e.SubnominalCode}, SubnomDesc: {e.SubnominalDescription}, UKPRN: {getUkprn(e)}");
            });
        }

        private class Summary
        {
            public string FundingStreamPeriod { get; }

            public string PaymentPeriod { get; }

            public DateTime CensusEndDate { get; }

            public int PaymentLineCount { get; }

            public decimal TotalValue { get; }

            public Summary(string fundingStreamPeriod, string paymentPeriod, DateTime censusEndDate, int paymentLineCount, decimal totalValue)
            {
                FundingStreamPeriod = fundingStreamPeriod;
                PaymentPeriod = paymentPeriod;
                CensusEndDate = censusEndDate;
                PaymentLineCount = paymentLineCount;
                TotalValue = totalValue;
            }
        }
    }  
}