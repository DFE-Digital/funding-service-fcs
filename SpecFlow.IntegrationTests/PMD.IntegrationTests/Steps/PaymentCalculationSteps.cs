namespace PMD.IntegrationTests.Steps
{
    extern alias Entity;
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using Extensions;
    //using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NUnit.Framework;
    using PageObjects;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using TechTalk.SpecFlow;
    using DeliveryAllocation = Entity::SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    [Binding]
    public sealed class PaymentCalculationSteps
    {
        private PaymentCalculationPageObject paymentPageObject;
        private DeliveryAllocation.allocationType _deliveryCommencedAllocation;

        [Given(@"there is no payment schedule data for contract '(.*)' version '(.*)'")]
        [Given(@"there is no contract '(.*)' version '(.*)'")]
        public void GivenThereIsNoPaymentScheduleDataForContractVersion(string contractNumber, string version)
        {
            paymentPageObject = new PaymentCalculationPageObject(contractNumber, int.Parse(version));
            paymentPageObject.ClearContractData();
        }

        [Given(@"the approved contract allocations details for the latest version of the contract are as follows")]
        public void GivenTheApprovedContractAllocationsDetailsForTheLatestVersionOfTheContractAreAsFollows(Table table)
        {
            List<ExtendedAllocation> allocations = TransformTableToExtendedAllocations(table);

            paymentPageObject.AddContractAllocations(allocations);
        }

        private List<ExtendedAllocation> TransformTableToExtendedAllocations(Table table)
        {
            var allocations = new List<ExtendedAllocation>();

            foreach (TableRow row in table.Rows)
            {
                var allocation = new ExtendedAllocation()
                {
                    Allocation = new Allocation
                    {
                        ContractNumber = row["ContractNumber"],
                        AllocationNumber = row["AllocationRef"],
                        FundingStreamPeriodCode = row["FundingStreamPeriodCode"],
                        ContractVersionNumber = paymentPageObject.ContractVersion,
                        VersionNumber = paymentPageObject.ContractVersion,
                        AllocationStartDate = DateTime.ParseExact(row["AllocationStartDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                        AllocationEndDate = DateTime.ParseExact(row["AllocationEndDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                    },

                    FundingStreamPeriodType = row["FundingStreamPeriodType"]
                };

                if (row.ContainsKey("EsfRegionType"))
                {
                    allocation.EsfData = new ExtendedAllocation.EsfAllocationData
                    {
                        RegionType = row["EsfRegionType"],
                        InvestmentPriority = row["EsfInvestmentPriority"]
                    };
                }

                allocations.Add(allocation);
            }

            return allocations;
        }

        [Given(@"the contract deliverables details for the latest version of the contract are as follows")]
        public void GivenTheContractDeliverablesDetailsForTheLatestVersionOfTheContractAreAsFollows(Table table)
        {
            var payments = ConstructDeliverablePayments(table);
            paymentPageObject.AddPlannedDeliverablePayments(payments);
        }

        private List<DeliverableCodePayments> ConstructDeliverablePayments(Table table)
        {
            var payments = new List<DeliverableCodePayments>();
            foreach (var row in table.Rows)
            {
                var deliverableCode = int.Parse(row["DeliverableCode"]);
                DeliverableCodePayments deliverablePayments = new DeliverableCodePayments
                {
                    DeliverableCode = deliverableCode,
                };

                var parentCode = row["ParentDeliverableCode"];
                if (!string.IsNullOrWhiteSpace(parentCode) && parentCode != "0" && parentCode != "?")
                {
                    deliverablePayments.ParentDeliverableCode = int.Parse(parentCode);
                }

                for (int i = 3; i < row.Keys.Count; i++)
                {
                    DateTime dt;
                    var period = row.Keys.ElementAt(i);
                    if (DateTime.TryParse("01-" + period, out dt))// && row[i] != "?")
                    {
                        var payment = new DeliverablePayment
                        {
                            AllocationNumber = row["AllocationRef"],
                            DeliverableCode = deliverableCode,
                            Period = dt.ToString("yyyyMM"),
                            PeriodTypeCode = PeriodTypeCode.CM,
                            VersionNumber = paymentPageObject.ContractVersion
                        };

                        if (row[i] != "?")
                        {
                            payment.PlannedValue = decimal.Parse(row[i]);
                        }

                        deliverablePayments.Payments.Add(payment);
                    }
                }

                payments.Add(deliverablePayments);
            }

            return payments.OrderBy(p => p.DeliverableCode).ToList();
        }

        [Given(@"the draft contract allocations details for the latest version of the contract are as follows")]
        public void GivenTheDraftContractAllocationsDetailsForTheLatestVersionOfTheContractAreAsFollows(Table table)
        {
            TableRow row = table.Rows.Single();

            _deliveryCommencedAllocation = new DeliveryAllocation.allocationType
            {
                contractReference = new DeliveryAllocation.contractReferenceType
                {
                    contractNumber = row["ContractNumber"],
                    contractVersionNumber = 1,
                    contractSubVersionNumber = 0
                },
                contractorReference = new DeliveryAllocation.organisationReferenceType
                {
                    organisationIdentifier = $"ORG{row["UKPRN"]}",
                    alternativeOrganisationIdentifiers = new List<DeliveryAllocation.alternativeOrganisationIdentifierType>
                    {
                        new DeliveryAllocation.alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = row["UKPRN"],
                            OrganisationIdentifierName = DeliveryAllocation.alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                contractAllocationNumber = row["AllocationRef"],
                startDate = row.ParseDate("AllocationStartDate"),
                endDate = row.ParseDate("AllocationEndDate"),
                fundingStreamPeriod = new DeliveryAllocation.allocationTypeFundingStreamPeriod
                {
                    fundingStreamPeriodCode = row["FundingStreamPeriodCode"],
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType
                        {
                            periodTypeCode = row.ParseEnum<DeliveryAllocation.periodTypeCodeType>("FundingStreamPeriodType")
                        }
                    }
                }
            };

            List<ExtendedAllocation> allocations = TransformTableToExtendedAllocations(table);
            paymentPageObject.SetContractAllocations(allocations);
        }

        [Given(@"the draft deliverable details for the latest version of the contract are as follows")]
        public void GivenTheDraftDeliverableDetailsForTheLatestVersionOfTheContractAreAsFollows(Table table)
        {
            Assert.IsNotNull(_deliveryCommencedAllocation, $"{nameof(_deliveryCommencedAllocation)} variable not set");

            var topLevelDeliverableRows = table.Rows
                .Where(row => row.ParseInt("ParentDeliverableCode") == 0)
                .ToList();

            _deliveryCommencedAllocation.contractDeliverables = topLevelDeliverableRows
                .Select(ToContractDeliverableType)
                .ToList();

            DeliveryAllocation.contractDeliverableType ToContractDeliverableType(TableRow row)
            {
                return new DeliveryAllocation.contractDeliverableType
                {
                    deliverable = new DeliveryAllocation.deliverableType
                    {
                        deliverableCode = row.ParseInt("DeliverableCode")
                    },
                    contractDeliverables = table.Rows
                        .Where(possibleChildRow => possibleChildRow.ParseInt("ParentDeliverableCode") == row.ParseInt("DeliverableCode"))
                        .Select(ToContractDeliverableType)
                        .ToList(),
                    contractDeliverablePeriods = row.GetPeriodValues().Select(periodValue => new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                    {
                        period = new DeliveryAllocation.periodType
                        {
                            periodType1 = new DeliveryAllocation.periodTypeType
                            {
                                periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM,
                                periodTypeName = DeliveryAllocation.periodTypeNameType.CALENDARMONTH
                            },
                            periodValue = periodValue.PeriodAsYYYYMM
                        },
                        plannedValue = periodValue.Value.Value
                    }).ToList()
                };
            }
        }

        [When(@"the contract is approved")]
        public void WhenTheContractIsApproved()
        {
            Assert.IsNotNull(_deliveryCommencedAllocation, $"{nameof(_deliveryCommencedAllocation)} variable not set");

            paymentPageObject.HandleAllocationDeliveryCommencedEvent(_deliveryCommencedAllocation);
        }

        [Then(@"The following Summarised Actuals for period '(.*)' for collection type '(.*)' are processed")]
        [When(@"The following Summarised Actuals for period '(.*)' for collection type '(.*)' are processed")]
        public void WhenTheFollowingSummarisedActualsForPeriodForCollectionTypeAreProcessed(string collectionReturnCode, string collectionType, Table table)
        {
            paymentPageObject.CollectionReturnCode = collectionReturnCode;
            paymentPageObject.CollectionType = collectionType;
            paymentPageObject.SetupContractAllocationActualsType(table);
            paymentPageObject.CalculatePayments();
        }

        [Then(@"The following Summarised Actuals for period '(.*)' for collection type '(.*)' are processed without aggregations")]
        [When(@"The following Summarised Actuals for period '(.*)' for collection type '(.*)' are processed without aggregations")]
        public void WhenTheFollowingSummarisedActualsForPeriodForCollectionTypeAreProcessedWithoutAggregations(string collectionReturnCode, string collectionType, Table table)
        {
            paymentPageObject.CollectionReturnCode = collectionReturnCode;
            paymentPageObject.CollectionType = collectionType;
            paymentPageObject.SetupContractAllocationActualsType(table);
            paymentPageObject.CalculatePayments(false);
        }

        [Then(@"the contract is amended as follows")]
        [When(@"the contract is amended as follows")]
        public void ThenTheContractIsAmendedAsFollows(Table table)
        {
            var payments = ConstructDeliverablePayments(table);
            paymentPageObject.ApproveAmendedContract(payments);
        }

        [Then(@"the Reconciliation Data is calculated as follows")]
        [Then(@"the Reconciliation Payments are calculated as follows")]
        public void ThenTheReconciliationDataIsCalculatedAsFollows(Table table)
        {
            paymentPageObject.CheckCalculations(CalculationType.Reconcilliation, ConstructExpectedAmountsFromTable(table, "DeliverableCode"));
        }

        [Then(@"the Capping Amounts are calculated as follows")]
        [Then(@"the Capping Payments are calculated as follows")]
        public void ThenTheCappingAmountsAreCalculatedAsFollows(Table table)
        {
            paymentPageObject.CheckCalculations(CalculationType.Capping, ConstructExpectedAmountsFromTable(table, "DeliverableCode"));
        }
        
        [Then(@"the Net Payments are calculated as follows")]
        public void ThenTheNetPaymentsAreCalculatedAsFollows(Table table)
        {
            paymentPageObject.CheckCalculations(CalculationType.Net, ConstructExpectedAmountsFromTable(table, "DeliverableCode"));

        }

        [Then(@"the Profile Payments are calculated as follows")]
        public void ThenTheProfilePaymentsAreCalculatedAsFollows(Table table)
        {
            paymentPageObject.CheckCalculations(CalculationType.Profile, ConstructExpectedAmountsFromTable(table, "DeliverableCode"));
        }

        [Then(@"the Balancing Payments are calculated as follows")]
        public void ThenTheBalancingPaymentsAreCalculatedAsFollows(Table table)
        {
            paymentPageObject.CheckCalculations(CalculationType.Balancing, ConstructExpectedAmountsFromTable(table, "DeliverableCode"));
        }

        [Then(@"the Capping Subnominal Amounts are calculated as follows")]
        public void ThenTheCappingSubnominalAmountsAreCalculatedAsFollows(Table table)
        {
            paymentPageObject.CheckAggregations(Entity::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.AggregationPaymentType.CAPPING, ConstructExpectedAmountsFromTable(table, "CappingSubnominal"));
        }

        [Then(@"the Reconciliation Subnominal Amounts are calculated as follows")]
        public void ThenTheReconciliationSubnominalAmountsAreCalculatedAsFollows(Table table)
        {
            paymentPageObject.CheckAggregations(Entity::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.AggregationPaymentType.RECONCILIATION, ConstructExpectedAmountsFromTable(table, "ReconciliationSubnominal"));
        }

        [Given(@"the previously calculated reconcillation amounts are as follows")]
        public void GivenThePreviouslyCalculatedReconcillationAmountsAreAsFollows(Table table)
        {
            var amounts = ConstructExpectedAmountsFromTable(table, "DeliverableCode", false);
            paymentPageObject.UpdatePaymentSchedule(CalculationType.Reconcilliation, amounts);
        }

        [Given(@"the previously calculated net amounts are as follows")]
        public void GivenThePreviouslyCalculatedNetAmountsAreAsFollows(Table table)
        {
            var amounts = ConstructExpectedAmountsFromTable(table, "DeliverableCode", false);
            paymentPageObject.UpdatePaymentSchedule(CalculationType.Net, amounts);
        }

        [Then(@"the override date is '(.*)'")]
        [Given(@"the override date is '(.*)'")]
        public void GivenTheOverrideDateIs(string overrideDate)
        {
            paymentPageObject.SetOverrideDate(overrideDate);
        }

        [Then(@"the override date is reset")]
        public void ThenTheOverrideDateIsReset()
        {
            paymentPageObject.ResetOverrideDate();
        }

        [Given(@"the override date it empty for '(.*)'")]
        public void GivenTheOverrideDateItEmptyFor(string businessKey)
        {
            paymentPageObject.ResetOverrideDate();
        }

        [Given(@"the config settings are")]
        [Then(@"the config settings are")]
        public void GivenTheConfigSettingsAre(Table table)
        {
            paymentPageObject.SetPayCalcConfigSettings(table);
        }

        [AfterScenario("PMDIntegration")]
        public void CleanUp()
        {
        }

        private static List<CalculatedAmount> ConstructExpectedAmountsFromTable(Table table, string codeHeading, bool includeNullValues = true)
        {
            var expectedAmounts = new List<CalculatedAmount>();
            foreach (var row in table.Rows)
            {
                var periodAmounts = new CalculatedAmount
                {
                    AllocationNumber = row["AllocationRef"],
                    DeliverableOrSubnominalCode = int.Parse(row[codeHeading]),
                    ContractNumber = row["ContractNumber"]
                };
                for (int i = 3; i < row.Keys.Count; i++)
                {

                    DateTime dt;
                    var period = row.Keys.ElementAt(i);
                    if (DateTime.TryParseExact(period, "MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    {
                        var periodAmount = new PeriodAmount
                        {
                            Period = dt.ToString("yyyyMM"),
                        };

                        if (row[i] != "?")
                            periodAmount.Amount = decimal.Parse(row[i]);

                        if (periodAmount.Amount.HasValue || includeNullValues)
                        {
                            periodAmounts.Amounts.Add(periodAmount);
                        }
                    }
                }

                expectedAmounts.Add(periodAmounts);
            }

            return expectedAmounts;
        }
    }
}
