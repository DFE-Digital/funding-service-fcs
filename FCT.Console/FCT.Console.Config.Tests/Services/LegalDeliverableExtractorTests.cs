namespace FCT.Console.Config.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Services;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class LegalDeliverableExtractorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LegalDeliverableExtractor_WhenGivenDeliverablesWithNoNesting_ShouldReturnCorrectDeliverables()
        {
            // Arrange
            FundingStreamPeriodDeliverablesSheetType row1 = new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP1",
                DeliverableCode = 1,
                AllowProfile = true
            };

            FundingStreamPeriodDeliverablesSheetType row2 = new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP2",
                DeliverableCode = 2,
                AllowProfile = false
            };

            List<FundingStreamPeriodDeliverablesSheetType> rows = new List<FundingStreamPeriodDeliverablesSheetType>()
            {
                row1,
                row2
            };

            // Act
            IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> result = LegalDeliverableExtractor.ExtractLegalDeliverables(rows);

            // Assert
            Assert.AreEqual(1, result.Count);
            Assert.AreEqual("FSP1" ,result.First().FundingStreamPeriodCode, "Unexpected funding stream period code in returned result");
            Assert.AreEqual(1, result.First().DeliverableCode, "Unexpected deliverable code in returned result");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LegalDeliverableExtractor_WhenGivenDeliverablesWithMultipleLevelsOfNesting_ShouldReturnCorrectDeliverables()
        {
            // Arrange
            List<FundingStreamPeriodDeliverablesSheetType> rows = new List<FundingStreamPeriodDeliverablesSheetType>();
            rows.Add(new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP1",
                DeliverableCode = 1,                
                AllowProfile = false
            });
            rows.Add(new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP1",
                DeliverableCode = 2,
                ParentDeliverableCode = 1,          
                AllowProfile = false
            });
            rows.Add(new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP1",
                DeliverableCode = 3,
                ParentDeliverableCode = 2,          
                AllowProfile = true
            });
            rows.Add(new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP1",
                DeliverableCode = 4,
                ParentDeliverableCode = 2,          
                AllowProfile = false
            });
            rows.Add(new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP1",
                DeliverableCode = 5,
                ParentDeliverableCode = 4,          
                AllowProfile = false
            });
            rows.Add(new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP2",  
                DeliverableCode = 1,
                AllowProfile = false
            });
            rows.Add(new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP2",  
                DeliverableCode = 3,
                ParentDeliverableCode = 1,
                AllowProfile = false
            });
            rows.Add(new FundingStreamPeriodDeliverablesSheetType()
            {
                FundingStreamPeriodCode = "FSP2",  
                DeliverableCode = 4,
                ParentDeliverableCode = 3,
                AllowProfile = false
            });
            
            // Act
            IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> result = LegalDeliverableExtractor.ExtractLegalDeliverables(rows);

            // Assert
            Assert.IsNotNull(result.SingleOrDefault(f => f.FundingStreamPeriodCode == "FSP1" && f.DeliverableCode == 1));
            Assert.IsNotNull(result.SingleOrDefault(f => f.FundingStreamPeriodCode == "FSP1" && f.DeliverableCode == 2));
            Assert.IsNotNull(result.SingleOrDefault(f => f.FundingStreamPeriodCode == "FSP1" && f.DeliverableCode == 3));
        }
    }
}
