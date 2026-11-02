namespace ADMonitoringDomain.DataStore
{
    using System.Data;
    using System.Data.Common;
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;
    using System.Linq;
    using ADMonitoringDomain.DataStore.Migrations;
    using ADMonitoringDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;
    using System.IO;
    using System.Text;
    using System.Xml.Serialization;

    public class AllocationDeliveryMonitoringDbContext : DbContext, IAllocationDeliveryMonitoringDbContext
    {
        public static string KeyVaultValue { get; set; } = string.Empty;

        public AllocationDeliveryMonitoringDbContext() : base(GetConnectionString())
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<AllocationDeliveryMonitoringDbContext, Configuration>());
       //     ((IObjectContextAdapter)this).ObjectContext.ObjectMaterialized += ObjectContext_DeserializeObject;
        }
        private static string GetConnectionString()
        {
            if (!string.IsNullOrWhiteSpace(KeyVaultValue))
            {
                return KeyVaultValue;
            }
            return "name=AllocationDeliveryMonitoringDbContext";
        }

        public AllocationDeliveryMonitoringDbContext(IDbConnection connection)
        : base((DbConnection) connection, false)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<AllocationDeliveryMonitoringDbContext, Configuration>());
      //      ((IObjectContextAdapter)this).ObjectContext.ObjectMaterialized += ObjectContext_DeserializeObject;
        }

        public AllocationDeliveryMonitoringDbContext(ConnectionInfo connectionInfo)
            : base((DbConnection)connectionInfo.Connection, false)
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<AllocationDeliveryMonitoringDbContext, Configuration>());
    //        ((IObjectContextAdapter)this).ObjectContext.ObjectMaterialized += ObjectContext_DeserializeObject;

            if (connectionInfo.Transaction != null)
            {
                Database.UseTransaction(connectionInfo.Transaction);
            }
        }

        public virtual IDbSet<AllocationDeliveryEventReceived> AllocationDeliveryEventsReceived { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("AllocationDeliveryMonitoring");
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }

        public void SetModified(AllocationDeliveryEventReceived entity, Type typeOfEvent)
        {

            this.Entry(entity).State = EntityState.Detached;
            AllocationDeliveryEventReceived entityInDb = AllocationDeliveryEventsReceived.Single(e => e.AllocationNumber == entity.AllocationNumber &&
                                                              e.VersionNumber == entity.VersionNumber &&
                                                              e.CategoryName == entity.CategoryName &&
                                                              e.EventName == entity.EventName);

            entityInDb.Object = entity.Object;
            Serialize(entityInDb, typeOfEvent);
            entityInDb.EventReceived = entity.EventReceived;
            Entry(entityInDb).State = EntityState.Modified;
            base.SaveChanges();
        }

        public override int SaveChanges()
        {
            var trackedEntities = ChangeTracker.Entries();

            foreach (var i in trackedEntities.Where(e => e.Entity is ISerializeToType).Select(e => e.Entity as ISerializeToType))
            {
                i.Serialize();
            }

            return base.SaveChanges();
        }

        private static void Serialize(ISerializeToType input, Type typeOfEvent)
        {
            if (input.Object == null || input.ObjectType == null)
            {
                input.Object = null;
                return;
            }

            using (var stream = new MemoryStream())
            {
                var serializer = new XmlSerializer(typeOfEvent);
                serializer.Serialize(stream, input.Object);
                input.SerializedXml = new UTF8Encoding().GetString((stream).ToArray());
            }
        }
    }
}
