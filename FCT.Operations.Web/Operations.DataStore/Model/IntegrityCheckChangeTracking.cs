namespace Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class IntegrityCheckChangeTracking
    {
        public const string PaasToCrmDeliverablePayment = "PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT";

        private IntegrityCheckChangeTracking()
        {
        }

        public IntegrityCheckChangeTracking(string name)
        {
            Name = name;
        }

        [Key, MaxLength(70)]
        public string Name { get; private set; }

        public long? CurrentVersion { get; set; }
    }
}
