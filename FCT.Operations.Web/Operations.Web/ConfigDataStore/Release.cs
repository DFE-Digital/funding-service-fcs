namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.Releases")]
    public partial class Release
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Release()
        {
            Release_Deployments = new HashSet<Release_Deployments>();
        }

        [Key]
        public int release_id { get; set; }

        [StringLength(100)]
        public string releaseName { get; set; }

        [StringLength(50)]
        public string version { get; set; }

        public string description { get; set; }

        [StringLength(100)]
        public string created_by { get; set; }

        [StringLength(100)]
        public string modified_by { get; set; }

        public DateTime? created_at { get; set; }

        public DateTime? modified_at { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Release_Deployments> Release_Deployments { get; set; }
    }
}
