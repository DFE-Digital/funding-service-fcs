namespace FCT.Console.Config.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;

    [TestClass]
    public class TypeTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TypeTransformer_ConvertFundingStreamPeriodSheetTypeToFundingStreamPeriod()
        {
            //Arrange
            DateTime startDate = DateTime.Now;
            DateTime endDate = DateTime.Now.AddDays(1);

            List<FundingStreamPeriodSheetType> fspSheetTypes = new List<FundingStreamPeriodSheetType>()
            {
                new FundingStreamPeriodSheetType()
                {
                    FundingStreamPeriodCode = "FundingStreamPeriodCode",
                    CreatedDate = DateTime.Now,
                    EndDate = endDate,
                    StartDate = startDate,
                    FundingStreamCode = "FSCode",
                    Name = "Name",
                    GeneratePayments = true
                }
            };

            // Act
            IEnumerable<PaymentGenerationDomain.Integration.DataStore.Model.FundingStreamPeriod> fundingStreamPeriods = 
                TypeTransformer.TransformCollection<FundingStreamPeriodSheetType, PaymentGenerationDomain.Integration.DataStore.Model.FundingStreamPeriod>(fspSheetTypes);

            // Assert
            Assert.AreEqual(fspSheetTypes.Count(), fundingStreamPeriods.Count());
            var firstRecord = fundingStreamPeriods.First();
            Assert.AreEqual(fspSheetTypes[0].FundingStreamPeriodCode, firstRecord.Code);
            Assert.AreEqual(fspSheetTypes[0].StartDate, firstRecord.StartDate);
            Assert.AreEqual(fspSheetTypes[0].EndDate, firstRecord.EndDate);
            Assert.AreEqual(fspSheetTypes[0].FundingStreamCode, firstRecord.FundingStreamCode);
            Assert.AreEqual(fspSheetTypes[0].ShouldCreatePaymentFileFlag, firstRecord.ShouldGeneratePayments);
        }
    }
}
