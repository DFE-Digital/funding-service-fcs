namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Linq;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using NUnit.Framework;
    using Pages;
    using TechTalk.SpecFlow;
    using NUnit.Framework.Legacy;

    [Binding]
    public class PublishApprovedContractSteps
    {
        private readonly PublishApprovedContractPageObject _pacPageObject;

        private readonly IReadOnlyCollection<string> validAtomFeeds =
            new ReadOnlyCollection<string>(new List<string> {"draft", "approvals"});

        public PublishApprovedContractSteps(PublishApprovedContractPageObject pacPageObject)
        {
            _pacPageObject = pacPageObject;
        }

        [Then(@"the following contracts exist in the retrieved '(.*)' feed")]
        public void ThenTheFollowingContractsExistInTheRetrievedFeed(string targetFeed, Table table)
        {
            ClassicAssert.IsTrue(validAtomFeeds.Contains(targetFeed), "Invalid target feed name.");

            var contractsToCheck = GetContractsFromTable(table);

            bool allContractsFound = false;
            var endDateTime = DateTime.Now + TimeSpan.FromSeconds(60);
            while (DateTime.Now < endDateTime)
            {
                Task.Delay(TimeSpan.FromSeconds(5)).Wait();

                allContractsFound = _pacPageObject.VerifiyContractsAreInFeed(targetFeed, contractsToCheck);

                if (allContractsFound)
                {
                    break;
                }
            }

            ClassicAssert.IsTrue(allContractsFound, "Not all expected contracts are in retrieved feed");
        }

        [Then(@"the following contract allocation details are present in the retrieved feed")]
        public void ThenTheFollowingContractAllocationDetailsArePresentInTheRetrievedFeed(Table table)
        {
            foreach (var row in table.Rows)
            {
                var allocation = this._pacPageObject.GetAllocation(row["Parent Contract"], row["ContractNumber"], int.Parse(row["Version"]), row["AllocationRef"]);
                ClassicAssert.IsNotNull(allocation);
                CheckValue(row, "AllocationDescription", allocation.description);
                CheckValue(row, "LEPName", allocation.ProcurementAttrs.LEPName);
                CheckValue(row, "LEPCode", allocation.ProcurementAttrs.LEPCode);
                CheckValue(row, "TenderSpecificationReference", allocation.ProcurementAttrs.TenderSpecReference);
                CheckValue(row, "LotReference", allocation.ProcurementAttrs.LotReference);
                CheckValue(row, "TenderAwardReference", allocation.ProcurementAttrs.AwardReference);
                CheckValue(row, "ActivityDescription", allocation.ProcurementAttrs.ActivityDescription);
                CheckValue(row, "InvestmentPriority", allocation.ProcurementAttrs.InvestmentPriority);
                CheckValue(row, "AgreementNumber", allocation.ProcurementAttrs.AgreementNumber);
                CheckValue(row, "SpecificationTitle", allocation.ProcurementAttrs.TenderSpecTitle);
                CheckValue(row, "RegionType", allocation.ProcurementAttrs.RegionType);
                CheckValue(row, "LearningRatePremium", allocation.ProcurementAttrs.LearningRatePremium.ToString());

                string learningRatePremium;
                if (row.TryGetValue("LearningRatePremium", out learningRatePremium))
                    ClassicAssert.AreEqual(decimal.Parse(learningRatePremium), allocation.ProcurementAttrs.LearningRatePremium, "LearningRatePremium is not expected value");
            }
        }

        [When(@"the '(.*)' link is retrieved (.*) times")]
        public void WhenTheLinkIsRetrievedTimes(string p0, int p1)
        {
           bool allContractsFound = false;
           for (int i=0; i<p1; i++)
           {
              allContractsFound = _pacPageObject.VerifyFeed(p0);
           }

           ClassicAssert.IsTrue(allContractsFound, "Not all expected contracts are in retrieved feed");
        }

        private static void CheckValue(TableRow row, string expectedValueHeading, string actualValue)
        {
            string expectedValue;
            if (row.TryGetValue(expectedValueHeading, out expectedValue))
                ClassicAssert.AreEqual(expectedValue, actualValue, expectedValueHeading + " is not expected value");
        }

        private static IList<Contract> GetContractsFromTable(Table table)
        {
            var contracts = new List<Contract>();

            var keys = new string[] { "Parent Contract", "Contract No", "Version" };

            foreach (var row in table.Rows)
            {
                if (!keys.All(k => row.Keys.Contains(k)))
                {
                    throw new ApplicationException("Row is missing key, required keys are 'Contract No' and 'Version'");
                }

                contracts.Add(
                    new Contract
                    {
                        contractNumber = row["Parent Contract"],
                        contracts = new List<contractType>
                        {
                            new contractType 
                            {
                                contractNumber = row["Contract No"], 
                                contractVersionNumber = int.Parse(row["Version"])
                            }
                        }
                    });
            }

            return contracts;
        }
    }
}
