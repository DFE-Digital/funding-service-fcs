namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public class FSPGroup
    {
        private FSPGroup()
        {
        }

        public FSPGroup(string fspGroupCode, string contractDocumentDisplayName, int displayOrder)
        {
            FSPGroupCode = fspGroupCode;
            ContractDocumentDisplayName = contractDocumentDisplayName;
            DisplayOrder = displayOrder;
        }

        [Key, MaxLength(50)]
        public string FSPGroupCode { get; private set; }

        [MaxLength(100), Required]
        public string ContractDocumentDisplayName { get; set; }

        [Required]
        public int DisplayOrder { get; set; }

        public virtual ICollection<FspGroupDocumentTemplate> DocumentTemplates { get; set; }

        public override bool Equals(object obj)
        {
            return obj is FSPGroup other && FSPGroupCode == other.FSPGroupCode;
        }

        public override int GetHashCode()
        {
            return FSPGroupCode.GetHashCode();
        }
    }
}
