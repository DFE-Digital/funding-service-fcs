namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Text.RegularExpressions;
    using Infrastructure.Services;
    using TechTalk.SpecFlow;
    using Xrm.TestFramework;

    [Binding]
    public class ContractReviewSteps
    {
        [Given(@"I am logged in as a Contract Adviser '(.*)' in the system")]
        public void GivenIAmLoggedInAsAContractAdviserInTheSystem(string p0)
        {
            // Covered as part of next step
        }

        [Given(@"a contract exists with multiple contract allocations")]
        public void GivenAContractExistsWithMultipleContractAllocations()
        {
            // Covered as part of next step
        }

        [When(@"I am on Contract Details page")]
        public void WhenIAmOnContractDetailsPage()
        {
            var associatedView =
                XrmService.Configuration.Entity("sfa_contractallocation")
                    .DefaultView()
                    .ViewId;

                XrmService.Configuration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                    .HasTab("tabGeneral")
                    .HasSubGridWithView(associatedView.ToUpperInvariant());
        }

        [Then(@"Contract Allocation Summary should be displayed in a table as follows")]
        public void ThenContractAllocationSummaryShouldBeDisplayedInATableAsFollows(Table table)
        {
            var defaultView = XrmService.Configuration.Entity("sfa_contractallocation").DefaultView();

            Regex regex = new Regex(@"[[A-Z]*[a-z]*[\s]*]*[[A-Z]*[a-z]*]*[\s]\<[[A-Z]*[a-z]*[\s]*]*[[A-Z]*[a-z]*]*\>");
                        
            foreach (var c in table.Header)
            {
                string columnName;

                if (regex.IsMatch(c))
                {
                    string trimmedColName = c.Split(new char[] { '<', '>' })[1];

                    var parentEntityLogicalName = XrmService.Configuration.Entity(c.Substring(0, c.LastIndexOf('<' + trimmedColName + '>')).TrimEnd()).LogicalName;

                    var childEntityLogicalName = XrmService.Configuration.Entity(trimmedColName).LogicalName;

                    columnName = XrmService.Configuration.Entity(parentEntityLogicalName)
                        .Relationship(childEntityLogicalName)
                        .LogicalName;
                }
                else
                {
                    columnName = c;
                }

                defaultView.HasColumn(columnName);
            }                
        }

        [Then(@"the column is sorted by Contract allocation reference and Start date")]
        public void ThenTheColumnIsSortedByContractAllocationReferenceAndStartDate()
        {
            XrmService.Configuration.Entity("sfa_contractallocation").DefaultView()
                .HasSortColumn("sfa_contractallocationnumber", XrmSortOrder.Ascending)
                .HasSortColumn("sfa_startdate", XrmSortOrder.Ascending);
        }

        [When(@"I select a contract allocation")]
        public void WhenISelectAContractAllocation()
        {
            var associatedView =
               XrmService.Configuration.Entity("sfa_contractdeliverable")
                   .DefaultView()
                   .ViewId;

            XrmService.Configuration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .HasTab("tabGeneral")
                .HasSubGridWithView(associatedView.ToUpperInvariant());
        }

        [Then(@"details of Contract Allocation view should be displayed with following fields:")]
        public void ThenDetailsOfContractAllocationViewShouldBeDisplayedWithFollowingFields(Table table)
        {
           var mainAllocationForm = XrmService.Configuration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main);
           var quickViewContractDetailsForm = XrmService.Configuration.Entity("sfa_contract").Form("Contract Details", XrmFormType.QuickView);
           var quickViewContractStatusesForm = XrmService.Configuration.Entity("sfa_contract").Form("Contract Statuses", XrmFormType.QuickView);

           foreach (var row in table.Rows) 
           {
               if (row["Source"] == "Allocation")
               {
                   mainAllocationForm.Field(row["Field"]);
               }
               else
               {
                   try
                   {
                       quickViewContractDetailsForm.Field(row["Field"]);
                   }
                   catch (Exception)
                   {
                       Console.WriteLine("Field was not on the Contract Details Quick View Form, checking Contract Statuses");
                       quickViewContractStatusesForm.Field(row["Field"]);
                   }
               }
           }
        }
        
        [Then(@"Deliverables Summary should be displayed in a table as follows")]
        public void ThenDeliverablesSummaryShouldBeDisplayedInATableAsFollows(Table table)
        {
            var defaultView = XrmService.Configuration.Entity("sfa_contractdeliverable").DefaultView();

            Regex regex = new Regex(@"[[A-Z]*[a-z]*[\s]*]*[[A-Z]*[a-z]*]*[\s]\<[[A-Z]*[a-z]*[\s]*]*[[A-Z]*[a-z]*]*\>");

            foreach (var c in table.Header)
            {
                string columnName;

                if (regex.IsMatch(c))
                {
                    string trimmedColName = c.Split(new char[] { '<', '>' })[1];

                    var parentEntityLogicalName = XrmService.Configuration.Entity(c.Substring(0, c.LastIndexOf('<' + trimmedColName + '>')).TrimEnd()).LogicalName;

                    var childEntityLogicalName = XrmService.Configuration.Entity(trimmedColName).LogicalName;

                    columnName = XrmService.Configuration.Entity(parentEntityLogicalName)
                        .Relationship(childEntityLogicalName)
                        .LogicalName;
                }
                else
                {
                    columnName = c;
                }

                defaultView.HasColumn(columnName);
            } 
        }

        [Then(@"Deliverable Summary is sorted by column Display Order \(D\)")]
        public void ThenDeliverableSummaryIsSortedByColumnDisplayOrderD()
        {
            XrmService.Configuration.Entity("sfa_contractdeliverable").DefaultView()
                .HasSortColumn("sfa_displayorder", XrmSortOrder.Ascending);
        }

        [Given(@"I am on a Contract Allocation details page")]
        public void GivenIAmOnAContractAllocationDetailsPage()
        {
            // Covered as part of next step
        }

        [Given(@"the Contract Allocation is associated with multiple Deliverables")]
        public void GivenTheContractAllocationIsAssociatedWithMultipleDeliverables()
        {
            // Covered as part of next step
        }

        [When(@"I select a Deliverable")]
        public void WhenISelectADeliverable()
        {
            var associatedView =
            XrmService.Configuration.Entity("sfa_contractdeliverableperiod")
                .DefaultView()
                .ViewId;

            XrmService.Configuration.Entity("sfa_contractdeliverable").Form("Information", XrmFormType.Main)
                .HasTab("tabGeneral")
                .HasSubGridWithView(associatedView.ToUpperInvariant());
        }

        [Then(@"details of Deliverable is displayed with following fields:")]
        public void ThenDetailsOfDeliverableIsDisplayedWithFollowingFields(Table table)
        {
            var mainDeliverableForm = XrmService.Configuration.Entity("sfa_contractdeliverable").Form("Information", XrmFormType.Main);
            var mainAllocationForm = XrmService.Configuration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main);
            var quickViewContractDetailsForm = XrmService.Configuration.Entity("sfa_contract").Form("Contract Details", XrmFormType.QuickView);
            var quickViewContractStatusesForm = XrmService.Configuration.Entity("sfa_contract").Form("Contract Statuses", XrmFormType.QuickView);
            var quickViewFspDeliverableSettingsForm =
                XrmService.Configuration.Entity("sfa_fundingstreamperioddeliverable").Form("Funding Stream Period Deliverable Settings", XrmFormType.QuickView);

            foreach (var row in table.Rows)
            {
                switch (row["Source"])
                {
                    case "Allocation":
                        mainAllocationForm.Field(row["Field"]);
                        break;
                    case "Deliverable":
                        mainDeliverableForm.Field(row["Field"]);
                        break;
                    case "FSP Deliverable":
                        quickViewFspDeliverableSettingsForm.Field(row["Field"]);
                        break;
                    default:
                        try
                        {
                            quickViewContractDetailsForm.Field(row["Field"]);
                        }
                        catch (Exception)
                        {
                            Console.WriteLine(@"Field was not on the Contract Details Quick View Form, checking Contract Statuses");
                            quickViewContractStatusesForm.Field(row["Field"]);
                        }
                        break;
                }
            }
        }

        [Then(@"Deliverables Values should be displayed in a table as follows")]
        public void ThenDeliverablesValuesShouldBeDisplayedInATableAsFollows(Table table)
        {
            var defaultView = XrmService.Configuration.Entity("sfa_contractdeliverableperiod").DefaultView();

            Regex regex = new Regex(@"[[A-Z]*[a-z]*[\s]*]*[[A-Z]*[a-z]*]*[\s]\<[[A-Z]*[a-z]*[\s]*]*[[A-Z]*[a-z]*]*\>");

            foreach (var c in table.Header)
            {
                string columnName;

                if (regex.IsMatch(c))
                {
                    string trimmedColName = c.Split(new char[] { '<', '>' })[1];

                    var parentEntityLogicalName = XrmService.Configuration.Entity(c.Substring(0, c.LastIndexOf('<' + trimmedColName + '>')).TrimEnd()).LogicalName;

                    var childEntityLogicalName = XrmService.Configuration.Entity(trimmedColName).LogicalName;

                    columnName = XrmService.Configuration.Entity(parentEntityLogicalName)
                        .Relationship(childEntityLogicalName)
                        .LogicalName;
                }
                else
                {
                    columnName = c;
                }

                defaultView.HasColumn(columnName);
            } 
        }

        [Then(@"Deliverable Summary is sorted by Period")]
        public void ThenDeliverableSummaryIsSortedByPeriod()
        {
            // The actual sort order is by display order, as sorting by period name would give erroneous values (Apr, Aug etc)
            XrmService.Configuration.Entity("sfa_contractdeliverableperiod").DefaultView()
                .HasSortColumn("sfa_displayorder", XrmSortOrder.Ascending);
        }

    }
}
