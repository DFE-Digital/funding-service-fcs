namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    extern alias Entities;
    using System;
    using System.Xml.Schema;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AtomGenerator : IAtomGenerator
    {
        private readonly IAtomItemCreator _atomCreator;

        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.AllocationDeliveryPerformance.allocation-delivery-performance-schema.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:allocation-delivery-performance";

        public ISchemaValidator SchemaValidator { get; set; }

        public AtomGenerator(IAtomItemCreator atomCreator)
        {
            _atomCreator = atomCreator;
        }

        public int GenerateAtomFeed(string allocationNumber,int versionNumber, AllocationDeliveryEntryCategory category, ConnectionInfo connectionInfo)
        {
            AllocationDeliveryPerformance item = _atomCreator.CreateAtomItem(allocationNumber, versionNumber, connectionInfo);

            var itemEntry = AllocationDeliveryEntry.Create(item, category);

            SchemaValidatorResultset resultset = SchemaValidator.ValidateAgainstSchema(AssemblyName, EmbeddedResourceName, SchemaNamespace, itemEntry.GetAllocationDeliveryPerformanceXml());

            if (!resultset.IsValid)
            {
                throw new XmlSchemaValidationException("Allocation Delivery Performance Xml Validation has failed", new Exception(String.Join(",", resultset.ValidationErrors)));
            }

            using (var context = new AllocationDeliveryDbContext(connectionInfo))
            {
                context.AllocationDeliveryEntries.Add(itemEntry);
                context.SaveChanges();
            }

            return itemEntry.ID;
        }
    }
}
