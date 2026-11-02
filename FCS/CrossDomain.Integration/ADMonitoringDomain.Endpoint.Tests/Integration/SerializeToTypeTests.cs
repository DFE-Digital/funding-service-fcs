namespace ADMonitoringDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;    
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class SerializeToTypeTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SaveChanges_SerializedXmlToDatabase_AndDeserializesOut()
        {
            var testAllocNum = new Guid().ToString();

            // Arrange
            var newEvent = new AllocationDeliveryEventReceived
            {
                AllocationNumber = testAllocNum,
                VersionNumber = 1,
                CategoryName = "NewContractAllocationApproved",
                EventName = "AllocationDeliveryCommenced",
                EventReceived = DateTime.Now,
                ObjectType = typeof(AllocationDeliveryCommencedEvent).AssemblyQualifiedName,
                Object = new AllocationDeliveryCommencedEvent()
                {
                    Allocation = new allocationType
                    {
                        contractAllocationNumber = testAllocNum,
                        contractReference = new contractReferenceType
                        {
                            contractNumber = "1234",
                            contractVersionNumber = 1,
                            contractSubVersionNumber = 1
                        },

                        contractorReference = new organisationReferenceType
                        {
                            organisationIdentifier = "12345",
                            alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                            {
                                new alternativeOrganisationIdentifierType
                                {
                                    OrganisationIdentifier = "123456",
                                    OrganisationIdentifierName = (alternativeOrganisationIdentifierTypeOrganisationIdentifierName)Enum.Parse(typeof(alternativeOrganisationIdentifierTypeOrganisationIdentifierName), "UKPROVIDERREFERENCENUMBER")
                                }
                            }
                        }
                    }
                }
            };

            var context = new AllocationDeliveryMonitoringDbContext();

            // Act

            context.AllocationDeliveryEventsReceived.Add(newEvent);

            context.SaveChanges();

            // Assert

            var updatedEvent = context.AllocationDeliveryEventsReceived.First(x => x.AllocationNumber == testAllocNum);

            Assert.IsFalse(string.IsNullOrEmpty(updatedEvent.SerializedXml));

            Assert.IsNotNull(updatedEvent.Object);

            context.AllocationDeliveryEventsReceived.Remove(updatedEvent);

            context.SaveChanges();
        }
    }
}
