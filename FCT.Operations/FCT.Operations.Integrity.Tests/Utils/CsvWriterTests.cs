namespace FCT.Operations.Integrity.Tests.Utils
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.DTOs;
    using SFA.FCT.Operations.Integrity.Utils;

    [TestClass]
    public class CsvWriterTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CsvWriter_ShouldCreateCsvColumnsIgnored()
        {
            // arrange
            CsvWriter<DeliverablePaymentWithFsp> csvWriter = new CsvWriter<DeliverablePaymentWithFsp>();
            IList<DeliverablePaymentWithFsp> deliverablePaymentWithFsps = new List<DeliverablePaymentWithFsp>
            {
                new DeliverablePaymentWithFsp()
            };
            
            // act
            string csv = csvWriter.CreateCsv(deliverablePaymentWithFsps);

            // assert
            Assert.IsTrue(!csv.Contains("PaymentMethod"), "The column PaymentMethod has not been removed");
            Assert.IsTrue(!csv.Contains("YearPeriod"), "The column YearPeriod has not been removed");
        }
    }
}
