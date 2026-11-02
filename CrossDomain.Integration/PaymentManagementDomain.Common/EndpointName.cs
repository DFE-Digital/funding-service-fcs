namespace SFA.FCT.PaymentManagementDomain.Common
{
    using CrossDomain.Integration.Common;

    public static class EndpointName
    {
        private const string paymentSchedule = "PaymentManagementDomain.PaymentSchedule";

        public static string PaymentSchedule
        {
            get { return FctEndpoint.GenerateEndpointName(paymentSchedule); }
        }
    }
}
