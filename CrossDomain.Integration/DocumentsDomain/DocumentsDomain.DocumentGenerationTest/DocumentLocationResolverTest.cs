namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using DocumentLocationResolver;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
  
    [TestClass]
    public class DocumentLocationResolverTest
    {

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_ResolveContractApendicesLocation()
        {
            IDocumentLocationResolver docLocResolver = new DocumentLocationResolver();
            string expectedResult = "24+LOANS-1516-Input-Appendices";

            string o365DocListofAppendices =
                docLocResolver.GetLocationOfAppendices(
                    new contractType()
                    {
                        period = new period() {period1 = "1516"},
                        fundingType = new fundingType() { fundingTypeCode = "24+LOANS" }
                    });
        
            Assert.AreEqual(expectedResult, o365DocListofAppendices, "Location doesn't match");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_ResolveContractTermsAndConditionsLocation()
        {
            IDocumentLocationResolver docLocResolver = new DocumentLocationResolver();
            string expectedResult = "24+LOANS-1516-Input-Terms And Conditions";

            string o365DocListOfTsAndCs = docLocResolver.GetLocationOfTermsAndConditions(
                    new contractType()
                    {
                        period = new period()
                        {
                            period1 = "1516" 
                        },
                        fundingType = new fundingType() { fundingTypeCode = "24+LOANS" }
                    });

            Assert.AreEqual(expectedResult, o365DocListOfTsAndCs, "Location doesn't match");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_ResolveContractMergedDocumentLocation()
        {
            IDocumentLocationResolver docLocResolver = new DocumentLocationResolver();
            string expectedResult = "24+LOANS-1516-Output-Merged Document";

            string o365DocListOfMergedDoc = docLocResolver.GetLocationOfMergedDocument(
                    new contractType()
                    {
                        period = new period() { period1 = "1516" },
                        fundingType = new fundingType() { fundingTypeCode = "24+LOANS" }
                    });

            Assert.AreEqual(expectedResult, o365DocListOfMergedDoc, "Location doesn't match");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_ResolveContractPublishedDocumentLocation()
        {
            IDocumentLocationResolver docLocResolver = new DocumentLocationResolver();
            string expectedResult = "24+LOANS-1516-Output-Documents for Publication";

            string o365DocListOfMergedDoc = docLocResolver.GetLocationOfPublishedDocument(
                    new contractType()
                    {
                        period = new period{ period1 = "1516" },
                        fundingType = new fundingType{ fundingTypeCode = "24+LOANS" }
                    });

            Assert.AreEqual(expectedResult, o365DocListOfMergedDoc, "Location doesn't match");
        }

    }
}
