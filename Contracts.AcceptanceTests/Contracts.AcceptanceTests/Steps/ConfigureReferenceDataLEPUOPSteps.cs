namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using Infrastructure.Services;
    using TechTalk.SpecFlow;

    [Binding]
    public class ConfigureReferenceDataLEPUOPSteps
    {
        [Given(@"that LEP organisation data exists")]
        public void GivenThatLEPOrganisationDataExists()
        {
            // no code required
        }

        [When(@"I upload the LEP data in CRM")]
        public void WhenIUploadTheLEPDataInCRM()
        {
            // no code required
        }

        [Then(@"these LEP Organisation are avaialbe in CRM")]
        public void ThenTheTheseLEPOrganisationAreAvaialbeInCRM(Table table)
        {
            var accountEntity = XrmService.Configuration.Entity("account");

            foreach (var row in table.Rows)
            {
                var accountRecord = XrmService.Connection.GetUniqueRecord(accountEntity, row["LEP Code"], "sfa_lepcode")
                    .GetLatestRecord();

                accountRecord.FieldValueEquals("sfa_lepcode", row["LEP Code"])
                    .FieldValueEquals("sfa_organisationcategory", row["Organisation Category"])
                    .FieldValueEquals("name", row["LEP Name"]);
            }
        }

        [Given(@"that UoP organisation data exists")]
        public void GivenThatUoPOrganisationDataExists()
        {
            // no code required as UoP data is part of the build
        }

        [When(@"I upload the UoP data in CRM")]
        public void WhenIUploadTheUoPDataInCRM()
        {
            // no code required as UoP data will be uploaded automatically
        }

        [Then(@"these UoP Organisation are avaialbe in CRM")]
        public void ThenTheseUoPOrganisationAreAvaialbeInCRM(Table table)
        {
            var uopEntity = XrmService.Configuration.Entity("sfa_unitofprocurement");

            foreach (var row in table.Rows)
            {
                var uopRecord = XrmService.Connection.GetUniqueRecord(uopEntity, row["UoP Code"], "sfa_uopcode")
                    .GetLatestRecord();

                uopRecord.FieldValueEquals(
                    "sfa_uopcode",
                    row["UoP Code"])
                    .FieldValueEquals("sfa_name", row["UoP Name"]);
            }
        }
    }
}
