namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration
{
    using System.Linq;

    public partial class PaymentPeriod
    {
        public virtual bool ShouldSerializePaymentDetails()
        {
            return this.paymentDetailsField != null && paymentDetailsField.Any();
        }
    }
}
