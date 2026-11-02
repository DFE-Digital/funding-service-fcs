namespace FCT.Console.Config.Tests.Transformers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class FspDeliverableClaimTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FspDeliverableClaimTransformet_CorrectlyMapsEntities()
        {
            FspDeliverableClaim expectedClaim = new FspDeliverableClaim("testCode", 0, "delName", true, "GC");

            FundingStreamPeriodDeliverablesSheetType sheetType = new FundingStreamPeriodDeliverablesSheetType
            {
                FundingStreamPeriodCode = "testCode",
                DeliverableCode = 0,
                DeliverableName = "delName",
                AllowClaim = true,
                ClaimReconciliationDeliverableGroupCode = "GC"
            };

            List<FundingStreamPeriodDeliverablesSheetType> listOfSheets = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                sheetType
            };

            var mapped = FspDeliverableClaimTransformer.TransformCollection(listOfSheets).ToList();

            Assert.AreEqual(mapped[0].AllowClaim, expectedClaim.AllowClaim);
            Assert.AreEqual(mapped[0].FspCode, expectedClaim.FspCode);
            Assert.AreEqual(mapped[0].DeliverableCode, expectedClaim.DeliverableCode);
            Assert.AreEqual(mapped[0].DeliverableName, expectedClaim.DeliverableName);
            Assert.AreEqual(mapped[0].ClaimReconciliationDeliverableGroupCode, expectedClaim.ClaimReconciliationDeliverableGroupCode);
        }
    }
}