namespace SFA.FCT.ContractManagementService.Controllers.PaymentRequestAtomFeed
{
    using System.IO;
    using System.ServiceModel.Syndication;
    using System.Xml;
    using global::ContractManagementService.AtomFeed;
    using Newtonsoft.Json;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    

    public class PaymentRequestSyndicationItemCreator : ISyndicationItemCreator<PaymentBatchFeedItem>
    {
        private const string DateFormat = "yyyy-MM-ddTHH:mm:ssZ";
        public SyndicationItem CreateItemForRow(PaymentBatchFeedItem row, string mediaType)
        {
            XmlTextReader xmlTextReader = new XmlTextReader(new StringReader(row.GetPaymentBatchXml()));
            SyndicationElementExtension syndicationElementExtension = new SyndicationElementExtension(xmlTextReader);
            var item = new SyndicationItem
            {
                Content = new XmlSyndicationContent(mediaType, syndicationElementExtension),
                Summary = new TextSyndicationContent(GetSummaryText(row)),
                Id = $"uuid:{row.Identifier}",
                PublishDate = row.CreatedDate,
                LastUpdatedTime = row.CreatedDate,
                Title = new TextSyndicationContent(GetTitleText(row)),
            };

            item.Categories.Add(new SyndicationCategory(GetName(), null, GetLabel()));

            return item;
        }

        private static string GetSummaryText(PaymentBatchFeedItem row)
        {
            return JsonConvert.SerializeObject(new Summary(fundingStreamPeriod: row.FundingStreamPeriod,
                paymentPeriod: row.PaymentPeriod,
                censusEndDate: row.CensusEndDate.ToString(DateFormat),
                paymentLineCount: row.PaymentLineCount,
                totalValue: row.TotalValue));
        }

        private static string GetTitleText(PaymentBatchFeedItem row)
        {
            return $"Payment Requests for Funding Stream Period {row.FundingStreamPeriod} for Payment Period {row.PaymentPeriod} have been generated as of Census End Date/Time {row.CensusEndDate.ToString(DateFormat)}.";
        }

        private static string GetName()
        {
            return "Payment Requests Generated";
        }

        private static string GetLabel()
        {
            return "Payment Requests have been generated";
        }

        private class Summary
        {
            public string FundingStreamPeriod { get; }

            public string PaymentPeriod { get; }

            public string CensusEndDate { get; }

            public int PaymentLineCount { get; }

            public decimal TotalValue { get; }

            public Summary(string fundingStreamPeriod, string paymentPeriod, string censusEndDate, int paymentLineCount, decimal totalValue)
            {
                FundingStreamPeriod = fundingStreamPeriod;
                PaymentPeriod = paymentPeriod;
                CensusEndDate = censusEndDate;
                PaymentLineCount = paymentLineCount;
                TotalValue = totalValue;
            }
        }
    }
}