namespace FCT.Operations.PaymentSummary
{
    public class FspPayment
    {
        public FspPayment(string fsp, decimal payment)
        {
            Fsp = fsp;
            Payment = payment;
        }

        public FspPayment(string fsp, decimal payment, string agencypayment)
        {
            Fsp = fsp;
            Payment = payment;
            AgencyPayment = agencypayment;
        }

        public FspPayment(string fsp, decimal payment,decimal totalpaid,int rownum)
        {
            Fsp = fsp;
            Payment = payment;
            Totalpaid = totalpaid;
            RowNum=rownum;
        }

        public string Fsp { get; }
            
        public decimal Payment { get; }

        public string AgencyPayment { get; }


        public decimal Totalpaid { get; }
        public decimal RowNum { get; }
    }
}
