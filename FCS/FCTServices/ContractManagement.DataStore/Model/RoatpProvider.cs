namespace ContractManagement.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class RoatpProvider
    {
        private RoatpProvider() { }

        public RoatpProvider(string ukprn)
        {
            Ukprn = ukprn;
        }

        [Key]
        [StringLength(10)]
        public string Ukprn { get; private set; }
    }
}