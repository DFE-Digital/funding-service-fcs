namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ReportedActualsRoutingCommandTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsRoutingCommand_ShouldReturnCollectionOfPartitionKeys_WhenPartitionKeyIsSet()
        {
            // arrange
            ReportedActualsRoutingCommand command = new ReportedActualsRoutingCommand { PartitionKey = "PK1" };

            // act
            string[] partitionKeys = command.GetPartitionKeys();

            // assert
            Assert.IsNotNull(partitionKeys);
            Assert.AreEqual(1, partitionKeys.Length);
            Assert.AreEqual("PK1", partitionKeys.Single());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsRoutingCommand_ShouldReturnEmptyCollectionOfPartitionKeys_WhenPartitionKeyIsNotSet()
        {
            // arrange
            ReportedActualsRoutingCommand command = new ReportedActualsRoutingCommand();

            // act
            string[] partitionKeys = command.GetPartitionKeys();

            // assert
            Assert.IsNotNull(partitionKeys);
            Assert.AreEqual(0, partitionKeys.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsRoutingCommand_ShouldReturnCollectionOfGroupKeys_WhenGroupKeyIsSet()
        {
            // arrange
            ReportedActualsRoutingCommand command = new ReportedActualsRoutingCommand
            {
                SummarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey { CollectionType = "APPS" }
            };

            // act
            SummarisedActualOrgFspGroupKey[] groupKeys = command.GetSummarisedActualOrgFspGroupKeys();

            // assert
            Assert.IsNotNull(groupKeys);
            Assert.AreEqual(1, groupKeys.Length);
            Assert.AreEqual("APPS", groupKeys.Single().CollectionType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsRoutingCommand_ShouldReturnEmptyCollectionOfGroupKeys_WhenGroupIsNotSet()
        {
            // arrange
            ReportedActualsRoutingCommand command = new ReportedActualsRoutingCommand();

            // act
            SummarisedActualOrgFspGroupKey[] groupKeys = command.GetSummarisedActualOrgFspGroupKeys();

            // assert
            Assert.IsNotNull(groupKeys);
            Assert.AreEqual(0, groupKeys.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsRoutingCommand_ShouldIdentifyAsUsingAzureTableStorage_WhenPartitionKeyIsSet()
        {
            // arrange
            ReportedActualsRoutingCommand command = new ReportedActualsRoutingCommand { PartitionKey = "PK1" };

            // act
            bool isUsingAzureTableStorage = command.IsUsingAzureTableStorage();

            // assert
            Assert.IsTrue(isUsingAzureTableStorage);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsRoutingCommand_ShouldIdentifyAsNotUsingAzureTableStorage_WhenPartitionKeyIsNotSet()
        {
            // arrange
            ReportedActualsRoutingCommand command = new ReportedActualsRoutingCommand();

            // act
            bool isUsingAzureTableStorage = command.IsUsingAzureTableStorage();

            // assert
            Assert.IsFalse(isUsingAzureTableStorage);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsRoutingCommand_ShouldGetPartitionKeyWhenPkNotSet()
        {
            // arrange
            const string collectionType = "APPS";
            const string collectionReturnCode = "APPS16";
            const string fsp = "APPS1819";
            const string orgId = "ORG0000009";
            const string uopCode = "TestUOP";
            ReportedActualsRoutingCommand command = new ReportedActualsRoutingCommand
            {
                SummarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey
                {
                    CollectionType = collectionType,
                    CollectionReturnCode = collectionReturnCode,
                    FundingStreamPeriodCode = fsp,
                    OrganisationId = orgId,
                    UopCode = uopCode
                }
            };

            // act
            string pk = command.GetPartitionKey();

            // assert
            //  key.CollectionType + key.CollectionReturnCode + "_" + {Org}{FSP{Uop}
            string expectedPk = $"{collectionType}{collectionReturnCode}_{orgId}{fsp}{uopCode}";

            Assert.AreEqual(expectedPk, pk);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsRoutingCommand_ShouldGetPartitionKeyWhenPkIsSet()
        {
            // arrange
            const string pk = "PK1";
        
            ReportedActualsRoutingCommand command = new ReportedActualsRoutingCommand
            {
               PartitionKey = pk
            };

            // act
            string retrievedPk = command.GetPartitionKey();

            // assert

            Assert.AreEqual(pk, retrievedPk);
        }
    }
}
