namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.Environments")]
    public partial class Environment
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Environment()
        {
            Release_Deployments = new HashSet<Release_Deployments>();
        }

        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string Env { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Release_Deployments> Release_Deployments { get; set; }
    }
}
