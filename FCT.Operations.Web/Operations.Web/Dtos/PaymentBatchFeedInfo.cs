using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Operations.Web.Dtos
{
    public class PaymentBatchFeedInfo
    {
        public PaymentBatchFeedInfo() { }

        /*public PaymentBatchFeedInfo(PaymentBatchFeedItem item)
            //(int id, string fundingStreamPeriod, string paymentPeriod, DateTime censusEndDate, DateTime createdDate, decimal totalValue)
        {
            Id = item.Id;
            FundingStreamPeriod = item.FundingStreamPeriod;
            PaymentPeriod = item.PaymentPeriod;
            CensusEndDate = item.CensusEndDate;
            CreatedDate = item.CreatedDate;
            TotalValue = item.TotalValue;
        }*/

        public PaymentBatchFeedInfo(int id, string fundingStreamPeriod, string paymentPeriod, DateTime censusEndDate, DateTime createdDate, decimal totalValue)
        {
            Id = id;
            FundingStreamPeriod = fundingStreamPeriod;
            PaymentPeriod = paymentPeriod;
            CensusEndDate = censusEndDate;
            CreatedDate = createdDate;
            //TotalValue = totalValue;
        }

        public int Id { get; set; }
        public string FundingStreamPeriod { get; set; }
        public string PaymentPeriod { get; set; }
        public DateTime CensusEndDate { get; set; }
        public DateTime CreatedDate { get; set; }
        //public decimal TotalValue { get; set; }
    }
}