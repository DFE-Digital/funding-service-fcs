namespace ContractManagement.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class RegionType
    {
        private RegionType() { }

        public RegionType(int regionTypeCode, string regionTypeName)
        {
            RegionTypeCode = regionTypeCode;
            RegionTypeName = regionTypeName;
        }

        [Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int RegionTypeCode { get; private set; }

        [StringLength(50)]
        [Required]
        public string RegionTypeName { get; private set; }

        protected bool Equals(RegionType other)
        {
            return RegionTypeCode == other.RegionTypeCode && string.Equals(RegionTypeName, other.RegionTypeName);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((RegionType) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return (RegionTypeCode*397) ^ (RegionTypeName?.GetHashCode() ?? 0);
            }
        }
    }
}