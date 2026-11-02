namespace SFA.FCT.ContractManagementService.Test.UnitTests.PaymentRequestAtomFeedTests
{
    using System;
    using System.Collections.Generic;
    using System.ServiceModel.Syndication;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using SFA.FCT.ContractManagementService.Controllers.PaymentRequestAtomFeed;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    [TestClass]
    public class PaymentRequestSyndicationItemCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentRequestSyndicationItemCreator_ShouldCreateSummaryText()
        {
            // arrange
            PaymentRequestSyndicationItemCreator syndicationItemCreator = new PaymentRequestSyndicationItemCreator();

            DateTime now = DateTime.Now;
            const string fsp = "ALLB1819";
            const string linkCode = "A";
            const string year = "2018";
            const string month = "07";
            PaymentBatchFeedItem paymentBatchFeedItem = PaymentBatchFeedItem.Create(new PaymentPeriod
            {
                FinancialPaymentFinancialYear = year,
                FinancialPaymentFinancialMonth = month,
                CensusEndDate = now,
                PaymentDetails = new List<PaymentDetail>
                {
                    new PaymentDetail
                    {
                        AggregatedValue = 10,
                    },
                    new PaymentDetail
                    {
                        AggregatedValue = 11,
                    }
                }
            },
               fsp,
               linkCode);

            // act
            SyndicationItem x = syndicationItemCreator.CreateItemForRow(paymentBatchFeedItem,
                "application/vnd.sfa.paymentrequests.v1+atom+xml");

            // assert

            var expectedSummary = "{\"FundingStreamPeriod\":\"ALLB1819\",\"PaymentPeriod\":\"201807\",\"CensusEndDate\":\"" + $"{now:yyyy-MM-ddTHH:mm:ssZ}" + "\",\"PaymentLineCount\":2,\"TotalValue\":21.0}";
                
            Assert.AreEqual(expectedSummary, x.Summary.Text);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentRequestSyndicationItemCreator_ShouldCreateTitle()
        {
            // arrange
            PaymentRequestSyndicationItemCreator syndicationItemCreator = new PaymentRequestSyndicationItemCreator();

            DateTime now = DateTime.Now;
            const string fsp = "ALLB1819";
            const string linkCode = "A";
            const string year = "2018";
            const string month = "07";
            PaymentBatchFeedItem paymentBatchFeedItem = PaymentBatchFeedItem.Create(new PaymentPeriod
                {
                    FinancialPaymentFinancialYear = year,
                    FinancialPaymentFinancialMonth = month,
                    CensusEndDate = now,
                    PaymentDetails = new List<PaymentDetail>()
                },
                fsp,
                linkCode);

            // act
            SyndicationItem x = syndicationItemCreator.CreateItemForRow(paymentBatchFeedItem,
                "application/vnd.sfa.paymentrequests.v1+atom+xml");

            // assert
            string expectedTitle =
                $"Payment Requests for Funding Stream Period {fsp} for Payment Period {year + month} have been generated as of Census End Date/Time {now:yyyy-MM-ddTHH:mm:ssZ}.";

            Assert.AreEqual(expectedTitle, x.Title.Text);
        }
    }
}
