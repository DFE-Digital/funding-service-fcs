namespace FCT.Operations.PaymentSummary
{
    using System.Collections.Generic;

    public class PaymentSummaryLine
    {
       

        public PaymentSummaryLine(int ukprn, string providerName, string agencyPayment, IList<FspPayment> payments)
        {
            Ukprn = ukprn;
            ProviderName = providerName;
            Payments = payments;
            AgencyPayment=agencyPayment;
        }

        public PaymentSummaryLine(int ukprn, string parentTradingName, int childUkprn, string childTradingName,decimal total1619, List<FspPayment> payments)
        {
            Ukprn = ukprn;
            ParentTradingName = parentTradingName;
            ChildUkprn = childUkprn;
            ChildTradingName = childTradingName;
            Payments = payments;
            Total1619 = total1619;
        }

       
        public int Ukprn { get; }
        public string ProviderName { get; }

        public string AgencyPayment { get; }

        public IList<FspPayment> Payments { get; }

        public decimal Total1619 { get; }
        public int ParentUkprn { get; }

        public int ChildUkprn { get; }
      
        public string ParentTradingName { get; }

        public string ChildTradingName { get; }

        public decimal AgencyPayment1619 { get; }

      
    }
}
