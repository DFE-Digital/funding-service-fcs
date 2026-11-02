namespace SFA.FCT.PaymentManagementDomain.BusinessLogic
{
    public class SubnominalValue
    {
        private SubnominalValue()
        {
        }

        public static SubnominalValue CreateNonEsf(int reconciliation, int capping, int profile)
        {
            return new SubnominalValue
            {
                Reconciliation = reconciliation,
                Capping = capping,
                Profile = profile
            };
        }

        public static SubnominalValue CreateEsf(int subnominalCode)
        {
            return new SubnominalValue
            {
                Reconciliation = subnominalCode,
                Capping = subnominalCode
            };
        }

        public int Reconciliation { get; private set; }

        public int Capping { get; private set; }

        public int Profile { get; private set; }
    }
}
