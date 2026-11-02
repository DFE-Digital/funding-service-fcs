using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace Operations.Web.PaymentGenerationDataStore
{
    public partial class PaymentGenDBContext : DbContext
    {
        public PaymentGenDBContext()
            : base("name=PaymentGenDBContext")
        {
        }

        public virtual DbSet<PaymentBatchFeedItem> PaymentBatchFeedItems { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
        }
    }
}
